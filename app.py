import streamlit as st 
import pandas as pd
from sklearn.tree import DecisionTreeClassifier

# Configuración de tema
st.set_page_config(page_title="Scouting Future Stars", layout="wide")

# Estilo personalizado
st.markdown(
    """
    <style>
    .main {background-color: #0D1B2A; color: white;}
    h1, h2, h3 {color: #1B98E0;}
    </style>
    """, unsafe_allow_html=True
)

# Sección 1: Introducción
def seccion_introduccion():
    col1, col2 = st.columns([2, 1])
    with col1:
        st.title("SCOUTING FUTURE STARS")
        st.subheader("Sobre nosotros")
        st.write("""
        En SFS somos la empresa que mejor representa a sus jugadores, acompañándolos desde su inicio hasta el infinito. 
        Brindando soluciones basadas en datos y potenciando su talento para alcanzar el máximo nivel competitivo.
        """)
    with col2:
        # Imagen al lado del texto
        st.image("sfs.png", use_container_width=True)  # Coloca tu imagen en el directorio del proyecto

# Sección 2: Modelo Predictivo de Talentos
def seccion_modelo():
    st.header("Modelo Predictivo de Talentos")
    st.write("Utilizamos un modelo de árbol de decisión para identificar jóvenes talentos en la NBA.")

    # Cargar los datos
    @st.cache_data
    def cargar_datos():
        return pd.read_csv('Fusionado_final.csv')

    Fusionado = cargar_datos()

    # Crear la columna de 'talento'
    Fusionado['talento'] = (Fusionado['UPER'] > 30).astype(int)

    # Seleccionar datos de entrenamiento y prueba
    entrenamiento = Fusionado[Fusionado['season'] <= '2019-2020']
    prueba = Fusionado[(Fusionado['season'] == '2022-2023') & (Fusionado['edad'] < 21)]

    # Verificar si hay datos suficientes para entrenar y probar
    if entrenamiento.empty or prueba.empty:
        st.error("No hay suficientes datos para entrenar o probar el modelo.")
        return

    # Seleccionar las características y la etiqueta
    features = ['Total_Tiros_Libres_IN', 'Max_Assists', 'Max_Points', 'Steals', 'Block_Count']
    X_train = entrenamiento[features]
    y_train = entrenamiento['talento']
    X_test = prueba[features]

    # Verificar que haya suficientes muestras en los conjuntos de datos
    if X_train.empty or X_test.empty:
        st.error("Los conjuntos de datos de entrenamiento o prueba están vacíos.")
        return

    # Entrenar el modelo
    modelo = DecisionTreeClassifier(max_depth=3, random_state=42)
    modelo.fit(X_train, y_train)

    # Realizar predicciones
    y_pred = modelo.predict(X_test)
    prueba['Predicción Talento'] = y_pred

    # Filtrar jugadores predichos como talento
    talentos_predichos = prueba[prueba['Predicción Talento'] == 1]

    # Interfaz interactiva
    st.subheader("Top 5 Jugadores con Mayor Player Efficiency Rating")
    if not talentos_predichos.empty:
        top_5 = talentos_predichos.nlargest(5, 'UPER')[['player_name', 'edad', 'UPER']]
        top_5.rename(columns={'UPER': 'Player Efficiency Rating'}, inplace=True)
        st.table(top_5)
    else:
        st.write("No se encontraron talentos destacados.")

    if st.checkbox("Mostrar todos los jugadores menores de 21 años"):
        if not prueba.empty:
            prueba.rename(columns={'UPER': 'Player Efficiency Rating'}, inplace=True)
            st.dataframe(prueba[['player_name', 'edad', 'Player Efficiency Rating']])
        else:
            st.write("No hay jugadores menores de 21 años disponibles.")

    # Gráfico interactivo
    if not talentos_predichos.empty:
        st.subheader("Gráfico de Player Efficiency Rating por Jugador")
        try:
            st.bar_chart(talentos_predichos.set_index('player_name')['UPER'])
        except KeyError:
            st.error("No se pudo generar el gráfico. Verifica los datos disponibles.")

    # Opcional: Exportar resultados
    def descargar_datos(df):
        return df.to_csv(index=False).encode('utf-8')

    data_descarga = descargar_datos(talentos_predichos)
    st.download_button(
        label="Descargar Resultados",
        data=data_descarga,
        file_name="resultados_talentos.csv",
        mime="text/csv"
    )

# Sección 4: Contacto
def seccion_contacto():
    st.header("Contáctanos")
    st.write("¡Estamos aquí para ayudarte a encontrar el próximo talento estrella!")
    email = st.text_input("Email de contacto")
    telefono = st.text_input("Teléfono de contacto")

# Mostrar las secciones
seccion_introduccion()
st.markdown("---")
seccion_modelo()
st.markdown("---")
seccion_contacto()

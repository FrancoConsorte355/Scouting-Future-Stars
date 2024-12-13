![Logo](https://github.com/FrancoConsorte355/Scouting-Future-Stars/reporte/WhatsApp_Image _024-12-13_at_08.12.54.jpeg)




# Scouting the Future Stars - Proyecto Final

Este repositorio contiene el proyecto final titulado "Descubriendo talentos emergentes en equipos de Los Ángeles de la NBA para Scouting Future Stars", donde se realiza un análisis de jugadores jóvenes en los equipos Los Angeles Clippers y Los Angeles Lakers con el objetivo de identificar a las futuras estrellas de la NBA.

## Participantes

- Bárbara Batlle Casas - Project Manager & Data Analyst
- Erica Baumann - Data Analyst
- Franco Consorte - Data Scientist
- Alexis Medina Castañeda - Data Engineer

## Descripción
La NBA (National Basketball Association) es una liga de baloncesto profesional de Estados Unidos y cuenta con 30 equipos. Este proyecto se enfoca en descubrir y potenciar el talento emergente en los equipos de la NBA. Se busca analizar el rendimiento de los jugadores jóvenes con alto potencial, pero con baja visibilidad en la liga.

## Objetivo del Proyecto
Identificar a jugadores emergentes en los equipos mencionados, permitiendo a la agencia de reclutamiento de talentos 'Scouting Future Stars' iniciar negociaciones para su representación y desarrollo profesional antes de que sean descubiertos por otros.

Metas específicas:
- Descubrir el Top 3 de jugadores con potencial, aplicando filtros por edad (19 a 21 años) y rendimiento en las últimas 4 temporada.
- Evaluar el desempeño bajo presión en playoffs o en los últimos cuartos de los partidos.
- Comparar el rendimiento de los mejores jugadores seleccionados con estadísticas avanzadas.
- Analizar el rendimiento y las ganancias de jugadores consagrados con los jovenes talentos.

## Resultados Esperados
El objetivo es encontrar jugadores jóvenes con gran potencial para que la agencia de talentos los represente y guíe en su carrera profesional. Esto posicionará a la agencia como líder en scouting de talentos emergentes y permitirá generar acuerdos comerciales y patrocinios en torno al éxito de estos jugadores, construyendo una base sólida y rentable para el futuro.

## Fuentes de Datos
Se utilizará el NBA Dataset disponible en Kaggle, que contiene:
- Información de 30 equipos de la NBA.
- Más de 4800 jugadores.
- Más de 65,000 partidos desde la temporada inaugural 1946-47.
- Datos jugada por jugada, resultados de juegos, entre otros.
- El archivo está en formato sqlite y tiene un tamaño de 2,36 GB.

## Información Presentada
- Datos generales de la liga.
- Estadísticas de todos los jugadores, con un enfoque en los más destacados.
- Presentación del Top 3 jugadores por equipo, seleccionados a partir de estadísticas generales y avanzadas.
- Comparativa entre los mejores jugadores seleccionados y el contexto general del equipo.
- Analisis financiero.

## Plan de Análisis
El proyecto se desarrollará en cinco fases:
- Definición de criterios para reconocer "talento emergente".
- Procesamiento y limpieza de datos, aplicando segmentaciones por edad (máximo 25 años) y eliminando tablas irrelevantes (jugadores inactivos, estadísticas del Combine, etc.).
- Cálculo de métricas claves, aplicando estadísticas generales y avanzadas, tales como:
True Shooting Percentage (TS%): Eficiencia de tiro.
Assist Percentage (AST%): Porcentaje de asistencias sobre el total del equipo.
- Evaluación de rendimiento bajo diferentes contextos, como presión en playoffs y en los últimos cuartos de los partidos.
- Construcción de un dashboard interactivo en Power BI, presentando visualizaciones y conclusiones sobre los jugadores más prometedores.

## Tecnologías Utilizadas
- SQL / Sqlite: Gestión y procesamiento de datos.
- Python: Análisis de datos utilizando Pandas, Matplotlib, Seaborn, y Numpy.
- Power BI: Creación de dashboards y visualizaciones interactivas.
- Streamlit


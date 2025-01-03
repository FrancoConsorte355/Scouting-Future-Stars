USE [master]
GO
/****** Object:  Database [NBA_STATS]    Script Date: 26/11/2024 11:21:56 ******/
CREATE DATABASE [NBA_STATS]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'NBA_STATS', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\NBA_STATS.mdf' , SIZE = 1187840KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'NBA_STATS_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL16.MSSQLSERVER\MSSQL\DATA\NBA_STATS_log.ldf' , SIZE = 1318912KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [NBA_STATS] SET COMPATIBILITY_LEVEL = 160
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [NBA_STATS].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [NBA_STATS] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [NBA_STATS] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [NBA_STATS] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [NBA_STATS] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [NBA_STATS] SET ARITHABORT OFF 
GO
ALTER DATABASE [NBA_STATS] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [NBA_STATS] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [NBA_STATS] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [NBA_STATS] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [NBA_STATS] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [NBA_STATS] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [NBA_STATS] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [NBA_STATS] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [NBA_STATS] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [NBA_STATS] SET  ENABLE_BROKER 
GO
ALTER DATABASE [NBA_STATS] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [NBA_STATS] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [NBA_STATS] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [NBA_STATS] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [NBA_STATS] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [NBA_STATS] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [NBA_STATS] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [NBA_STATS] SET RECOVERY FULL 
GO
ALTER DATABASE [NBA_STATS] SET  MULTI_USER 
GO
ALTER DATABASE [NBA_STATS] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [NBA_STATS] SET DB_CHAINING OFF 
GO
ALTER DATABASE [NBA_STATS] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [NBA_STATS] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [NBA_STATS] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [NBA_STATS] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
EXEC sys.sp_db_vardecimal_storage_format N'NBA_STATS', N'ON'
GO
ALTER DATABASE [NBA_STATS] SET QUERY_STORE = ON
GO
ALTER DATABASE [NBA_STATS] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [NBA_STATS]
GO
/****** Object:  User [Erica]    Script Date: 26/11/2024 11:21:56 ******/
CREATE USER [Erica] FOR LOGIN [Erica] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [Barbara]    Script Date: 26/11/2024 11:21:56 ******/
CREATE USER [Barbara] FOR LOGIN [Barbara] WITH DEFAULT_SCHEMA=[dbo]
GO
/****** Object:  User [Alexis]    Script Date: 26/11/2024 11:21:56 ******/
CREATE USER [Alexis] FOR LOGIN [Alexis] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_datareader] ADD MEMBER [Erica]
GO
ALTER ROLE [db_datareader] ADD MEMBER [Barbara]
GO
ALTER ROLE [db_datareader] ADD MEMBER [Alexis]
GO
/****** Object:  UserDefinedFunction [dbo].[fn_GetTotalPoints]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fn_GetTotalPoints]
(
    @player_id INT,  -- ID del jugador
    @game_id INT     -- ID del juego
)
RETURNS INT
AS
BEGIN
    DECLARE @total_points INT;

    SELECT 
        @total_points = SUM(
            CASE 
                WHEN pbp.eventmsgtype IN (1, 2) THEN 2 -- Tiros normales
                WHEN pbp.eventmsgtype = 3 THEN 3       -- Triples
                ELSE 0
            END
        )
    FROM 
        play_by_play pbp
    JOIN 
        common_player_info cpi ON pbp.player1_id = cpi.person_id
    JOIN 
        player p ON cpi.person_id = p.id
    JOIN 
        game g ON pbp.game_id = g.game_id
    WHERE 
        p.id = @player_id
        AND g.game_id = @game_id;

    RETURN ISNULL(@total_points, 0); -- Devuelve 0 si no hay puntos
END;
GO
/****** Object:  Table [dbo].[common_player_info]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[common_player_info](
	[person_id] [int] NOT NULL,
	[first_name] [varchar](max) NULL,
	[last_name] [varchar](max) NULL,
	[display_first_last] [varchar](max) NULL,
	[display_last_comma_first] [varchar](max) NULL,
	[display_fi_last] [varchar](max) NULL,
	[player_slug] [varchar](max) NULL,
	[birthdate] [varchar](max) NULL,
	[school] [varchar](max) NULL,
	[country] [varchar](max) NULL,
	[last_affiliation] [varchar](max) NULL,
	[height] [varchar](max) NULL,
	[weight] [float] NULL,
	[season_exp] [float] NULL,
	[jersey] [varchar](max) NULL,
	[position] [varchar](max) NULL,
	[rosterstatus] [varchar](max) NULL,
	[games_played_current_season_flag] [varchar](max) NULL,
	[team_id] [bigint] NULL,
	[team_name] [varchar](max) NULL,
	[team_abbreviation] [varchar](max) NULL,
	[team_code] [varchar](max) NULL,
	[team_city] [varchar](max) NULL,
	[playercode] [varchar](max) NULL,
	[from_year] [float] NULL,
	[to_year] [float] NULL,
	[dleague_flag] [varchar](max) NULL,
	[nba_flag] [varchar](max) NULL,
	[games_played_flag] [varchar](max) NULL,
	[draft_year] [varchar](max) NULL,
	[draft_round] [varchar](max) NULL,
	[draft_number] [varchar](max) NULL,
	[greatest_75_flag] [varchar](max) NULL,
 CONSTRAINT [UQ_common_player_info_person] UNIQUE NONCLUSTERED 
(
	[person_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[draft_combine_stats]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[draft_combine_stats](
	[season] [bigint] NULL,
	[player_id] [int] NOT NULL,
	[first_name] [varchar](max) NULL,
	[last_name] [varchar](max) NULL,
	[player_name] [varchar](max) NULL,
	[position] [varchar](max) NULL,
	[height_wo_shoes] [float] NULL,
	[height_wo_shoes_ft_in] [varchar](max) NULL,
	[height_w_shoes] [float] NULL,
	[height_w_shoes_ft_in] [varchar](max) NULL,
	[weight] [float] NULL,
	[wingspan] [float] NULL,
	[wingspan_ft_in] [varchar](max) NULL,
	[standing_reach] [float] NULL,
	[standing_reach_ft_in] [varchar](max) NULL,
	[body_fat_pct] [float] NULL,
	[hand_length] [float] NULL,
	[hand_width] [float] NULL,
	[standing_vertical_leap] [float] NULL,
	[max_vertical_leap] [float] NULL,
	[lane_agility_time] [float] NULL,
	[modified_lane_agility_time] [float] NULL,
	[three_quarter_sprint] [float] NULL,
	[bench_press] [float] NULL,
	[spot_fifteen_corner_left] [varchar](max) NULL,
	[spot_fifteen_break_left] [varchar](max) NULL,
	[spot_fifteen_top_key] [varchar](max) NULL,
	[spot_fifteen_break_right] [varchar](max) NULL,
	[spot_fifteen_corner_right] [varchar](max) NULL,
	[spot_college_corner_left] [varchar](max) NULL,
	[spot_college_break_left] [varchar](max) NULL,
	[spot_college_top_key] [varchar](max) NULL,
	[spot_college_break_right] [varchar](max) NULL,
	[spot_college_corner_right] [varchar](max) NULL,
	[spot_nba_corner_left] [varchar](max) NULL,
	[spot_nba_break_left] [varchar](max) NULL,
	[spot_nba_top_key] [varchar](max) NULL,
	[spot_nba_break_right] [varchar](max) NULL,
	[spot_nba_corner_right] [varchar](max) NULL,
	[off_drib_fifteen_break_left] [varchar](max) NULL,
	[off_drib_fifteen_top_key] [varchar](max) NULL,
	[off_drib_fifteen_break_right] [varchar](max) NULL,
	[off_drib_college_break_left] [varchar](max) NULL,
	[off_drib_college_top_key] [varchar](max) NULL,
	[off_drib_college_break_right] [varchar](max) NULL,
	[on_move_fifteen] [varchar](max) NULL,
	[on_move_college] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[draft_history]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[draft_history](
	[person_id] [int] NOT NULL,
	[player_name] [varchar](max) NULL,
	[season] [bigint] NULL,
	[round_number] [bigint] NULL,
	[round_pick] [bigint] NULL,
	[overall_pick] [bigint] NULL,
	[draft_type] [varchar](max) NULL,
	[team_id] [int] NOT NULL,
	[team_city] [varchar](max) NULL,
	[team_name] [varchar](max) NULL,
	[team_abbreviation] [varchar](max) NULL,
	[organization] [varchar](max) NULL,
	[organization_type] [varchar](max) NULL,
	[player_profile_flag] [bigint] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[game]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[game](
	[season_id] [bigint] NULL,
	[team_id_home] [bigint] NULL,
	[team_abbreviation_home] [varchar](max) NULL,
	[team_name_home] [varchar](max) NULL,
	[game_id] [int] NOT NULL,
	[game_date] [varchar](max) NULL,
	[matchup_home] [varchar](max) NULL,
	[wl_home] [varchar](max) NULL,
	[min] [bigint] NULL,
	[fgm_home] [float] NULL,
	[fga_home] [float] NULL,
	[fg_pct_home] [float] NULL,
	[fg3m_home] [float] NULL,
	[fg3a_home] [float] NULL,
	[fg3_pct_home] [float] NULL,
	[ftm_home] [float] NULL,
	[fta_home] [float] NULL,
	[ft_pct_home] [float] NULL,
	[oreb_home] [float] NULL,
	[dreb_home] [float] NULL,
	[reb_home] [float] NULL,
	[ast_home] [float] NULL,
	[stl_home] [float] NULL,
	[blk_home] [float] NULL,
	[tov_home] [float] NULL,
	[pf_home] [float] NULL,
	[pts_home] [float] NULL,
	[plus_minus_home] [bigint] NULL,
	[video_available_home] [bigint] NULL,
	[team_id_away] [bigint] NULL,
	[team_abbreviation_away] [varchar](max) NULL,
	[team_name_away] [varchar](max) NULL,
	[matchup_away] [varchar](max) NULL,
	[wl_away] [varchar](max) NULL,
	[fgm_away] [float] NULL,
	[fga_away] [float] NULL,
	[fg_pct_away] [float] NULL,
	[fg3m_away] [float] NULL,
	[fg3a_away] [float] NULL,
	[fg3_pct_away] [float] NULL,
	[ftm_away] [float] NULL,
	[fta_away] [float] NULL,
	[ft_pct_away] [float] NULL,
	[oreb_away] [float] NULL,
	[dreb_away] [float] NULL,
	[reb_away] [float] NULL,
	[ast_away] [float] NULL,
	[stl_away] [float] NULL,
	[blk_away] [float] NULL,
	[tov_away] [float] NULL,
	[pf_away] [float] NULL,
	[pts_away] [float] NULL,
	[plus_minus_away] [bigint] NULL,
	[video_available_away] [bigint] NULL,
	[season_type] [varchar](max) NULL,
 CONSTRAINT [PK_game] PRIMARY KEY CLUSTERED 
(
	[game_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Perdida_Robos_Balon]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Perdida_Robos_Balon](
	[game_id] [int] NULL,
	[eventmsgtype] [bigint] NULL,
	[player1_id] [int] NULL,
	[player1_name] [varchar](max) NULL,
	[player2_id] [int] NULL,
	[player2_name] [varchar](max) NULL,
	[turnover_type] [varchar](max) NULL,
	[steal_count] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[player]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[player](
	[id] [int] NOT NULL,
	[full_name] [varchar](max) NULL,
	[first_name] [varchar](max) NULL,
	[last_name] [varchar](max) NULL,
	[is_active] [bigint] NULL,
 CONSTRAINT [PK_player] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[PlayerStatsSummary]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PlayerStatsSummary](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[game_id] [bigint] NOT NULL,
	[player_id_max_points] [bigint] NULL,
	[player1_name] [nvarchar](100) NULL,
	[max_points] [int] NULL,
	[player_id_max_assists] [bigint] NULL,
	[player2_name] [nvarchar](100) NULL,
	[max_assists] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Rebotes]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Rebotes](
	[game_id] [int] NULL,
	[homedescription] [varchar](max) NULL,
	[eventmsgtype] [bigint] NULL,
	[visitordescription] [varchar](max) NULL,
	[player1_id] [int] NULL,
	[player1_name] [varchar](max) NULL,
	[total_rebounds] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[team]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[team](
	[id] [int] NOT NULL,
	[full_name] [varchar](max) NULL,
	[abbreviation] [varchar](max) NULL,
	[nickname] [varchar](max) NULL,
	[city] [varchar](max) NULL,
	[state] [varchar](max) NULL,
	[year_founded] [float] NULL,
 CONSTRAINT [PK_team] PRIMARY KEY CLUSTERED 
(
	[id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[team_details]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[team_details](
	[team_id] [int] NOT NULL,
	[abbreviation] [varchar](max) NULL,
	[nickname] [varchar](max) NULL,
	[yearfounded] [float] NULL,
	[city] [varchar](max) NULL,
	[arena] [varchar](max) NULL,
	[arenacapacity] [float] NULL,
	[owner] [varchar](max) NULL,
	[generalmanager] [varchar](max) NULL,
	[headcoach] [varchar](max) NULL,
	[dleagueaffiliation] [varchar](max) NULL,
	[facebook] [varchar](max) NULL,
	[instagram] [varchar](max) NULL,
	[twitter] [varchar](max) NULL,
 CONSTRAINT [PK_team_details] PRIMARY KEY CLUSTERED 
(
	[team_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[tipo_evento]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tipo_evento](
	[eventmsgtype] [bigint] NOT NULL,
	[descripcion] [nvarchar](50) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[eventmsgtype] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tiros_Exitosos]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tiros_Exitosos](
	[game_id] [int] NULL,
	[eventmsgtype] [bigint] NULL,
	[homedescription.1] [varchar](max) NULL,
	[visitordescription] [varchar](max) NULL,
	[player1_id] [int] NULL,
	[player1_name] [varchar](max) NULL,
	[player2_id] [int] NULL,
	[player2_name] [varchar](max) NULL,
	[Player_Description] [varchar](max) NULL,
	[Points] [varchar](max) NULL,
	[Assistant_Name] [varchar](max) NULL,
	[Assists] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tiros_Libres]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tiros_Libres](
	[game_id] [int] NULL,
	[eventmsgtype] [bigint] NULL,
	[player1_id] [int] NULL,
	[player1_name] [varchar](max) NULL,
	[Description] [varchar](max) NULL,
	[Details] [varchar](max) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Tiros_NO_Exitosos]    Script Date: 26/11/2024 11:21:56 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Tiros_NO_Exitosos](
	[game_id] [int] NULL,
	[homedescription] [varchar](max) NULL,
	[eventmsgtype] [bigint] NULL,
	[visitordescription] [varchar](max) NULL,
	[player1_id] [int] NULL,
	[player1_name] [varchar](max) NULL,
	[player3_id] [int] NULL,
	[player3_name] [varchar](max) NULL,
	[Miss Shoot] [varchar](max) NULL,
	[Block] [varchar](max) NULL,
	[Block Number] [float] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[common_player_info]  WITH CHECK ADD  CONSTRAINT [FK_common_player_info] FOREIGN KEY([person_id])
REFERENCES [dbo].[player] ([id])
GO
ALTER TABLE [dbo].[common_player_info] CHECK CONSTRAINT [FK_common_player_info]
GO
ALTER TABLE [dbo].[draft_combine_stats]  WITH CHECK ADD  CONSTRAINT [FK_draft_combine_stats] FOREIGN KEY([player_id])
REFERENCES [dbo].[player] ([id])
GO
ALTER TABLE [dbo].[draft_combine_stats] CHECK CONSTRAINT [FK_draft_combine_stats]
GO
ALTER TABLE [dbo].[draft_history]  WITH CHECK ADD  CONSTRAINT [FK_draft_history_player] FOREIGN KEY([person_id])
REFERENCES [dbo].[player] ([id])
GO
ALTER TABLE [dbo].[draft_history] CHECK CONSTRAINT [FK_draft_history_player]
GO
ALTER TABLE [dbo].[draft_history]  WITH CHECK ADD  CONSTRAINT [FK_draft_history_team] FOREIGN KEY([team_id])
REFERENCES [dbo].[team] ([id])
GO
ALTER TABLE [dbo].[draft_history] CHECK CONSTRAINT [FK_draft_history_team]
GO
ALTER TABLE [dbo].[Perdida_Robos_Balon]  WITH CHECK ADD  CONSTRAINT [FK_Game_Perdida_Robos_Balon] FOREIGN KEY([game_id])
REFERENCES [dbo].[game] ([game_id])
GO
ALTER TABLE [dbo].[Perdida_Robos_Balon] CHECK CONSTRAINT [FK_Game_Perdida_Robos_Balon]
GO
ALTER TABLE [dbo].[Perdida_Robos_Balon]  WITH CHECK ADD  CONSTRAINT [FK_Player1_Perdida_Robos_Balon] FOREIGN KEY([player1_id])
REFERENCES [dbo].[player] ([id])
GO
ALTER TABLE [dbo].[Perdida_Robos_Balon] CHECK CONSTRAINT [FK_Player1_Perdida_Robos_Balon]
GO
ALTER TABLE [dbo].[Perdida_Robos_Balon]  WITH CHECK ADD  CONSTRAINT [FK_Player2_Perdida_Robos_Balon] FOREIGN KEY([player2_id])
REFERENCES [dbo].[player] ([id])
GO
ALTER TABLE [dbo].[Perdida_Robos_Balon] CHECK CONSTRAINT [FK_Player2_Perdida_Robos_Balon]
GO
ALTER TABLE [dbo].[PlayerStatsSummary]  WITH CHECK ADD  CONSTRAINT [FK_PlayerStatsSummary] FOREIGN KEY([id])
REFERENCES [dbo].[player] ([id])
GO
ALTER TABLE [dbo].[PlayerStatsSummary] CHECK CONSTRAINT [FK_PlayerStatsSummary]
GO
ALTER TABLE [dbo].[Rebotes]  WITH CHECK ADD  CONSTRAINT [FK_Game_Rebotes] FOREIGN KEY([game_id])
REFERENCES [dbo].[game] ([game_id])
GO
ALTER TABLE [dbo].[Rebotes] CHECK CONSTRAINT [FK_Game_Rebotes]
GO
ALTER TABLE [dbo].[Rebotes]  WITH CHECK ADD  CONSTRAINT [FK_Player1_Rebotes] FOREIGN KEY([player1_id])
REFERENCES [dbo].[player] ([id])
GO
ALTER TABLE [dbo].[Rebotes] CHECK CONSTRAINT [FK_Player1_Rebotes]
GO
ALTER TABLE [dbo].[team_details]  WITH CHECK ADD  CONSTRAINT [FK_team_details_team] FOREIGN KEY([team_id])
REFERENCES [dbo].[team] ([id])
GO
ALTER TABLE [dbo].[team_details] CHECK CONSTRAINT [FK_team_details_team]
GO
ALTER TABLE [dbo].[Tiros_Exitosos]  WITH CHECK ADD  CONSTRAINT [FK_Tiros_Exitosos] FOREIGN KEY([game_id])
REFERENCES [dbo].[game] ([game_id])
GO
ALTER TABLE [dbo].[Tiros_Exitosos] CHECK CONSTRAINT [FK_Tiros_Exitosos]
GO
ALTER TABLE [dbo].[Tiros_Libres]  WITH CHECK ADD  CONSTRAINT [FK_Player1_Tiros_Libres] FOREIGN KEY([player1_id])
REFERENCES [dbo].[player] ([id])
GO
ALTER TABLE [dbo].[Tiros_Libres] CHECK CONSTRAINT [FK_Player1_Tiros_Libres]
GO
ALTER TABLE [dbo].[Tiros_Libres]  WITH CHECK ADD  CONSTRAINT [FK_Tiros_Libres] FOREIGN KEY([game_id])
REFERENCES [dbo].[game] ([game_id])
GO
ALTER TABLE [dbo].[Tiros_Libres] CHECK CONSTRAINT [FK_Tiros_Libres]
GO
ALTER TABLE [dbo].[Tiros_NO_Exitosos]  WITH CHECK ADD  CONSTRAINT [FK_Player1_Tiros_NO_Exitosos] FOREIGN KEY([player1_id])
REFERENCES [dbo].[player] ([id])
GO
ALTER TABLE [dbo].[Tiros_NO_Exitosos] CHECK CONSTRAINT [FK_Player1_Tiros_NO_Exitosos]
GO
ALTER TABLE [dbo].[Tiros_NO_Exitosos]  WITH CHECK ADD  CONSTRAINT [FK_Player3_Tiros_NO_Exitosos] FOREIGN KEY([player3_id])
REFERENCES [dbo].[player] ([id])
GO
ALTER TABLE [dbo].[Tiros_NO_Exitosos] CHECK CONSTRAINT [FK_Player3_Tiros_NO_Exitosos]
GO
ALTER TABLE [dbo].[Tiros_NO_Exitosos]  WITH CHECK ADD  CONSTRAINT [FK_Tiros_NO_Exitosos] FOREIGN KEY([game_id])
REFERENCES [dbo].[game] ([game_id])
GO
ALTER TABLE [dbo].[Tiros_NO_Exitosos] CHECK CONSTRAINT [FK_Tiros_NO_Exitosos]
GO
USE [master]
GO
ALTER DATABASE [NBA_STATS] SET  READ_WRITE 
GO

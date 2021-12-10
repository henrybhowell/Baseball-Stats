USE Baseball;
-- Aggregates a batter's game level stats against a given team within a date range
DROP PROCEDURE IF EXISTS batterGameStats;
DELIMITER //
CREATE PROCEDURE batterGameStats(firstname VARCHAR(20), lastname VARCHAR(20), opponent VARCHAR(3), start_date DATE, end_date DATE, home BIT, away BIT)
BEGIN
	DECLARE pid INT;
	SET pid = (SELECT player_id FROM Players WHERE (first_name = firstname AND last_name = lastname));
	IF opponent = 'All' THEN
		IF home = 1 THEN
			SELECT * FROM BatterPlaysIn AS B, (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date) AS G
			WHERE B.player_id = pid AND B.team = G.home_team AND G.game_id = B.game_id;
		ELSEIF away = 1 THEN
			SELECT * FROM BatterPlaysIn AS B, (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date) AS G
			WHERE B.player_id = pid AND B.team = G.away_team AND G.game_id = B.game_id;
		ELSE
			SELECT * FROM BatterPlaysIn AS B, (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date) AS G
			WHERE B.player_id = pid AND (B.team = G.home_team OR B.team = G.away_team)AND G.game_id = B.game_id;
		END IF;
	ELSE
		IF home = 1 THEN
			SELECT * FROM BatterPlaysIn AS B, (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date AND Game.away_team = opponent) AS G
			WHERE B.player_id = pid AND B.team = G.home_team AND G.game_id = B.game_id;
		ELSEIF away = 1 THEN
			SELECT * FROM BatterPlaysIn AS B, (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date AND Game.home_team = opponent) AS G
			WHERE B.player_id = pid AND B.team = G.home_team AND G.game_id = B.game_id;
		ELSE
			SELECT * FROM BatterPlaysIn AS B, (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date) AS G
			WHERE B.player_id = pid AND ((B.team = G.home_team AND G.away_team = opponent) OR (B.team = G.away_team AND G.home_team = opponent)) AND G.game_id = B.game_id;
		END IF;
	END IF;
END;
//
DELIMITER ;

-- Aggregates a pitcher's game level statistics against a given team within a date range
DROP PROCEDURE IF EXISTS pitcherGameStats;
DELIMITER //
CREATE PROCEDURE pitcherGameStats(firstname VARCHAR(20), lastname VARCHAR(20), opponent VARCHAR(3), start_date DATE, end_date DATE, home BIT, away BIT)
BEGIN
	DECLARE pid INT;
	SET pid = (SELECT player_id FROM Players WHERE (first_name = firstname AND last_name = lastname));
	IF opponent = 'All' THEN
		IF home = 1 THEN
			SELECT * FROM PitcherPlaysIn AS B, (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date) AS G
			WHERE B.player_id = pid AND B.team = G.home_team AND G.game_id = B.game_id;
		ELSEIF away = 1 THEN
			SELECT * FROM PitcherPlaysIn AS B, (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date) AS G
			WHERE B.player_id = pid AND B.team = G.away_team AND G.game_id = B.game_id;
		ELSE
			SELECT * FROM PitcherPlaysIn AS B, (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date) AS G
			WHERE B.player_id = pid AND (B.team = G.home_team OR B.team = G.away_team)AND G.game_id = B.game_id;
		END IF;
	ELSE
		IF home = 1 THEN
			SELECT * FROM PitcherPlaysIn AS B, (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date AND Game.away_team = opponent) AS G
			WHERE B.player_id = pid AND B.team = G.home_team AND G.game_id = B.game_id;
		ELSEIF away = 1 THEN
			SELECT * FROM PitcherPlaysIn AS B, (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date AND Game.home_team = opponent) AS G
			WHERE B.player_id = pid AND B.team = G.home_team AND G.game_id = B.game_id;
		ELSE
			SELECT * FROM PitcherPlaysIn AS B, (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date) AS G
			WHERE B.player_id = pid AND ((B.team = G.home_team AND G.away_team = opponent) OR (B.team = G.away_team AND G.home_team = opponent)) AND G.game_id = B.game_id;
		END IF;
	END IF;
END;
//
DELIMITER ;

DROP PROCEDURE IF EXISTS teamTable;
DELIMITER //
CREATE PROCEDURE teamTable(team VARCHAR(3), opponent VARCHAR(3), home BIT, away BIT, start_date DATE, finish_date DATE)
BEGIN
	IF opponent = 'All' THEN 
		IF home = 1 THEN
			SET @wins = (SELECT COUNT(*) FROM Game WHERE (home_team = team) AND (home_score - away_score > 0));
			SET @losses = (SELECT COUNT(*) FROM Game WHERE (home_team = team) AND (home_score - away_score < 0));
			SET @winpercentage = @wins/(@wins+@losses);
			SET @GP = @wins+@losses;
			SET @RF = (SELECT SUM(home_score) FROM Game WHERE home_team = team);
			SET @RA = (SELECT SUM(away_score) FROM Game WHERE home_team = team);
			SELECT @GP AS Games_Played, @winpercentage AS Win_PCT, @RF AS RF, @RA AS RA;
			SELECT * FROM Game WHERE home_team = team;
		ELSEIF away = 1 THEN
			SET @wins = (SELECT COUNT(*) FROM Game WHERE (away_team = team) AND (home_score - away_score < 0));
			SET @losses = (SELECT COUNT(*) FROM Game WHERE (away_team = team) AND (home_score - away_score >0));
			SET @winpercentage = @wins/(@wins+@losses);
			SET @GP = @wins+@losses;
			SET @RF = (SELECT SUM(away_score) FROM Game WHERE away_team = team);
			SET @RA = (SELECT SUM(home_score) FROM Game WHERE away_team = team);
			SELECT @GP AS Games_Played, @winpercentage AS Win_PCT, @RF AS RF, @RA AS RA;
			SELECT * FROM Game WHERE away_team = team;
		ELSE
			SET @wins = (SELECT COUNT(*) FROM Game WHERE ((away_team = team) AND (home_score - away_score < 0)) OR ((home_team = team) AND (home_score - away_score > 0)));
			SET @losses = (SELECT COUNT(*) FROM Game WHERE ((away_team = team) AND (home_score - away_score >0)) OR ((home_team = team) AND (home_score - away_score <0)));
			SET @winpercentage = @wins/(@wins+@losses);
			SET @GP = @wins+@losses;
			SET @RF = (SELECT SUM(away_score) FROM Game WHERE away_team = team) + (SELECT SUM(home_score) FROM Game WHERE away_team = team);
			SET @RA = (SELECT SUM(home_score) FROM Game WHERE away_team = team) + (SELECT SUM(away_score) FROM Game WHERE away_team = team);
			SELECT @GP AS Games_Played, @winpercentage AS Win_PCT, @RF AS RF, @RA AS RA;
			SELECT * FROM Game;
		END IF;	
	ELSE 
		IF home = 1 THEN
			SET @wins = (SELECT COUNT(*) FROM Game WHERE (home_team = team) AND (away_team = opponent) AND (home_score - away_score > 0));
			SET @losses = (SELECT COUNT(*) FROM Game WHERE (home_team = team) AND (away_team = opponent) AND (home_score - away_score <0));
			SET @winpercentage = @wins/(@wins+@losses);
			SET @GP = @wins+@losses;
			SET @RF = (SELECT SUM(home_score) FROM Game WHERE home_team = team AND away_team = opponent);
			SET @RA = (SELECT SUM(away_score) FROM Game WHERE home_team = team AND away_team = opponent);
			SELECT @GP AS Games_Played, @winpercentage AS Win_PCT, @RF AS RF, @RA AS RA;
			SELECT * FROM Game WHERE home_team = team and away_team = opponenet;
		ELSEIF away = 1 THEN
			SET @wins = (SELECT COUNT(*) FROM Game WHERE (away_team = team) AND (home_team = opponent) AND (home_score - away_score < 0));
			SET @losses = (SELECT COUNT(*) FROM Game WHERE (away_team = team) AND (home_team = opponent) AND (home_score - away_score >0));
			SET @winpercentage = @wins/(@wins+@losses);
			SET @GP = @wins+@losses;
			SET @RF = (SELECT SUM(away_score) FROM Game WHERE away_team = team AND home_team = opponent); 
			SET @RA = (SELECT SUM(home_score) FROM Game WHERE home_team = opponent AND away_team = team);
			SELECT @GP AS Games_Played, @winpercentage AS Win_PCT, @RF AS RF, @RA AS RA;
			SELECT * FROM Game WHERE home_team = team and away_team = opponenet;
		ELSE
			SET @wins = (SELECT COUNT(*) FROM Game WHERE ((away_team = team AND home_team = opponent) AND (home_score - away_score < 0) ) OR ((home_team = team AND away_team = opponent) AND (home_score - away_score > 0)));
			SET @losses = (SELECT COUNT(*) FROM Game WHERE ((away_team = team AND home_team = opponent) AND (home_score - away_score >0)) OR ((home_team = team AND away_team = opponent) AND (home_score - away_score < 0)));
			SET @winpercentage = @wins/(@wins+@losses);
			SET @GP = @wins+@losses;
			SET @RF = (SELECT SUM(away_score) FROM Game WHERE away_team = team and home_team = opponent) + (SELECT SUM(home_score) FROM Game WHERE away_team = team AND home_team = opponent);
			SET @RA = (SELECT SUM(home_score) FROM Game WHERE away_team = team AND home_team = oppenent) + (SELECT SUM(away_score) FROM Game WHERE away_team = team AND away_team = opponent);
			SELECT @GP AS Games_Played, @winpercentage AS Win_PCT, @RF AS RF, @RA AS RA;
			SELECT * FROM Game;
		END IF;
	END IF;
END;
//
DELIMITER ;

DROP PROCEDURE IF EXISTS pitcherSeasonStats;
DELIMITER //
CREATE PROCEDURE pitcherSeasonStats(start_year VARCHAR(4), end_year VARCHAR(4), firstname VARCHAR(20), lastname VARCHAR(20))
BEGIN
	DECLARE pid INT;
	SET pid = (SELECT player_id FROM Players WHERE (first_name = firstname AND last_name = lastname));
	SELECT * FROM PitcherSeasonStats WHERE player_id = pid AND season >= start_year AND season <= end_year;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS pitcherSeasonStats;
DELIMITER //
CREATE PROCEDURE pitcherSeasonStats(start_year VARCHAR(4), end_year VARCHAR(4), firstname VARCHAR(20), lastname VARCHAR(20))
BEGIN
	DECLARE pid INT;
	SET pid = (SELECT player_id FROM Players WHERE (first_name = firstname AND last_name = lastname));
	SELECT * FROM PitcherSeasonStats WHERE player_id = pid AND season >= start_year AND season <= end_year;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS batterSeasonStats;
DELIMITER //
CREATE PROCEDURE batterSeasonStats(start_year VARCHAR(4), end_year VARCHAR(4), firstname VARCHAR(20), lastname VARCHAR(20))
BEGIN
	DECLARE pid INT;
	SET pid = (SELECT player_id FROM Players WHERE (first_name = firstname AND last_name = lastname));
	SELECT * FROM BatterSeasonStats WHERE player_id = pid AND season >= start_year AND season <= end_year;
END
//
DELIMITER ;

-- Add aggregate stats 
DROP PROCEDURE IF EXISTS batterMatchUp; 
DELIMITER //
CREATE PROCEDURE batterMatchUp(firstname VARCHAR(20), lastname VARCHAR(20), opponent VARCHAR(3), start_date DATE, end_date DATE, home BIT, away BIT)
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
-- Add aggregate
DROP PROCEDURE IF EXISTS pitcherMatchUp; 
DELIMITER //
CREATE PROCEDURE pitcherMatchUp(firstname VARCHAR(20), lastname VARCHAR(20), opponent VARCHAR(3), start_date DATE, end_date DATE, home BIT, away BIT)
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

DROP PROCEDURE IF EXISTS batterLeaderboard;
DELIMITER //
CREATE PROCEDURE batterLeaderboard(start_date DATE, end_date DATE)
BEGIN
	SELECT * FROM BatterPlaysIn AS B, (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date) AS G, Players AS P 
	WHERE B.game_id = G.game_id AND P.player_id = B.player_id;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS pitcherLeaderboard;
DELIMITER //
CREATE PROCEDURE pitcherLeaderboard(start_date DATE, end_date DATE)
BEGIN
	SELECT * FROM PitcherPlaysIn AS B, (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date) AS G, Players AS P 
	WHERE B.game_id = G.game_id AND P.player_id = B.player_id;
END
//
DELIMITER ;
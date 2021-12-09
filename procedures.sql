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
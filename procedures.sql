USE Baseball;

DROP FUNCTION IF EXISTS getAgeDay; 
DELIMITER //
CREATE FUNCTION getAgeDay(dob DATE) RETURNS INTEGER READS SQL DATA
BEGIN
	DECLARE years INT; DECLARE days INT; DECLARE cur_date DATE;
	SET cur_date = NOW();
	SET days = DAYOFYEAR(cur_date) - DAYOFYEAR(dob);
	RETURN days;
END;
//
DELIMITER ;


DROP FUNCTION IF EXISTS getAgeYear; 
DELIMITER //
CREATE FUNCTION getAgeYear(dob DATE) RETURNS INTEGER READS SQL DATA
BEGIN
	DECLARE years INT; DECLARE cur_date DATE;
	SET cur_date = NOW();
	SET years = YEAR(cur_date) - YEAR(dob);
	RETURN years;
END;
//
DELIMITER ;

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
-- Add aggregate
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
CALL pitcherMatchUp('Rich', 'Hill', 'All', '2015-01-01', '2022-01-01', 1,0);

DROP PROCEDURE IF EXISTS batterGameLeaderboard;
DELIMITER //
CREATE PROCEDURE batterGameLeaderboard(start_date DATE, end_date DATE)
BEGIN
	SELECT * FROM (Players NATURAL JOIN BatterPlaysIn AS P) NATURAL JOIN (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date) AS G;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS pitcherGameLeaderboard;
DELIMITER //
CREATE PROCEDURE pitcherGameLeaderboard(start_date DATE, end_date DATE)
BEGIN
	SELECT * FROM (Players NATURAL JOIN PitcherPlaysIn AS P) NATURAL JOIN (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date) AS G;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS getPlayerInfo;
DELIMITER //
CREATE PROCEDURE getPlayerInfo(firstname VARCHAR(20), lastname VARCHAR(20))
BEGIN
	DECLARE pid INT;
	SET pid = (SELECT player_id FROM Players WHERE first_name = firstname AND last_name = lastname);
	SELECT *, getAgeYear(birthdate) AS ageYear, getAgeDay(birthdate) AS ageDay FROM Players WHERE player_id = pid; 
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS PitcherSeasonAggregate;
DELIMITER //
CREATE PROCEDURE PitcherSeasonAggregate(start_year VARCHAR(4), finish_year VARCHAR(4))
BEGIN
    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
    SUM(R) AS R, SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
    SUM(xISO*AB)/SUM(AB) as xISO,
    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_mph,
    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin
    FROM PitcherSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=finish_year
    GROUP BY player_id;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS BatterGameAggregate;
DELIMITER //
CREATE PROCEDURE BatterGameAggregate(start_date DATE, end_date DATE, stat VARCHAR(20))

BEGIN
	IF stat = 'G' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date 
		GROUP BY player_id
		ORDER BY G DESC
		LIMIT 100;
	ELSEIF stat = 'PA' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY PA DESC
		LIMIT 100;
	ELSEIF stat = 'AB' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY PA DESC
		LIMIT 100;
	ELSEIF stat = 'R' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY R DESC
		LIMIT 100;
	ELSEIF stat = 'H' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY H DESC
		LIMIT 100;
	ELSEIF stat = '2B' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY 2B DESC
		LIMIT 100;
	ELSEIF stat = '3B' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY 3B DESC
		LIMIT 100;
	ELSEIF stat = 'HR' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY HR DESC
		LIMIT 100;
	ELSEIF stat = 'RBI' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY RBI DESC
		LIMIT 100;
	ELSEIF stat = 'BB' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY BB DESC
		LIMIT 100;
	ELSEIF stat = 'IBB' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY IBB DESC
		LIMIT 100;
	ELSEIF stat = 'K' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY K DESC
		LIMIT 100;
	ELSEIF stat = 'HBP' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY HBP DESC
		LIMIT 100;
	ELSEIF stat = 'SH' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY SH DESC
		LIMIT 100;
	ELSEIF stat = 'SF' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY SF DESC
		LIMIT 100;
	ELSEIF stat = 'ROE' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY ROE DESC
		LIMIT 100;
	ELSEIF stat = 'GIDP' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY GIDP DESC
		LIMIT 100;
	ELSEIF stat = 'SB' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY SB DESC
		LIMIT 100;
	ELSEIF stat = 'CS' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY CS DESC
		LIMIT 100;
	ELSEIF stat = 'Average' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY Average DESC
		LIMIT 100;
	ELSEIF stat = 'OBP' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY OBP DESC
		LIMIT 100;
	ELSEIF stat = 'SLG' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY slugging_perc DESC
		LIMIT 100;
	ELSEIF stat = 'OPS' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY OPS DESC
		LIMIT 100;
	ELSEIF stat = 'batting_order_position' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY batting_order_position DESC
		LIMIT 100;
	ELSEIF stat = 'leverage_index_avg' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY leverage_index_avg DESC
		LIMIT 100;
	ELSEIF stat = 'wpa_bat' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY wpa_bat DESC
		LIMIT 100;
	ELSEIF stat = 'cli_avg' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY cli_avg DESC
		LIMIT 100;
	ELSEIF stat = 'cwpa_bat' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY cwpa_bat DESC
		LIMIT 100;
	ELSEIF stat = 're24_bat' THEN 
		SELECT first_name, last_name, COUNT(*) AS G, SUM(PA) AS PA, SUM(AB) AS AB, SUM(R) AS R,
		SUM(H) AS H, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(RBI) AS RBI, SUM(BB) AS BB, SUM(IBB) AS IBB,
		SUM(SO) AS K, SUM(HBP) AS HBP, SUM(SH) AS SH, SUM(SF) AS SF, 
		SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
		SUM(batting_avg*AB)/SUM(AB) as Average, SUM(onbase_perc*PA)/SUM(PA) as OBP, SUM(slugging_perc*AB)/SUM(AB) as slugging_perc,
		(SUM(onbase_perc*PA)/SUM(PA) +  SUM(slugging_perc*AB)/SUM(AB)) as OPS, AVG(batting_order_position),
		AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_bat) AS wpa_bat, AVG(cli_avg) AS cli_avg,
		SUM(cwpa_bat) AS cwpa_bat, SUM(re24_bat) AS re24_bat
		FROM (BatterPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY re24_bat DESC
		LIMIT 100;
	END IF;
END
//
DELIMITER ;
DROP PROCEDURE IF EXISTS PitcherGameAggregate;
DELIMITER //
CREATE PROCEDURE PitcherGameAggregate(start_date DATE, end_date DATE, stat VARCHAR(20))

BEGIN
    IF stat = 'G' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY G DESC
		LIMIT 100;
	ELSEIF stat = 'IP' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY IP DESC
		LIMIT 100;
	ELSEIF stat = 'H' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY H ASC
		LIMIT 100;
	ELSEIF stat = 'R' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY R ASC
		LIMIT 100;
	ELSEIF stat = 'ER' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY ER ASC
		LIMIT 100;
	ELSEIF stat = 'BB' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY BB ASC
		LIMIT 100;
	ELSEIF stat = 'K' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY K DESC
		LIMIT 100;
	ELSEIF stat = 'HR' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY HR ASC
		LIMIT 100;
	ELSEIF stat = 'HBP' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY HBP ASC
		LIMIT 100;
	ELSEIF stat = 'BAA' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY BAA ASC
		LIMIT 100;
	ELSEIF stat = 'ERA' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY ERA ASC
		LIMIT 100;
	ELSEIF stat = 'BF' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY BF DESC
		LIMIT 100;
	ELSEIF stat = 'pitches' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY pitches DESC
		LIMIT 100;
	ELSEIF stat = 'strikes_total' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY strikes_total DESC
		LIMIT 100;
	ELSEIF stat = 'ROE' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY ROE DESC
		LIMIT 100;
	ELSEIF stat = 'GIDP' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY GIDP ASC
		LIMIT 100;
	ELSEIF stat = 'SB' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY SB DESC
		LIMIT 100;
	ELSEIF stat = 'CS' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY CS DESC
		LIMIT 100;
	ELSEIF stat = 'strikes_looking' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY strikes_looking ASC
		LIMIT 100;
	ELSEIF stat = 'inplay_gb_total' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY inplay_gb_total DESC
		LIMIT 100;
	ELSEIF stat = 'inplay_fb_total' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY inplay_fb_total DESC
		LIMIT 100;
	ELSEIF stat = 'inplay_ld' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY inplay_ld DESC
		LIMIT 100;
	ELSEIF stat = 'inplay_pu' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY inplay_pu DESC
		LIMIT 100;
	ELSEIF stat = 'inplay_unk' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY inplay_unk DESC
		LIMIT 100;
	ELSEIF stat = 'inherited_runners' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY inherited_runners DESC
		LIMIT 100;
	ELSEIF stat = 'inherited_score' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY inherited_score DESC
		LIMIT 100;
	ELSEIF stat = 'SF' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY SF DESC
		LIMIT 100;
	ELSEIF stat = 'leverage_index_avg' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY leverage_index_avg DESC
		LIMIT 100;
	ELSEIF stat = 'wpa_def' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY wpa_def DESC
		LIMIT 100;
	ELSEIF stat = 'cwpa_def' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY cwpa_def DESC
		LIMIT 100;
	ELSEIF stat = 're24_def' THEN 
    	SELECT first_name, last_name, COUNT(*) AS G, SUM(IP) AS IP,
	    SUM(H) AS H, SUM(R) AS R, SUM(ER) AS ER, SUM(BB) AS BB,
	    SUM(SO) AS K, SUM(HR) AS HR, SUM(HBP) AS HBP, SUM(H)/SUM(AB) AS BAA,
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(BF) AS BF, SUM(pitches) AS pitches, SUM(strikes_total) AS strikes_total, 
	    SUM(ROE) AS ROE, SUM(GIDP) AS GIDP, SUM(SB) AS SB, SUM(CS) AS CS,
	    SUM(strikes_looking) as strikes_looking, SUM(inplay_gb_total) as inplay_gb_total, SUM(inplay_fb_total) as inplay_fb_total,
	    SUM(inplay_ld) AS inplay_ld, SUM(inplay_pu) AS inplay_pu, SUM(inplay_unk) AS inplay_unk, 
	    SUM(inherited_runners) AS inherited_runners, SUM(inherited_score) AS inherited_score,
	    SUM(SB) AS SB, SUM(CS) AS CS, SUM(pickoffs) AS pickoffs, SUM(AB) AS AB, SUM(2B) AS 2B,
	    SUM(3B) AS 3B, SUM(IBB) AS IBB, SUM(GIDP) AS GIDP, SUM(SF) AS SF, SUM(ROE) AS ROE,
	    AVG(leverage_index_avg) AS leverage_index_avg, SUM(wpa_def) AS wpa_def,
	    SUM(cwpa_def) AS cwpa_def, SUM(re24_def) AS re24_def
	    FROM (PitcherPlaysIn NATURAL JOIN Players) NATURAL JOIN Game WHERE date_game >= start_date AND date_game <= end_date
		GROUP BY player_id
		ORDER BY re24_def 
		LIMIT 100;
	END IF;
END

//
DELIMITER ;

DROP PROCEDURE IF EXISTS PitcherSeasonAggregate;
DELIMITER //
CREATE PROCEDURE PitcherSeasonAggregate(start_year YEAR, finish_year YEAR, stat VARCHAR(20))

BEGIN
    IF (stat = 'G') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY G LIMIT 0,100;
    
    
    ELSEIF (stat = 'IP') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY IP DESC 
	   	LIMIT 0,100;
    ELSEIF (stat = 'AB') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY AB DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'PA') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY PA DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'H') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY H DESC LIMIT 0,100;
    
    
    ELSEIF (stat = '1B') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY 1B DESC LIMIT 0,100;
    
    
    ELSEIF (stat = '2B') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY 2B DESC LIMIT 0,100;
    
    
    ELSEIF (stat = '3B') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY 3B DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'HR') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY HR DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'K') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY K DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'BB') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY BB DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'HBP') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY HBP DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'K_percent') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY K_percent DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'BB_percent') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY BB_percent LIMIT 0,100;
    
    
    ELSEIF (stat = 'BAA') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY BAA LIMIT 0,100;
    
    
    ELSEIF (stat = 'SLG') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY SLG LIMIT 0,100;
    
    
    ELSEIF (stat = 'OBP') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY OBP LIMIT 0,100;
    
    
    ELSEIF (stat = 'OPS') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY OPS LIMIT 0,100;
    
    
    ELSEIF (stat = 'ER') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY ER DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'R') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY R DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'SV') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY SV DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'BS') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY BS DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'W') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY W DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'L') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY L DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'ERA') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY ERA LIMIT 0,100;
    
    
    ELSEIF (stat = 'xBA') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY xBA LIMIT 0,100;
    
    
    ELSEIF (stat = 'xSLG') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY xSLG LIMIT 0,100;
    
    
    ELSEIF (stat = 'wOBA') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY wOBA LIMIT 0,100;
    
    
    ELSEIF (stat = 'xwOBA') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY xwOBA LIMIT 0,100;
    
    
    ELSEIF (stat = 'xOBP') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY xOBP LIMIT 0,100;
    
    
    ELSEIF (stat = 'xISO') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO,
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY xISO LIMIT 0,100;
    
    
    ELSEIF (stat = 'four_seam_percent') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY four_seam_percent DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'four_seam_avg_speed') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY four_seam_avg_speed DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'four_seam_avg_spin') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY four_seam_avg_spin DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'slider_percent') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY slider_percent DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'slider_avg_speed') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY slider_avg_speed DESC LIMIT 0,100;
    ELSEIF (stat = 'slider_avg_spin') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY slider_avg_spin DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'changeup_percent') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY changeup_percent DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'changeup_avg_speed') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY changeup_avg_speed DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'changeup_avg_spin') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY changeup_avg_spin DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'curveball_percent') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY curveball_percent DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'curveball_avg_speed') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY curveball_avg_speed DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'curveball_avg_spin') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY curveball_avg_spin DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'sinker_percent') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY sinker_percent DESC LIMIT 0,100;
	    
    
    ELSEIF (stat = 'sinker_avg_speed') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY sinker_avg_speed DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'sinker_avg_spin') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
    ORDER BY sinker_avg_spin DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'cutter_percent') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY cutter_percent DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'cutter_avg_speed') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY cutter_avg_speed DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'cutter_avg_spin') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY cutter_avg_spin DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'splitter_percent') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY splitter_percent DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'splitter_avg_speed') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY splitter_avg_speed DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'splitter_avg_spin') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY splitter_avg_spin DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'knuckle_percent') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY knuckle_percent DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'knuckle_avg_speed') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY knuckle_avg_speed DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'knuckle_avg_spin') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY knuckle_avg_spin DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'exit_velocity_avg') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY exit_velocity_avg DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'launch_angle_avg') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY launch_angle_avg DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'sweet_spot_percent') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
	    ORDER BY sweet_spot_percent DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'barrel_rate') THEN 
	    SELECT first_name, last_name, SUM(G) AS G, SUM(IP) AS IP, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(BAA*AB)/SUM(AB) as BAA,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(ER) AS ER, SUM(R) AS R,
	    SUM(SV) AS SV, SUM(BS) AS BS, SUM(W) AS W, SUM(L) AS L, 
	    SUM(ER)/(9*SUM(IP)) AS ERA, SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG,
	    SUM(wOBA*PA)/SUM(PA) as wOBA, SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, (SUM(xSLG*AB)/SUM(AB)-SUM(xBA*AB)/SUM(AB)) AS xISO, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    SUM(Pitches) AS Pitches,
	    SUM(four_seam_percent*Pitches)/SUM(Pitches) AS four_seam_percent,
	    SUM(four_seam_avg_mph*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_speed,
	    SUM(four_seam_avg_spin*four_seam_percent*Pitches)/SUM(four_seam_percent*Pitches) AS four_seam_avg_spin,
	    SUM(slider_percent*Pitches)/SUM(Pitches) AS slider_percent,
	    SUM(slider_avg_speed*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_speed,
	    SUM(slider_avg_spin*slider_percent*Pitches)/SUM(slider_percent*Pitches) AS slider_avg_spin,   
	    SUM(changeup_percent*Pitches)/SUM(Pitches) AS changeup_percent,
	    SUM(changeup_avg_speed*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_speed,
	    SUM(changeup_avg_spin*changeup_percent*Pitches)/SUM(changeup_percent*Pitches) AS changeup_avg_spin, 
	    SUM(curveball_percent*Pitches)/SUM(Pitches) AS curveball_avg_spin,
	    SUM(curveball_avg_speed*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_speed,
	    SUM(curveball_avg_spin*curveball_percent*Pitches)/SUM(curveball_percent*Pitches) AS curveball_avg_spin,
	    SUM(sinker_percent*Pitches)/SUM(Pitches) AS sinker_percent,
	    SUM(sinker_avg_speed*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_speed,
	    SUM(sinker_avg_spin*sinker_percent*Pitches)/SUM(sinker_percent*Pitches) AS sinker_avg_spin, 
	    SUM(cutter_percent*Pitches)/SUM(Pitches) AS cutter_percent,
	    SUM(cutter_avg_speed*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_speed,
	    SUM(cutter_avg_spin*cutter_percent*Pitches)/SUM(cutter_percent*Pitches) AS cutter_avg_spin, 
	    SUM(splitter_percent*Pitches)/SUM(Pitches) AS splitter_percent,
	    SUM(splitter_avg_speed*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_speed,
	    SUM(splitter_avg_spin*splitter_percent*Pitches)/SUM(splitter_percent*Pitches) AS splitter_avg_spin, 
	    SUM(knuckle_percent*Pitches)/SUM(Pitches) AS knuckle_percent,
	    SUM(knuckle_avg_speed*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_speed,
	    SUM(knuckle_avg_spin*knuckle_percent*Pitches)/SUM(knuckle_percent*Pitches) AS knuckle_avg_spin 
	    FROM (PitcherSeasonStats NATURAL JOIN Players) WHERE season>=start_year AND season<=finish_date
	    GROUP BY player_id
    	ORDER BY barrel_rate DESC LIMIT 0,100;
   
    END IF;
END
//
DELIMITER ;

DROP PROCEDURE IF EXISTS batterSeasonAggregate;
DELIMITER //
CREATE PROCEDURE batterSeasonAggregate(start_year VARCHAR(4), end_year VARCHAR(4), stat VARCHAR(20))
BEGIN
    IF (stat = 'G') THEN 
		SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
		SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
		SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
		SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
		SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
		(SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
		 SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
		SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
		SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
		SUM(xISO*AB)/SUM(AB) as xISO, 
		-- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
		-- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
		-- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
		-- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
		-- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
		-- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
		-- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
		-- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
		-- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
		-- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
		-- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
		-- -- AVG(whiff_percent) AS whiff_percent, 
		AVG(sprint_speed) as sprint_speed
		FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year GROUP BY player_id
		ORDER BY G DESC LIMIT 0,100;
    
    ELSEIF (stat = 'AB') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY AB DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'PA') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY PA DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'H') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY H DESC LIMIT 0,100;
    
    
    ELSEIF (stat = '1B') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY 1B DESC LIMIT 0,100;
    
    
    ELSEIF (stat = '2B') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY 2B DESC LIMIT 0,100;
    
    
    ELSEIF (stat = '3B') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY 3B DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'HR') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY HR DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'K') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY K DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'BB') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY BB DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'K_percent') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY K_percent LIMIT 0,100;
    
    
    ELSEIF (stat = 'BB_percent') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY BB_percent DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'Average') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY Average DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'SLG') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY SLG DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'OBP') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY OBP DESC LIMIT 0,100;
	    
    
    ELSEIF (stat = 'OPS') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY OPS DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'RBI') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY RBI DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'SB') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY SB DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'CS') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY CS DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'HBP') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY HBP DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'R') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY R DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'SB_percent') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY SB_percent DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'xBA') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY xBA DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'xSLG') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY xSLG DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'wOBA') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY wOBA DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'xwOBA') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY xwOBA DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'xOBP') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY xOBP DESC LIMIT 0,100;
    
    
    ELSEIF (stat = 'xISO') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY xISO DESC LIMIT 0,100;
    
     
    ELSEIF (stat = 'sprint_speed') THEN
	    SELECT first_name, last_name, SUM(G) AS G, SUM(AB) AS AB, SUM(PA) AS PA,
	    SUM(H) AS H, SUM(1B) AS 1B, SUM(2B) AS 2B, SUM(3B) AS 3B, SUM(HR) AS HR,
	    SUM(K) AS K, SUM(BB) AS BB, SUM(K_percent*PA)/SUM(PA) as K_percent,
	    SUM(BB_percent*PA)/SUM(PA) as BB_percent, SUM(Average*AB)/SUM(AB) as Average,
	    SUM(SLG*AB)/SUM(AB) as SLG, SUM(OBP*PA)/SUM(PA) as OBP,
	    (SUM(OBP*PA)/SUM(PA) +  SUM(SLG*AB)/SUM(AB)) as OPS, SUM(RBI) AS RBI, SUM(SB) AS SB,
	     SUM(HBP) AS HBP, SUM(R) AS R, SUM(SB)/SUM(SB/SB_percent) AS SB_percent,
	    SUM(xBA*AB)/SUM(AB) as xBA, SUM(xSLG*AB)/SUM(AB) as xSLG, SUM(wOBA*PA)/SUM(PA) as wOBA,
	    SUM(xwOBA*PA)/SUM(PA) as xwOBA, SUM(xOBP*PA)/SUM(PA) as xOBP, 
	    SUM(xISO*AB)/SUM(AB) as xISO, 
	    -- SUM(wOBACON*batted_balls)/SUM(batted_balls) AS wOBACON, 
	    -- SUM(xwBACON*batted_balls)/SUM(batted_balls) AS xwBACON, SUM(BACON*batted_balls)/SUM(batted_balls) AS BACON,
	    -- SUM(xBACON*batted_balls)/SUM(batted_balls) AS xBACON, SUM(batted_balls) AS batted_balls, 
	    -- SUM(exit_velocity_avg*batted_balls)/SUM(batted_balls) AS exit_velocity_avg, 
	    -- SUM(launch_angle_avg*batted_balls)/SUM(batted_balls) AS launch_angle_avg, 
	    -- SUM(sweet_spot_percent*batted_balls)/SUM(batted_balls) AS sweet_spot_percent, 
	    -- SUM(barrel_rate*batted_balls)/SUM(batted_balls) AS barrel_rate, 
	    -- SUM(groundballs_percent*batted_balls)/SUM(batted_balls) AS groundballs_percent, 
	    -- SUM(flyballs_percent*batted_balls)/SUM(batted_balls) AS flyballs_percent, 
	    -- SUM(linedrives_percent*batted_balls)/SUM(batted_balls) AS linedrives_percent, 
	    -- SUM(popups_percent*batted_balls)/SUM(batted_balls) AS popups_percent, 
	    -- AVG(whiff_percent) AS whiff_percent, 
	    AVG(sprint_speed) as sprint_speed
	    FROM BatterSeasonStats NATURAL JOIN Players WHERE season>=start_year AND season<=end_year
	    GROUP BY player_id
	    ORDER BY sprint_speed DESC LIMIT 0,100;
    END IF;
END
//
DELIMITER ;
CALL batterSeasonAggregate('2015', '2022', 'xISO');


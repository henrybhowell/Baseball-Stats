USE Baseball;
--Gets a given pitcher's season level stats split into individual years, within a year range
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
--Gets a given batter's season level stats split into individual years, within a year range
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

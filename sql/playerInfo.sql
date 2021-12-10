USE Baseball;

-- get a given player's bio information
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

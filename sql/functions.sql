USE Baseball;
--Get number of days a player has been their current age based on date of birth
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

--Gets age in years of player based on date of birth
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

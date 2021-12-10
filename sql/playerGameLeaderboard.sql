USE Baseball;

DROP PROCEDURE IF EXISTS batterGameLeaderboard;
DELIMITER //
CREATE PROCEDURE batterGameLeaderboard(start_date DATE, end_date DATE)
BEGIN
	SELECT * FROM (Players NATURAL JOIN BatterPlaysIn AS P) NATURAL JOIN (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date) AS G
	ORDER BY HR DESC
	LIMIT 0,100;
END
//
DELIMITER ;


DROP PROCEDURE IF EXISTS pitcherGameLeaderboard;
DELIMITER //
CREATE PROCEDURE pitcherGameLeaderboard(start_date DATE, end_date DATE)
BEGIN
	SELECT * FROM (Players NATURAL JOIN PitcherPlaysIn AS P) NATURAL JOIN (SELECT * FROM Game WHERE Game.date_game >= start_date AND Game.date_game <= end_date) AS G
	ORDER BY SO DESC
	LIMIT 0,100;
END

//
DELIMITER ;

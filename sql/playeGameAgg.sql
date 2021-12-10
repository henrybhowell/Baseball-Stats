DROP PROCEDURE IF EXISTS BatterGameAggregate;
DELIMITER //
CREATE PROCEDURE BatterGameAggregate(start_date DATE, end_date DATE, stat VARCHAR(20))
-- Aggregates game level stats for all batters between certain date range, projects top 100 of given stat ordered by stat
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
-- Aggregates game level stats for all pitchers between certain date range, projects top 100 of given stat ordered by stat
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

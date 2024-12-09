/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP PROCEDURE IF EXISTS `sp_getDayRangeBaseData`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_getDayRangeBaseData`(
    IN startTime DATE,
    IN endTime DATE,
    IN agents LONGTEXT
)
BEGIN
    SELECT
    SUM(WinGold * exchangeRate) AS dayWinGold,
    SUM(LostGold * exchangeRate) AS dayLostGold,
    SUM(CellScore * exchangeRate) AS dayValidBet,
    SUM(Revenue * exchangeRate) AS dayDeductGold,
    SUM(ActiveUsers) AS dayBetGames,
    SUM((WinGold + LostGold - Revenue) * exchangeRate) AS dayProfit
    FROM
    statis_record_agent_all
    WHERE
    StatisDate BETWEEN startTime AND endTime
    AND FIND_IN_SET(ChannelID, agents); 

END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP PROCEDURE IF EXISTS `sp_getSameTableAccount`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_getSameTableAccount`(IN `beginDate` date, IN `endDate` date, IN `gameId` int, IN `agentId` int, IN `account` varchar(200), IN `isAgent` int)
BEGIN
    DECLARE v_sqlBase LONGTEXT; 
    DECLARE v_innerWhereSql LONGTEXT; 
    DECLARE v_sqlSameTableAccount LONGTEXT; 
    DECLARE v_sqlRecord LONGTEXT; 
    DECLARE v_sqlWhere LONGTEXT; 
    DECLARE v_sqlRecordSelect LONGTEXT; 
    DECLARE v_beginM varchar(6); 
    DECLARE v_endM varchar(6); 
    DECLARE v_tableName varchar(100); 
    DECLARE v_gameName varchar(20);    

    SET v_innerWhereSql = CONCAT(' WHERE statisDate >= "',beginDate,'" AND statisDate <= "', endDate,'"'); 
    IF gameId > 0 THEN
        SET v_innerWhereSql = CONCAT(v_innerWhereSql,' AND gameId = ',gameId);             
    END IF ;  
    IF LENGTH(account) > 0 THEN
        SET v_innerWhereSql = CONCAT(v_innerWhereSql,' AND member1 = "',account,'"'); 
    END IF ;    
    IF agentId > 0 THEN
        SET v_innerWhereSql = CONCAT(v_innerWhereSql,' AND agentId1 = ',agentId);             
    END IF ; 
    IF isAgent > 0 THEN
        SET v_innerWhereSql = CONCAT(v_innerWhereSql,' AND agentId1 = agentId2');             
    END IF ; 

    SET v_sqlBase = CONCAT('
    SELECT member1, member2, COUNT(DISTINCT(member2)) AS memberCount, agentId1, SUM(sameTableCount) AS sameTableCount
    FROM (
		SELECT member1, member2, agentId1,	SUM(winCount + lostCount) AS sameTableCount	
        FROM KYStatis.sameTableUsers
		', v_innerWhereSql,'
		GROUP BY member1, member2) AS temp
    GROUP BY temp.member1
    HAVING memberCount > 0'); 

    SET v_beginM = DATE_FORMAT(beginDate,'%Y%m'); 
    SET v_endM = DATE_FORMAT(endDate,'%Y%m'); 
    SET v_sqlWhere = CONCAT(' WHERE StatisDate >= "',beginDate,'" AND StatisDate <= "',endDate,'"'); 

    IF agentId > 0 THEN   #代理商后台
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND ChannelID = ',agentId); 
    END IF; 
    IF LENGTH(account) > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND Account = "',account,'"'); 
    END IF; 

    SET v_sqlRecordSelect = 'Account, ChannelID, CellScore, (WinGold + LostGold) AS Profit, Revenue, (WinNum + LostNum) AS GameNum, currency'; 
    IF gameId = 0 THEN  -- 不选游戏
        SET v_tableName = CONCAT('statis_allgames',v_beginM,'_users'); 
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tableName) THEN
            SET v_sqlRecord = CONCAT('
            SELECT ',v_sqlRecordSelect,'
            FROM KYStatisUsers.',v_tableName,
            v_sqlWhere); 
        END IF; 
        IF v_beginM <> v_endM THEN
            SET v_tableName = CONCAT('statis_allgames',v_endM,'_users'); 
            IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tableName) THEN
                SET v_sqlRecord = CONCAT(v_sqlRecord,'
                UNION ALL 
                SELECT ',v_sqlRecordSelect,'
                FROM KYStatisUsers.',v_tableName,
                v_sqlWhere); 
            END IF; 
        END IF; 
    ELSE  -- 分游戏查询
        SET v_gameName = (SELECT GameParameter FROM KYDB_NEW.GameInfo WHERE GameID = gameId); 
        IF gameId = 620 THEN
			SET v_gameName = 'dzpk'; 
		END IF; 

        SET v_tableName = CONCAT('statis_',v_gameName,v_beginM,'_users'); 
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tableName) THEN
            SET v_sqlRecord = CONCAT('
            SELECT ',v_sqlRecordSelect,'
            FROM KYStatisUsers.',v_tableName,
            v_sqlWhere); 
        END IF; 
        IF v_beginM <> v_endM THEN
            SET v_tableName = CONCAT('statis_',v_gameName,v_endM,'_users'); 
            IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tableName) THEN
                SET v_sqlRecord = CONCAT(v_sqlRecord,' 
                UNION ALL 
                SELECT ',v_sqlRecordSelect,'
                FROM KYStatisUsers.',v_tableName,
                v_sqlWhere); 
            END IF; 
        END IF; 
    END IF; 

    SET v_sqlRecord = CONCAT('
        SELECT Account, ChannelID, SUM(CellScore * c.exchangeRate) AS CellScore, SUM(Profit * c.exchangeRate) AS Profit,
            SUM(Revenue * c.exchangeRate) AS Revenue, SUM(GameNum) AS GameNum 
        FROM (', v_sqlRecord,') AS main
        LEFT JOIN game_manage.rp_currency AS c ON main.currency = c.currency
        GROUP BY Account,ChannelID'); 

    IF LENGTH(v_sqlBase) > 0 THEN
        SET v_sqlSameTableAccount = CONCAT(
            'SELECT 	
                uni.member1 AS account, 
                uni.memberCount AS memberCount,
                uni.sameTableCount AS sameTableCount,
                (B.WinNum + B.LostNum) AS allGameNum,
                B.CellScore * C.exchangeRate AS allCellScore,
                (B.WinGold * C.exchangeRate + B.LostGold * C.exchangeRate) AS allProfit,
                B.Revenue * C.exchangeRate AS allRevenue, 
                A.CellScore AS cellScore, 
                A.Profit AS profit, 
                A.Revenue AS revenue, 
                A.GameNum AS gameNum
            FROM (',v_sqlBase,') AS uni
            LEFT JOIN (', v_sqlRecord,') AS A ON A.Account = uni.member1
            LEFT JOIN KYStatisUsers.statis_all_users_unique AS B ON B.account = uni.member1 
            LEFT JOIN game_manage.rp_currency AS C ON C.currency = B.currency
            GROUP BY uni.member1, uni.agentId1'); 
        SET @v_sqlRecord = v_sqlSameTableAccount; 
        PREPARE stmt
        FROM @v_sqlRecord; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
    END IF; 
END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP PROCEDURE IF EXISTS `sp_sameTableAccountDetail`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_sameTableAccountDetail`(IN `beginDate` date, IN `endDate` date,	IN `gameId` int, IN `account` varchar(200), IN `isAgent` int)
BEGIN
    DECLARE v_date VARCHAR(8); 
    DECLARE v_sqlBase LONGTEXT; 
    DECLARE v_sqlWhere LONGTEXT; 
    DECLARE v_sqlSameTableAccount LONGTEXT; 
    DECLARE v_sqlRecord LONGTEXT; 
    DECLARE v_sqlRecordSelect LONGTEXT; 
    DECLARE v_beginM varchar(6); 
    DECLARE v_endM varchar(6); 
    DECLARE v_tableName varchar(100); 
    DECLARE v_gameName varchar(20); 


    SET v_sqlWhere = CONCAT(' WHERE a.statisDate >= "',beginDate,'" AND a.statisDate <= "', endDate,'"', ' AND a.member1 = "', account,'"'); 
    IF gameId > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlBase , ' AND a.gameId = ' , gameId); 
    END IF ; 
    IF isAgent > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND a.agentId1 = a.agentId2'); 
    END IF ; 


    SET v_sqlBase = CONCAT('
        SELECT 			
            a.member1,
            a.member2,
            SUM(a.winCount + b.lostCount) AS sameTableCount,
            a.agentId1,
            a.agentId2,
            SUM(a.winCount) AS ownWinCount,
            SUM(b.lostCount) AS oppLostCount
        FROM KYStatis.sameTableUsers AS a
        JOIN KYStatis.sameTableUsers AS b ON a.gameId = b.gameId AND a.member1 = b.member2 AND a.member2 = b.member1 
        ',v_sqlWhere,'
        GROUP BY a.member1, a.member2'); 

    SET v_beginM = DATE_FORMAT(beginDate,'%Y%m'); 
    SET v_endM = DATE_FORMAT(endDate,'%Y%m'); 
    SET v_sqlRecordSelect = 'Account, ChannelID, CellScore, (WinGold + LostGold) AS Profit, Revenue, (WinNum + LostNum) AS GameNum, currency'; 

    IF gameId = 0 THEN  -- 不选游戏
        SET v_tableName = CONCAT('statis_allgames',v_beginM,'_users'); 
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tableName) THEN
            SET v_sqlRecord = CONCAT('
            SELECT ',v_sqlRecordSelect,'
            FROM KYStatisUsers.',v_tableName,'
            WHERE statisDate >= "',beginDate,'" AND statisDate <= "', endDate,'"'); 
        END IF; 
        IF v_beginM <> v_endM THEN
            SET v_tableName = CONCAT('statis_allgames',v_endM,'_users'); 
            IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tableName) THEN
                SET v_sqlRecord = CONCAT(v_sqlRecord,'
                UNION ALL 
                SELECT ',v_sqlRecordSelect,'
                FROM KYStatisUsers.',v_tableName,'
                WHERE statisDate >= "',beginDate,'" AND statisDate <= "', endDate,'"'); 
            END IF; 
        END IF; 
    ELSE  -- 分游戏查询
        SET v_gameName = (SELECT GameParameter FROM KYDB_NEW.GameInfo WHERE GameID = gameId); 
        IF gameId = 620 THEN
			SET v_gameName = 'dzpk'; 
		END IF; 

        SET v_tableName = CONCAT('statis_',v_gameName,v_beginM,'_users'); 
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tableName) THEN
            SET v_sqlRecord = CONCAT('
            SELECT ',v_sqlRecordSelect,'
            FROM KYStatisUsers.',v_tableName,'
            WHERE statisDate >= "',beginDate,'" AND statisDate <= "', endDate,'"'); 
        END IF; 
        IF v_beginM <> v_endM THEN
            SET v_tableName = CONCAT('statis_',v_gameName,v_endM,'_users'); 
            IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tableName) THEN
                SET v_sqlRecord = CONCAT(v_sqlRecord,' 
                UNION ALL 
                SELECT ',v_sqlRecordSelect,'
                FROM KYStatisUsers.',v_tableName,'
                WHERE statisDate >= "',beginDate,'" AND statisDate <= "', endDate,'"'); 
            END IF; 
        END IF; 
    END IF; 

    SET v_sqlRecord = CONCAT('
        SELECT Account, ChannelID, SUM(CellScore * c.exchangeRate) AS CellScore, SUM(Profit * c.exchangeRate) AS Profit,
            SUM(Revenue * c.exchangeRate) AS Revenue, SUM(GameNum) AS GameNum 
            FROM (', v_sqlRecord,') AS main
            LEFT JOIN game_manage.rp_currency AS c ON main.currency = c.currency 
            GROUP BY Account, ChannelID'); 

    IF LENGTH(v_sqlBase) > 0 THEN
        SET v_sqlSameTableAccount = CONCAT(
            'SELECT 	
                uni.member2 as account, 
                uni.sameTableCount AS sameTableCount,
                uni.ownWinCount AS ownWinCount,
                uni.oppLostCount AS oppLostCount,
                (B.WinNum + B.LostNum) AS allGameNum,
                B.CellScore * C.exchangeRate AS allCellScore,
                (B.WinGold * C.exchangeRate + B.LostGold * C.exchangeRate) AS allProfit,
                B.Revenue * C.exchangeRate AS allRevenue,
                A.CellScore AS cellScore, 
                A.Profit AS profit, 
                A.Revenue AS revenue, 
                A.GameNum AS gameNum
            FROM (',v_sqlBase,') AS uni
            LEFT JOIN (', v_sqlRecord,') AS A ON A.Account = uni.member2
            LEFT JOIN KYStatisUsers.statis_all_users_unique AS B ON B.account = uni.member2
            LEFT JOIN game_manage.rp_currency AS C ON C.currency = B.currency
            GROUP BY uni.member2'); 
        SET @v_sqlRecord = v_sqlSameTableAccount; 
        PREPARE stmt
        FROM @v_sqlRecord; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
    END IF; 
END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP PROCEDURE IF EXISTS `sp_statisSameTableUsers`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisSameTableUsers`(IN `in_statisDate` date)
BEGIN
	DECLARE v_sqlBase LONGTEXT; 
	DECLARE v_sqlSelect LONGTEXT; 
	DECLARE v_startTime TIMESTAMP(3); 
	DECLARE v_endTime TIMESTAMP(3); 
	DECLARE v_tableName varchar(100); 
	DECLARE v_date varchar(30); 
	DECLARE done INT DEFAULT FALSE; 
	DECLARE cur_gameId, cur_gameParameter LONGTEXT; 
	DECLARE cur1 CURSOR FOR SELECT GameID, GameParameter FROM KYDB_NEW.GameInfo; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

	SET v_startTime = CURRENT_TIMESTAMP(3); 
	SET v_sqlBase = ''; 
	IF in_statisDate IS NULL THEN
		SET in_statisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
	END IF; 

	SET v_date = DATE_FORMAT(in_statisDate,'%Y-%m-%d'); 

	OPEN cur1; 
		read_loop: LOOP
			FETCH cur1 INTO cur_gameId, cur_gameParameter; 

			IF done THEN
				LEAVE read_loop; 
			END IF; 

			IF cur_gameId = 620 THEN
				SET cur_gameParameter = 'dzpk'; 
			END IF; 

			SET v_tableName = CONCAT(cur_gameParameter, '_gameRecord'); 
			IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'detail_record' AND TABLE_NAME = v_tableName) THEN
				SET v_sqlBase = CONCAT(IF(LENGTH(v_sqlBase) <> 0, CONCAT(v_sqlBase,' UNION ALL '),''), '
					SELECT 
						"',v_date,'" AS statisDate,
						a.Accounts AS member1,
						b.Accounts AS member2,
						a.KindID AS gameId,
						a.ChannelID AS agentId1,
						b.ChannelID AS agentId2,
						SUM(CASE WHEN a.Profit > 0 THEN 1 ELSE 0 END) AS winCount,
						SUM(CASE WHEN a.Profit < 0 THEN 1 ELSE 0 END) AS lostCount
					FROM detail_record.',v_tableName,' AS a, detail_record.', v_tableName,' AS b
					WHERE a.GameEndTime = b.GameEndTime
					AND a.GameID = b.GameID
					AND a.Accounts != b.Accounts
					AND a.GameEndTime >= "',v_date,' 00:00:00"
					AND a.GameEndTime <= "',v_date,' 23:59:59"
					GROUP BY a.Accounts, b.Accounts'); 
			END IF; 
		END LOOP; 
	CLOSE cur1; 

	IF LENGTH(v_sqlBase) <> 0 THEN
		SET v_sqlSelect = CONCAT('REPLACE INTO KYStatis.sameTableUsers (statisDate, member1, member2, gameId, agentId1, agentId2, winCount, lostCount) ',v_sqlBase); 
		SET @v_sqlSelect = v_sqlSelect; 
		PREPARE stmt FROM @v_sqlSelect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 

    SET v_endTime = CURRENT_TIMESTAMP(3); 
    INSERT INTO KYStatis.prolog VALUES (NOW(),'KYStatis.sp_statisSameTableUsers',TIMESTAMPDIFF(SECOND,v_startTime,v_endTime)); 
END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP PROCEDURE IF EXISTS `sp_statis_game_daily_data`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statis_game_daily_data`(IN `Begindate` DATE, IN `Enddate` DATE)
BEGIN

    IF Begindate IS NULL AND `Enddate` IS NULL THEN
        SET `Begindate` = DATE_ADD(CURDATE(),INTERVAL -1 day); 
				SET `Enddate` = `Begindate`; 
    END IF; 

	IF Begindate IS NOT NULL AND EndDate IS NULL THEN
				TRUNCATE TABLE KYStatis.statis_game_daily; 
				SET `Begindate` = DATE_ADD(CURDATE(),INTERVAL -36 day); 
				SET `Enddate` = DATE_ADD(CURDATE(),INTERVAL -1 day); 
	END IF; 

	INSERT INTO KYStatis.statis_game_daily
	SELECT
			StatisDate,
			gameId,
			A.currency,
			cur.exchangeRate,
			dayProfit,
			dayValidBet,
			dayDeductGold,
			dayBetGames,
			dayNewBetUsers,
			gameNum 
	FROM (
	SELECT
			StatisDate,
			gameId,
			currency,
			SUM(WinGold + LostGold) AS dayProfit,
			SUM(CellScore) AS dayValidBet,
			SUM(Revenue) AS dayDeductGold,
			SUM(ActiveUsers) AS dayBetGames,
			SUM(DayNewBetUsers) AS dayNewBetUsers,
			SUM(WinNum + LostNum) AS gameNum 
	FROM KYStatis.statis_record_agent_game AS S
	WHERE StatisDate BETWEEN `Begindate` AND `Enddate`
	GROUP BY
			StatisDate,
			gameId,
			currency) AS A
	JOIN game_manage.rp_currency  AS cur ON cur.currency = A.currency; 

	DELETE FROM KYStatis.statis_game_daily
	WHERE StatisDate <= DATE_ADD(CURDATE(),INTERVAL -36 day); 

END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP PROCEDURE IF EXISTS `sp_statis_room_recordtype_data`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statis_room_recordtype_data`(IN beginDate date, IN endDate date)
BEGIN
	declare v_sql longtext; 
	declare v_sql_child longtext; 
	declare v_createSql longtext; 
	declare v_days int; 
	declare v_i int; 
	declare v_statis_date date; 
	declare v_tbl_name varchar(40); 
	declare v_sel_tbl_name varchar(40); 
	set @timediff = NOW(); 

	if beginDate is null then
		set beginDate = date_format(date_add(CURDATE(),interval -1 day),'%Y-%m-%d'); 
	end if; 
	if endDate is null then
		set endDate = date_format(date_add(CURDATE(),interval -1 day),'%Y-%m-%d'); 
	end if; 

	set v_days = datediff(endDate,beginDate); 
	set v_i = 0; 
	if v_days >= 0 then
		while v_i <= v_days do

			set v_statis_date = date_add(beginDate,interval v_i day); 

			set v_sel_tbl_name = concat('statis_room_kd_',date_format(v_statis_date,'%Y%m')); 

			set v_tbl_name = concat('statis_room_recordtype_data_',date_format(v_statis_date,'%Y%m')); 

			if not exists(select * from information_schema.tables where table_schema = 'KYStatis' and table_name = v_tbl_name) then
				set v_createSql = concat('CREATE TABLE ', v_tbl_name,' (
																StatisDate date NOT NULL,
																KindId int(11) NOT NULL DEFAULT ''0'',
																ServerId int(11) NOT NULL DEFAULT ''0'',
																oldSumValid bigint(20) not null default ''0'',
																oldSumProfit bigint(20) not null default ''0'',
																oldSumGameNum bigint(20) not null default ''0'',
																oldSumActiveUser int(11) not null default ''0'',
																oldNormalValid bigint(20) NOT NULL DEFAULT ''0'',
																oldNormalProfit bigint(20) NOT NULL DEFAULT ''0'',
																oldNormalGameNum bigint(20) NOT NULL DEFAULT ''0'',
																oldNormalActiveUser int(11) NOT NULL DEFAULT ''0'',
																oldKillValid bigint(20) NOT NULL DEFAULT ''0'',
																oldKillProfit bigint(20) NOT NULL DEFAULT ''0'',
																oldKillGameNum bigint(20) NOT NULL DEFAULT ''0'',
																oldKillActiveUser int(11) NOT NULL DEFAULT ''0'',
																oldClassKillValid bigint(20) NOT NULL DEFAULT ''0'',
																oldClassKillProfit bigint(20) NOT NULL DEFAULT ''0'',
																oldClassKillGameNum bigint(20) NOT NULL DEFAULT ''0'',
																oldClassKillActiveUser int(11) NOT NULL DEFAULT ''0'',
																oldRevValid bigint(20) NOT NULL DEFAULT ''0'',
																oldRevProfit bigint(20) NOT NULL DEFAULT ''0'',
																oldRevGameNum bigint(20) NOT NULL DEFAULT ''0'',
																oldRevActiveUser int(11) NOT NULL DEFAULT ''0'',
																oldClassRevValid bigint(20) NOT NULL DEFAULT ''0'',
																oldClassRevProfit bigint(20) NOT NULL DEFAULT ''0'',
																oldClassRevGameNum bigint(20) NOT NULL DEFAULT ''0'',
																oldClassRevActiveUser int(11) NOT NULL DEFAULT ''0'',
																oldPtkillValid bigint(20) NOT NULL DEFAULT ''0'',
																oldPtkillProfit bigint(20) NOT NULL DEFAULT ''0'',
																oldPtkillGameNum bigint(20) NOT NULL DEFAULT ''0'',
																oldPtkillActiveUser int(11) NOT NULL DEFAULT ''0'',
																newSumValid bigint(20) not null default ''0'',
																newSumProfit bigint(20) not null default ''0'',
																newSumGameNum bigint(20) not null default ''0'',
																newSumActiveUser int(11) not null default ''0'',
																newNormalValid bigint(20) NOT NULL DEFAULT ''0'',
																newNormalProfit bigint(20) NOT NULL DEFAULT ''0'',
																newNormalGameNum bigint(20) NOT NULL DEFAULT ''0'',
																newNormalActiveUser int(11) NOT NULL DEFAULT ''0'',
																newKillValid bigint(20) NOT NULL DEFAULT ''0'',
																newKillProfit bigint(20) NOT NULL DEFAULT ''0'',
																newKillGameNum bigint(20) NOT NULL DEFAULT ''0'',
																newKillActiveUser int(11) NOT NULL DEFAULT ''0'',
																newClassKillValid bigint(20) NOT NULL DEFAULT ''0'',
																newClassKillProfit bigint(20) NOT NULL DEFAULT ''0'',
																newClassKillGameNum bigint(20) NOT NULL DEFAULT ''0'',
																newClassKillActiveUser int(11) NOT NULL DEFAULT ''0'',
																newRevValid bigint(20) NOT NULL DEFAULT ''0'',
																newRevProfit bigint(20) NOT NULL DEFAULT ''0'',
																newRevGameNum bigint(20) NOT NULL DEFAULT ''0'',
																newRevActiveUser int(11) NOT NULL DEFAULT ''0'',
																newClassRevValid bigint(20) NOT NULL DEFAULT ''0'',
																newClassRevProfit bigint(20) NOT NULL DEFAULT ''0'',
																newClassRevGameNum bigint(20) NOT NULL DEFAULT ''0'',
																newClassRevActiveUser int(11) NOT NULL DEFAULT ''0'',
																newPtkillValid bigint(20) NOT NULL DEFAULT ''0'',
																newPtkillProfit bigint(20) NOT NULL DEFAULT ''0'',
																newPtkillGameNum bigint(20) NOT NULL DEFAULT ''0'',
																newPtkillActiveUser int(11) NOT NULL DEFAULT ''0'',
																currency varchar(20) NOT NULL COMMENT ''幣別'',
  																exchangeRate decimal(20,5) NOT NULL COMMENT ''汇率'',
																CreateTime datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
																Updatetime datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
																KEY idx_statisdate (StatisDate,KindId,ServerID,currency) USING BTREE
															) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;'); 
					set @v_createSql = v_createSql; 
					prepare stmt from @v_createSql; 
					execute stmt; 
					deallocate prepare stmt; 
			end if; 


			set v_sql = concat('delete from KYStatis.', v_tbl_name,' where StatisDate = ''', v_statis_date,''''); 
			set @v_sql = v_sql; 
			prepare stmt from @v_sql; 
			execute stmt; 
			deallocate prepare stmt; 

			if exists(select * from information_schema.tables where table_schema = 'KYStatis' and table_name = v_sel_tbl_name) then
				set v_sql_child = concat('select ''', v_statis_date,''' as StatisDate, G.GameID,main.RoomType
														,ifnull(sum(main.KDValidBet),0) as sumValid,ifnull(sum(main.KDWin),0) as sumProfit,ifnull(sum(main.KDGames),0) as sumGameNum,ifnull(main.TotalUsers_userType,0) as sumActiveUser
														,ifnull(sum(case when locate(''普通局'',K.KDvalue) > 0 then KDValidBet end),0) as NormalValid
														,ifnull(sum(case when locate(''普通局'',K.KDvalue) > 0 then KDWin end),0) as NormalProfit
														,ifnull(sum(case when locate(''普通局'',K.KDvalue) > 0 then KDGames end),0) as NormalGameNum
														,ifnull(sum(case when locate(''普通局'',K.KDvalue) > 0 then K.KDUsers end),0) as NormalActiveUser
														,ifnull(sum(case when locate(''普通追杀'',K.KDvalue) > 0 then KDValidBet end),0) as KillValid
														,ifnull(sum(case when locate(''普通追杀'',K.KDvalue) > 0 then KDWin end),0) as KillProfit
														,ifnull(sum(case when locate(''普通追杀'',K.KDvalue) > 0 then KDGames end),0) as KillGameNum
														,ifnull(sum(case when locate(''普通追杀'',K.KDvalue) > 0 then K.KDUsers end),0) as KillActiveUser
														,ifnull(sum(case when locate(''分级追杀'',K.KDvalue) > 0 then KDValidBet end),0) as ClassKillValid
														,ifnull(sum(case when locate(''分级追杀'',K.KDvalue) > 0 then KDWin end),0) as ClassKillProfit
														,ifnull(sum(case when locate(''分级追杀'',K.KDvalue) > 0 then KDGames end),0) as ClassKillGameNum
														,ifnull(sum(case when locate(''分级追杀'',K.KDvalue) > 0 then K.KDUsers end),0) as ClassKillActiveUser
														,ifnull(sum(case when locate(''普通放水'',K.KDvalue) > 0 then KDValidBet end),0) as RevValid
														,ifnull(sum(case when locate(''普通放水'',K.KDvalue) > 0 then KDWin end),0) as RevProfit
														,ifnull(sum(case when locate(''普通放水'',K.KDvalue) > 0 then KDGames end),0) as RevGameNum
														,ifnull(sum(case when locate(''普通放水'',K.KDvalue) > 0 then K.KDUsers end),0) as RevActiveUser
														,ifnull(sum(case when locate(''分级放水'',K.KDvalue) > 0 then KDValidBet end),0) as ClassRevValid
														,ifnull(sum(case when locate(''分级放水'',K.KDvalue) > 0 then KDWin end),0) as ClassRevProfit
														,ifnull(sum(case when locate(''分级放水'',K.KDvalue) > 0 then KDGames end),0) as ClassRevGameNum
														,ifnull(sum(case when locate(''分级放水'',K.KDvalue) > 0 then K.KDUsers end),0) as ClassRevActiveUser
														,ifnull(sum(case when locate(''ptkill'',K.KDvalue) > 0 then KDValidBet end),0) as PtkillValid
														,ifnull(sum(case when locate(''ptkill'',K.KDvalue) > 0 then KDWin end),0) as PtkillProfit
														,ifnull(sum(case when locate(''ptkill'',K.KDvalue) > 0 then KDGames end),0) as PtkillGameNum
														,ifnull(sum(case when locate(''ptkill'',K.KDvalue) > 0 then K.KDUsers end),0) as PtkillActiveUser
														,main.currency
														,rpCurrency.exchangeRate
														from KYStatis.', v_sel_tbl_name,' main
														inner join KYDB_NEW.GameInfo G on main.GameType = G.GameParameter
														LEFT JOIN game_manage.rp_currency rpCurrency ON rpCurrency.currency = main.currency
														LEFT JOIN (SELECT StatisDate,Type,MatchType,RoomType,KDvalue,KDUsers FROM ', v_sel_tbl_name,' where StatisDate = ''', v_statis_date, '''  GROUP BY StatisDate,Type,MatchType,RoomType,KDvalue) K ON K.StatisDate = main.StatisDate AND K.Type = main.Type AND K.MatchType = main.MatchType AND K.RoomType = main.RoomType AND K.KDvalue = main.KDvalue
														where main.StatisDate = ''', v_statis_date,''''); 

				set v_sql = concat('insert into KYStatis.', v_tbl_name,'(StatisDate,KindId,ServerId,oldSumValid,oldSumProfit,oldSumGameNum,oldSumActiveUser,oldNormalValid,oldNormalProfit,oldNormalGameNum,oldNormalActiveUser,oldKillValid,oldKillProfit,oldKillGameNum,oldKillActiveUser,oldClassKillValid,oldClassKillProfit,oldClassKillGameNum,oldClassKillActiveUser,oldRevValid,oldRevProfit,oldRevGameNum,oldRevActiveUser,oldClassRevValid,oldClassRevProfit,oldClassRevGameNum,oldClassRevActiveUser,oldPtkillValid,oldPtkillProfit,oldPtkillGameNum,oldPtkillActiveUser,currency,exchangeRate) '
													,v_sql_child,' and main.Type = 2 group by G.GameID,main.RoomType,main.currency'); 
				set @v_sql = v_sql; 
				prepare stmt from @v_sql; 
				execute stmt; 
				deallocate prepare stmt; 


				set v_sql = concat('update KYStatis.', v_tbl_name,' A inner join (', v_sql_child,' and main.Type = 1 group by G.GameID,main.RoomType,main.currency) B on A.StatisDate = B.StatisDate and A.ServerID = B.RoomType and A.currency = B.currency
															set A.newSumValid = B.sumValid
															,A.newSumProfit = B.sumProfit
															,A.newSumGameNum = B.sumGameNum
															,A.newSumActiveUser = B.sumActiveUser
															,A.newNormalValid = B.NormalValid
															,A.newNormalProfit = B.NormalProfit
															,A.newNormalGameNum = B.NormalGameNum
															,A.newNormalActiveUser = B.NormalActiveUser
															,A.newKillValid = B.KillValid
															,A.newKillProfit = B.KillProfit
															,A.newKillGameNum = B.KillGameNum
															,A.newKillActiveUser = B.KillActiveUser
															,A.newClassKillValid = B.ClassKillValid
															,A.newClassKillProfit = B.ClassKillProfit
															,A.newClassKillGameNum = B.ClassKillGameNum
															,A.newClassKillActiveUser = B.ClassKillActiveUser
															,A.newRevValid = B.RevValid
															,A.newRevProfit = B.RevProfit
															,A.newRevGameNum = B.RevGameNum
															,A.newRevActiveUser = B.RevActiveUser
															,A.newClassRevValid = B.ClassRevValid
															,A.newClassRevProfit = B.ClassRevProfit
															,A.newClassRevGameNum = B.ClassRevGameNum
															,A.newClassRevActiveUser = B.ClassRevActiveUser
															,A.newPtkillValid = B.PtkillValid
															,A.newPtkillProfit = B.PtkillProfit
															,A.newPtkillGameNum = B.PtkillGameNum
															,A.newPtkillActiveUser = B.PtkillActiveUser'); 
				set @v_sql = v_sql; 
				prepare stmt from @v_sql; 
				execute stmt; 
				deallocate prepare stmt; 

				set v_sql = concat('insert into KYStatis.', v_tbl_name,'(StatisDate,KindId,ServerId,newSumValid,newSumProfit,newSumGameNum,newSumActiveUser,newNormalValid,newNormalProfit,newNormalGameNum,newNormalActiveUser,newKillValid,newKillProfit,newKillGameNum,newKillActiveUser,newClassKillValid,newClassKillProfit,newClassKillGameNum,newClassKillActiveUser,newRevValid,newRevProfit,newRevGameNum,newRevActiveUser,newClassRevValid,newClassRevProfit,newClassRevGameNum,newClassRevActiveUser,newPtkillValid,newPtkillProfit,newPtkillGameNum,newPtkillActiveUser,currency,exchangeRate)
													',v_sql_child,' and main.Type = 1 and CONCAT(main.RoomType,main.currency) not in (select CONCAT(ServerID , currency) from KYStatis.', v_tbl_name,' where StatisDate = ''', v_statis_date,''') group by G.GameID,main.RoomType,main.currency'); 
				set @v_sql = v_sql; 
				prepare stmt from @v_sql; 
				execute stmt; 
				deallocate prepare stmt; 

			end if; 

			set v_i = v_i +1; 
		end while; 
	end if; 

	set @ts = TIMESTAMPDIFF(SECOND,@timediff,NOW()); 
	INSERT INTO KYStatis.prolog VALUES(NOW(),'KYStatis.sp_statis_room_recordtype_data',@ts); 

END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_statis_room_recordtype_data`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_statis_room_recordtype_data` ON SCHEDULE EVERY 30 MINUTE STARTS '2021-03-09 19:05:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_statis_room_recordtype_data(CURDATE(),CURDATE());
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_statisSameTableUsers_every20min`;
CREATE DEFINER=`root`@`%` EVENT `event_statisSameTableUsers_every20min` ON SCHEDULE EVERY 20 MINUTE STARTS '2018-05-31 23:50:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO CALL sp_statisSameTableUsers(CURDATE());
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_statis_game_daily_everyday01:00`;
CREATE DEFINER=`root`@`%` EVENT `event_statis_game_daily_everyday01:00` ON SCHEDULE EVERY 1 DAY STARTS '2024-07-20 01:00:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO CALL KYStatis.sp_statis_game_daily_data(NULL,NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

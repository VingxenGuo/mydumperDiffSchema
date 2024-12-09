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
DROP PROCEDURE IF EXISTS `sp_createStatisticsUsersTable`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_createStatisticsUsersTable`(IN in_tablename varchar(50), IN in_type int)
BEGIN

        DECLARE createsql VARCHAR(4000); 

        DECLARE createsql0 VARCHAR(4000); 

        DECLARE createsql1 VARCHAR(4000); 

        SET createsql0=CONCAT('

        CREATE TABLE ',in_tablename,' (

        `StatisDate` date NOT NULL,

        `Account` varchar(200) NOT NULL,

        `ChannelID` int(11) DEFAULT NULL,

        `LineCode` varchar(100) NOT NULL,

        `AllBet` bigint(20) DEFAULT ''0'' COMMENT ''总投注'',

        `CellScore` bigint(20) DEFAULT ''0'' COMMENT ''有效投注'',

        `WinGold` bigint(20) DEFAULT ''0'' COMMENT ''赢钱'',

        `LostGold` bigint(20) DEFAULT ''0'' COMMENT ''输钱'',

        `Revenue` bigint(20) DEFAULT ''0'' COMMENT ''抽水'',

        `WinNum` int(11) DEFAULT ''0'' COMMENT ''赢钱局数(包含和局)'',

        `LostNum` int(11) DEFAULT ''0'' COMMENT ''输钱局数'',

        `currency` varchar(50) NOT NULL COMMENT ''币别'',

        `exchangeRate` decimal(20,5) NOT NULL COMMENT ''汇率'',

        `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,

        `UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

        PRIMARY KEY (`StatisDate`,`Account`,`LineCode`,`currency`),

                    INDEX (`StatisDate`)

        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 

    '); 

        SET createsql1=CONCAT('

        CREATE TABLE ',in_tablename,' (

        `Account` varchar(200) NOT NULL,

        `ChannelID` int(11) DEFAULT NULL,

        `LineCode` varchar(100) NOT NULL,

        `AllBet` bigint(20) DEFAULT ''0'' COMMENT ''总投注'',

        `CellScore` bigint(20) DEFAULT ''0'' COMMENT ''有效投注'',

        `WinGold` bigint(20) DEFAULT ''0'' COMMENT ''赢钱'',

        `LostGold` bigint(20) DEFAULT ''0'' COMMENT ''输钱'',

        `Revenue` bigint(20) DEFAULT ''0'' COMMENT ''抽水'',

        `WinNum` int(11) DEFAULT ''0'' COMMENT ''赢钱局数(包含和局)'',

        `LostNum` int(11) DEFAULT ''0'' COMMENT ''输钱局数'',

        `currency` varchar(50) NOT NULL COMMENT ''币别'',

        `exchangeRate` decimal(20,5) NOT NULL COMMENT ''汇率'',

        `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,

        `UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

        RIMARY KEY (`Account`,`LineCode`,`currency`)

        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 

    '); 



        IF in_type=0 THEN SET createsql=createsql0; END IF; 

        IF in_type=1 THEN SET createsql=createsql1; END IF; 

        SET @v_sqlselect = createsql; 

PREPARE stmt FROM @v_sqlselect; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 

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
DROP PROCEDURE IF EXISTS `sp_StatisUsersDayData`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisUsersDayData`(IN `in_StatisDate` date)
BEGIN

	-- 美东时间统计

	DECLARE v_month VARCHAR(30); 

	DECLARE v_tblname VARCHAR(100); 

	DECLARE v_starttime TIMESTAMP(3); 

	DECLARE v_endtime TIMESTAMP(3); 

	DECLARE v_sqlbase LONGTEXT; 

	DECLARE done INT DEFAULT FALSE; 

	DECLARE cur_Gameid, cur_GameParameter LONGTEXT; 

	DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 



	-- 记录开始时间

	SET v_starttime=CURRENT_TIMESTAMP(3); 



	IF in_StatisDate IS NULL THEN

		SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 

	END IF; 



	SET v_month=DATE_FORMAT(in_StatisDate,'%Y%m'); 



	OPEN cur1; 

		read_loop: LOOP

			FETCH cur1 INTO cur_Gameid, cur_GameParameter; 



			IF done THEN

				LEAVE read_loop; 

			END IF; 



			IF cur_Gameid = 620 THEN

				SET cur_GameParameter = 'dzpk'; 

			END IF; 



			CALL sp_StatisUsersGameDayData(in_StatisDate, cur_GameParameter); 

	    	SET v_sqlbase = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' UNION ALL '),''),'SELECT * FROM KYStatisUsers_EST.statis_', cur_GameParameter, v_month, '_users WHERE StatisDate=''', in_StatisDate, ''''); 

		END LOOP; 

	CLOSE cur1;	



	-- 添加所有游戏当天数据

	IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_EST' AND TABLE_NAME = CONCAT('statis_allgames',v_month,'_users')) THEN

		CALL sp_createStatisticsUsersTable(CONCAT('statis_allgames',v_month,'_users'),0); 

	END IF; 

	SET @v_sqlselect = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT('REPLACE INTO KYStatisUsers_EST.statis_allgames',v_month,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum,currency,exchangeRate) 

																SELECT ''',in_StatisDate,''' AS StatisDate, tmptable.Account,tmptable.ChannelID,tmptable.LineCode,SUM(tmptable.CellScore) CellScore,SUM(tmptable.WinGold) WinGold,SUM(tmptable.LostGold) LostGold,

																	SUM(tmptable.Revenue) Revenue,SUM(tmptable.WinNum) WinNum,SUM(tmptable.LostNum) LostNum, tmptable.currency, currencyTable.exchangeRate

																FROM ( ',v_sqlbase),''),' ) tmptable 

																LEFT JOIN game_manage.rp_currency currencyTable

																ON tmptable.currency = currencyTable.currency

																GROUP BY StatisDate,Account,ChannelID,LineCode,currency'); 

	IF(LENGTH(v_sqlbase)) > 0 THEN

	PREPARE stmt FROM @v_sqlselect; 

	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt; 

	END IF; 

	/*

	-- 更新玩家月数据 先更新现有的玩家，然后添加第一次出现的玩家

	IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_EST' AND TABLE_NAME = CONCAT('statis_month',v_month,'_users')) THEN

		CALL sp_createStatisticsUsersTable(CONCAT('statis_month',v_month,'_users'),1); 

	END IF; 

	SET @v_sqlselect = CONCAT('UPDATE KYStatisUsers_EST.statis_allgames',v_month,'_users a LEFT JOIN KYStatisUsers_EST.statis_month',v_month,'_users b ON a.Account=b.Account AND a.LineCode=b.LineCode

	SET b.CellScore=b.CellScore+a.CellScore, b.WinGold=b.WinGold+a.WinGold,b.LostGold=b.LostGold+a.LostGold,b.Revenue=b.Revenue+a.Revenue,b.WinNum=b.WinNum+a.WinNum,b.LostNum=b.LostNum+a.LostNum

	WHERE a.StatisDate=''',in_StatisDate,'''

	'); 

	PREPARE stmt FROM @v_sqlselect; 

	-- EXECUTE stmt; 

	DEALLOCATE PREPARE stmt; 

	-- 添加本月第一次玩游戏的玩家

	SET @v_sqlselect = CONCAT('INSERT INTO KYStatisUsers_EST.statis_month',v_month,'_users (Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) 

	SELECT a.Account,a.ChannelID,a.LineCode,a.CellScore,a.WinGold,a.LostGold,a.Revenue,a.WinNum,a.LostNum

	FROM KYStatisUsers_EST.statis_allgames',v_month,'_users  a LEFT JOIN KYStatisUsers_EST.statis_month',v_month,'_users b ON b.Account=a.Account AND b.LineCode=a.LineCode WHERE a.StatisDate=''',in_StatisDate,''' AND b.Account IS NULL; 

	'); 

	PREPARE stmt FROM @v_sqlselect; 

	-- EXECUTE stmt; 

	DEALLOCATE PREPARE stmt; 

	-- 更新玩家历史输赢数据 先update 再insert

	IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_EST' AND TABLE_NAME = CONCAT('statis_all_users')) THEN

		CALL sp_createStatisticsUsersTable(CONCAT('statis_all_users'),1); 

	END IF; 

	SET @v_sqlselect = CONCAT('UPDATE KYStatisUsers_EST.statis_allgames',v_month,'_users a LEFT JOIN KYStatisUsers_EST.statis_all_users b  ON a.Account=b.Account AND a.LineCode=b.LineCode

	SET b.CellScore=b.CellScore+a.CellScore, b.WinGold=b.WinGold+a.WinGold,b.LostGold=b.LostGold+a.LostGold,b.Revenue=b.Revenue+a.Revenue,b.WinNum=b.WinNum+a.WinNum,b.LostNum=b.LostNum+a.LostNum

	WHERE a.StatisDate=''',in_StatisDate,'''

	'); 

	PREPARE stmt FROM @v_sqlselect; 

	-- EXECUTE stmt; 

	DEALLOCATE PREPARE stmt; 

	-- 添加第一次玩游戏的玩家

	SET @v_sqlselect = CONCAT('INSERT INTO KYStatisUsers_EST.statis_all_users (Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) 

	SELECT a.Account,a.ChannelID,a.LineCode,a.CellScore,a.WinGold,a.LostGold,a.Revenue,a.WinNum,a.LostNum

	FROM KYStatisUsers_EST.statis_allgames',v_month,'_users  a LEFT JOIN KYStatisUsers_EST.statis_all_users b ON b.Account=a.Account AND b.LineCode=a.LineCode WHERE a.StatisDate=''',in_StatisDate,''' AND b.Account IS NULL; 

	'); 

	PREPARE stmt FROM @v_sqlselect; 

	-- EXECUTE stmt; 

	DEALLOCATE PREPARE stmt; 

	*/

	-- 记录结束时间

	SET v_endtime = CURRENT_TIMESTAMP(); 



	-- 添加执行日志

	INSERT INTO KYStatisUsers_EST.event_log_record (sp_name, starttime, endtime, exectime,mark) VALUES ('sp_StatisUsersDayData', v_starttime, v_endtime, TIMESTAMPDIFF(SECOND,v_starttime,v_endtime),in_StatisDate); 

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
DROP PROCEDURE IF EXISTS `sp_StatisUsersDayData_allbet`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisUsersDayData_allbet`(IN `in_StatisDate` date)
BEGIN

	-- 美东时间统计 2018-09-26

	DECLARE v_month VARCHAR(30); 

	DECLARE v_tblname VARCHAR(100); 

	DECLARE v_starttime TIMESTAMP(3); 

	DECLARE v_endtime TIMESTAMP(3); 

	DECLARE v_sqlbase LONGTEXT; 

	DECLARE done INT DEFAULT FALSE; 

	DECLARE cur_Gameid, cur_GameParameter LONGTEXT; 

	DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 



	-- 记录开始时间

	SET v_starttime=CURRENT_TIMESTAMP(3); 



	IF in_StatisDate IS NULL THEN

		SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 

	END IF; 



	SET v_month=DATE_FORMAT(in_StatisDate,'%Y%m'); 



	OPEN cur1; 

		read_loop: LOOP

			FETCH cur1 INTO cur_Gameid, cur_GameParameter; 



			IF done THEN

				LEAVE read_loop; 

			END IF; 



			IF cur_Gameid = 620 THEN

				SET cur_GameParameter = 'dzpk'; 

			END IF; 



			CALL sp_StatisUsersGameDayData(in_StatisDate, cur_GameParameter); 

	    	SET v_sqlbase = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' UNION ALL '),''),'SELECT * FROM KYStatisUsers_EST.statis_', cur_GameParameter, v_month, '_users WHERE StatisDate=''', in_StatisDate, ''''); 

		END LOOP; 

	CLOSE cur1; 

        

	-- 添加所有游戏当天数据

	IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_EST' AND TABLE_NAME = CONCAT('statis_allgames',v_month,'_users')) THEN

		CALL sp_createStatisticsUsersTable(CONCAT('statis_allgames',v_month,'_users'),0); 

	END IF; 

	SET @v_sqlselect = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT('REPLACE INTO KYStatisUsers_EST.statis_allgames',v_month,'_users (StatisDate,Account,ChannelID,LineCode,AllBet,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) 

																	SELECT ''',in_StatisDate,''' AS StatisDate, Account, ChannelID, LineCode, SUM(AllBet) AllBet,SUM(CellScore) CellScore,SUM(WinGold) WinGold,SUM(LostGold) LostGold,

																		SUM(Revenue) Revenue,SUM(WinNum) WinNum,SUM(LostNum) LostNum  

																	FROM ( ',v_sqlbase),''),' ) tmptable 

																	GROUP BY StatisDate,Account,ChannelID,LineCode'); 

	IF(LENGTH(v_sqlbase)) > 0 THEN

		PREPARE stmt FROM @v_sqlselect; 

	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt; 

	END IF; 

	/*

	-- 更新玩家月数据 先更新现有的玩家，然后添加第一次出现的玩家

	IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_EST' AND TABLE_NAME = CONCAT('statis_month',v_month,'_users')) THEN

		CALL sp_createStatisticsUsersTable(CONCAT('statis_month',v_month,'_users'),1); 

	END IF; 

	SET @v_sqlselect = CONCAT('UPDATE KYStatisUsers_EST.statis_allgames',v_month,'_users a LEFT JOIN KYStatisUsers_EST.statis_month',v_month,'_users b ON a.Account = b.Account AND a.LineCode = b.LineCode

	SET b.CellScore=b.CellScore+a.CellScore, b.WinGold=b.WinGold+a.WinGold,b.LostGold=b.LostGold+a.LostGold,b.Revenue=b.Revenue+a.Revenue,b.WinNum=b.WinNum+a.WinNum,b.LostNum=b.LostNum+a.LostNum

	WHERE a.StatisDate=''',in_StatisDate,'''

	'); 

	PREPARE stmt FROM @v_sqlselect; 

	-- EXECUTE stmt; 

	DEALLOCATE PREPARE stmt; 

	-- 添加本月第一次玩游戏的玩家

	SET @v_sqlselect = CONCAT('INSERT INTO KYStatisUsers_EST.statis_month',v_month,'_users (Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) 

	SELECT a.Account,a.ChannelID,a.LineCode,a.CellScore,a.WinGold,a.LostGold,a.Revenue,a.WinNum,a.LostNum

	FROM KYStatisUsers_EST.statis_allgames',v_month,'_users  a LEFT JOIN KYStatisUsers_EST.statis_month',v_month,'_users b ON b.Account=a.Account AND b.LineCode=a.LineCode WHERE a.StatisDate=''',in_StatisDate,''' AND b.Account IS NULL; 

	'); 

	PREPARE stmt FROM @v_sqlselect; 

	-- EXECUTE stmt; 

	DEALLOCATE PREPARE stmt; 

	-- 更新玩家历史输赢数据 先update 再insert

	IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_EST' AND TABLE_NAME = CONCAT('statis_all_users')) THEN

	CALL sp_createStatisticsUsersTable(CONCAT('statis_all_users'),1); 

	END IF; 

	SET @v_sqlselect = CONCAT('UPDATE KYStatisUsers_EST.statis_allgames',v_month,'_users a LEFT JOIN KYStatisUsers_EST.statis_all_users b ON a.Account=b.Account AND a.LineCode=b.LineCode

	SET b.CellScore=b.CellScore+a.CellScore, b.WinGold=b.WinGold+a.WinGold,b.LostGold=b.LostGold+a.LostGold,b.Revenue=b.Revenue+a.Revenue,b.WinNum=b.WinNum+a.WinNum,b.LostNum=b.LostNum+a.LostNum

	WHERE a.StatisDate=''',in_StatisDate,'''

	'); 

	PREPARE stmt FROM @v_sqlselect; 

	-- EXECUTE stmt; 

	DEALLOCATE PREPARE stmt; 

	-- 添加第一次玩游戏的玩家

	SET @v_sqlselect = CONCAT('INSERT INTO KYStatisUsers_EST.statis_all_users (Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) 

	SELECT a.Account,a.ChannelID,a.LineCode,a.CellScore,a.WinGold,a.LostGold,a.Revenue,a.WinNum,a.LostNum

	FROM KYStatisUsers_EST.statis_allgames',v_month,'_users  a LEFT JOIN KYStatisUsers_EST.statis_all_users b ON b.Account=a.Account AND b.LineCode=a.LineCode WHERE a.StatisDate=''',in_StatisDate,''' AND b.Account IS NULL; 

	'); 

	PREPARE stmt FROM @v_sqlselect; 

	--EXECUTE stmt; 

	DEALLOCATE PREPARE stmt; 

	*/

	-- 记录结束时间

	SET v_endtime = CURRENT_TIMESTAMP(); 



	-- 添加执行日志

	INSERT INTO KYStatisUsers_EST.event_log_record (sp_name, starttime, endtime, exectime,mark) VALUES ('sp_StatisUsersDayData', v_starttime, v_endtime, TIMESTAMPDIFF(SECOND,v_starttime,v_endtime),in_StatisDate); 

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
DROP PROCEDURE IF EXISTS `sp_StatisUsersGameDayData`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisUsersGameDayData`(`in_StatisDate` date,`in_GameName` varchar(100))
BEGIN

    DECLARE v_month VARCHAR(30); 

    DECLARE v_tblname varchar(100); 

    DECLARE v_sqlbase LONGTEXT; 

    DECLARE in_StatisDate_end date; 

    IF in_StatisDate IS NULL THEN

        SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 DAY); 

    END IF; 

    SET in_StatisDate_end=DATE_ADD(in_StatisDate,INTERVAL 1 DAY); 

    SET v_month=DATE_FORMAT(in_StatisDate,'%Y%m'); 

    SET v_tblname = CONCAT(in_GameName, '_gameRecord'); 



    IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_EST' AND TABLE_NAME = CONCAT('statis_',in_GameName,v_month,'_users')) THEN

        CALL sp_createStatisticsUsersTable(CONCAT('statis_',in_GameName,v_month,'_users'),0); 

    END IF; 

    IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'detail_record' AND TABLE_NAME = v_tblname) THEN

        SET v_sqlbase=CONCAT('select ''',in_StatisDate,''' AS StatisDate, Accounts,ChannelID,LineCode,

					SUM(AllBet) AllBet,

					SUM(CellScore) CellScore,

					SUM(CASE WHEN Profit>0 THEN Profit ELSE 0 END) wingold,

					SUM(CASE WHEN Profit<0 THEN Profit ELSE 0 END) lostgold,

					SUM(Revenue) Revenue,

					COUNT(CASE WHEN Profit>=0 THEN Profit END) winNum,

					COUNT(CASE WHEN Profit<0 THEN Profit END) lostNum,

                    currency

					FROM ','detail_record.',v_tblname,' FORCE index(index_gameendtime)  WHERE GameEndTime>=''',in_StatisDate,' 12:00:00'' AND GameEndTime<=''',in_StatisDate_end,' 11:59:59.998''

					GROUP BY Accounts,ChannelID,LineCode,currency'); 

    END IF; 



    IF(LENGTH(v_sqlbase) > 0) THEN

        SET v_sqlbase=CONCAT('REPLACE INTO KYStatisUsers_EST.statis_',in_GameName,v_month,'_users (StatisDate,Account,ChannelID,LineCode,AllBet,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum,currency,exchangeRate)

            SELECT ''',in_StatisDate,''' AS StatisDate, tmp1.Accounts, tmp1.ChannelID, tmp1.LineCode,SUM(tmp1.AllBet),SUM(tmp1.CellScore),SUM(tmp1.wingold),SUM(tmp1.lostgold),SUM(tmp1.Revenue),SUM(tmp1.winNum),SUM(tmp1.lostNum),tmp1.currency,currencyTable.exchangeRate

            FROM (',v_sqlbase,') tmp1

            LEFT JOIN game_manage.rp_currency currencyTable

            ON tmp1.currency = currencyTable.currency

            GROUP BY Accounts,ChannelID,LineCode,currency'); 

        SET @v_sqlselect =v_sqlbase; 

        PREPARE stmt FROM @v_sqlselect; 

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
DROP EVENT IF EXISTS `event_StatisUsersDayData`;
CREATE DEFINER=`root`@`%` EVENT `event_StatisUsersDayData` ON SCHEDULE EVERY 1 DAY STARTS '2023-06-01 13:30:00' ON COMPLETION NOT PRESERVE ENABLE DO call sp_StatisUsersDayData(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

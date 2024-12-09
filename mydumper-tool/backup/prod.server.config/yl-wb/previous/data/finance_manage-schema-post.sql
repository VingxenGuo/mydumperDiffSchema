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
    DECLARE createsql VARCHAR(1000); 
    DECLARE createsql0 VARCHAR(1000); 
    DECLARE createsql1 VARCHAR(1000); 
    DECLARE createsql2 VARCHAR(1000); 
    DECLARE createsql3 VARCHAR(1000); 

    SET createsql0 = CONCAT('CREATE TABLE IF NOT EXISTS `', in_tablename, '` (
                `StatisDate` date NOT NULL,
                `Account` varchar(200) NOT NULL,
                `ChannelID` int(11) DEFAULT NULL,
                `LineCode` varchar(100) DEFAULT NULL,
                `CellScore` bigint(20) DEFAULT ''0'' COMMENT ''有效投注'',
                `WinGold` bigint(20) DEFAULT ''0'' COMMENT ''赢钱'',
                `LostGold` bigint(20) DEFAULT ''0'' COMMENT ''输钱'',
                `Revenue` bigint(20) DEFAULT ''0'' COMMENT ''抽水'',
                `WinNum` int(11) DEFAULT ''0'' COMMENT ''赢钱局数(包含和局)'',
                `LostNum` int(11) DEFAULT ''0'' COMMENT ''输钱局数'',
                `currency` varchar(50) NOT NULL COMMENT "币别",
                `exchangeRate` decimal(20,5) NOT NULL COMMENT "汇率",
                `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                `UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                PRIMARY KEY (`StatisDate`, `Account`, `LineCode`, `currency`),
                INDEX (`StatisDate`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;'); 

    SET createsql1 = CONCAT('CREATE TABLE IF NOT EXISTS `', in_tablename, '` (
                `Account` varchar(200) NOT NULL,
                `ChannelID` int(11) DEFAULT NULL,
                `LineCode` varchar(100) DEFAULT NULL,
                `CellScore` bigint(20) DEFAULT ''0'' COMMENT ''有效投注'',
                `WinGold` bigint(20) DEFAULT ''0'' COMMENT ''赢钱'',
                `LostGold` bigint(20) DEFAULT ''0'' COMMENT ''输钱'',
                `Revenue` bigint(20) DEFAULT ''0'' COMMENT ''抽水'',
                `WinNum` int(11) DEFAULT ''0'' COMMENT ''赢钱局数(包含和局)'',
                `LostNum` int(11) DEFAULT ''0'' COMMENT ''输钱局数'',
                `currency` varchar(50) NOT NULL COMMENT "币别",
                `exchangeRate` decimal(20,5) NOT NULL COMMENT "汇率",
                `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                `UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                PRIMARY KEY (`Account`, `LineCode`, `currency`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;'); 

    SET createsql2 = CONCAT('CREATE TABLE IF NOT EXISTS `', in_tablename, '` (
                `StatisDate` date NOT NULL,
                `Account` varchar(200) NOT NULL,
                `ChannelID` int(11) DEFAULT NULL,
                `ServerID` int(11) DEFAULT NULL,
                `CellScore` bigint(20) DEFAULT ''0'' COMMENT ''有效投注'',
                `WinGold` bigint(20) DEFAULT ''0'' COMMENT ''赢钱'',
                `LostGold` bigint(20) DEFAULT ''0'' COMMENT ''输钱'',
                `Revenue` bigint(20) DEFAULT ''0'' COMMENT ''抽水'',
                `WinNum` int(11) DEFAULT ''0'' COMMENT ''赢钱局数(包含和局)'',
                `LostNum` int(11) DEFAULT ''0'' COMMENT ''输钱局数'',
                `isNew` int(11) DEFAULT ''0'' COMMENT ''是否是新注册0老,1新注册'',
                `currency` varchar(50) NOT NULL COMMENT "币别",
                `exchangeRate` decimal(20,5) NOT NULL COMMENT "汇率",
                `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                `UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                PRIMARY KEY (`StatisDate`, `Account`, `ServerID`, `currency`),
                INDEX (`StatisDate`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;'); 

    SET createsql3 = CONCAT('
                CREATE TABLE IF NOT EXISTS `', in_tablename, '` (
                `StatisDate` date NOT NULL,
                `ChannelID` int(11) NOT NULL DEFAULT ''0'',
                `CellScore` bigint(20) DEFAULT ''0'' COMMENT ''有效投注'',
                `WinGold` bigint(20) DEFAULT ''0'' COMMENT ''赢钱'',
                `LostGold` bigint(20) DEFAULT ''0'' COMMENT ''输钱'',
                `Revenue` bigint(20) DEFAULT ''0'' COMMENT ''抽水'',
                `WinNum` int(11) DEFAULT ''0'' COMMENT ''赢钱局数(包含和局)'',
                `LostNum` int(11) DEFAULT ''0'' COMMENT ''输钱局数'',
                `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
                `UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
                `PeopleNum` int(11) DEFAULT NULL COMMENT ''活动领奖总人数'',
                `CheckpointNum` int(11) DEFAULT NULL COMMENT ''完成关卡数量'',
                `AllMoney` decimal(11,2) DEFAULT NULL COMMENT ''活动领奖总金币'',
                `currency` varchar(50) NOT NULL COMMENT "币别",
                `exchangeRate` decimal(20,5) NOT NULL COMMENT "汇率",
                PRIMARY KEY (`StatisDate`, `ChannelID`, `currency`),
                INDEX (`StatisDate`)
                ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;'); 


    IF in_type = 0 THEN SET createsql = createsql0; END IF; 
    IF in_type = 1 THEN SET createsql = createsql1; END IF; 
    IF in_type = 2 THEN SET createsql = createsql2; END IF; 
    IF in_type = 3 THEN SET createsql = createsql3; END IF; 
    SET @v_sqlselect = createsql; 
    PREPARE stmt from @v_sqlselect; 
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
DROP PROCEDURE IF EXISTS `sp_create_finance_dielivery_currency_report_category`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_create_finance_dielivery_currency_report_category`(
    IN `createDate1` date,
    IN `createDate2` date,
    IN `channelIds` varchar(4000),
    IN `pzUID` int,
    IN `categoryType` int
)
BEGIN
    DECLARE v_sql LONGTEXT; 
    DECLARE v_sql_proxy LONGTEXT; 
    DECLARE v_tblName VARCHAR(100); 
    DECLARE v_timeZone INT; 
    DECLARE v_i INT; 
    DECLARE v_delSql LONGTEXT; 
    DECLARE v_channelIdList LONGTEXT; 
    DECLARE v_category LONGTEXT; 

    IF categoryType = 0 THEN
        SET v_category = ''; 
    ELSEIF categoryType = 1 THEN
        SET v_category = CONCAT(' AND D.category != 4'); 
    ELSE
        SET v_category = CONCAT(' AND D.category = ', categoryType); 
    END IF; 

    IF LENGTH(channelIds) > 0 THEN
        SELECT KYDB_NEW.selRecursive(channelIds) INTO v_channelIdList; 
    END IF; 

    SET v_delSql = CONCAT('DELETE FROM finance_manage.finance_dielivery_currency_detail WHERE StatisDate = date_format(''', createDate1 ,''', ''%Y-%m'') AND category = ', categoryType); 
    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_delSql = CONCAT(v_delSql,' AND find_in_set(channelID,''', v_channelIdList,''')'); 
    END IF; 

    SET @v_delSql = v_delSql; 
    prepare stmt FROM @v_delSql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    SET v_sql = CONCAT('
                        SELECT 
                            date_format(''', createDate1 ,''', ''%Y-%m'') AS StatisDate, 
                            A.Currency, 
                            B.id, 
                            SUM(A.CellScore) AS CellScore, 
                            SUM((A.WinGold + A.LostGold )) AS Profit, 
                            0 AS SumProfit, 
                            0 AS TimeZone, 
                            IFNULL(C.financeExchangeRate, C.exchangeRate) AS financeExchangeRate, ', 
                            categoryType ,' AS category
                        FROM (SELECT StatisDate, ChannelID, currency, GameID, CellScore, WinGold, LostGold
                                FROM KYStatis.statis_record_agent_game 
                                WHERE StatisDate >= ''',createDate1,'''
                                AND StatisDate <= ''',createDate2,'''
                                AND ChannelID NOT IN (
                                            SELECT channelId 
                                            FROM finance_manage.special_agent_manage 
                                            WHERE type IN (0,5))) AS A 
                        INNER JOIN KYDB_NEW.agent AS B ON A.ChannelID = B.id
                        INNER JOIN game_manage.rp_currency AS C ON A.currency = C.currency
                        INNER JOIN KYDB_NEW.GameInfo D on A.GameID = D.GameID  ', v_category); 
                            
    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_sql = CONCAT(v_sql,' AND find_in_set(A.channelId,''', v_channelIdList,''')'); 
    END IF; 

    SET v_sql = CONCAT(v_sql,' GROUP BY date_format(''', createDate1, ''', ''%Y-%m''), A.ChannelID, A.Currency'); 

    SET v_sql = CONCAT(v_sql, ' UNION ALL
                        SELECT 
                            date_format(''', createDate1 ,''', ''%Y-%m'') AS StatisDate, 
                            A.Currency, 
                            B.id, 
                            SUM(A.CellScore) AS CellScore, 
                            SUM((A.WinGold + A.LostGold)) AS Profit, 
                            0 AS SumProfit, 
                            0 AS TimeZone, 
                            IFNULL(C.financeExchangeRate, C.exchangeRate) AS financeExchangeRate, ', 
                            categoryType ,' AS category
                        FROM (SELECT StatisDate, ChannelID, currency, GameID, CellScore, WinGold, LostGold
                                FROM KYStatis.statis_record_agent_game_EST 
                                WHERE StatisDate >= ''',createDate1,'''
                                AND StatisDate <= ''',createDate2,'''
                                AND ChannelID IN (
                                            SELECT channelId 
                                            FROM finance_manage.special_agent_manage 
                                            WHERE type IN (0,5))) AS A 
                        INNER JOIN KYDB_NEW.agent AS B ON A.ChannelID = B.id
                        INNER JOIN game_manage.rp_currency AS C ON A.currency = C.currency
                        INNER JOIN KYDB_NEW.GameInfo D on A.GameID = D.GameID  ', v_category); 

    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_sql = CONCAT(v_sql,' AND find_in_set(A.channelId,''', v_channelIdList,''')'); 
    END IF; 

    SET v_sql = CONCAT(v_sql,' GROUP BY date_format(''', createDate1, ''', ''%Y-%m''), A.ChannelID, A.Currency'); 

    SET v_sql = CONCAT('REPLACE INTO finance_manage.finance_dielivery_currency_detail (StatisDate, Currency, ChannelID, CellScore, Profit, SumProfit, TimeZone, financeExchangeRate, category) ',  v_sql); 

    SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    SET v_sql = CONCAT('UPDATE finance_manage.finance_dielivery_currency_detail AS main 
                        INNER JOIN (
                            SELECT 
                                temp.TopUID, 
                                A.StatisDate, 
                                SUM(Profit) AS sumProfit, 
                                A.currency, 
                                A.category
                            FROM finance_manage.finance_dielivery_currency_detail AS A 
                            INNER JOIN KYDB_NEW.TEMP_AGENT_TOP AS temp ON A.ChannelID = temp.ChannelID
                            WHERE A.StatisDate = date_format(''', createDate1 ,''', ''%Y-%m'') AND category = ',categoryType); 

    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_sql = CONCAT(v_sql,' AND find_in_set(A.channelId,''', v_channelIdList,''')'); 
    END IF; 
    SET v_sql = CONCAT(v_sql,' GROUP BY temp.TopUID, A.StatisDate, A.currency, A.category) AS T SET main.SumProfit = T.sumProfit WHERE main.ChannelID = T.TopUID AND main.currency = T.currency AND main.StatisDate = T.StatisDate AND main.category = ', categoryType); 
    SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    SET v_sql = CONCAT('INSERT IGNORE INTO finance_manage.finance_dielivery_currency_detail (sumProfit, channelID, currency, statisDate, financeExchangeRate, category)
                        SELECT 
                            SUM(Profit) AS sumProfit, 
                            temp.TopUID, 
                            A.currency, 
                            A.statisDate, 
                            IFNULL(B.financeExchangeRate, B.exchangeRate), 
                            A.category
                        FROM finance_manage.finance_dielivery_currency_detail AS A 
                        INNER JOIN KYDB_NEW.TEMP_AGENT_TOP AS temp ON A.ChannelID = temp.ChannelID
                        INNER JOIN game_manage.rp_currency AS B ON A.currency = B.currency
                        WHERE A.StatisDate = date_format(''', createDate1 ,''', ''%Y-%m'') AND category = ',categoryType); 

    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_sql = CONCAT(v_sql,' AND find_in_set(A.channelId,''', v_channelIdList,''')'); 
    END IF; 
    SET v_sql = CONCAT(v_sql,' GROUP BY temp.TopUID, A.StatisDate, A.currency, A.category'); 

    SET @v_sql = v_sql; 
    
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

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
DROP PROCEDURE IF EXISTS `sp_create_finance_dielivery_report`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_create_finance_dielivery_report`(IN `createDate1` date,IN `createDate2` date,IN `channelIds` varchar(4000),IN `pzUID` int)
BEGIN
    DECLARE v_sql LONGTEXT; 
    DECLARE v_sql_proxy LONGTEXT; 
    DECLARE v_tblName VARCHAR(100); 
    DECLARE v_timeZone INT; 
    DECLARE v_i INT; 
    DECLARE v_delSql LONGTEXT; 
    DECLARE v_channelIdList LONGTEXT; 

    IF LENGTH(channelIds) > 0 THEN
        SELECT KYDB_NEW.selRecursive(channelIds) INTO v_channelIdList; 
    END IF; 

    SET v_delSql = CONCAT('DELETE FROM finance_manage.finance_dielivery_detail WHERE StatisDate >= ''', createDate1,''' AND StatisDate <= ''', createDate2,''''); 
    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_delSql = CONCAT(v_delSql,' AND find_in_set(channelID,''', v_channelIdList,''')'); 
    END IF; 
    SET @v_delSql = v_delSql; 
    prepare stmt FROM @v_delSql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    SET v_sql = CONCAT('REPLACE INTO finance_manage.finance_dielivery_detail (StatisDate, ChannelID, ChannelName, NickName, AccountingFor, CellScore, Profit, SumProfit, TimeZone) 
                        SELECT A.StatisDate, B.id, B.account, B.nickname, B.accountingFor, SUM(A.CellScore * IFNULL(C.financeExchangeRate, C.exchangeRate)) AS CellScore, 
                            SUM(((A.WinGold * IFNULL(C.financeExchangeRate, C.exchangeRate)) + (A.LostGold * IFNULL(C.financeExchangeRate, C.exchangeRate)))) AS Profit, 0 AS SumProfit, 0
                        FROM KYStatis.statis_record_agent_all AS A 
                        INNER JOIN KYDB_NEW.agent AS B ON A.ChannelID = B.id
                        INNER JOIN game_manage.rp_currency AS C ON A.currency = C.currency
                        WHERE A.StatisDate >= ''', createDate1,''' 
                        AND A.StatisDate <= ''', createDate2,''' 
                        AND A.ChannelID NOT IN (
                            SELECT channelId 
                            FROM finance_manage.special_agent_manage 
                            WHERE type IN (0,5))'); 
    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_sql = CONCAT(v_sql,' AND find_in_set(A.channelId,''', v_channelIdList,''')'); 
    END IF; 
    SET v_sql = CONCAT(v_sql,' GROUP BY StatisDate, ChannelID'); 
    SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    SET v_sql = CONCAT('REPLACE INTO finance_manage.finance_dielivery_detail (StatisDate, ChannelID, ChannelName, NickName, AccountingFor, CellScore, Profit, SumProfit, TimeZone) 
                        SELECT A.StatisDate, B.id, B.account, B.nickname, B.accountingFor, SUM(A.CellScore * IFNULL(C.financeExchangeRate, C.exchangeRate)) AS CellScore, 
                            SUM(((A.WinGold * IFNULL(C.financeExchangeRate, C.exchangeRate)) + (A.LostGold * IFNULL(C.financeExchangeRate, C.exchangeRate)))) AS Profit, 0 AS SumProfit, 1
                        FROM KYStatis.statis_record_agent_all_EST AS A 
                        INNER JOIN KYDB_NEW.agent AS B ON A.ChannelID = B.id
                        INNER JOIN game_manage.rp_currency AS C ON A.currency = C.currency
                        WHERE A.StatisDate >= ''', createDate1,''' 
                        AND A.StatisDate <= ''', createDate2,''' 
                        AND A.ChannelID IN (
                            SELECT channelId 
                            FROM finance_manage.special_agent_manage 
                            WHERE type IN (0,5))'); 
    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_sql = CONCAT(v_sql,' AND find_in_set(A.channelId,''', v_channelIdList,''')'); 
    END IF; 
    SET v_sql = CONCAT(v_sql,' GROUP BY StatisDate, ChannelID'); 
    SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    CALL finance_manage.sp_create_finance_dielivery_currency_report_category(createDate1, createDate2, channelIds, pzUID); 
    CALL KYDB_NEW.sp_statis_agent_top_all_line(pzUID); 
    SET v_sql = CONCAT('UPDATE finance_manage.finance_dielivery_detail AS main 
                        INNER JOIN (
                            SELECT temp.TopUID, A.StatisDate, SUM(Profit) AS sumProfit 
                            FROM finance_manage.finance_dielivery_detail AS A 
                            INNER JOIN KYDB_NEW.TEMP_AGENT_TOP AS temp ON A.ChannelID = temp.ChannelID
                            WHERE A.StatisDate >= ''', createDate1,''' AND A.StatisDate <= ''', createDate2,''''); 
    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_sql = CONCAT(v_sql,' AND find_in_set(A.channelId,''', v_channelIdList,''')'); 
    END IF; 
    SET v_sql = CONCAT(v_sql,' GROUP BY temp.TopUID, A.StatisDate) AS T SET main.SumProfit = T.sumProfit WHERE main.ChannelID = T.TopUID AND main.StatisDate = T.StatisDate'); 
    SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    SET v_sql = CONCAT('DELETE FROM finance_manage.finance_dielivery_list WHERE statisdate = date_format(''', createDate1,''',''%Y-%m'')'); 
    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_sql = CONCAT(v_sql,' AND find_in_set(channelId,''', v_channelIdList,''');'); 
    END IF; 
    SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    SET v_sql = CONCAT('REPLACE INTO finance_manage.finance_dielivery_list (StatisDate, ChannelID, ChannelName, NickName, AccountingFor, CellScore, Profit, SumProfit, TimeZone, ref_deliveryMoneyType, ref_deliveryExchangeRate)
                        SELECT date_format(''', createDate1,''',''%Y-%m''), A.ChannelID, A.ChannelName, A.NickName, A.AccountingFor, SUM(CellScore) AS CellScore, SUM(Profit) AS Profit, SUM(SumProfit) AS SumProfit, A.TimeZone, C.currency, C.financeExchangeRate
                        FROM finance_manage.finance_dielivery_detail A
                        INNER JOIN KYDB_NEW.agent AS B ON A.ChannelID = B.id
                        INNER JOIN game_manage.rp_currency AS C ON B.deliveryMoneyType = C.id
                        WHERE StatisDate >= ''', createDate1,''' AND StatisDate <= ''', createDate2,''''); 
    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_sql = CONCAT(v_sql,' AND find_in_set(channelId,''', v_channelIdList,''')'); 
    END IF; 
    SET v_sql = CONCAT(v_sql,' GROUP BY A.ChannelID, A.ChannelName, A.NickName, A.AccountingFor, A.TimeZone;'); 
    SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 
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
DROP PROCEDURE IF EXISTS `sp_create_finance_dielivery_report_category`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_create_finance_dielivery_report_category`(
    IN `createDate1` date,
    IN `createDate2` date,
    IN `channelIds` varchar(4000),
    IN `pzUID` int,
    IN `categoryType` int,
    IN `jackpotStatus` int
)
BEGIN
    DECLARE v_sql LONGTEXT; 
    DECLARE v_sql_proxy LONGTEXT; 
    DECLARE v_tblName VARCHAR(100); 
    DECLARE v_timeZone INT; 
    DECLARE v_i INT; 
    DECLARE v_delSql LONGTEXT; 
    DECLARE v_channelIdList LONGTEXT; 
    DECLARE v_category LONGTEXT; 
    DECLARE v_date_EST1 DATETIME; 
    DECLARE v_date_EST2 DATETIME; 
    DECLARE v_sqlWhere LONGTEXT; 

    SET v_date_EST1 = DATE_ADD( createDate1, INTERVAL 12 HOUR); 
    SET v_date_EST2 = DATE_ADD( createDate2, INTERVAL 12 HOUR); 

    IF categoryType = 0 THEN
        SET v_category = ''; 
    ELSEIF categoryType = 1 THEN
        SET v_category = CONCAT(' AND D.category != 4'); 
    ELSE
        SET v_category = CONCAT(' AND D.category = ', categoryType); 
    END IF; 

    IF LENGTH(channelIds) > 0 THEN
        SELECT KYDB_NEW.selRecursive(channelIds) INTO v_channelIdList; 
    END IF; 

    SET v_delSql = CONCAT('DELETE FROM finance_manage.finance_dielivery_detail WHERE StatisDate >= ''', createDate1,''' AND StatisDate <= ''', createDate2,''' and category = ', categoryType); 
    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_delSql = CONCAT(v_delSql,' AND find_in_set(channelID,''', v_channelIdList,''')'); 
    END IF; 

    SET @v_delSql = v_delSql; 
    prepare stmt FROM @v_delSql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    SET v_sqlWhere = ''; 
    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND find_in_set(channelId,''', v_channelIdList,''')'); 
    END IF; 

    SET v_sql = CONCAT('
                        SELECT 
                            A.StatisDate, 
                            B.id, 
                            B.account, 
                            B.nickname, 
                            ifnull(E.AccountingFor,B.AccountingFor) AS AccountingFor, 
                            SUM(A.CellScore * IFNULL(C.financeExchangeRate, C.exchangeRate)) AS CellScore, 
                            SUM(((A.WinGold * IFNULL(C.financeExchangeRate, C.exchangeRate)) + (A.LostGold * IFNULL(C.financeExchangeRate, C.exchangeRate)))) AS Profit, 
                            0 AS SumProfit, 
                            0, ' , 
                            categoryType , ' AS category
                        FROM ( SELECT StatisDate, ChannelID, currency, GameID, CellScore, WinGold, LostGold 
                                FROM KYStatis.statis_record_agent_game
                                WHERE StatisDate >= ''', createDate1,''' 
                                AND StatisDate <= ''', createDate2,'''
                                AND ChannelID NOT IN (
                                                    SELECT channelId 
                                                    FROM finance_manage.special_agent_manage 
                                                    WHERE type IN (0,5))
                                                    ', v_sqlWhere ,')  AS A 
                        INNER JOIN KYDB_NEW.agent AS B ON A.ChannelID = B.id
                        INNER JOIN game_manage.rp_currency AS C ON A.currency = C.currency
                        INNER JOIN KYDB_NEW.GameInfo D on A.GameID = D.GameID  ', v_category  ,'
                        LEFT JOIN finance_manage.accountingForSet E on A.ChannelID = E.channelId and E.category = ',categoryType ); 

    SET v_sql = CONCAT(v_sql,' GROUP BY StatisDate, A.ChannelID '); 

    SET v_sql = CONCAT(v_sql, ' UNION ALL
                        SELECT 
                            A.StatisDate, 
                            B.id, 
                            B.account, 
                            B.nickname, 
                            ifnull(E.AccountingFor,B.AccountingFor) AS AccountingFor, 
                            SUM(A.CellScore * IFNULL(C.financeExchangeRate, C.exchangeRate)) AS CellScore, 
                            SUM(((A.WinGold * IFNULL(C.financeExchangeRate, C.exchangeRate)) + (A.LostGold * IFNULL(C.financeExchangeRate, C.exchangeRate)))) AS Profit, 
                            0 AS SumProfit, 
                            1, ' , 
                            categoryType , ' AS category
                        FROM ( SELECT StatisDate, ChannelID, currency, GameID, CellScore, WinGold, LostGold 
                                FROM KYStatis.statis_record_agent_game_EST 
                                WHERE StatisDate >= ''', createDate1,''' 
                                AND StatisDate <= ''', createDate2,'''
                                AND ChannelID IN (
                                                SELECT channelId 
                                                FROM finance_manage.special_agent_manage 
                                                WHERE type IN (0,5))
                                                ', v_sqlWhere ,') AS A 
                        INNER JOIN KYDB_NEW.agent AS B ON A.ChannelID = B.id
                        INNER JOIN game_manage.rp_currency AS C ON A.currency = C.currency
                        INNER JOIN KYDB_NEW.GameInfo D on A.GameID = D.GameID ', v_category  ,'
                        LEFT JOIN finance_manage.accountingForSet E on A.ChannelID = E.channelId and E.category = ',categoryType); 

    SET v_sql = CONCAT(v_sql,' GROUP BY StatisDate, A.ChannelID '); 

    SET v_sql = CONCAT('REPLACE INTO finance_manage.finance_dielivery_detail (StatisDate, ChannelID, ChannelName, NickName, AccountingFor, CellScore, Profit, SumProfit, TimeZone, category) ', v_sql); 

    SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    IF jackPotStatus = 1 THEN
        SET v_sql = CONCAT('UPDATE finance_manage.finance_dielivery_detail AS main 
                            INNER JOIN (SELECT 
                                            agent,
                                            SUM(add_score) AS jpMoney,
                                            date_format(order_time, ''%Y-%m-%d'') AS orderTime
                                        FROM jackpot.jackpot_payout_record 
                                        WHERE order_Time >= ''', createDate1,''' 
                                        AND order_Time <= DATE_FORMAT(''', createDate2,''', ''%Y-%m-%d 23:59:59'')
                                        AND agent NOT IN (
                                                SELECT channelId 
                                                FROM finance_manage.special_agent_manage 
                                                WHERE type IN (0,5))
                                        GROUP BY agent, date_format(order_time, ''%Y-%m-%d'')) 
                                    AS T SET main.jpMoney = T.jpMoney WHERE main.ChannelID = T.agent AND main.StatisDate = T.orderTime AND main.category = ', categoryType); 

        IF LENGTH(v_channelIdList) > 0 THEN
            SET v_sql = CONCAT(v_sql,' AND find_in_set(main.channelId,''', v_channelIdList,''')'); 
        END IF; 
        SET @v_sql = v_sql; 
        prepare stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE prepare stmt; 
        SET v_sql = CONCAT('UPDATE finance_manage.finance_dielivery_detail AS main 
                            INNER JOIN (SELECT 
                                            agent, 
                                            SUM(add_score) AS jpMoney, 
                                            date_format(CONVERT_TZ(order_time, ''Asia/Shanghai'', ''America/New_York''), ''%Y-%m-%d'') AS orderTime
                                        FROM jackpot.jackpot_payout_record 
                                        WHERE order_Time >= ''', v_date_EST1,''' 
                                        AND order_Time <= ''', v_date_EST2,'''
                                        AND agent IN (
                                                SELECT channelId 
                                                FROM finance_manage.special_agent_manage 
                                                WHERE type IN (0,5))
                                        GROUP BY agent, date_format(CONVERT_TZ(order_time, ''Asia/Shanghai'', ''America/New_York''), ''%Y-%m-%d''))
                                    AS T SET main.jpMoney = T.jpMoney WHERE main.ChannelID = T.agent AND main.StatisDate = T.orderTime AND main.category = ', categoryType); 

        IF LENGTH(v_channelIdList) > 0 THEN
            SET v_sql = CONCAT(v_sql,' AND find_in_set(main.channelId,''', v_channelIdList,''')'); 
        END IF; 
        SET @v_sql = v_sql; 
        prepare stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE prepare stmt; 
    END IF; 
    
    CALL KYDB_NEW.sp_statis_agent_top_all_line(pzUID); 
    CALL finance_manage.sp_create_finance_dielivery_currency_report_category(createDate1, createDate2, channelIds, pzUID, categoryType); 

    SET v_sql = CONCAT('UPDATE finance_manage.finance_dielivery_detail AS main 
                        INNER JOIN (
                            SELECT temp.TopUID, A.StatisDate, SUM(Profit) AS sumProfit, SUM(jpMoney) AS sumJpMoney
                            FROM finance_manage.finance_dielivery_detail AS A 
                            INNER JOIN KYDB_NEW.TEMP_AGENT_TOP AS temp ON A.ChannelID = temp.ChannelID
                            WHERE A.StatisDate >= ''', createDate1,''' AND A.StatisDate <= ''', createDate2,''' AND category = ',categoryType); 
    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_sql = CONCAT(v_sql,' AND find_in_set(A.channelId,''', v_channelIdList,''')'); 
    END IF; 

    SET v_sql = CONCAT(v_sql,' GROUP BY temp.TopUID, A.StatisDate, category) AS T SET main.SumProfit = T.sumProfit, main.sumJpMoney = T.sumJpMoney WHERE main.ChannelID = T.TopUID AND main.StatisDate = T.StatisDate AND main.category = ', categoryType); 
    
    SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    SET v_sql = CONCAT('DELETE FROM finance_manage.finance_dielivery_list WHERE statisdate = date_format(''', createDate1,''',''%Y-%m'')  and category = ', categoryType); 
    
    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_sql = CONCAT(v_sql,' AND find_in_set(channelId,''', v_channelIdList,''');'); 
    END IF; 
    
    SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    SET v_sql = CONCAT('REPLACE INTO finance_manage.finance_dielivery_list (StatisDate, ChannelID, ChannelName, NickName, AccountingFor, CellScore, Profit, SumProfit, TimeZone, jpMoney, sumJpMoney, ref_deliveryMoneyType, ref_deliveryExchangeRate, category)
                        SELECT date_format(''', createDate1,''',''%Y-%m''), A.ChannelID, A.ChannelName, A.NickName, A.AccountingFor, SUM(CellScore) AS CellScore, SUM(Profit) AS Profit, SUM(SumProfit) AS SumProfit, A.TimeZone, SUM(jpMoney) AS jpMoney, SUM(sumJpMoney) AS sumJpMoney, C.currency, IFNULL(C.financeExchangeRate, C.exchangeRate), category AS category
                        FROM finance_manage.finance_dielivery_detail A
                        INNER JOIN KYDB_NEW.agent AS B ON A.ChannelID = B.id
                        INNER JOIN game_manage.rp_currency AS C ON B.deliveryMoneyType = C.id
                        WHERE StatisDate >= ''', createDate1,''' AND StatisDate <= ''', createDate2,''' AND category = ', categoryType); 
    
    IF LENGTH(v_channelIdList) > 0 THEN
        SET v_sql = CONCAT(v_sql,' AND find_in_set(channelId,''', v_channelIdList,''')'); 
    END IF; 
    
    SET v_sql = CONCAT(v_sql,' GROUP BY A.ChannelID, A.ChannelName, A.NickName, A.AccountingFor, A.TimeZone, A.category;'); 
    
    SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 
    IF jackPotStatus = 1 THEN
        IF categoryType in (0, 1) THEN
            -- # KX JP 交收 start
            DROP TABLE IF EXISTS update_statis_record_agent_game; 

            CREATE TEMPORARY TABLE update_statis_record_agent_game
            (
                ChannelID INT,
                StatisDate DATE,
                CellScore DECIMAL(20,5)
            ); 

            SET v_sql = CONCAT(
                                '
                                INSERT INTO update_statis_record_agent_game
                                SELECT
                                    A.ChannelID,
                                    A.StatisDate,
                                    SUM(A.CellScore * IFNULL(C.financeExchangeRate, A.ExchangeRate)) AS CellScore
                                FROM KYStatis.statis_record_agent_game AS A
                                INNER JOIN KYDB_NEW.GameInfo B on A.GameID = B.GameID AND B.category = 1
                                INNER JOIN game_manage.rp_currency AS C ON A.currency = C.currency
                                WHERE A.StatisDate BETWEEN DATE_SUB(date_format(''', createDate1,''', ''%Y-%m-01''), INTERVAL 1 MONTH) AND DATE_FORMAT(LAST_DAY(''', createDate2,'''), ''%Y-%m-%d 23:59:59'') 
                                AND B.category = 1 
                                GROUP BY ChannelID, StatisDate'
                                ); 

            SET @v_sql = v_sql; 
            prepare stmt FROM @v_sql; 
            EXECUTE stmt; 
            DEALLOCATE prepare stmt; 

            SET v_sql = CONCAT('
                        UPDATE finance_manage.finance_dielivery_list AS main 
                        INNER JOIN 
                        (
                        SELECT 
                            date_format(''', createDate1,''',''%Y-%m'') AS statisDate,
                            a.ChannelID AS channelId, 
                            b.InsuranceType AS insuranceType, 
                            SUM(a.CellScore) AS jpInsuranceMoney, 
                            b.JackpotOpenDate AS jackpotOpenDate 
                        FROM update_statis_record_agent_game AS a 
                        LEFT JOIN ( 
                            SELECT 
                                id,
                                InsuranceType,
                                JackpotOpenDate,
                                (
                                    CASE
                                    WHEN JackpotOpenDate IS NULL THEN NULL
                                    WHEN InsuranceType = 0 THEN
                                        IF (
                                            PERIOD_DIFF(DATE_FORMAT(''', createDate1,''', ''%Y%M''), DATE_FORMAT(JackpotOpenDate, ''%Y%M'')) = - 1,
                                            DATE_SUB(JackpotOpenDate,INTERVAL 1 MONTH),
                                            date_format(''', createDate1,''', ''%Y-%m-01'')
                                        )
                                    WHEN InsuranceType = 1 THEN
                                        IF (
                                            date_format(''', createDate1,''', ''%Y-%m-01'') <= JackpotOpenDate,
                                            JackpotOpenDate,
                                            date_format(''', createDate1,''', ''%Y-%m-01'')
                                        )
                                    END
                                ) AS InsuranceDate
                            FROM KYDB_NEW.agent
                        ) b ON a.ChannelID = b.id 
                        WHERE a.StatisDate BETWEEN b.InsuranceDate AND DATE_FORMAT(LAST_DAY(''', createDate2,'''), ''%Y-%m-%d 23:59:59'') 
                        AND a.ChannelID NOT IN (
                                    SELECT channelId 
                                    FROM finance_manage.special_agent_manage 
                                    WHERE type IN (0,5)
                                    )'); 

            IF LENGTH(v_channelIdList) > 0 THEN
                SET v_sql = CONCAT(v_sql,' AND find_in_set(a.channelId,''', v_channelIdList,''')'); 
            END IF; 
            SET v_sql = CONCAT(v_sql,'  GROUP BY a.ChannelID ) AS T 
                                        SET main.InsuranceType = T.InsuranceType, 
                                        main.jpInsuranceMoney = T.jpInsuranceMoney, 
                                        main.jackpotOpenDate = T.jackpotOpenDate 
                                        WHERE main.ChannelID = T.ChannelID 
                                        AND main.StatisDate = T.StatisDate 
                                        AND main.category = ', categoryType); 
            SET @v_sql = v_sql; 
            prepare stmt FROM @v_sql; 
            EXECUTE stmt; 
            DEALLOCATE prepare stmt; 

            SET v_sql = CONCAT('
                        UPDATE finance_manage.finance_dielivery_list AS main 
                        INNER JOIN (
                        SELECT 
                            date_format(''', createDate1,''',''%Y-%m'') AS statisDate, 
                            b.topUId AS topUId, 
                            SUM(a.CellScore) AS jpInsuranceMoney 
                        FROM update_statis_record_agent_game a 
                        LEFT JOIN ( 
                            SELECT 
                                id,
                                topUId,
                                InsuranceType,
                                JackpotOpenDate,
                                (
                                    CASE
                                    WHEN JackpotOpenDate IS NULL THEN NULL
                                    WHEN InsuranceType = 0 THEN
                                        IF (
                                            PERIOD_DIFF(DATE_FORMAT(''', createDate1,''', ''%Y%M''), DATE_FORMAT(JackpotOpenDate, ''%Y%M'')) = - 1,
                                            DATE_SUB(JackpotOpenDate,INTERVAL 1 MONTH),
                                            date_format(''', createDate1,''', ''%Y-%m-01'')
                                        )
                                    WHEN InsuranceType = 1 THEN
                                        IF (
                                            date_format(''', createDate1,''', ''%Y-%m-01'') <= JackpotOpenDate,
                                            JackpotOpenDate,
                                            date_format(''', createDate1,''', ''%Y-%m-01'')
                                        )
                                    END
                                ) AS InsuranceDate
                            FROM KYDB_NEW.agent
                        ) b ON a.ChannelID = b.id 
                        WHERE a.StatisDate BETWEEN b.InsuranceDate AND DATE_FORMAT(LAST_DAY(''', createDate2,'''), ''%Y-%m-%d 23:59:59'') 
                        AND b.topUId NOT IN (
                                    SELECT channelId 
                                    FROM finance_manage.special_agent_manage 
                                    WHERE type IN (0,5))'); 
            IF LENGTH(v_channelIdList) > 0 THEN
                SET v_sql = CONCAT(v_sql,' AND find_in_set(a.channelId,''', v_channelIdList,''')'); 
            END IF; 
            SET v_sql = CONCAT(v_sql,'  GROUP BY b.topUId ) AS T 
                                        SET main.sumJpInsuranceMoney = T.jpInsuranceMoney 
                                        WHERE main.ChannelID = T.topUId 
                                        AND main.StatisDate = T.StatisDate 
                                        AND main.category = ', categoryType); 
            SET @v_sql = v_sql; 
            prepare stmt FROM @v_sql; 
            EXECUTE stmt; 
            DEALLOCATE prepare stmt; 

            DROP TABLE IF EXISTS update_statis_record_agent_game_EST; 

            CREATE TEMPORARY TABLE update_statis_record_agent_game_EST
            (
                ChannelID INT,
                StatisDate DATE,
                CellScore DECIMAL(20,5)
            ); 

            SET v_sql = CONCAT(
                                '
                                INSERT INTO update_statis_record_agent_game_EST
                                SELECT
                                    A.ChannelID,
                                    A.StatisDate,
                                    SUM(A.CellScore * IFNULL(C.financeExchangeRate, A.ExchangeRate)) AS CellScore
                                FROM KYStatis.statis_record_agent_game_EST AS A
                                INNER JOIN KYDB_NEW.GameInfo B on A.GameID = B.GameID AND B.category = 1
                                INNER JOIN game_manage.rp_currency AS C ON A.currency = C.currency
                                WHERE A.StatisDate BETWEEN DATE_SUB(date_format(''', createDate1,''', ''%Y-%m-01''), INTERVAL 1 MONTH) AND DATE_FORMAT(LAST_DAY(''', createDate2,'''), ''%Y-%m-%d 23:59:59'') 
                                AND B.category = 1 
                                GROUP BY ChannelID, StatisDate'
                                ); 

            SET @v_sql = v_sql; 
            prepare stmt FROM @v_sql; 
            EXECUTE stmt; 
            DEALLOCATE prepare stmt; 

            SET v_sql = CONCAT('
                        UPDATE finance_manage.finance_dielivery_list AS main 
                        INNER JOIN (
                        SELECT 
                            date_format(''', createDate1,''',''%Y-%m'') AS statisDate,
                            a.ChannelID AS channelId, 
                            b.InsuranceType AS insuranceType, 
                            SUM(a.CellScore) AS jpInsuranceMoney, 
                            b.JackpotOpenDate AS jackpotOpenDate 
                        FROM update_statis_record_agent_game_EST a 
                        LEFT JOIN ( 
                            SELECT 
                                id,
                                InsuranceType,
                                JackpotOpenDate,
                                (
                                    CASE
                                    WHEN JackpotOpenDate IS NULL THEN NULL
                                    WHEN InsuranceType = 0 THEN
                                        IF (
                                            PERIOD_DIFF(DATE_FORMAT(''', createDate1,''', ''%Y%M''), DATE_FORMAT(JackpotOpenDate, ''%Y%M'')) = - 1,
                                            DATE_SUB(JackpotOpenDate,INTERVAL 1 MONTH),
                                            date_format(''', createDate1,''', ''%Y-%m-01'')
                                        )
                                    WHEN InsuranceType = 1 THEN
                                        IF (
                                            date_format(''', createDate1,''', ''%Y-%m-01'') <= JackpotOpenDate,
                                            JackpotOpenDate,
                                            date_format(''', createDate1,''', ''%Y-%m-01'')
                                        )
                                    END
                                ) AS InsuranceDate
                            FROM KYDB_NEW.agent
                        ) b ON a.ChannelID = b.id 
                        WHERE a.StatisDate BETWEEN b.InsuranceDate AND DATE_FORMAT(LAST_DAY(''', createDate2,'''), ''%Y-%m-%d 23:59:59'') 
                        AND a.ChannelID IN (
                                    SELECT channelId 
                                    FROM finance_manage.special_agent_manage 
                                    WHERE type IN (0,5))'); 

            IF LENGTH(v_channelIdList) > 0 THEN
                SET v_sql = CONCAT(v_sql,' AND find_in_set(a.channelId,''', v_channelIdList,''')'); 
            END IF; 
            
            SET v_sql = CONCAT(v_sql,'  GROUP BY a.ChannelID ) AS T 
                                        SET main.InsuranceType = T.InsuranceType, 
                                        main.jpInsuranceMoney = T.jpInsuranceMoney, 
                                        main.jackpotOpenDate = T.jackpotOpenDate 
                                        WHERE main.ChannelID = T.ChannelID 
                                        AND main.StatisDate = T.StatisDate 
                                        AND main.category = ', categoryType); 
            SET @v_sql = v_sql; 
            prepare stmt FROM @v_sql; 
            EXECUTE stmt; 
            DEALLOCATE prepare stmt; 

            SET v_sql = CONCAT('
                        UPDATE finance_manage.finance_dielivery_list AS main 
                        INNER JOIN (
                        SELECT 
                            date_format(''', createDate1,''',''%Y-%m'') AS statisDate, 
                            b.topUId AS topUId, 
                            SUM(a.CellScore) AS jpInsuranceMoney 
                        FROM update_statis_record_agent_game_EST a 
                        LEFT JOIN ( 
                            SELECT 
                                id,
                                topUId,
                                InsuranceType,
                                JackpotOpenDate,
                                (
                                    CASE
                                    WHEN JackpotOpenDate IS NULL THEN NULL
                                    WHEN InsuranceType = 0 THEN
                                        IF (
                                            PERIOD_DIFF(DATE_FORMAT(''', createDate1,''', ''%Y%M''), DATE_FORMAT(JackpotOpenDate, ''%Y%M'')) = - 1,
                                            DATE_SUB(JackpotOpenDate,INTERVAL 1 MONTH),
                                            date_format(''', createDate1,''', ''%Y-%m-01'')
                                        )
                                    WHEN InsuranceType = 1 THEN
                                        IF (
                                            date_format(''', createDate1,''', ''%Y-%m-01'') <= JackpotOpenDate,
                                            JackpotOpenDate,
                                            date_format(''', createDate1,''', ''%Y-%m-01'')
                                        )
                                    END
                                ) AS InsuranceDate
                            FROM KYDB_NEW.agent
                        ) b ON a.ChannelID = b.id 
                        WHERE a.StatisDate BETWEEN b.InsuranceDate AND DATE_FORMAT(LAST_DAY(''', createDate2,'''), ''%Y-%m-%d 23:59:59'') 
                        AND b.topUId IN (
                                    SELECT channelId 
                                    FROM finance_manage.special_agent_manage 
                                    WHERE type IN (0,5))'); 

            IF LENGTH(v_channelIdList) > 0 THEN
                SET v_sql = CONCAT(v_sql,' AND find_in_set(a.channelId,''', v_channelIdList,''')'); 
            END IF; 

            SET v_sql = CONCAT(v_sql,'  GROUP BY b.topUId ) AS T 
                                        SET main.sumJpInsuranceMoney = T.jpInsuranceMoney 
                                        WHERE main.ChannelID = T.topUId 
                                        AND main.StatisDate = T.StatisDate 
                                        AND main.category = ', categoryType); 
            SET @v_sql = v_sql; 
            prepare stmt FROM @v_sql; 
            EXECUTE stmt; 
            DEALLOCATE prepare stmt; 
            -- # KX JP 交收 end
        END IF; 
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
DROP PROCEDURE IF EXISTS `sp_GetAccountCellScore`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_GetAccountCellScore`(OUT `recordTotal` int,IN `gameSQL` text, IN `pageSize` int,IN `pageIndex` int,IN `isPage` bit)
BEGIN
    DECLARE v_sqlcount LONGTEXT; 
    DECLARE v_sqlselect LONGTEXT; 
    DECLARE v_sqlstatis LONGTEXT; 
    DECLARE v_sqlbase LONGTEXT; 

    SET v_sqlbase = gameSQL; 

    IF LENGTH(v_sqlbase) <> 0 THEN
        SET v_sqlbase = CONCAT('SELECT main.ChannelID, b.Accounts AS Agent, main.Accounts, SUM(main.CellScore) AS CellScore, SUM(main.AllBet) AS AllBet, SUM(main.Profit) AS Profit, a.lastlogintime, main.currency
								FROM (',v_sqlbase,') AS main
								LEFT JOIN KYDB_NEW.accounts AS a ON main.Accounts = a.account
								LEFT JOIN KYDB_NEW.Sys_ProxyAccount AS b ON main.ChannelID = b.ChannelID
								GROUP BY main.Accounts, main.currency
								ORDER BY main.CellScore DESC'); 
        IF isPage = 1 THEN
            SET v_sqlselect = CONCAT(v_sqlbase,' LIMIT ',pageIndex,',',pageSize); 
        ELSE
            SET v_sqlselect = v_sqlbase; 
        END IF; 
        SET @v_sqlselect = v_sqlselect; 
        PREPARE stmt FROM @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 

        SET v_sqlcount = CONCAT('SELECT count(*) INTO @recordCount FROM ','(',v_sqlbase,') AS main'); 
        SET @v_sqlcount = v_sqlcount; 
        PREPARE stmt FROM @v_sqlcount; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        SET recordTotal = @recordCount; 
        SELECT recordTotal; 
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
DROP PROCEDURE IF EXISTS `sp_StatisUsersGameDayData_room`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisUsersGameDayData_room`(`in_StatisDate` date, `in_GameName` varchar(100))
BEGIN
	DECLARE v_month VARCHAR(30); 
	DECLARE v_tblname VARCHAR(100); 
	DECLARE v_startTime VARCHAR(100); 
	DECLARE v_endTime VARCHAR(100); 
	DECLARE v_sqlbase LONGTEXT; 

	IF in_StatisDate IS NULL THEN
		SET in_StatisDate = DATE_ADD(CURDATE(), INTERVAL -1 day); 
	END IF; 

	SET v_startTime =  CONCAT(in_StatisDate, ' 00:00:00'); 
	SET v_endTime =  CONCAT(in_StatisDate, ' 23:59:59'); 
	SET v_month = DATE_FORMAT(in_StatisDate,'%Y%m'); 
	SET v_tblname = CONCAT(in_GameName, '_gameRecord'); 
	IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_', in_GameName, v_month, '_users_room')) THEN
		CALL sp_createStatisticsUsersTable(CONCAT('statis_', in_GameName, v_month, '_users_room'), 2); 
	END IF; 
	IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'detail_record' AND TABLE_NAME = v_tblname) THEN
		SET v_sqlbase = CONCAT('REPLACE INTO KYStatisUsers.statis_', in_GameName,v_month, '_users_room (StatisDate, Account, ChannelID, ServerID, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum, currency) 
			SELECT ''', in_StatisDate, ''' AS StatisDate, Accounts, ChannelID, ServerID,
				SUM(CellScore) CellScore,
				SUM(case when Profit > 0 then Profit else 0 end) wingold, 
				SUM(case when Profit < 0 then Profit else 0 end) lostgold, 
				SUM(Revenue) Revenue, 
				COUNT(case when Profit >= 0 then Profit end) winNum, 
				COUNT(case when Profit < 0 then Profit end) lostNum, 
				currency 
				FROM detail_record.', v_tblname,' 
				WHERE GameEndTime >= ''',v_startTime,'''
				AND GameEndTime <= ''',v_endTime,'''
				GROUP BY Accounts, ChannelID, ServerID, currency'); 
	SET @v_sqlselect = v_sqlbase; 

	PREPARE stmt FROM @v_sqlselect; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
	set @VVV = v_sqlbase; 
-- 	select @VVV; 
	IF NOT EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = CONCAT('statis_',in_GameName,v_month,'_users_room') AND COLUMN_NAME = 'isNew') THEN
		SET @v_sqlselect = CONCAT('ALTER TABLE KYStatisUsers.statis_', in_GameName,v_month, '_users_room add `isNew` int(11) DEFAULT 0;'); 
		
		PREPARE stmt FROM @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 
	SET @v_sqlselect = CONCAT('UPDATE KYStatisUsers.statis_', in_GameName,v_month, '_users_room set isNew=1 
	WHERE StatisDate = ''', in_StatisDate, ''' AND Account in (SELECT account FROM KYDB_NEW.accounts WHERE createdate >= ''', in_StatisDate, ' 00:00:00'' AND createdate <= ''', in_StatisDate, ' 23:59:59'')'); 
	SELECT @v_sqlselect;  		
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
DROP PROCEDURE IF EXISTS `sp_statis_month`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statis_month`(IN `payMonth` varchar(7),IN `channelId` int,IN `in_name` varchar(50))
BEGIN
	DECLARE v_ReceiveMoney BIGINT; 
	DECLARE v_i INT; 
	DECLARE v_sql LONGTEXT; 

	SET v_sql = CONCAT('UPDATE finance_dielivery_list SET Status = 3 WHERE StatisDate = ''', payMonth,''' AND ChannelID = ', channelId,';'); 
	SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    SET v_sql = CONCAT('UPDATE finance_income_info SET Status = 1 WHERE PayMonth = ''', payMonth,''' AND ChannelID = ', channelId,';'); 
    SELECT v_sql; 
    SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 
    
    SET v_sql = CONCAT('SELECT exchangeRate, 1 AS RateCalculate INTO @ExchangeRate, @RateCalculate 
                        FROM game_manage.rp_currency AS A
                        INNER JOIN (
                            SELECT moneyType 
                            FROM KYDB_NEW.agent 
                            WHERE FIND_IN_SET(', channelId,', id)) AS B ON B.moneyType = A.id;'); 
    SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 
    SET @ExchangeRate = IFNULL(@ExchangeRate, 1); 
	SET @RateCalculate = IFNULL(@RateCalculate, 0); 

	SET v_sql = CONCAT('SELECT COUNT(1) INTO @count FROM finance_dielivery_list WHERE StatisDate = ''', payMonth,''' AND ChannelID = ', channelId,';'); 
	SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    SET v_ReceiveMoney = 0; 
	IF @count > 1 THEN
		SET v_i = 0; 
		f_loop:LOOP
			SET v_sql = CONCAT('SELECT IFNULL(SumProfit,0), IFNULL(AccountingFor,0), IFNULL(SpecialMoney,0) 
                                INTO @SumProfit, @AccountingFor, @SpecialMoney
								FROM finance_dielivery_list WHERE StatisDate = ''', payMonth,''' AND ChannelID = ', channelId,' AND LevelID > 0 limit ', v_i,', 1;'); 
			SET @v_sql = v_sql; 
            prepare stmt FROM @v_sql; 
            EXECUTE stmt; 
            DEALLOCATE prepare stmt; 
            SET @SumProfit = IFNULL(@SumProfit,0); 
            IF @SumProfit / 100 > -200 THEN
                SET @SumProfit = 0; 
            END IF; 
            SET @AccountingFor = IFNULL(@AccountingFor, 0); 
            SET @SpecialMoney = IFNULL(@SpecialMoney, 0); 

		    SET @jsMoney = (@SumProfit * -1) * (@AccountingFor / 100); 
            IF @RateCalculate = 0 THEN
			    SET @jsMoney = ROUND(@jsMoney * @ExchangeRate / 100); 
            ELSE
                SET @jsMoney = ROUND(@jsMoney / @ExchangeRate / 100); 
            END IF; 

            SET v_ReceiveMoney = v_ReceiveMoney + ROUND(@jsMoney - @SpecialMoney / 100); 
            SET @SumProfit = 0; 
            SET @AccountingFor = 0; 
            SET @SpecialMoney = 0; 

            SET v_i = v_i + 1; 
            IF v_i = @count - 1 THEN
                leave f_loop; 
            END IF; 
        END LOOP f_loop; 
    ELSE
		SET v_sql = CONCAT('SELECT IFNULL(SumProfit,0), IFNULL(AccountingFor,1), IFNULL(SpecialMoney,0) 
                            INTO @SumProfit, @AccountingFor, @SpecialMoney
							FROM finance_dielivery_list WHERE StatisDate = ''', payMonth,''' AND ChannelID = ', channelId,' AND LevelID = 0;'); 
		SET @v_sql = v_sql; 
        prepare stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE prepare stmt; 

        SET @SumProfit = IFNULL(@SumProfit, 0); 

		IF @SumProfit / 100 > -200 THEN
			SET @SumProfit = 0; 
        END IF; 
        SET @AccountingFor = IFNULL(@AccountingFor, 0); 
		SET @SpecialMoney = IFNULL(@SpecialMoney, 0); 
		SET @jsMoney = (@SumProfit * -1) * (@AccountingFor/100); 
		IF @RateCalculate = 0 THEN
			SET @jsMoney = ROUND(@jsMoney * @ExchangeRate / 100); 
        ELSE
			SET @jsMoney = ROUND(@jsMoney / @ExchangeRate / 100); 
        END IF; 
		SET v_ReceiveMoney = ROUND(@jsMoney - @SpecialMoney / 100); 
    END IF; 

	SET @prevMonth = DATE_FORMAT(date_add(CONCAT(payMonth,'-01'),interval -1 month),'%Y-%m'); 
	SET v_sql = CONCAT('SELECT Unpaid INTO @PrevUnpaid FROM finance_income_report WHERE PayMonth = ''', @prevMonth,''' AND ChannelID = ', channelId,' AND Status = 1'); 
	SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    SET @PrevUnpaid = IFNULL(@PrevUnpaid, 0); 

	SET v_sql = CONCAT('SELECT 
                            IFNULL(SUM(CASE WHEN IncomeType = 0 THEN IncomeMoney ELSE 0 END),0),
                            IFNULL(SUM(case WHEN IncomeType = 1 OR IncomeType = 2 THEN IncomeMoney ELSE 0 END),0),
                            IFNULL(SUM(OtherPay),0),IFNULL(SUM(OtherIncome),0),
                            IFNULL(SUM(Rebate),0)
                        INTO @incomeMoney, @beforeMoney, @otherPay, @otherIncome, @rebate 
                        FROM finance_income_info 
                        WHERE PayMonth = ''', payMonth,''' AND ChannelID = ', channelId,';'); 
	SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 
    SET @incomeMoney = IFNULL(@incomeMoney, 0); 
	SET @beforeMoney = IFNULL(@beforeMoney, 0); 
	SET @otherPay = IFNULL(@otherPay, 0); 
	SET @otherIncome = IFNULL(@otherIncome, 0); 
	SET @rebate = IFNULL(@rebate, 0); 

	SET @nextIncomeMoney = @incomeMoney + @beforeMoney - v_ReceiveMoney * 100 - @PrevUnpaid - @otherPay - @rebate; 
	IF @nextIncomeMoney < 0 THEN
		SET @nextIncomeMoney = 0; 
    END IF; 


	SET @nextMonth = DATE_FORMAT(date_add(CONCAT(payMonth,'-01'),interval 1 month),'%Y-%m'); 
	SET v_sql = CONCAT('SELECT IFNULL(SUM(IncomeMoney),0) INTO @nextIncomeMoney2 FROM finance_income_info WHERE PayMonth = ''', @nextMonth,''' AND ChannelID = ', channelId,' AND (IncomeType = 1)'); 
	SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 
    SET @nextIncomeMoney2 = IFNULL(@nextIncomeMoney2, 0); 
	SET @lastIncomeMoney = @incomeMoney + @otherIncome + @nextIncomeMoney2; 
	SET @unpaid = v_ReceiveMoney * 100 + @PrevUnpaid - @beforeMoney - @incomeMoney - @otherPay - @rebate; 
	IF @unpaid < 0 THEN
		SET @unpaid = 0; 
    END IF; 

	SET v_sql = CONCAT('REPLACE INTO finance_income_report (ChannelID, PayMonth, ReceiveMoney, BeforeIncomeMoney, IncomeMoney, OtherPay, OtherIncome, Rebate, NextIncomeMoney, LastIncomeMoney, Unpaid, Status, PrevUnpaid)
                        VALUES (', channelId,',''', payMonth,''',',v_ReceiveMoney*100,',',@beforeMoney,',', @incomeMoney,',', @otherPay,',',@otherIncome,',', @rebate,',', @nextIncomeMoney2,',', @lastIncomeMoney,',', @unpaid,',1,', @PrevUnpaid,');'); 
	SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 

    SET v_sql = CONCAT('UPDATE finance_agent_money SET money = ', @nextIncomeMoney,' WHERE channelid = ', channelId,';'); 

	IF @nextIncomeMoney > 0 THEN
		INSERT INTO finance_income_info (ChannelID, IncomeType, PayMonth, IncomeMoney, IncomeDate, CreatePerson) VALUES (channelId, 2, @nextMonth, @nextIncomeMoney, CURDATE(), in_name); 
    END IF; 
	SET @v_sql = v_sql; 
    prepare stmt FROM @v_sql; 
    EXECUTE stmt; 
    DEALLOCATE prepare stmt; 
END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

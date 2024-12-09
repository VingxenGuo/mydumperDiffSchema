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
CREATE DEFINER=`root`@`%` PROCEDURE `sp_createStatisticsUsersTable`(IN `in_tablename` varchar(50),IN `in_type` int)
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
DROP PROCEDURE IF EXISTS `sp_StatisActivityUsersDayData`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisActivityUsersDayData`(IN `in_StatisDate` date)
BEGIN
		DECLARE v_date varchar(30); 
		DECLARE v_month VARCHAR(30); 
		DECLARE v_tblname varchar(100); 
		DECLARE v_starttime TIMESTAMP(3); 
		DECLARE v_endtime TIMESTAMP(3); 
		DECLARE v_sqlbase LONGTEXT; 
		DECLARE q_date VARCHAR(30); 
		DECLARE s_date VARCHAR(30); 
		DECLARE e_date VARCHAR(30); 
		DECLARE v_sqlcount LONGTEXT; 

		set v_starttime = CURRENT_TIMESTAMP(3); 
		IF in_StatisDate is null THEN
				SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
		END IF; 
		SET v_date = DATE_FORMAT(in_StatisDate, '%Y%m%d'); 
		SET v_month = DATE_FORMAT(in_StatisDate, '%Y%m'); 
		SET v_tblname = CONCAT('gameRecord', v_date); 
		SET q_date = DATE_FORMAT(in_StatisDate, '%Y-%m-%d'); 
		SET s_date = CONCAT(q_date, ' 20:00:00'); 
		SET e_date = CONCAT(q_date, ' 23:59:59.998'); 
select 0;	
		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'black_record' AND TABLE_NAME = v_tblname) THEN
select 1;        
			IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_Activity' AND TABLE_NAME = CONCAT('statis_black', v_month, '_users')) THEN
select 2;               
				call sp_createStatisticsUsersTable(CONCAT('statis_black', v_month, '_users'),0); 
			END IF; 
			SET @v_sqlselect = CONCAT('REPLACE into KYStatisUsers_Activity.statis_black', v_month,' _users (StatisDate, Account, ChannelID, LineCode, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum, Currency) select ''', in_StatisDate, ''' as StatisDate, Accounts, ChannelID, LineCode, sum(CellScore) CellScore, SUM(case when Profit > 0 then Profit else 0 end) wingold, sum(case when Profit < 0 then Profit else 0 end) lostgold, sum(Revenue) Revenue, COUNT(case when Profit >= 0 then Profit end) winNum, count(case when Profit < 0 then Profit end) lostNum, Currency
			from black_record.', v_tblname, ' WHERE CreateTime >= ', '"', s_date, '"' , ' AND CreateTime <= ', '"', e_date, '"' , ' GROUP BY Accounts, ChannelID, LineCode, Currency'); 
            PREPARE stmt from @v_sqlselect; 
			EXECUTE stmt; 
			DEALLOCATE PREPARE stmt; 
			SET v_sqlbase = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from KYStatisUsers_Activity.statis_black', v_month, '_users where StatisDate = ''', in_StatisDate, ''''); 
		END IF; 
select 1; 
		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'qznn_record' AND TABLE_NAME = v_tblname) THEN
			IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_Activity' AND TABLE_NAME = CONCAT('statis_qznn',v_month,'_users')) THEN
				call sp_createStatisticsUsersTable(CONCAT('statis_qznn',v_month,'_users'),0); 
			END IF; 
			SET @v_sqlselect = CONCAT('REPLACE into KYStatisUsers_Activity.statis_qznn', v_month,' _users (StatisDate, Account, ChannelID, LineCode, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum, Currency) select ''', in_StatisDate, ''' as StatisDate, Accounts, ChannelID, LineCode, sum(CellScore) CellScore, SUM(case when Profit > 0 then Profit else 0 end) wingold, sum(case when Profit < 0 then Profit else 0 end) lostgold, sum(Revenue) Revenue, COUNT(case when Profit >= 0 then Profit end) winNum, count(case when Profit < 0 then Profit end) lostNum, Currency
			from black_record.', v_tblname, ' WHERE CreateTime >= ', '"', s_date, '"' , ' AND CreateTime <= ', '"', e_date, '"' , ' GROUP BY Accounts, ChannelID, LineCode, Currency'); 
			PREPARE stmt from @v_sqlselect; 
			EXECUTE stmt; 
			DEALLOCATE PREPARE stmt; 
			SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from KYStatisUsers_Activity.statis_qznn', v_month, '_users where StatisDate = ''', in_StatisDate, '''');			
		END IF; 
select 2;			
		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'mpnn_record' AND TABLE_NAME = v_tblname) THEN
			IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_Activity' AND TABLE_NAME = CONCAT('statis_mpnn',v_month,'_users')) THEN
				call sp_createStatisticsUsersTable(CONCAT('statis_mpnn',v_month,'_users'),0); 
			END IF; 
			SET @v_sqlselect = CONCAT('REPLACE into KYStatisUsers_Activity.statis_mpnn', v_month,' _users (StatisDate, Account, ChannelID, LineCode, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum, Currency) select ''', in_StatisDate, ''' as StatisDate, Accounts, ChannelID, LineCode, sum(CellScore) CellScore, SUM(case when Profit > 0 then Profit else 0 end) wingold, sum(case when Profit < 0 then Profit else 0 end) lostgold, sum(Revenue) Revenue, COUNT(case when Profit >= 0 then Profit end) winNum, count(case when Profit < 0 then Profit end) lostNum, Currency
			from black_record.', v_tblname, ' WHERE CreateTime >= ', '"', s_date, '"' , ' AND CreateTime <= ', '"', e_date, '"' , ' GROUP BY Accounts, ChannelID, LineCode, Currency'); 
			PREPARE stmt from @v_sqlselect; 
			EXECUTE stmt; 
			DEALLOCATE PREPARE stmt; 
			SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from KYStatisUsers_Activity.statis_mpnn', v_month, '_users where StatisDate = ''', in_StatisDate, '''');						
		END IF; 
select 3;			
		IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_Activity' AND TABLE_NAME = CONCAT('statis_allgames',v_month,'_users')) THEN
			call sp_createStatisticsUsersTable(CONCAT('statis_allgames', v_month, '_users'),0); 
		END IF; 
		SET @v_sqlselect = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT('REPLACE into KYStatisUsers_Activity.statis_allgames', v_month, '_users (StatisDate, Account, ChannelID, LineCode, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum, Currency) select ''', in_StatisDate, ''' as StatisDate, Account, ChannelID, LineCode, sum(CellScore) CellScore, SUM(WinGold) WinGold, sum(LostGold) LostGold, sum(Revenue) Revenue, sum(WinNum) WinNum, sum(LostNum) LostNum, Currency  from ( ', v_sqlbase), ''), ' ) tmptable group by StatisDate, Account, ChannelID, LineCode, Currency'); 
		IF(LENGTH(v_sqlbase)) > 0 then
			PREPARE stmt from @v_sqlselect; 
			EXECUTE stmt; 
			DEALLOCATE PREPARE stmt; 
		END IF; 
select 4;	
		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'yxhd_record' AND TABLE_NAME = v_tblname) THEN
			SET v_sqlcount=CONCAT('REPLACE INTO KYStatisUsers_Activity.statis_awards_users (StatisDate, Account, ChannelID, LineCode, Currency) SELECT ''', in_StatisDate, '''  as StatisDate, Accounts, ChannelID, LineCode, Currency FROM yxhd_record.', v_tblname,	' GROUP BY Accounts, Currency'); 
			SET @v_sqlcount=v_sqlcount; 
			PREPARE stmt FROM @v_sqlcount; 
			EXECUTE stmt; 
			DEALLOCATE PREPARE stmt; 
		END IF; 
select 5;		
		INSERT INTO KYStatisUsers_Activity.event_log_record (sp_name, starttime, endtime, exectime,mark) VALUES ('sp_StatisActivityUsersDayData', v_starttime, v_endtime, TIMESTAMPDIFF(SECOND,v_starttime,v_endtime),''); 

END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

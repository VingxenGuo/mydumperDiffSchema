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
CREATE DEFINER=`root`@`%` PROCEDURE `sp_createStatisticsUsersTable`(
    IN `in_tablename` varchar(50),
    IN `in_type` int
)
BEGIN
    DECLARE createsql VARCHAR(1000); 
    DECLARE createsql0 VARCHAR(1000); 
    DECLARE createsql1 VARCHAR(1000); 
    DECLARE createsql2 VARCHAR(1000); 
    DECLARE createsql3 VARCHAR(1000); 
    DECLARE createsql4 VARCHAR(1000); 

    set createsql0=CONCAT('
        CREATE TABLE `',in_tablename,'` (
            `StatisDate` date NOT NULL,
            `Account` varchar(100) NOT NULL,
            `ChannelID` int(11) DEFAULT NULL,
            `LineCode` varchar(100) NOT NULL DEFAULT ''0'',
            `CellScore` bigint(20) DEFAULT ''0'' COMMENT ''有效投注'',
            `WinGold` bigint(20) DEFAULT ''0'' COMMENT ''赢钱'',
            `LostGold` bigint(20) DEFAULT ''0'' COMMENT ''输钱'',
            `Revenue` bigint(20) DEFAULT ''0'' COMMENT ''抽水'',
            `WinNum` int(11) DEFAULT ''0'' COMMENT ''赢钱局数(包含和局)'',
            `LostNum` int(11) DEFAULT ''0'' COMMENT ''输钱局数'',
            `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
            `UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`StatisDate`,`Account`,`LineCode`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
        '); 

    set createsql1=CONCAT('
        CREATE TABLE `',in_tablename,'` (
            `Account` varchar(100) NOT NULL,
            `ChannelID` int(11) DEFAULT NULL,
            `LineCode` varchar(100) NOT NULL DEFAULT ''0'',
            `CellScore` bigint(20) DEFAULT ''0'' COMMENT ''有效投注'',
            `WinGold` bigint(20) DEFAULT ''0'' COMMENT ''赢钱'',
            `LostGold` bigint(20) DEFAULT ''0'' COMMENT ''输钱'',
            `Revenue` bigint(20) DEFAULT ''0'' COMMENT ''抽水'',
            `WinNum` int(11) DEFAULT ''0'' COMMENT ''赢钱局数(包含和局)'',
            `LostNum` int(11) DEFAULT ''0'' COMMENT ''输钱局数'',
            `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
            `UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`Account`,`LineCode`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
        '); 
    set createsql2=CONCAT('
        CREATE TABLE `',in_tablename,'` (
            `StatisDate` date NOT NULL,
            `Account` varchar(100) NOT NULL,
            `ChannelID` int(11) DEFAULT NULL,
            `ServerID` int(11) NOT NULL DEFAULT ''0'',
            `CellScore` bigint(20) DEFAULT ''0'' COMMENT ''有效投注'',
            `WinGold` bigint(20) DEFAULT ''0'' COMMENT ''赢钱'',
            `LostGold` bigint(20) DEFAULT ''0'' COMMENT ''输钱'',
            `Revenue` bigint(20) DEFAULT ''0'' COMMENT ''抽水'',
            `WinNum` int(11) DEFAULT ''0'' COMMENT ''赢钱局数(包含和局)'',
            `LostNum` int(11) DEFAULT ''0'' COMMENT ''输钱局数'',
            `isNew` int(11) DEFAULT ''0'' COMMENT ''是否是新注册0老,1新注册'',
            `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
            `UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`StatisDate`,`Account`,`ServerID`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
        '); 

    set createsql3=CONCAT('
        CREATE TABLE `',in_tablename,'` (
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
            PRIMARY KEY (`StatisDate`,`ChannelID`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
        '); 

    set createsql4=CONCAT('
        CREATE TABLE `',in_tablename,'` (
            `Account` varchar(100) NOT NULL,
            `ChannelID` int(11) DEFAULT NULL,
            `CellScore` bigint(20) DEFAULT ''0'' COMMENT ''有效投注'',
            `WinGold` bigint(20) DEFAULT ''0'' COMMENT ''赢钱'',
            `LostGold` bigint(20) DEFAULT ''0'' COMMENT ''输钱'',
            `Revenue` bigint(20) DEFAULT ''0'' COMMENT ''抽水'',
            `WinNum` int(11) DEFAULT ''0'' COMMENT ''赢钱局数(包含和局)'',
            `LostNum` int(11) DEFAULT ''0'' COMMENT ''输钱局数'',
            `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
            `UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
            PRIMARY KEY (`Account`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
        '); 


    if in_type=0 then set createsql=createsql0; end if; 
    if in_type=1 then set createsql=createsql1; end if; 
    if in_type=2 then set createsql=createsql2; end if; 
    if in_type=3 then set createsql=createsql3; end if; 
    if in_type=4 then set createsql=createsql4; end if; 
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
DROP PROCEDURE IF EXISTS `sp_StatisUsersDayData`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisUsersDayData`(IN `in_StatisDate` date)
BEGIN
        
        DECLARE v_month VARCHAR(30); 
        DECLARE v_tblname varchar(100); 
        DECLARE v_starttime TIMESTAMP(3); 
        DECLARE v_endtime TIMESTAMP(3); 
        DECLARE v_sqlbase LONGTEXT; 

        DECLARE v_gameName varchar(20); 

        DECLARE v_GameParameter varchar(100); 
        DECLARE v_GameID INT; 
        
        DECLARE no_more_maps INT DEFAULT 0; 
        
        DECLARE dept_csr CURSOR FOR SELECT GameID,GameParameter_Platform FROM KYDB_NEW.View_Game_NameList; 
        
        DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_maps=1; 

        
        set v_starttime=CURRENT_TIMESTAMP(3); 
        IF in_StatisDate is null THEN
                SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
        END IF; 
        set v_month=DATE_FORMAT(in_StatisDate,'%Y%m'); 

        
        OPEN dept_csr; 
        
        dept_loop:REPEAT
            
            FETCH dept_csr INTO v_GameID,v_GameParameter; 
            IF no_more_maps=0 THEN
                SET v_gameName = v_GameParameter; 
                    CALL KYStatisUsers_EST.sp_StatisUsersGameDayData(in_StatisDate,v_gameName); 
                    SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from KYStatisUsers_EST.statis_',v_gameName,v_month,'_users where StatisDate=''',in_StatisDate,''''); 
            END IF; 
        UNTIL no_more_maps END REPEAT dept_loop; 
        CLOSE dept_csr; 


        
        IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_EST' AND TABLE_NAME = CONCAT('statis_allgames',v_month,'_users')) THEN
            call sp_createStatisticsUsersTable(CONCAT('statis_allgames',v_month,'_users'),0); 
        end if; 
        SET @v_sqlselect = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT('REPLACE into KYStatisUsers_EST.statis_allgames',v_month,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Account,ChannelID,LineCode,sum(CellScore) CellScore,SUM(WinGold) WinGold,sum(LostGold) LostGold,sum(Revenue) Revenue,sum(WinNum) WinNum,sum(LostNum) LostNum  from ( ',v_sqlbase),''),' ) tmptable group by StatisDate,Account,ChannelID,LineCode ORDER BY StatisDate,Account,ChannelID,LineCode'); 
        IF(LENGTH(v_sqlbase)) > 0 then
        PREPARE stmt from @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        end if; 
        
        
        set v_endtime=CURRENT_TIMESTAMP(); 
        
        INSERT INTO KYStatisUsers_EST.event_log_record (sp_name, starttime, endtime, exectime,mark) VALUES ('sp_StatisUsersDayData', v_starttime, v_endtime, TIMESTAMPDIFF(SECOND,v_starttime,v_endtime),in_StatisDate); 

END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = latin1;
SET character_set_results = latin1;
SET collation_connection = latin1_swedish_ci;
DROP PROCEDURE IF EXISTS `sp_StatisUsersDayData_allbet`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisUsersDayData_allbet`(IN `in_StatisDate` date)
BEGIN
        
        DECLARE v_month VARCHAR(30); 
        DECLARE v_tblname varchar(100); 
        DECLARE v_starttime TIMESTAMP(3); 
        DECLARE v_endtime TIMESTAMP(3); 
        DECLARE v_sqlbase LONGTEXT; 
        
        set v_starttime=CURRENT_TIMESTAMP(3); 
        IF in_StatisDate is null THEN
                SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
        END IF; 
        set v_month=DATE_FORMAT(in_StatisDate,'%Y%m'); 
        
            call sp_StatisUsersGameDayData(in_StatisDate,'jssc'); 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from KYStatisUsers_EST.statis_','jssc',v_month,'_users where StatisDate=''',in_StatisDate,''''); 
        
            call sp_StatisUsersGameDayData(in_StatisDate,'xzdd'); 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from KYStatisUsers_EST.statis_','xzdd',v_month,'_users where StatisDate=''',in_StatisDate,''''); 
        
            call sp_StatisUsersGameDayData(in_StatisDate,'erren'); 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from KYStatisUsers_EST.statis_','erren',v_month,'_users where StatisDate=''',in_StatisDate,''''); 
        
            call sp_StatisUsersGameDayData(in_StatisDate,'gdy'); 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from KYStatisUsers_EST.statis_','gdy',v_month,'_users where StatisDate=''',in_StatisDate,''''); 

        
        IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_EST' AND TABLE_NAME = CONCAT('statis_allgames',v_month,'_users')) THEN
            call sp_createStatisticsUsersTable(CONCAT('statis_allgames',v_month,'_users'),0); 
        end if; 
        SET @v_sqlselect = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT('REPLACE into KYStatisUsers_EST.statis_allgames',v_month,'_users (StatisDate,Account,ChannelID,LineCode,AllBet,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Account,ChannelID,LineCode,sum(AllBet) AllBet,sum(CellScore) CellScore,SUM(WinGold) WinGold,sum(LostGold) LostGold,sum(Revenue) Revenue,sum(WinNum) WinNum,sum(LostNum) LostNum  from ( ',v_sqlbase),''),' ) tmptable group by StatisDate,Account,ChannelID,LineCode'); 
        IF(LENGTH(v_sqlbase)) > 0 then
        PREPARE stmt from @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        end if; 
        
        
        set v_endtime=CURRENT_TIMESTAMP(); 
        
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
		DECLARE v_tblname1 varchar(100); 
		DECLARE v_tblname2 varchar(100); 
		DECLARE v_sqlbase LONGTEXT; 
		DECLARE in_StatisDate_end date; 
		IF in_StatisDate is null THEN
				SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
		END IF; 
		set in_StatisDate_end=DATE_ADD(in_StatisDate,INTERVAL 1 day); 
		set v_month=DATE_FORMAT(in_StatisDate,'%Y%m'); 
		SET v_tblname1 = CONCAT('gameRecord',DATE_FORMAT(in_StatisDate,'%Y%m%d')); 
		SET v_tblname2 = CONCAT('gameRecord',DATE_FORMAT(in_StatisDate_end,'%Y%m%d')); 
		IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_EST' AND TABLE_NAME = CONCAT('statis_',in_GameName,v_month,'_users')) THEN
				call sp_createStatisticsUsersTable(CONCAT('statis_',in_GameName,v_month,'_users'),0); 
		end if; 
		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = CONCAT(in_GameName,'_record') AND TABLE_NAME = v_tblname1) THEN
					set v_sqlbase=CONCAT('select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,
					sum(CellScore) CellScore,
					SUM(case when Profit>0 then Profit else 0 end) wingold,
					sum(case when Profit<0 then Profit else 0 end) lostgold,
					sum(Revenue) Revenue,
					COUNT(case when Profit>=0 then Profit end) winNum,
					count(case when Profit<0 then Profit end) lostNum 
					from ',in_GameName,'_record.',v_tblname1,' FORCE index(index_gameendtime)  where GameEndTime>=''',in_StatisDate,' 12:00:00'' and GameEndTime<=''',in_StatisDate,' 23:59:59.998''
					GROUP BY Accounts,ChannelID,LineCode'); 
		end if; 
		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = CONCAT(in_GameName,'_record') AND TABLE_NAME = v_tblname2) THEN
					set v_sqlbase=CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,
					sum(CellScore) CellScore,
					SUM(case when Profit>0 then Profit else 0 end) wingold,
					sum(case when Profit<0 then Profit else 0 end) lostgold,
					sum(Revenue) Revenue,
					COUNT(case when Profit>=0 then Profit end) winNum,
					count(case when Profit<0 then Profit end) lostNum 
					from ',in_GameName,'_record.',v_tblname2,' FORCE index(index_gameendtime)  where GameEndTime>=''',in_StatisDate_end,' 00:00:00'' and GameEndTime<=''',in_StatisDate_end,' 11:59:59.998''
					GROUP BY Accounts,ChannelID,LineCode'); 
		end if; 
		IF(LENGTH(v_sqlbase) > 0) THEN
			set v_sqlbase=CONCAT('REPLACE into KYStatisUsers_EST.statis_',in_GameName,v_month,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate,Accounts,ChannelID,LineCode,sum(CellScore),sum(wingold),sum(lostgold),sum(Revenue),sum(winNum),sum(lostNum) from 
			(',v_sqlbase,') tmp1 GROUP BY Accounts,ChannelID,LineCode'); 
		SET @v_sqlselect =v_sqlbase; 
		PREPARE stmt from @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		end if; 
END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

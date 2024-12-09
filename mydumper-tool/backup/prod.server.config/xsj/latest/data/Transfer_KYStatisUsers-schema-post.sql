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
DROP PROCEDURE IF EXISTS `sp_createStatisticsUsersAllGamesTables`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_createStatisticsUsersAllGamesTables`(IN `in_StatisDate` date)
BEGIN
    DECLARE v_date varchar(30); 
    DECLARE v_month VARCHAR(30); 
    DECLARE v_starttime TIMESTAMP(3); 
    DECLARE v_endtime TIMESTAMP(3); 
    DECLARE v_sqlbase LONGTEXT; 

    DECLARE v_tblname1 varchar(100); 
    DECLARE v_tblname2 varchar(100); 
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
    set v_date = DATE_FORMAT(in_StatisDate,'%Y%m%d'); 
    set v_month=DATE_FORMAT(in_StatisDate,'%Y%m'); 
    SET v_tblname2 = CONCAT('gameRecord',v_date); 

    
    OPEN dept_csr; 
    
    dept_loop:REPEAT
    
    FETCH dept_csr INTO v_GameID,v_GameParameter; 
    IF no_more_maps=0 THEN
        SET v_gameName = v_GameParameter; 
        SET v_tblName1 = concat(v_gameName,'_record'); 

        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = v_tblName1 AND TABLE_NAME = v_tblname2) THEN
            IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_',v_gameName,v_month,'_users')) THEN
                CALL sp_createStatisticsUsersTable(CONCAT('statis_',v_gameName,v_month,'_users'),0); 
            END IF; 
        END IF; 

    END IF; 
    UNTIL no_more_maps END REPEAT dept_loop; 
    CLOSE dept_csr; 


    
    IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_allgames',v_month,'_users')) THEN
        call sp_createStatisticsUsersTable(CONCAT('statis_allgames',v_month,'_users'),0); 
    end if; 
    
    IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_month',v_month,'_users')) THEN
        call sp_createStatisticsUsersTable(CONCAT('statis_month',v_month,'_users'),1); 
    end if; 
    
    
    IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_all_users')) THEN
        call sp_createStatisticsUsersTable(CONCAT('statis_all_users'),1); 
    end if; 
    

    
    set v_endtime=CURRENT_TIMESTAMP(); 
    
    INSERT INTO KYStatisUsers.event_log_record (sp_name, starttime, endtime, exectime,mark) VALUES ('sp_createStatisticsUsersAllGamesTables', v_starttime, v_endtime, TIMESTAMPDIFF(SECOND,v_starttime,v_endtime),''); 

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
DROP PROCEDURE IF EXISTS `sp_createStatisticsUsersTable`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_createStatisticsUsersTable`(IN `in_tablename` varchar(50),IN `in_type` int)
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
DROP PROCEDURE IF EXISTS `sp_dailyPlayerGameData`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dailyPlayerGameData`(IN `today` date,IN `channelID` int,IN `page` int,IN `pageCount` int)
BEGIN
    DECLARE v_sqlbase LONGTEXT; 
    DECLARE whereString VARCHAR(1000); 
    DECLARE v_gameName VARCHAR(20); 
    DECLARE v_tbName VARCHAR(100); 
    DECLARE v_GameID INT; 

    DECLARE no_more_maps INT DEFAULT 0; 

    DECLARE dept_csr CURSOR FOR
    SELECT GameID,GameParameter_Platform
    FROM KYDB_NEW.View_Game_NameList; 

    DECLARE CONTINUE HANDLER FOR NOT FOUND
    SET no_more_maps = 1; 
    SET v_sqlbase = ""; 
    SET whereString = CONCAT(
        " AND StatisDate ='",DATE_FORMAT(today, "%Y-%m-%d"),"'",
        " AND ChannelID ='",channelID,"'"
    ); 

    OPEN dept_csr; 

    dept_loop :REPEAT
    FETCH dept_csr INTO v_GameID,v_gameName; 
    IF no_more_maps = 0 THEN
        SET v_tbName = CONCAT(
            "statis_",
            v_gameName,
            DATE_FORMAT(today, "%Y%m"),
            "_users"
        ); 
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = "KYStatisUsers" AND TABLE_NAME = v_tbName) THEN
            SET v_sqlbase = CONCAT(
                IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),
                    " SELECT *",
                    ",'",v_GameID,"' as gameid",
                    ",'",v_gameName,"' as gamename",
                    " from KYStatisUsers.",v_tbName,
                    " where 1=1 ",
                    whereString
                ); 
            END IF; 
        END IF; 
        UNTIL no_more_maps END REPEAT dept_loop; 
    CLOSE dept_csr; 
    SET @sqlCount = CONCAT(
            "select count(*) as count from ",
            "(",v_sqlbase,") as main "
        ); 
    PREPARE sqlCount from @sqlCount; 
    EXECUTE sqlCount; 
    DEALLOCATE PREPARE sqlCount; 
    SET @sql = CONCAT(
            "select * from ",
            "(",v_sqlbase,") as main ",
            "limit ", (`page` -1) * `pageCount` ,",",`pageCount`
        ); 
    PREPARE stmtResult from @sql; 
    EXECUTE stmtResult; 
    DEALLOCATE PREPARE stmtResult; 
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
DROP PROCEDURE IF EXISTS `sp_StatisGameRoomData_everyDay`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisGameRoomData_everyDay`(
	IN `in_StatisDate` date
)
BEGIN
		
		DECLARE v_tblname varchar(100); 
		DECLARE v_starttime TIMESTAMP(3); 
		DECLARE v_endtime TIMESTAMP(3); 
		
		set v_starttime=CURRENT_TIMESTAMP(3); 
		IF in_StatisDate is null THEN
				SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
		END IF; 
		
			call sp_StatisGameRoomData(in_StatisDate,'dzpk',620); 
		
			call sp_StatisGameRoomData(in_StatisDate,'erba',720); 
		
			call sp_StatisGameRoomData(in_StatisDate,'qznn',830); 
		
			call sp_StatisGameRoomData(in_StatisDate,'gflower',220); 
		
			call sp_StatisGameRoomData(in_StatisDate,'sang',860); 
		
			call sp_StatisGameRoomData(in_StatisDate,'lh',900); 
		
			call sp_StatisGameRoomData(in_StatisDate,'black',600); 
		
			call sp_StatisGameRoomData(in_StatisDate,'tbnn',870); 
		
			call sp_StatisGameRoomData(in_StatisDate,'hongb',880); 
		
			call sp_StatisGameRoomData(in_StatisDate,'ddz',610); 
		
			call sp_StatisGameRoomData(in_StatisDate,'qzpj',730); 
		
			call sp_StatisGameRoomData(in_StatisDate,'jsgflower',230); 
		
			call sp_StatisGameRoomData(in_StatisDate,'sss',630); 
		
			call sp_StatisGameRoomData(in_StatisDate,'luckyfive',380); 
		
			call sp_StatisGameRoomData(in_StatisDate,'slm',390); 
		
			call sp_StatisGameRoomData(in_StatisDate,'bjl',910); 
		
			call sp_StatisGameRoomData(in_StatisDate,'forestparty',920); 
		
			call sp_StatisGameRoomData(in_StatisDate,'mpnn',890); 
		
			call sp_StatisGameRoomData(in_StatisDate,'brnn',930); 
		
			call sp_StatisGameRoomData(in_StatisDate,'hhdz',950); 
		
			call sp_StatisGameRoomData(in_StatisDate,'erren',740); 
		
			call sp_StatisGameRoomData(in_StatisDate,'qztb',550); 
	  
			call sp_StatisGameRoomData(in_StatisDate,'ddznew',680); 
		
			call sp_StatisGameRoomData(in_StatisDate,'wrzjh',1950); 
		
			call sp_StatisGameRoomData(in_StatisDate,'xlch',650); 
		
			call sp_StatisGameRoomData(in_StatisDate,'goldenshark',1940); 
		
			call sp_StatisGameRoomData(in_StatisDate,'xzdd',8120); 
		
			call sp_StatisGameRoomData(in_StatisDate,'xyzp',1350); 
		
			call sp_StatisGameRoomData(in_StatisDate,'tb',3930); 
		
			call sp_StatisGameRoomData(in_StatisDate,'runfast',8130); 
		
			call sp_StatisGameRoomData(in_StatisDate,'ksznn',8150); 
		
			call sp_StatisGameRoomData(in_StatisDate,'jackpotbenz',1960); 
		
			call sp_StatisGameRoomData(in_StatisDate,'brtb',1980); 
		
			call sp_StatisGameRoomData(in_StatisDate,'bsxxl',8180); 
		
			call sp_StatisGameRoomData(in_StatisDate,'db',3100); 
		
			call sp_StatisGameRoomData(in_StatisDate,'lznn',8160); 
		
			call sp_StatisGameRoomData(in_StatisDate,'kyxzdd',1660); 
		
			call sp_StatisGameRoomData(in_StatisDate,'byb',8210); 
		
			call sp_StatisGameRoomData(in_StatisDate,'qzwxs',8200); 
		
			call sp_StatisGameRoomData(in_StatisDate,'wrttz',8190); 
		
			call sp_StatisGameRoomData(in_StatisDate,'bybk',1355); 
		
			call sp_StatisGameRoomData(in_StatisDate,'sznn',3890); 
		
			call sp_StatisGameRoomData(in_StatisDate,'shnn',3001); 
		
			call sp_StatisGameRoomData(in_StatisDate,'fkdzn',3101); 
		
			call sp_StatisGameRoomData(in_StatisDate,'cjnn',3201); 
		
			call sp_StatisGameRoomData(in_StatisDate,'hsznn',3301); 
		
			call sp_StatisGameRoomData(in_StatisDate,'sgj',999); 
		
			call sp_StatisGameRoomData(in_StatisDate,'hbby',510); 
		
			call sp_StatisGameRoomData(in_StatisDate,'zjhnn',3401); 

			call sp_StatisGameRoomData(in_StatisDate,'ft',8310); 

			call sp_StatisGameRoomData(in_StatisDate,'sd',8540); 

            call sp_StatisGameRoomData(in_StatisDate,'yxx',8290); 
			
			call sp_StatisGameRoomData(in_StatisDate,'catte',8600); 

			call sp_StatisGameRoomData(in_StatisDate,'tienlen',8700); 

            call sp_StatisGameRoomData(in_StatisDate,'brsb',8200); 

            call sp_StatisGameRoomData(in_StatisDate,'csd',8910); 

            call sp_StatisGameRoomData(in_StatisDate,'tx',8210); 
		
		SET @v_sqlselect = CONCAT(
			'update KYStatis.statis_room_monitoring a 
			join (
			select roomId,COUNT(DISTINCT account) logcouont from
 			KYDB_NEW.statistics_login_room 
			 where createdate >=''',in_StatisDate,''' 
			 and createdate <= ''',in_StatisDate,' 23:59:59.998'' 
			 and gameid is not null GROUP BY roomId
			) b  
			on a.roomId=b.roomId
			left join (
				select roomId,AVG(`value`) avgOnline,
				MAX(`value`) maxOnline 
				from KYDB_NEW.online_room 
				where createtime>=''',in_StatisDate,''' 
				and createtime<=''',in_StatisDate,' 23:59:59.998''  
				GROUP BY roomId) c 
				on c.roomId=a.roomId
			set a.logCount=ifnull(b.logcouont,0),
			a.dayKillGold=a.killRobotProfit*-1,
			a.dayDiveGold=a.revRobotProfit*-1,
			a.avgOnline=ifnull(c.avgOnline,0),
			a.maxOnline=ifnull(c.maxOnline,0)  
			where  a.createdate=''',in_StatisDate,''''); 
		PREPARE stmt from @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		
		set v_endtime=CURRENT_TIMESTAMP(); 
		
		insert into KYStatis.prolog (`logdate`,`proname`,`time`) values (NOW(),'KYDB_NEW.sp_StatisGameRoomData_everyDay',TIMESTAMPDIFF(SECOND,v_starttime,v_endtime)); 
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
DROP PROCEDURE IF EXISTS `sp_StatisUsersData_EveryDay`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisUsersData_EveryDay`(
    IN `in_StatisDate` date
)
BEGIN
    declare v_sql varchar(4000); 
    SET @timediff = NOW(); 
    if in_StatisDate is null then
        set in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 DAY); 
    end if; 
    set @in_StatisDate_end = CONCAT(in_StatisDate,' 23:59:59.998'); 

    
    truncate table KYStatisUsers.accounts_yesterday; 
    
    replace into KYStatisUsers.accounts_yesterday select account from KYDB_NEW.accounts where createdate >= in_StatisDate and createdate <= @in_StatisDate_end; 
    
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'dzpk',620,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'erba',720,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'qznn',830,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'gflower',220,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'sang',860,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'lh',900,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'black',600,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'tbnn',870,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'hongb',880,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'ddz',610,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'qzpj',730,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'jsgflower',230,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'sss',630,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'luckyfive',380,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'slm',390,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'bjl',910,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'forestparty',920,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'mpnn',890,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'brnn',930,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'hhdz',950,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'erren',740,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'qztb',550,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'ddznew',680,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'wrzjh',1950,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'xlch',650,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'goldenshark',1940,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'xzdd',8120,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'xyzp',1350,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'tb',3930,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'runfast',8130,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'ksznn',8150,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'jackpotbenz',1960,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'brtb',1980,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'bsxxl',8180,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'db',3100,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'sznn',3890,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'shnn',3001,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'fkdzn',3101,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'cjnn',3201,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'hsznn',3301,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'sgj',999,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'hbby',510,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'zjhnn',3401,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'jssc',8330,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'rummyclassic',5011,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'remi',5501,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'dkbiasa',5511,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'dkbet',5512,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'qiuqiu',5513,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'aduqiu',5514,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'TeenPatti',5515,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'ft',8310,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'sd',8540,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'yxx',8290,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'catte',8600,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'tienlen',8700,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'brsb',8200,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'csd',8910,0); 
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,'tx',8210,0); 
    
    call KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate,null,null,1); 
    
    if exists(select * from KYStatisUsers.statis_reg_users where StatisDate = in_StatisDate) then
        set v_sql = CONCAT('update KYStatisUsers.statis_reg_users A inner join(select sum(value)/1440 as avgOnline from KYDB_NEW.online_game_all where createtime >= ''', in_StatisDate,''' and createtime <= ''', in_StatisDate,' 23:59:59.998'')B set A.AvgOnline = B.avgOnline where A.StatisDate = ''', in_StatisDate,''''); 
    ELSE
        set v_sql = CONCAT('insert into KYStatisUsers.statis_reg_users(StatisDate,AvgOnline)select ''', in_StatisDate,''', sum(value)/1440 as avgOnline from KYDB_NEW.online_game_all where createtime >= ''', in_StatisDate,''' and createtime <= ''', in_StatisDate,' 23:59:59.998'''); 
    end if; 
    set @v_sql = v_sql; 
    PREPARE stmt from @v_sql; 
    execute stmt; 
    DEALLOCATE PREPARE stmt; 

    SET @ts = TIMESTAMPDIFF(SECOND,@timediff,NOW()); 
    INSERT INTO KYStatis.prolog (`logdate`,`proname`,`time`) VALUES (NOW(),'KYStatisUsers.sp_StatisUsersData_EveryDay',@ts); 
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
    DECLARE v_date varchar(30); 
    DECLARE v_month VARCHAR(30); 
    DECLARE v_starttime TIMESTAMP(3); 
    DECLARE v_endtime TIMESTAMP(3); 
    DECLARE v_sqlbase LONGTEXT; 

    DECLARE v_tblname1 varchar(100); 
    DECLARE v_tblname2 varchar(100); 
    DECLARE v_gameName varchar(20); 

    DECLARE v_GameParameter varchar(100); 
    DECLARE v_GameID INT; 
    
    DECLARE no_more_maps INT DEFAULT 0; 
    
    DECLARE dept_csr CURSOR FOR SELECT GameID,GameParameter_Platform FROM KYDB_NEW.View_Game_NameList; 
    
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_maps=1; 

    
    SET v_starttime=CURRENT_TIMESTAMP(3); 
    IF in_StatisDate is null THEN
        SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
    END IF; 
    SET v_date = DATE_FORMAT(in_StatisDate,'%Y%m%d'); 
    SET v_month=DATE_FORMAT(in_StatisDate,'%Y%m'); 
    SET v_tblname2 = CONCAT('gameRecord',v_date); 

    
    OPEN dept_csr; 
    
    dept_loop:REPEAT
    
    FETCH dept_csr INTO v_GameID,v_GameParameter; 
    IF no_more_maps=0 THEN
        SET v_gameName = v_GameParameter; 
        SET v_tblName1 = concat(v_gameName,'_record'); 
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = v_tblName1 AND TABLE_NAME = v_tblname2) THEN
            IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_',v_gameName,v_month,'_users')) THEN
                CALL sp_createStatisticsUsersTable(CONCAT('statis_',v_gameName,v_month,'_users'),0); 
            END IF; 

            SET @v_sqlselect = CONCAT('REPLACE into KYStatisUsers.statis_',v_gameName,v_month,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum from ',v_tblName1 ,'.',v_tblname2,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from KYStatisUsers.statis_',v_gameName,v_month,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
    END IF; 
    UNTIL no_more_maps END REPEAT dept_loop; 
    CLOSE dept_csr; 


    
    IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_allgames',v_month,'_users')) THEN
        call sp_createStatisticsUsersTable(CONCAT('statis_allgames',v_month,'_users'),0); 
    end if; 
    SET @v_sqlselect = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT('REPLACE into KYStatisUsers.statis_allgames',v_month,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Account,ChannelID,LineCode,sum(CellScore) CellScore,SUM(WinGold) WinGold,sum(LostGold) LostGold,sum(Revenue) Revenue,sum(WinNum) WinNum,sum(LostNum) LostNum  from ( ',v_sqlbase),''),' ) tmptable group by StatisDate,Account,ChannelID,LineCode ORDER BY StatisDate,Account,ChannelID,LineCode'); 
    IF(LENGTH(v_sqlbase)) > 0 then
        PREPARE stmt from @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
    end if; 
    
    IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_month',v_month,'_users')) THEN
        call sp_createStatisticsUsersTable(CONCAT('statis_month',v_month,'_users'),1); 
    end if; 
    SET @v_sqlselect = CONCAT('update KYStatisUsers.statis_allgames',v_month,'_users a left join KYStatisUsers.statis_month',v_month,'_users b  on a.Account=b.Account and a.LineCode=b.LineCode
        set b.CellScore=b.CellScore+a.CellScore, b.WinGold=b.WinGold+a.WinGold,b.LostGold=b.LostGold+a.LostGold,b.Revenue=b.Revenue+a.Revenue,b.WinNum=b.WinNum+a.WinNum,b.LostNum=b.LostNum+a.LostNum
        where a.StatisDate=''',in_StatisDate,'''
        '); 
    PREPARE stmt from @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt; 
    
    SET @v_sqlselect = CONCAT('insert into KYStatisUsers.statis_month',v_month,'_users (Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum)
        select a.Account,a.ChannelID,a.LineCode,a.CellScore,a.WinGold,a.LostGold,a.Revenue,a.WinNum,a.LostNum
        from KYStatisUsers.statis_allgames',v_month,'_users  a left join KYStatisUsers.statis_month',v_month,'_users b on b.Account=a.Account and b.LineCode=a.LineCode where a.StatisDate=''',in_StatisDate,''' and b.Account is  null; 
        '); 
    PREPARE stmt from @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt; 
    
    IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_all_users')) THEN
        call sp_createStatisticsUsersTable(CONCAT('statis_all_users'),1); 
    end if; 
    SET @v_sqlselect = CONCAT('update KYStatisUsers.statis_allgames',v_month,'_users a left join KYStatisUsers.statis_all_users b  on a.Account=b.Account and a.LineCode=b.LineCode
        set b.CellScore=b.CellScore+a.CellScore, b.WinGold=b.WinGold+a.WinGold,b.LostGold=b.LostGold+a.LostGold,b.Revenue=b.Revenue+a.Revenue,b.WinNum=b.WinNum+a.WinNum,b.LostNum=b.LostNum+a.LostNum
        where a.StatisDate=''',in_StatisDate,'''
        '); 
    PREPARE stmt from @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt; 
    
    SET @v_sqlselect = CONCAT('insert into KYStatisUsers.statis_all_users (Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum)
        select a.Account,a.ChannelID,a.LineCode,a.CellScore,a.WinGold,a.LostGold,a.Revenue,a.WinNum,a.LostNum
        from KYStatisUsers.statis_allgames',v_month,'_users  a left join KYStatisUsers.statis_all_users b on b.Account=a.Account and b.LineCode=a.LineCode where a.StatisDate=''',in_StatisDate,''' and b.Account is  null; 
        '); 
    PREPARE stmt from @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt; 
    
    set v_endtime=CURRENT_TIMESTAMP(); 
    
    INSERT INTO KYStatisUsers.event_log_record (sp_name, starttime, endtime, exectime,mark) VALUES ('sp_StatisUsersDayData', v_starttime, v_endtime, TIMESTAMPDIFF(SECOND,v_starttime,v_endtime),''); 

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
        
        DECLARE v_date varchar(30); 
        DECLARE v_month VARCHAR(30); 
        DECLARE v_tblname varchar(100); 
        DECLARE v_starttime TIMESTAMP(3); 
        DECLARE v_endtime TIMESTAMP(3); 
        DECLARE v_sqlbase LONGTEXT; 
        

        set v_starttime=CURRENT_TIMESTAMP(3); 

        IF in_StatisDate is null THEN
                SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
        END IF; 
        select 3; 
        set v_date = DATE_FORMAT(in_StatisDate,'%Y%m%d'); 
        set v_month=DATE_FORMAT(in_StatisDate,'%Y%m'); 
        SET v_tblname = CONCAT('gameRecord',v_date); 

        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'erren_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_erren',v_month,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('statis_erren',v_month,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into KYStatisUsers.statis_erren',v_month,'_users (StatisDate,Account,ChannelID,LineCode,AllBet,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(AllBet) AllBet,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum
            from erren_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from KYStatisUsers.statis_erren',v_month,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'xzdd_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_xzdd',v_month,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('statis_xzdd',v_month,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into KYStatisUsers.statis_xzdd',v_month,'_users (StatisDate,Account,ChannelID,LineCode,AllBet,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(AllBet) AllBet,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum
            from xzdd_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from KYStatisUsers.statis_xzdd',v_month,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'gdy_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_gdy',v_month,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('statis_gdy',v_month,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into KYStatisUsers.statis_gdy',v_month,'_users (StatisDate,Account,ChannelID,LineCode,AllBet,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(AllBet) AllBet,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum
            from gdy_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from KYStatisUsers.statis_gdy',v_month,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'jssc_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_jssc',v_month,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('statis_jssc',v_month,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into KYStatisUsers.statis_jssc',v_month,'_users (StatisDate,Account,ChannelID,LineCode,AllBet,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(AllBet) AllBet,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum
            from jssc_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from KYStatisUsers.statis_jssc',v_month,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 



        
        IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_allgames',v_month,'_users')) THEN
            call sp_createStatisticsUsersTable(CONCAT('statis_allgames',v_month,'_users'),0); 
        end if; 
        SET @v_sqlselect = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT('REPLACE into KYStatisUsers.statis_allgames',v_month,'_users (StatisDate,Account,ChannelID,LineCode,AllBet,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Account,ChannelID,LineCode,sum(AllBet) AllBet,sum(CellScore) CellScore,SUM(WinGold) WinGold,sum(LostGold) LostGold,sum(Revenue) Revenue,sum(WinNum) WinNum,sum(LostNum) LostNum  from ( ',v_sqlbase),''),' ) tmptable group by StatisDate,Account,ChannelID,LineCode'); 
        IF(LENGTH(v_sqlbase)) > 0 then
        PREPARE stmt from @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        end if; 
        
        IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_month',v_month,'_users')) THEN
            call sp_createStatisticsUsersTable(CONCAT('statis_month',v_month,'_users'),1); 
        end if; 
        SET @v_sqlselect = CONCAT('update KYStatisUsers.statis_allgames',v_month,'_users a left join KYStatisUsers.statis_month',v_month,'_users b  on a.Account=b.Account and a.LineCode=b.LineCode
        set b.AllBet=b.AllBet+a.AllBet,b.CellScore=b.CellScore+a.CellScore, b.WinGold=b.WinGold+a.WinGold,b.LostGold=b.LostGold+a.LostGold,b.Revenue=b.Revenue+a.Revenue,b.WinNum=b.WinNum+a.WinNum,b.LostNum=b.LostNum+a.LostNum
        where a.StatisDate=''',in_StatisDate,'''
        '); 
        PREPARE stmt from @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        
        SET @v_sqlselect = CONCAT('insert into KYStatisUsers.statis_month',v_month,'_users (Account,ChannelID,LineCode,AllBet,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum)
        select a.Account,a.ChannelID,a.LineCode,a.AllBet,a.CellScore,a.WinGold,a.LostGold,a.Revenue,a.WinNum,a.LostNum
        from KYStatisUsers.statis_allgames',v_month,'_users  a left join KYStatisUsers.statis_month',v_month,'_users b on b.Account=a.Account and b.LineCode=a.LineCode where a.StatisDate=''',in_StatisDate,''' and b.Account is  null; 
        '); 
        PREPARE stmt from @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        
        IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_all_users')) THEN
            call sp_createStatisticsUsersTable(CONCAT('statis_all_users'),1); 
        end if; 
        SET @v_sqlselect = CONCAT('update KYStatisUsers.statis_allgames',v_month,'_users a left join KYStatisUsers.statis_all_users b  on a.Account=b.Account and a.LineCode=b.LineCode
        set b.AllBet=b.AllBet+a.AllBet,b.CellScore=b.CellScore+a.CellScore, b.WinGold=b.WinGold+a.WinGold,b.LostGold=b.LostGold+a.LostGold,b.Revenue=b.Revenue+a.Revenue,b.WinNum=b.WinNum+a.WinNum,b.LostNum=b.LostNum+a.LostNum
        where a.StatisDate=''',in_StatisDate,'''
        '); 
        PREPARE stmt from @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        
        SET @v_sqlselect = CONCAT('insert into KYStatisUsers.statis_all_users (Account,ChannelID,LineCode,AllBet,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum)
        select a.Account,a.ChannelID,a.LineCode,a.AllBet,a.CellScore,a.WinGold,a.LostGold,a.Revenue,a.WinNum,a.LostNum
        from KYStatisUsers.statis_allgames',v_month,'_users  a left join KYStatisUsers.statis_all_users b on b.Account=a.Account and b.LineCode=a.LineCode where a.StatisDate=''',in_StatisDate,''' and b.Account is  null; 
        '); 
        PREPARE stmt from @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        
        set v_endtime=CURRENT_TIMESTAMP(); 
        
        INSERT INTO KYStatisUsers.event_log_record (sp_name, starttime, endtime, exectime,mark) VALUES ('sp_StatisUsersDayData', v_starttime, v_endtime, TIMESTAMPDIFF(SECOND,v_starttime,v_endtime),''); 

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
DROP PROCEDURE IF EXISTS `sp_StatisUsersDayData_allusers`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisUsersDayData_allusers`(IN `in_StatisDate` date)
BEGIN
		DECLARE v_date varchar(30); 
		DECLARE v_month VARCHAR(30); 
		DECLARE v_starttime TIMESTAMP(3); 
		DECLARE v_endtime TIMESTAMP(3); 
		
		set v_starttime=CURRENT_TIMESTAMP(3); 
		IF in_StatisDate is null THEN
				SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
		END IF; 
		set v_date = DATE_FORMAT(in_StatisDate,'%Y%m%d'); 
		set v_month=DATE_FORMAT(in_StatisDate,'%Y%m'); 
		
		SET @v_sqlselect = CONCAT('update (select Account,ChannelID,sum(CellScore) CellScore,sum(WinGold) WinGold,sum(LostGold) LostGold,sum(Revenue)Revenue,sum(WinNum)WinNum,sum(LostNum)LostNum
		from KYStatisUsers.statis_allgames',v_month,'_users where StatisDate=''',in_StatisDate,''' GROUP BY Account,ChannelID) a left join KYStatisUsers.statis_all_users_unique b  on a.Account=b.Account 
		set b.CellScore=b.CellScore+a.CellScore, b.WinGold=b.WinGold+a.WinGold,b.LostGold=b.LostGold+a.LostGold,b.Revenue=b.Revenue+a.Revenue,b.WinNum=b.WinNum+a.WinNum,b.LostNum=b.LostNum+a.LostNum
		'); 
		PREPARE stmt from @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		
		SET @v_sqlselect = CONCAT('insert into KYStatisUsers.statis_all_users_unique (Account,ChannelID,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) 
		select a.Account,a.ChannelID,a.CellScore,a.WinGold,a.LostGold,a.Revenue,a.WinNum,a.LostNum
		from (select Account,ChannelID,sum(CellScore) CellScore,sum(WinGold) WinGold,sum(LostGold) LostGold,sum(Revenue)Revenue,sum(WinNum)WinNum,sum(LostNum)LostNum
		from KYStatisUsers.statis_allgames',v_month,'_users where StatisDate=''',in_StatisDate,''' GROUP BY Account,ChannelID)  a left join KYStatisUsers.statis_all_users_unique b on b.Account=a.Account where b.Account is  null; 
		'); 
		PREPARE stmt from @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		
		set v_endtime=CURRENT_TIMESTAMP(); 
		
		INSERT INTO KYStatisUsers.event_log_record (sp_name, starttime, endtime, exectime,mark) VALUES ('sp_StatisUsersDayData_allusers', v_starttime, v_endtime, TIMESTAMPDIFF(SECOND,v_starttime,v_endtime),in_StatisDate); 

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
DROP PROCEDURE IF EXISTS `sp_StatisUsersDayData_EveryDay`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisUsersDayData_EveryDay`(IN `in_StatisDate` date)
BEGIN
        DECLARE v_date varchar(30); 
        DECLARE v_month VARCHAR(30); 
        DECLARE v_tblname varchar(100); 
        DECLARE v_starttime TIMESTAMP(3); 
        DECLARE v_endtime TIMESTAMP(3); 
        DECLARE v_sqlbase LONGTEXT; 
        
        set v_starttime=CURRENT_TIMESTAMP(3); 
        IF in_StatisDate is null THEN
                SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
        END IF; 
        set v_date = DATE_FORMAT(in_StatisDate,'%Y%m%d'); 
        set v_month=DATE_FORMAT(in_StatisDate,'%Y%m'); 
        SET v_tblname = CONCAT('gameRecord',v_date); 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'dzpk_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'dzpk_record' AND TABLE_NAME = CONCAT(v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('dzpk_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into dzpk_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum from dzpk_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            set v_sqlbase= CONCAT('select * from dzpk_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'erba_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'erba_record' AND TABLE_NAME = CONCAT(v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('erba_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into erba_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum from erba_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from erba_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'qznn_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'qznn_record' AND TABLE_NAME = CONCAT(v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('qznn_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into qznn_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum from qznn_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from qznn_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'gflower_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'gflower_record' AND TABLE_NAME = CONCAT(v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('gflower_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into gflower_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum from gflower_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from gflower_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'sang_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'sang_record' AND TABLE_NAME = CONCAT(v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('sang_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into sang_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from sang_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from sang_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'lh_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'lh_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('lh_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into lh_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from lh_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from lh_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'black_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'black_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('black_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into black_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from black_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from black_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'tbnn_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'tbnn_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('tbnn_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into tbnn_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from tbnn_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from tbnn_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'hongb_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'hongb_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('hongb_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into hongb_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from hongb_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from hongb_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'ddz_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'ddz_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('ddz_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into ddz_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from ddz_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from ddz_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'qzpj_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'qzpj_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('qzpj_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into qzpj_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from qzpj_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from qzpj_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'jsgflower_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'jsgflower_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('jsgflower_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into jsgflower_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from jsgflower_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from jsgflower_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'sss_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'sss_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('sss_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into sss_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from sss_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from sss_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'luckyfive_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'luckyfive_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('luckyfive_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into luckyfive_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from luckyfive_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from luckyfive_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'slm_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'slm_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('slm_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into slm_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from slm_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from slm_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'bjl_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'bjl_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('bjl_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into bjl_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from bjl_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from bjl_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'forestparty_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'forestparty_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('forestparty_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into forestparty_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from forestparty_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from forestparty_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 


        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'erren_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'erren_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('erren_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into erren_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from erren_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from erren_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 


        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'xzdd_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'xzdd_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('xzdd_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into xzdd_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from xzdd_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from xzdd_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 

        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'runfast_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'runfast_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('runfast_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into runfast_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from runfast_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from runfast_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 

        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'jssc_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'jssc_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('jssc_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into jssc_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from jssc_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from jssc_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 

        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'ft_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'ft_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('ft_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into ft_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from ft_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from ft_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'sd_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'sd_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('sd_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into sd_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from sd_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from sd_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 

        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'yxx_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'yxx_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('yxx_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into yxx_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from yxx_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from yxx_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 

        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'hhdz_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'hhdz_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('hhdz_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into hhdz_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from hhdz_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from hhdz_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 
        
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'catte_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'catte_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('catte_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into catte_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from catte_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from catte_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 

        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'tienlen_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'tienlen_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('tienlen_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into tienlen_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from tienlen_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from tienlen_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 

        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'brsb_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'brsb_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('brsb_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into brsb_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
            from brsb_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from brsb_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 

        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'csd_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'csd_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('csd_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into csd_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
                from csd_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from csd_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 

        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'tx_record' AND TABLE_NAME = v_tblname) THEN
            IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'tx_record' AND TABLE_NAME = CONCAT('',v_tblname,'_users')) THEN
                call sp_createStatisticsUsersTable(CONCAT('tx_record.',v_tblname,'_users'),0); 
            end if; 
            SET @v_sqlselect = CONCAT('REPLACE into tx_record.',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Accounts,ChannelID,LineCode,sum(CellScore) CellScore,SUM(case when Profit>0 then Profit else 0 end) wingold,sum(case when Profit<0 then Profit else 0 end) lostgold,sum(Revenue) Revenue,COUNT(case when Profit>=0 then Profit end) winNum,count(case when Profit<0 then Profit end) lostNum 
                from tx_record.',v_tblname,' GROUP BY Accounts,ChannelID,LineCode'); 
            PREPARE stmt from @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),'select * from tx_record.',v_tblname,'_users where StatisDate=''',in_StatisDate,''''); 
        END IF; 

        IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('all',v_tblname,'_users')) THEN
            call sp_createStatisticsUsersTable(CONCAT('all',v_tblname,'_users'),0); 
        end if; 
        SET @v_sqlselect = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT('REPLACE into KYStatisUsers.all',v_tblname,'_users (StatisDate,Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) select ''',in_StatisDate,''' as StatisDate, Account,ChannelID,LineCode,sum(CellScore) CellScore,SUM(WinGold) WinGold,sum(LostGold) LostGold,sum(Revenue) Revenue,sum(WinNum) WinNum,sum(LostNum) LostNum  from ( ',v_sqlbase),''),' ) tmptable group by StatisDate,Account,ChannelID,LineCode'); 
        IF(LENGTH(v_sqlbase)) > 0 then
        PREPARE stmt from @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        end if; 
        
        IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_month',v_month,'_users')) THEN
            call sp_createStatisticsUsersTable(CONCAT('statis_month',v_month,'_users'),1); 
        end if; 
        SET @v_sqlselect = CONCAT('update KYStatisUsers.all',v_tblname,'_users a left join KYStatisUsers.statis_month',v_month,'_users b  on a.Account=b.Account 
        set b.CellScore=b.CellScore+a.CellScore, b.WinGold=b.WinGold+a.WinGold,b.LostGold=b.LostGold+a.LostGold,b.Revenue=b.Revenue+a.Revenue,b.WinNum=b.WinNum+a.WinNum,b.LostNum=b.LostNum+a.LostNum
        where a.StatisDate=''',in_StatisDate,'''
        '); 
        PREPARE stmt from @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        
        SET @v_sqlselect = CONCAT('insert into KYStatisUsers.statis_month',v_month,'_users (Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) 
        select a.Account,a.ChannelID,a.LineCode,a.CellScore,a.WinGold,a.LostGold,a.Revenue,a.WinNum,a.LostNum
        from KYStatisUsers.all',v_tblname,'_users  a left join KYStatisUsers.statis_month',v_month,'_users b on b.Account=a.Account where a.StatisDate=''',in_StatisDate,''' and b.Account is  null; 
        '); 
        PREPARE stmt from @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        
        IF not EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_all_users')) THEN
            call sp_createStatisticsUsersTable(CONCAT('statis_all_users'),1); 
        end if; 
        SET @v_sqlselect = CONCAT('update KYStatisUsers.all',v_tblname,'_users a left join KYStatisUsers.statis_all_users b  on a.Account=b.Account 
        set b.CellScore=b.CellScore+a.CellScore, b.WinGold=b.WinGold+a.WinGold,b.LostGold=b.LostGold+a.LostGold,b.Revenue=b.Revenue+a.Revenue,b.WinNum=b.WinNum+a.WinNum,b.LostNum=b.LostNum+a.LostNum
        where a.StatisDate=''',in_StatisDate,'''
        '); 
        PREPARE stmt from @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        
        SET @v_sqlselect = CONCAT('insert into KYStatisUsers.statis_all_users (Account,ChannelID,LineCode,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) 
        select a.Account,a.ChannelID,a.LineCode,a.CellScore,a.WinGold,a.LostGold,a.Revenue,a.WinNum,a.LostNum
        from KYStatisUsers.all',v_tblname,'_users  a left join KYStatisUsers.statis_all_users b on b.Account=a.Account where a.StatisDate=''',in_StatisDate,''' and b.Account is  null; 
        '); 
        PREPARE stmt from @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        
        set v_endtime=CURRENT_TIMESTAMP(); 
        
        INSERT INTO KYStatisUsers.event_log_record (sp_name, starttime, endtime, exectime,mark) VALUES ('sp_StatisUsersDayData_EveryDay', v_starttime, v_endtime, TIMESTAMPDIFF(SECOND,v_starttime,v_endtime),''); 

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
DROP PROCEDURE IF EXISTS `sp_StatisUsersDayData_room`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisUsersDayData_room`(IN `in_StatisDate` date)
BEGIN

    DECLARE v_startTime TIMESTAMP(3); 
    DECLARE v_endTime TIMESTAMP(3); 
    DECLARE v_sqlbase LONGTEXT; 
    DECLARE v_GameParameter VARCHAR(100); 
    DECLARE no_more_maps INT DEFAULT 0; 
    DECLARE dept_csr CURSOR FOR SELECT GameParameter_Platform FROM KYDB_NEW.View_Game_NameList; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_maps = 1; 


    SET v_startTime = CURRENT_TIMESTAMP(3); 
    IF in_StatisDate IS NULL THEN
        SET in_StatisDate = DATE_ADD(CURDATE(), INTERVAL -1 DAY); 
    END IF; 

    OPEN dept_csr; 
    dept_loop:REPEAT
    IF no_more_maps = 0 THEN
        FETCH dept_csr INTO v_GameParameter; 
        CALL sp_StatisUsersGameDayData_room(in_StatisDate, v_GameParameter); 
    END IF; 
    UNTIL no_more_maps END REPEAT dept_loop; 
    CLOSE dept_csr; 


    SET v_endTime = CURRENT_TIMESTAMP(); 

    INSERT INTO KYStatisUsers.event_log_record (sp_name, starttime, endtime, exectime,mark)
    VALUES ('sp_StatisUsersDayData_room', v_startTime, v_endTime, TIMESTAMPDIFF(SECOND, v_startTime, v_endTime), in_StatisDate); 
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
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisUsersGameDayData_room`(`in_StatisDate` date,`in_GameName` varchar(100))
BEGIN
   DECLARE v_month VARCHAR(30); 
   DECLARE v_tblname1 VARCHAR(100); 
   DECLARE v_sqlbase LONGTEXT; 
   IF in_StatisDate IS NULL THEN
      SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
   END IF; 
   SET v_month=DATE_FORMAT(in_StatisDate,'%Y%m'); 
   SET v_tblname1 = CONCAT('gameRecord',DATE_FORMAT(in_StatisDate,'%Y%m%d')); 
   IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_',in_GameName,v_month,'_users_room')) THEN
      CALL sp_createStatisticsUsersTable(CONCAT('statis_',in_GameName,v_month,'_users_room'),2); 
   END IF; 
   IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = CONCAT(in_GameName,'_record') AND TABLE_NAME = v_tblname1) THEN
      SET v_sqlbase=CONCAT('REPLACE INTO KYStatisUsers.statis_',in_GameName,v_month,'_users_room (StatisDate,Account,ChannelID,ServerID,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum)
      SELECT ''',in_StatisDate,''' AS StatisDate, Accounts,ChannelID,ServerID,
      SUM(CellScore) CellScore,
      SUM(CASE WHEN Profit>0 THEN Profit ELSE 0 END) wingold,
      SUM(CASE WHEN Profit<0 THEN Profit ELSE 0 END) lostgold,
      SUM(Revenue) Revenue,
      COUNT(CASE WHEN Profit>=0 THEN Profit END) winNum,
      COUNT(CASE WHEN Profit<0 THEN Profit END) lostNum
      FROM ',in_GameName,'_record.',v_tblname1,'
      GROUP BY Accounts,ChannelID,ServerID'); 
   SET @v_sqlselect =v_sqlbase; 
   PREPARE stmt FROM @v_sqlselect; 
   EXECUTE stmt; 
   DEALLOCATE PREPARE stmt; 
   
   IF NOT EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name=CONCAT('statis_',in_GameName,v_month,'_users_room') AND COLUMN_NAME='isNew') THEN
      SET @v_sqlselect = CONCAT('ALTER TABLE KYStatisUsers.statis_',in_GameName,v_month,'_users_room ADD `isNew` int(11) DEFAULT 0;'); 
      PREPARE stmt FROM @v_sqlselect; 
      EXECUTE stmt; 
      DEALLOCATE PREPARE stmt; 
   END IF; 
   SET @v_sqlselect = CONCAT('
   UPDATE KYStatisUsers.statis_',in_GameName,v_month,'_users_room SET isNew=1
   WHERE StatisDate=''',in_StatisDate,''' AND Account IN (SELECT account FROM KYDB_NEW.accounts WHERE createdate>=''',in_StatisDate,''' AND createdate<=''',in_StatisDate,' 23:59:59'')
   '); 
   PREPARE stmt FROM @v_sqlselect; 
   EXECUTE stmt; 
   DEALLOCATE PREPARE stmt; 
   END IF; 
END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

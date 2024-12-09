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
DROP PROCEDURE IF EXISTS `sp_createKeepLoginTable`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_createKeepLoginTable`(IN `in_tblName` varchar(50),IN `in_type` int)
BEGIN
    DECLARE v_createSql varchar(1000); 
    DECLARE v_createSql0 varchar(1000); 

    SET v_createSql0 = CONCAT('CREATE TABLE ',in_tblName,' (
  `statisdate` date NOT NULL COMMENT ''统计日期'',
  `statis_reg_day` int(11) NOT NULL COMMENT ''第N天留存点'',
  `channelid` int(11) NOT NULL COMMENT ''代理编号'',
  `keep_login_users` int(11) DEFAULT NULL COMMENT ''留存人数'',
  `regdate` date DEFAULT NULL COMMENT ''注册时间(天)'',
  `regusers` int(11) DEFAULT NULL COMMENT ''注册当天的注册人数'',
  PRIMARY KEY (`statisdate`,`statis_reg_day`,`channelid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;'); 

    if in_type=0 then
        set v_createSql=v_createSql0; 
    end if; 
    SET @v_createSql = v_createSql; 
    PREPARE stmt from @v_createSql; 
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
DROP PROCEDURE IF EXISTS `sp_createTable`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_createTable`( IN `in_tblName` VARCHAR ( 50 ), IN `in_type` INT )
BEGIN
	DECLARE
		v_createSql VARCHAR ( 1000 ); 
	DECLARE
		v_createSql0 VARCHAR ( 1000 ); 
	DECLARE
		v_createSql1 VARCHAR ( 1000 ); 
	DECLARE
		v_createSql2 VARCHAR ( 1000 ); 
	DECLARE
		v_createSql3 VARCHAR ( 1000 ); 
	DECLARE
		v_createSql4 VARCHAR ( 1000 ); 
	DECLARE
		v_createSql5 VARCHAR ( 1000 ); 
	DECLARE
		v_createSql6 VARCHAR ( 1000 ); 
	
	SET v_createSql0 = CONCAT( 'CREATE TABLE ', in_tblName, ' (
		`StatisDate` date NOT NULL,
		`ChannelID` int(10) NOT NULL,
		`GameID` int(10) NOT NULL,
		`Accounts` varchar(200) DEFAULT NULL,
		KEY `INDEX_SG` (`StatisDate`,`GameID`) USING BTREE,
		KEY `index_StatisDate_GameID_Accounts` (`StatisDate`,`GameID`,`Accounts`) USING BTREE,
		UNIQUE KEY `index_StatisDate_ChannelID_GameId_Accounts` (`StatisDate`,`ChannelID`,`GameID`,`Accounts`) USING BTREE
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;' ); 
	
	SET v_createSql1 = CONCAT( 'CREATE TABLE ', in_tblName, ' (
		`StatisDate` date NOT NULL,
		`ChannelID` int(10) NOT NULL,
		`GameID` int(10) NOT NULL,
		`LoginCount` int(10) DEFAULT 0,
		KEY `INDEX_SG` (`StatisDate`,`GameID`) USING BTREE,
		UNIQUE KEY `index_StatisDate_ChannelID_GameId_LoginCount` (`StatisDate`,`ChannelID`,`GameID`,`LoginCount`) USING BTREE
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;' ); 
	
	SET v_createSql2 = CONCAT( 'CREATE TABLE ', in_tblName, ' (
		`StatisDate` date NOT NULL,
		`ChannelID` int(10) NOT NULL,
		`Accounts` varchar(200) DEFAULT NULL,
		KEY `index_SA` (`StatisDate`,`Accounts`) USING BTREE,
		UNIQUE KEY `index_StatisDate_ChannelID_Accounts` (`StatisDate`,`ChannelID`,`Accounts`) USING BTREE
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;' ); 
	
	SET v_createSql3 = CONCAT( 'CREATE TABLE ', in_tblName, ' (
		`ChannelID` int(10) NOT NULL,
		`Accounts` varchar(200) DEFAULT NULL,
		UNIQUE KEY `index_ChannelID_Accounts` (`ChannelID`,`Accounts`) USING BTREE
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;' ); 
	
	SET v_createSql4 = CONCAT( 'CREATE TABLE ', in_tblName, ' (
		`ChannelID` int(10) NOT NULL,
		`GameID` int(10) NOT NULL,
		`Accounts` varchar(200) DEFAULT NULL,
		UNIQUE KEY `index_StatisDate_ChannelID_GameId_LoginCount` (`ChannelID`,`GameID`,`Accounts`) USING BTREE
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;' ); 
	
	SET v_createSql5 = CONCAT( 'CREATE TABLE ', in_tblName, ' (
		`StatisDate` date NOT NULL,
		`ChannelID` int(10) NOT NULL,
		`Accounts` varchar(190) DEFAULT NULL,
		`loginNum` int(11) NOT NULL DEFAULT 0,
		`location` varchar(190) DEFAULT NULL,
		UNIQUE KEY `index_StatisDate_ChannelID_Accounts` (`StatisDate`,`ChannelID`,`Accounts`) USING BTREE,
		INDEX `index_statisdate`(`StatisDate`) USING BTREE,
		INDEX `index_Accounts`(`Accounts`) USING BTREE
	) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;' ); 
	
	SET v_createSql6 = CONCAT( 'CREATE TABLE `', in_tblName, '` (
		`StatisDate` date NOT NULL COMMENT ''统计日期'',
		`location` varchar(190) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NULL DEFAULT NULL,
		`GameID` int(11) NOT NULL,
		`BetUsers` int(11) NOT NULL DEFAULT 0 COMMENT ''总投注人数'',
		`GameNum` bigint(20) NOT NULL DEFAULT 0 COMMENT ''总局数'',
		INDEX `index_statisdate`(`StatisDate`) USING BTREE,
		INDEX `index_statisdate_location`(`StatisDate`, `location`) USING BTREE
	) ENGINE = InnoDB CHARACTER SET = utf8mb4;' ); 
	IF
		in_type = 0 THEN
			
			SET v_createSql = v_createSql0; 
		
		ELSEIF in_type = 1 THEN
		
		SET v_createSql = v_createSql1; 
		
		ELSEIF in_type = 2 
		OR in_type = 4 THEN
			
			SET v_createSql = v_createSql2; 
			
			ELSEIF in_type = 3 
			OR in_type = 6 THEN
				
				SET v_createSql = v_createSql3; 
				
				ELSEIF in_type = 5 THEN
				
				SET v_createSql = v_createSql4; 
				
				ELSEIF in_type = 7 THEN
				
				SET v_createSql = v_createSql5; 
				
				ELSEIF in_type = 8 THEN
				
				SET v_createSql = v_createSql6; 
				
			END IF; 
			
			SET @v_createSql = v_createSql; 
			PREPARE stmt 
			FROM
				@v_createSql; 
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
DROP PROCEDURE IF EXISTS `sp_query_keeplogin_data`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_query_keeplogin_data`(IN `in_statisdate` date,IN `in_channelids` varchar(1000))
BEGIN

DECLARE v_sqlbase LONGTEXT; 

set @tablename1=CONCAT('statis_keep_login_users_',DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +1 day),'%Y%m')); 
set @statisdate1=DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +1 day),'%Y-%m-%d'); 
IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME =@tablename1) THEN
set v_sqlbase= CONCAT('select statisdate,statis_reg_day,sum(keep_login_users) keep_login_users,sum(regusers) regusers from 
KYStatisLogin.',@tablename1,' where statisdate=''',@statisdate1,''' and statis_reg_day=1 ',
IF(in_channelids<>'0',CONCAT(' and channelid in(',in_channelids,') '),' ')
); 
END IF; 

set @tablename2=CONCAT('statis_keep_login_users_',DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +2 day),'%Y%m')); 
set @statisdate2=DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +2 day),'%Y-%m-%d'); 
IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME =@tablename2) THEN
set v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),
'select statisdate,statis_reg_day,sum(keep_login_users) keep_login_users,sum(regusers) regusers from 
KYStatisLogin.',@tablename2,' where statisdate=''',@statisdate2,''' and statis_reg_day=2 ',
IF(in_channelids<>'0',CONCAT(' and channelid in(',in_channelids,') '),' ')
); 
END IF; 

set @tablename3=CONCAT('statis_keep_login_users_',DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +3 day),'%Y%m')); 
set @statisdate3=DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +3 day),'%Y-%m-%d'); 
IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME =@tablename3) THEN
set v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),
'select statisdate,statis_reg_day,sum(keep_login_users) keep_login_users,sum(regusers) regusers from 
KYStatisLogin.',@tablename3,' where statisdate=''',@statisdate3,''' and statis_reg_day=3 ',
IF(in_channelids<>'0',CONCAT(' and channelid in(',in_channelids,') '),' ')
); 
END IF; 

set @tablename4=CONCAT('statis_keep_login_users_',DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +4 day),'%Y%m')); 
set @statisdate4=DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +4 day),'%Y-%m-%d'); 
IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME =@tablename4) THEN
set v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),
'select statisdate,statis_reg_day,sum(keep_login_users) keep_login_users,sum(regusers) regusers from 
KYStatisLogin.',@tablename4,' where statisdate=''',@statisdate4,''' and statis_reg_day=4 ',
IF(in_channelids<>'0',CONCAT(' and channelid in(',in_channelids,') '),' ')
); 
END IF; 

set @tablename5=CONCAT('statis_keep_login_users_',DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +5 day),'%Y%m')); 
set @statisdate5=DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +5 day),'%Y-%m-%d'); 
IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME =@tablename5) THEN
set v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),
'select statisdate,statis_reg_day,sum(keep_login_users) keep_login_users,sum(regusers) regusers from 
KYStatisLogin.',@tablename5,' where statisdate=''',@statisdate5,''' and statis_reg_day=5 ',
IF(in_channelids<>'0',CONCAT(' and channelid in(',in_channelids,') '),' ')
); 
END IF; 

set @tablename6=CONCAT('statis_keep_login_users_',DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +6 day),'%Y%m')); 
set @statisdate6=DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +6 day),'%Y-%m-%d'); 
IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME =@tablename6) THEN
set v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),
'select statisdate,statis_reg_day,sum(keep_login_users) keep_login_users,sum(regusers) regusers from 
KYStatisLogin.',@tablename6,' where statisdate=''',@statisdate6,''' and statis_reg_day=6 ',
IF(in_channelids<>'0',CONCAT(' and channelid in(',in_channelids,') '),' ')
); 
END IF; 

set @tablename7=CONCAT('statis_keep_login_users_',DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +7 day),'%Y%m')); 
set @statisdate7=DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +7 day),'%Y-%m-%d'); 
IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME =@tablename7) THEN
set v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),
'select statisdate,statis_reg_day,sum(keep_login_users) keep_login_users,sum(regusers) regusers from 
KYStatisLogin.',@tablename7,' where statisdate=''',@statisdate7,''' and statis_reg_day=7 ',
IF(in_channelids<>'0',CONCAT(' and channelid in(',in_channelids,') '),' ')
); 
END IF; 

set @tablename15=CONCAT('statis_keep_login_users_',DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +15 day),'%Y%m')); 
set @statisdate15=DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +15 day),'%Y-%m-%d'); 
IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME =@tablename15) THEN
set v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),
'select statisdate,statis_reg_day,sum(keep_login_users) keep_login_users,sum(regusers) regusers from 
KYStatisLogin.',@tablename15,' where statisdate=''',@statisdate15,''' and statis_reg_day=15 ',
IF(in_channelids<>'0',CONCAT(' and channelid in(',in_channelids,') '),' ')
); 
END IF; 

set @tablename30=CONCAT('statis_keep_login_users_',DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +30 day),'%Y%m')); 
set @statisdate30=DATE_FORMAT(DATE_ADD(in_statisdate,INTERVAL +30 day),'%Y-%m-%d'); 
IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME =@tablename30) THEN
set v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),
'select statisdate,statis_reg_day,sum(keep_login_users) keep_login_users,sum(regusers) regusers from 
KYStatisLogin.',@tablename30,' where statisdate=''',@statisdate30,''' and statis_reg_day=30 ',
IF(in_channelids<>'0',CONCAT(' and channelid in(',in_channelids,') '),' ')
); 
END IF; 

IF(LENGTH(v_sqlbase) > 0) THEN
set v_sqlbase=CONCAT('
select 
''',in_statisdate,''' statisdate,
ifnull(max(regusers),0) regusers,
max(case WHEN statis_reg_day=1 then keep_login_users else 0 end) ''1ds'',
max(case WHEN statis_reg_day=2 then keep_login_users else 0  end)''2ds'',
max(case WHEN statis_reg_day=3 then keep_login_users else 0  end)''3ds'',
max(case WHEN statis_reg_day=4 then keep_login_users else 0  end)''4ds'',
max(case WHEN statis_reg_day=5 then keep_login_users else 0  end)''5ds'',
max(case WHEN statis_reg_day=6 then keep_login_users else 0  end)''6ds'',
max(case WHEN statis_reg_day=7 then keep_login_users else 0  end)''7ds'',
max(case WHEN statis_reg_day=15 then keep_login_users else 0  end)''15ds'',
max(case WHEN statis_reg_day=30 then keep_login_users else 0  end)''30ds''
FROM
(',v_sqlbase,') tmp1'); 

SET @v_sqlselect =v_sqlbase; 
PREPARE stmt from @v_sqlselect; 
EXECUTE stmt; 
DEALLOCATE PREPARE stmt; 
end if; 
 
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
DROP PROCEDURE IF EXISTS `sp_statisKeepGameUsers`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisKeepGameUsers`(
	IN `in_statisdate` date,
	IN `in_gameid` int,
	IN `in_gamename` varchar(50)
)
BEGIN
    DECLARE v_orderTblName VARCHAR(100);
    DECLARE v_date VARCHAR(6);
    DECLARE v_date1 VARCHAR(6);
    DECLARE v_date7 VARCHAR(6);
    DECLARE v_sql LONGTEXT;
    -- SET @timediff = NOW();

    IF in_statisdate IS NULL THEN
        SET in_statisdate = DATE_ADD(CURDATE(), INTERVAL -8 DAY);
    END IF;
    SET v_date = DATE_FORMAT(in_statisdate, '%Y%m');
    SET v_date1 = DATE_FORMAT(DATE_ADD(in_statisdate, INTERVAL 1 DAY), '%Y%m');
    SET v_date7 = DATE_FORMAT(DATE_ADD(in_statisdate, INTERVAL 7 DAY), '%Y%m');
    IF (v_date1 > v_date) THEN
        SET v_date1 = v_date;
    END IF;
    IF (v_date7 > v_date) THEN
        SET v_date7 = v_date;
    END IF;
    IF EXISTS(SELECT *
              FROM information_schema.TABLES
              WHERE TABLE_SCHEMA = 'KYStatisUsers'
                AND TABLE_NAME = CONCAT('statis_', in_gamename, v_date, '_users')) THEN
        SET v_sql = CONCAT('REPLACE INTO KYStatisLogin.statis_keep_game_users (StatisDate, GameID, RegUsers, CR, QR, HYCR, HYQR, currency, exchangeRate)
		SELECT ''', in_statisdate, ''',', in_gameid, ',COUNT(DISTINCT a.account) 平台注册人数,
		COUNT(DISTINCT cr.accounts) 次日,COUNT(DISTINCT qr.accounts) 七日,COUNT(DISTINCT hcr.accounts) 活跃次日,COUNT(DISTINCT hqr.accounts) 活跃七日, "CNY", 1.00000
		FROM (SELECT account FROM KYDB_NEW.accounts WHERE createdate>=''', in_statisdate, ''' AND createdate<=''',
                           in_statisdate, ' 23:59:59'') a 
		LEFT JOIN (SELECT account FROM KYStatisUsers.statis_', in_gamename,
                           '', v_date, '_users WHERE StatisDate=''', in_statisdate, ''') c  ON a.account=c.account
		LEFT JOIN (SELECT accounts FROM KYStatisLogin.statis_login_game_detail_', v_date, ' WHERE StatisDate=''',
                           in_statisdate, ''' AND GameID=', in_gameid, ') b ON a.account=b.accounts
		LEFT JOIN (SELECT accounts FROM KYStatisLogin.statis_login_game_detail_', v_date1, ' WHERE StatisDate=''',
                           DATE_ADD(in_statisdate, INTERVAL 1 DAY), ''' AND GameID=', in_gameid, ') cr ON b.accounts=cr.accounts
		LEFT JOIN (SELECT accounts FROM KYStatisLogin.statis_login_game_detail_', v_date7, ' WHERE StatisDate=''',
                           DATE_ADD(in_statisdate, INTERVAL 7 DAY), ''' AND GameID=', in_gameid, ') qr ON b.accounts=qr.accounts
		LEFT JOIN (SELECT accounts FROM KYStatisLogin.statis_login_game_detail_', v_date1, ' WHERE StatisDate=''',
                           DATE_ADD(in_statisdate, INTERVAL 1 DAY), ''' AND GameID=', in_gameid, ') hcr ON c.account=hcr.accounts
		LEFT JOIN (SELECT accounts FROM KYStatisLogin.statis_login_game_detail_', v_date7, ' WHERE StatisDate=''',
                           DATE_ADD(in_statisdate, INTERVAL 7 DAY), ''' AND GameID=', in_gameid, ') hqr ON c.account=hqr.accounts
		');
        SET @v_sql = v_sql;
        PREPARE stmt FROM @v_sql;
        EXECUTE stmt;
        DEALLOCATE PREPARE stmt;
        
        SET v_sql = CONCAT('UPDATE KYStatisLogin.statis_keep_game_users keep
				INNER JOIN (SELECT IFNULL(StatisDate, ''', in_statisdate, ''' ) AS StatisDate, IFNULL(COUNT(DISTINCT account), 0) AS PlayGameUsers,
				IFNULL(SUM(CellScore * exchangeRate), 0) as CellScore,
				IFNULL(SUM((WinGold+LostGold) * exchangeRate), 0) as Profit,
				IFNULL(SUM(Revenue * exchangeRate), 0) as Revenue FROM KYStatisUsers.statis_',in_gamename,'', v_date, '_users WHERE StatisDate=''', in_statisdate, ''') game ON keep.StatisDate = game.StatisDate
				INNER JOIN (SELECT IFNULL(COUNT(DISTINCT accounts), 0) as GameLoginUsers FROM KYStatisLogin.statis_login_game_detail_', v_date, ' WHERE StatisDate=''',
                           in_statisdate, ''' AND GameID=', in_gameid, ') login
				SET keep.PlayGameUsers=game.PlayGameUsers, keep.CellScore=game.CellScore, keep.Profit=game.Profit, keep.Revenue=game.Revenue, keep.GameLoginUsers=login.GameLoginUsers
            WHERE keep.StatisDate =''', in_statisdate, ''' and keep.GameID=', in_gameid);
        SET @v_sql = v_sql;
        PREPARE stmt FROM @v_sql;
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
DROP PROCEDURE IF EXISTS `sp_statisKeepGameUsers_EveryDay`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisKeepGameUsers_EveryDay`(IN `in_statisdate` date)
BEGIN
	DECLARE done INT DEFAULT FALSE; 
	DECLARE cur_Gameid, cur_GameParameter LONGTEXT; 
	DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

	SET @timediff = NOW(); 

	IF in_statisdate IS NULL THEN
		SET in_statisdate = DATE_ADD(CURDATE(),INTERVAL -8 DAY); 
	END IF; 

	OPEN cur1; 
		read_loop: LOOP
			FETCH cur1 INTO cur_Gameid, cur_GameParameter; 
		
			IF done THEN
				LEAVE read_loop; 
			END IF; 
		
			IF cur_Gameid = 620 THEN
				SET cur_GameParameter = 'dzpk'; 
			END IF; 

			CALL KYStatisLogin.sp_statisKeepGameUsers(in_statisdate, cur_Gameid, cur_GameParameter); 
		END LOOP; 
	CLOSE cur1;	
    
	SET @ts = TIMESTAMPDIFF(SECOND,@timediff,NOW()); 

	INSERT INTO KYStatis.prolog VALUES(NOW(),'KYStatisLogin.sp_statisKeepGameUsers_EveryDay',@ts); 
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
DROP PROCEDURE IF EXISTS `sp_statisKeepLoginUsers`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisKeepLoginUsers`(IN `in_statisdate` date)
BEGIN
	DECLARE v_tblName varchar(100);
	DECLARE v_orderTblName varchar(100);
	DECLARE v_date varchar(6);
	DECLARE v_sql LONGTEXT;
	SET @timediff = NOW();
   
	if in_statisdate is null THEN
		set in_statisdate = DATE_ADD(CURDATE(),INTERVAL -1 day);
	end if;
	set v_date = DATE_FORMAT(in_statisdate,'%Y%m');
	set v_tblName = CONCAT('statis_keep_login_users_', v_date);
	if not exists(select * from information_schema.`TABLES` where TABLE_SCHEMA = 'KYStatisLogin' and TABLE_NAME = v_tblName) THEN
		call sp_createKeepLoginTable(v_tblName,0);
	end if;
	set v_sql=CONCAT('replace into KYStatisLogin.',v_tblName,' (statisdate, statis_reg_day, channelid, keep_login_users, regdate,regusers) ',' select tmp1.*,tmp2.Y_RegUsers from 
	(
	select a.StatisDate,DATEDIFF(a.StatisDate,b.createdate) statis_reg_day ,a.ChannelID,count(1) usercount,DATE_FORMAT(createdate,''%Y-%m-%d'') regdate
	from KYStatisLogin.statis_login_hall_detail_',v_date,' a
	join KYDB_NEW.accounts b on a.Accounts=b.account 
	where a.StatisDate=''',in_statisdate,'''
	group by DATE_FORMAT(b.createdate,''%Y-%m-%d''),a.ChannelID
	) tmp1 left join KYStatis.statisusers tmp2 on tmp1.regdate=tmp2.StatisDate and tmp1.ChannelID=tmp2.ChannelId');
	set @v_sql = v_sql;
	prepare stmt from @v_sql;
	execute stmt;
	deallocate prepare stmt;

	SET @ts = TIMESTAMPDIFF(SECOND,@timediff,NOW());
	INSERT INTO KYStatis.prolog VALUES(NOW(),'KYStatisLogin.sp_statisKeepLoginUsers',@ts);
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
DROP PROCEDURE IF EXISTS `sp_statisKeepLoginUsersValid`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisKeepLoginUsersValid`(
	IN `in_statisdate` date
)
BEGIN
	DECLARE v_tblName varchar(100); 
	DECLARE v_orderTblName varchar(100); 
	DECLARE v_date varchar(6); 
	DECLARE v_sql LONGTEXT; 
	SET @timediff = NOW(); 
  
	if in_statisdate is null THEN
		set in_statisdate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
	end if; 
	set v_date = DATE_FORMAT(in_statisdate,'%Y%m'); 
	set v_tblName = CONCAT('statis_keep_login_validusers_', v_date); 
	if not exists(select * from information_schema.`TABLES` where TABLE_SCHEMA = 'KYStatisLogin' and TABLE_NAME = v_tblName) THEN
		call sp_createKeepLoginTable(v_tblName,0); 
	end if; 
	set v_sql=CONCAT('replace into KYStatisLogin.',v_tblName,' (statisdate, statis_reg_day, channelid, keep_login_users, regdate,regusers) ',' 
	select tmp1.StatisDate,tmp1.statis_reg_day,tmp1.ChannelID,tmp1.usercount,tmp1.regdate,tmp2.ValidNextRegisterUser from 
	(
	select a.StatisDate,DATEDIFF(a.StatisDate,b.createdate) statis_reg_day ,a.ChannelID,count(1) usercount,DATE_FORMAT(createdate,''%Y-%m-%d'') regdate,DATE_FORMAT(DATE_ADD(createdate,INTERVAL +1 day),''%Y-%m-%d'') regdate1
	from KYStatisLogin.statis_login_hall_detail_',v_date,' a
	join KYStatisLogin.validaccounts b on a.Accounts=b.account 
	where a.StatisDate=''',in_statisdate,'''
	group by DATE_FORMAT(b.createdate,''%Y-%m-%d''),a.ChannelID
	) tmp1 left join KYStatis.statisusers tmp2 on tmp1.regdate1=tmp2.StatisDate and tmp1.ChannelID=tmp2.ChannelId'); 
	set @v_sql = v_sql; 
	prepare stmt from @v_sql; 
	execute stmt; 
	deallocate prepare stmt; 

	SET @ts = TIMESTAMPDIFF(SECOND,@timediff,NOW()); 
	INSERT INTO KYStatis.prolog VALUES(NOW(),'KYStatisLogin.sp_statisKeepLoginUsers',@ts); 
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
DROP PROCEDURE IF EXISTS `sp_StatisLocationGameDayData`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisLocationGameDayData`(IN `in_StatisDate` date)
BEGIN
    DECLARE v_month VARCHAR(30); 
    DECLARE v_tblname varchar(100); 
    DECLARE v_starttime TIMESTAMP(3); 
    DECLARE v_endtime TIMESTAMP(3); 
    DECLARE v_Gameid, v_GameParameter VARCHAR(100); 
    DECLARE v_schemaName VARCHAR(100); 
    DECLARE v_tblStatisName VARCHAR(100); 
    DECLARE v_sqlbase LONGTEXT; 
    DECLARE v_sqlselect LONGTEXT; 
    DECLARE no_more_maps INT DEFAULT 0; 
    DECLARE dept_csr CURSOR FOR SELECT GameID, GameParameter FROM KYDB_NEW.GameInfo; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_maps = 1; 

    #记录开始时间
    SET v_starttime=CURRENT_TIMESTAMP(3); 
    IF in_StatisDate is null THEN
        SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
    END IF; 
    SET v_month = DATE_FORMAT(in_StatisDate, '%Y%m'); 
    SET v_sqlselect = CONCAT(' SELECT ''',in_StatisDate,''' AS StatisDate, b.Location, a.GameID AS GameID, COUNT(a.Account) AS BetUsers, SUM(a.WinNum+a.LostNum) AS GameNum from (');	
    SET v_schemaName = 'KYStatisUsers'; 
    SET v_tblname = CONCAT('statis_location_game_',v_month); 

    OPEN dept_csr; 
    dept_loop:REPEAT
        FETCH dept_csr INTO v_Gameid, v_GameParameter; 
            IF v_Gameid = 620 THEN
				SET v_GameParameter = 'dzpk'; 
            END IF; 
        IF no_more_maps = 0 THEN
        	SET v_tblStatisName = CONCAT('statis_', v_GameParameter, v_month, '_users'); 
        	IF EXISTS (SELECT * from information_schema.TABLES WHERE TABLE_SCHEMA = v_schemaName AND TABLE_NAME = v_tblStatisName) THEN
                SET v_sqlbase= CONCAT(
                    IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' union all '),''),
                    'SELECT *, ',v_Gameid,' AS GameID FROM KYStatisUsers.', v_tblStatisName, ' WHERE StatisDate = ''',in_StatisDate,''''
                ); 
        	END IF; 
        END IF; 
    UNTIL no_more_maps END REPEAT dept_loop; 
    CLOSE dept_csr; 
    SET @v_sqlselect = CONCAT('REPLACE INTO KYStatisLogin.', v_tblname, '(StatisDate, Location, GameID, BetUsers, GameNum)', v_sqlselect, v_sqlbase,' ) a INNER JOIN KYStatisLogin.statis_login_hall_detail_', v_month,' b ON b.StatisDate=a.StatisDate and b.Accounts=a.Account GROUP BY b.Location, a.GameID '); 

    IF NOT EXISTS (SELECT * from information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME = v_tblname) THEN
        CALL sp_createTable(v_tblname, 8); 
    END IF; 
    PREPARE stmt from @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt; 

    #记录结束时间
    SET v_endtime=CURRENT_TIMESTAMP(); 
    #添加执行日志
    INSERT INTO KYStatis.prolog values(NOW(),'KYStatisLogin.sp_StatisLocationGameDayData',TIMESTAMPDIFF(SECOND,v_startTime,v_endTime)); 

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
DROP PROCEDURE IF EXISTS `sp_statisLoginData`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisLoginData`(IN `in_statisdate` date)
BEGIN
	DECLARE v_tblName VARCHAR(100); 
	DECLARE v_orderTblName VARCHAR(100); 
	DECLARE v_date VARCHAR(6); 
	DECLARE v_sql LONGTEXT; 
	SET @timediff = NOW(); 

	IF in_statisdate IS NULL THEN
		SET in_statisdate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
	END IF; 
	
	SET v_date = DATE_FORMAT(in_statisdate,'%Y%m'); 

	SET v_tblName = CONCAT('statis_login_hall_detail_', v_date); 
	IF NOT EXISTS(SELECT * FROM information_schema.`TABLES` WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME = v_tblName) THEN
		CALL sp_createTable(v_tblName,7); 
	END IF; 
	SET v_sql = CONCAT('REPLACE INTO ',v_tblName,'(StatisDate, ChannelID, Accounts, LoginNum, Location)
						SELECT ''', in_statisdate,''' AS StatisDate, agent, MAX(DISTINCT account) AS account, COUNT(account) AS LoginNum, MAX(CASE WHEN (ipLocal REGEXP ''^中国..'' = 1) THEN substring(ipLocal, 1, 4) 
							WHEN (ipLocal REGEXP ''^美国|^英国|^荷兰|^日本|^法国|^越南'' = 1) 
							THEN substring(ipLocal, 1, 2) WHEN (ipLocal REGEXP ''^新加坡|^柬埔寨'' = 1) 
							THEN substring(ipLocal, 1, 3) ELSE ''其他'' END) AS Location 
						FROM KYDB_NEW.statistics_login_hall 
						WHERE createdate >= ''', in_statisdate,''' AND createdate <= ''', in_statisdate,' 23:59:59.998'' 
						GROUP BY account'); 
	SET @v_sql = v_sql; 
	prepare stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE prepare stmt; 

	SET v_tblName = CONCAT('statis_login_hall_month_', v_date); 
	IF NOT EXISTS(SELECT * FROM information_schema.`TABLES` WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME = v_tblName) THEN
		CALL sp_createTable(v_tblName,3); 
	END IF; 
	SET v_sql = CONCAT('REPLACE INTO ',v_tblName,'(ChannelID,Accounts)
						SELECT ChannelID,Accounts 
						FROM KYStatisLogin.statis_login_hall_detail_', v_date,' 
						WHERE StatisDate = ''', in_statisdate,''''); 
	SET @v_sql = v_sql; 
	prepare stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE prepare stmt; 

	SET v_sql = CONCAT('REPLACE INTO statis_login_hall_history(ChannelID,Accounts)
						SELECT DISTINCT ChannelID,Accounts 
						FROM KYStatisLogin.statis_login_hall_detail_', v_date,'
						WHERE StatisDate = ''', in_statisdate,''''); 
	SET @v_sql = v_sql; 
	prepare stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE prepare stmt; 

	
	SET v_tblName = CONCAT('statis_login_game_detail_', v_date); 
	IF NOT EXISTS(SELECT * FROM information_schema.`TABLES` WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME = v_tblName) THEN
		CALL sp_createTable(v_tblName,0); 
	END IF; 
	SET v_sql = CONCAT('REPLACE INTO ',v_tblName,'(StatisDate,ChannelID,GameID,Accounts) 
						SELECT DISTINCT ''', in_statisdate,''' AS StatisDate,agent,gameId,account 
						FROM KYDB_NEW.statistics_login_game 
						WHERE createdate >= ''', in_statisdate,''' AND createdate <= ''', in_statisdate,' 23:59:59.998'' AND gameid IS not NULL'); 
	SET @v_sql = v_sql; 
	prepare stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE prepare stmt; 
	
	SET v_tblName = CONCAT('statis_login_game_month_', v_date); 
	IF NOT EXISTS(SELECT * FROM information_schema.`TABLES` WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME = v_tblName) THEN
		CALL sp_createTable(v_tblName,5); 
	END IF; 
	SET v_sql = CONCAT('REPLACE INTO ',v_tblName,'(ChannelID,GameID,Accounts) 
						SELECT ChannelID,GameID,Accounts 
						FROM KYStatisLogin.statis_login_game_detail_', v_date,' 
						WHERE StatisDate = ''', in_statisdate,''''); 
	SET @v_sql = v_sql; 
	prepare stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE prepare stmt; 

	
	SET v_tblName = CONCAT('statis_login_game_sum_', v_date); 
	IF NOT EXISTS(SELECT * FROM information_schema.`TABLES` WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME = v_tblName) THEN
		CALL sp_createTable(v_tblName,1); 
	END IF; 
	SET v_sql = CONCAT('REPLACE INTO ',v_tblName,'(StatisDate,ChannelID,GameID,LoginCount)
						SELECT StatisDate,ChannelID,GameID,count(Accounts) 
						FROM KYStatisLogin.statis_login_game_detail_', v_date,' 
						WHERE StatisDate = ''', in_statisdate,''' 
						GROUP BY StatisDate,ChannelID,GameID'); 
	SET @v_sql = v_sql; 
	prepare stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE prepare stmt; 


	
	SET v_tblName = CONCAT('statis_agent_orders_detail_', v_date); 
	IF NOT EXISTS(SELECT * FROM information_schema.`TABLES` WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME = v_tblName) THEN
		CALL sp_createTable(v_tblName,4); 
	END IF; 
	SET v_orderTblName = 'agent_orders'; 
	IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'orders_record' AND TABLE_NAME = v_orderTblName) THEN
		SET v_sql = CONCAT('REPLACE INTO ',v_tblName,'(StatisDate,ChannelID,Accounts)
						SELECT DISTINCT ''', in_statisdate,''' AS StatisDate,ChannelID,CreateUser 
						FROM orders_record.', v_orderTblName,' 
						WHERE OrderTime >= ''', in_statisdate,''' AND OrderTime <= ''', in_statisdate,' 23:59:59.998'' AND OrderType =2 AND OrderStatus = 0'); 
		SET @v_sql = v_sql; 
		prepare stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE prepare stmt; 
	END IF; 

	SET v_tblName = CONCAT('statis_agent_orders_month_', v_date); 
	IF NOT EXISTS(SELECT * FROM information_schema.`TABLES` WHERE TABLE_SCHEMA = 'KYStatisLogin' AND TABLE_NAME = v_tblName) THEN
		CALL sp_createTable(v_tblName,6); 
	END IF; 
	SET v_sql = CONCAT('REPLACE INTO ',v_tblName,'(ChannelID,Accounts)
						SELECT ChannelID,Accounts 
						FROM KYStatisLogin.statis_agent_orders_detail_', v_date,' 
						WHERE StatisDate = ''', in_statisdate,''''); 
	SET @v_sql = v_sql; 
	prepare stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE prepare stmt; 

	
	SET v_sql = CONCAT('REPLACE INTO statis_agent_orders_history(ChannelID,Accounts)
						SELECT DISTINCT ChannelID,Accounts 
						FROM KYStatisLogin.statis_agent_orders_detail_', v_date,' 
						WHERE StatisDate = ''', in_statisdate,''''); 
	SET @v_sql = v_sql; 
	prepare stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE prepare stmt; 

	SET @ts = TIMESTAMPDIFF(SECOND,@timediff,NOW()); 
	INSERT INTO KYStatis.prolog VALUES(NOW(),'KYStatisLogin.sp_statisLoginData',@ts); 
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
DROP PROCEDURE IF EXISTS `sp_statis_users_iplocal`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statis_users_iplocal`(IN `in_StatisDate` date)
BEGIN
	DECLARE v_date varchar(6);
	set @s_time = now();

	if in_StatisDate is null THEN
		set in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 DAY);
	end if;
	set v_date = DATE_FORMAT(in_StatisDate,'%Y%m');
	
	truncate table statis_users_iplocal_tmp;
	
	set @v_sql=CONCAT('
	INSERT INTO statis_users_iplocal_tmp(ipLocal,userCount) 
	select b.ipLocal,COUNT(DISTINCT b.account) from
	(
	select Account from KYStatisUsers.statis_allgames',v_date,'_users where StatisDate=''',in_StatisDate,''' and Account in(
	select account from KYDB_NEW.accounts where createdate>=''',in_StatisDate,''' and createdate<=''',in_StatisDate,' 23:59:59.998'') 
	) a join KYDB_NEW.statistics_login_hall b on a.Account=b.account 
	where b.createdate>=''',in_StatisDate,''' and b.createdate<=''',in_StatisDate,' 23:59:59.998''
	group by b.ipLocal;
	');
	prepare stmt from @v_sql;
	execute stmt;
	deallocate prepare stmt;
	
	UPDATE statis_users_iplocal_tmp a left join statis_users_iplocal b on b.ipLocal=a.ipLocal set b.userCount=b.userCount+a.userCount;
	
	
	INSERT statis_users_iplocal(ipLocal,userCount) 
	select a.ipLocal,a.userCount from statis_users_iplocal_tmp a left join statis_users_iplocal b on b.ipLocal=a.ipLocal  where b.ipLocal is null;
	set @ts = TIMESTAMPDIFF(SECOND,@s_time,now());
	insert into KYStatis.prolog values(NOW(),'KYStatisLogin.sp_statis_users_iplocal',@ts);
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
DROP PROCEDURE IF EXISTS `sp_statis_validaccounts`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statis_validaccounts`(IN `in_statisdate` date)
BEGIN
    DECLARE v_tblName varchar(100);
    DECLARE v_date varchar(6);
    DECLARE v_sql LONGTEXT;
    SET @timediff = NOW();

    if in_statisdate is null THEN
        set in_statisdate = DATE_ADD(CURDATE(),INTERVAL -1 day);
    end if;
    set v_date = DATE_FORMAT(in_statisdate,'%Y%m');
    set v_tblName = CONCAT('day_play_game');
    if exists(select * from information_schema.`TABLES` where TABLE_SCHEMA = 'KYDB_NEW' and TABLE_NAME = v_tblName) THEN
        set v_sql=CONCAT('REPLACE INTO KYStatisLogin.validaccounts (account, agent, createdate)
		select DISTINCT a.Account,a.ChannelID,b.createdate from (select ChannelID,Account from KYStatisUsers.statis_allgames',v_date,'_users where StatisDate=''',in_statisdate,''')
		a  join KYDB_NEW.accounts b on a.account=b.account
		 where  b.createdate>=''',in_statisdate,''' and b.createdate<=''',in_statisdate,' 23:59:59.998'';
		');
        set @v_sql = v_sql;
        prepare stmt from @v_sql;
        execute stmt;
        deallocate prepare stmt;
    end if;
    SET @ts = TIMESTAMPDIFF(SECOND,@timediff,NOW());
    INSERT INTO KYStatis.prolog VALUES(NOW(),'KYStatisLogin.sp_statis_validaccounts',@ts);
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
DROP EVENT IF EXISTS `event_1_00_sp_statisKeepLoginUsers`;
CREATE DEFINER=`root`@`%` EVENT `event_1_00_sp_statisKeepLoginUsers` ON SCHEDULE EVERY 1 DAY STARTS '2021-07-25 03:00:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_statisKeepLoginUsers(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_sp_statis_users_iplocal_00_40`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_sp_statis_users_iplocal_00_40` ON SCHEDULE EVERY 1 DAY STARTS '2021-09-13 02:40:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_statis_users_iplocal(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_statisKeepGameUsers_EveryDay_01_30`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_statisKeepGameUsers_EveryDay_01_30` ON SCHEDULE EVERY 1 DAY STARTS '2021-10-25 03:30:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call KYStatisLogin.sp_statisKeepGameUsers_EveryDay(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_statisKeepGameUsers_EveryDay_01_40_-2`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_statisKeepGameUsers_EveryDay_01_40_-2` ON SCHEDULE EVERY 1 DAY STARTS '2021-10-25 03:40:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call KYStatisLogin.sp_statisKeepGameUsers_EveryDay(DATE_ADD(CURDATE(),INTERVAL -2 day));
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_statisKeepLoginUsersValid_02:30`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_statisKeepLoginUsersValid_02:30` ON SCHEDULE EVERY 1 DAY STARTS '2021-01-01 03:30:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_statisKeepLoginUsersValid(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_StatisLocationGameDayData_02:40`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_StatisLocationGameDayData_02:40` ON SCHEDULE EVERY 1 DAY STARTS '2023-01-01 02:40:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call `KYStatisLogin`.`sp_StatisLocationGameDayData`(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_statisLoginData`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_statisLoginData` ON SCHEDULE EVERY 1 DAY STARTS '2021-07-18 02:05:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_statisLoginData(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_statis_users_visits`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_statis_users_visits` ON SCHEDULE EVERY 1 DAY STARTS '2021-09-13 02:10:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_statis_users_visits(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_statis_validaccounts_02_00`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_statis_validaccounts_02_00` ON SCHEDULE EVERY 1 DAY STARTS '2021-01-01 03:00:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_statis_validaccounts(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

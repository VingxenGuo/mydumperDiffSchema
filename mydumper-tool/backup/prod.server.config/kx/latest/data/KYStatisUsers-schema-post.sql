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
DROP PROCEDURE IF EXISTS `Re_StatisUsersDayData_room`;
CREATE DEFINER=`root`@`%` PROCEDURE `Re_StatisUsersDayData_room`(IN `in_StatisDate` date)
BEGIN
  DECLARE v_endDate VARCHAR(30); 
  SET v_endDate=CURDATE(); 

  IF in_StatisDate is null THEN
    SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
  END IF; 
  WHILE in_StatisDate<=v_endDate DO
    call sp_StatisUsersGameDayData_room(in_StatisDate,'yxx'); 
    SET in_StatisDate = DATE_ADD(in_StatisDate,INTERVAL 1 day); 
  END WHILE; 
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
CREATE DEFINER=`root`@`%` PROCEDURE `sp_createStatisticsUsersTable`(IN `in_tablename` varchar(50), IN `in_type` int)
BEGIN
    DECLARE createsql VARCHAR(1000); 
    DECLARE createsql0 VARCHAR(1000); 
    DECLARE createsql1 VARCHAR(1000); 
    DECLARE createsql2 VARCHAR(1000); 

    SET createsql0 = CONCAT('CREATE TABLE IF NOT EXISTS ',in_tablename,' (
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
		`currency` varchar(50) NOT NULL COMMENT "币别",
		`exchangeRate` decimal(20,5) NOT NULL COMMENT "汇率",
		`CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
		`UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		PRIMARY KEY (`StatisDate`,`Account`,`LineCode`, `currency`),
		INDEX (`StatisDate`)
		) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;'); 

    SET createsql1 = CONCAT('CREATE TABLE IF NOT EXISTS ',in_tablename,' (
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
		`currency` varchar(50) NOT NULL COMMENT "币别",
		`exchangeRate` decimal(20,5) NOT NULL COMMENT "汇率",
		`CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
		`UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
		PRIMARY KEY (`Account`,`LineCode`, `currency`)
		) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;'); 

    SET createsql2 = CONCAT('CREATE TABLE IF NOT EXISTS `',in_tablename,'` (
		`StatisDate` date NOT NULL,
		`Account` varchar(200) NOT NULL,
		`ChannelID` int(11) DEFAULT NULL,
		`ServerID` int(11) NOT NULL,
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
		PRIMARY KEY (`StatisDate`,`Account`,`ServerID`, `currency`),
		INDEX (`StatisDate`)
		) ENGINE = InnoDB DEFAULT CHARSET = utf8mb4;'); 

    IF in_type = 0 THEN SET createsql = createsql0; END IF; 
    IF in_type = 1 THEN SET createsql = createsql1; END IF; 
    IF in_type = 2 THEN SET createsql = createsql2; END IF; 
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
DROP PROCEDURE IF EXISTS `sp_dailyPlayerGameData`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_dailyPlayerGameData`(
    IN `today` date,
    IN `channelID` int,
    IN `page` int,
    IN `pageCount` int
)
BEGIN
    DECLARE v_sqlbase LONGTEXT; 
    DECLARE whereString VARCHAR(1000); 
    DECLARE v_gameName VARCHAR(20); 
    DECLARE v_tbName VARCHAR(100); 
    DECLARE v_GameID INT; 
    -- 將handler設為初始化設定為0
    DECLARE no_more_maps INT DEFAULT 0; 
    -- 定義資料庫cursor
    DECLARE dept_csr CURSOR FOR
        SELECT GameID,If((GameID = 620),'dzpk',GameParameter) AS GameParameter
        FROM KYDB_NEW.GameInfo; 
    -- 宣告一個繼續作業的HANDLER，此HANDLER監聽'NOT FOUND'狀態, 如果出現'NOT FOUND'的狀態時, 就把變數的值設為1
    DECLARE CONTINUE HANDLER FOR NOT FOUND

    SET no_more_maps = 1; 
    SET v_sqlbase = ""; 
    SET whereString = CONCAT(
            " AND StatisDate ='",DATE_FORMAT(today, "%Y-%m-%d"),"'",
            " AND ChannelID ='",channelID,"'"
        ); 

    -- 開啟資料庫cursor
    OPEN dept_csr; 
        -- 用repeat…until….end repeat的語法(至少會迴圈一次)
        dept_loop :REPEAT -- 用FETCH將cursor逐筆讀入
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
DROP PROCEDURE IF EXISTS `sp_gameRecordSort`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_gameRecordSort`(IN `kindId` int,IN `accounts` varchar(190),IN `linecode` varchar(190),IN `beginDate` date,IN `endDate` date,IN `sortType` int,IN `pageOffset` int,IN `pageLimit` int,IN `channelId` int,IN `isPage` bit,IN `tmpRecordCount` int, IN `ServerId` int, IN `ProxyId` int)
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_totalSql LONGTEXT; 
	DECLARE v_sqlWhere LONGTEXT; 
	DECLARE v_selectName LONGTEXT; 
	DECLARE v_sql_tmp LONGTEXT; 
	DECLARE v_aTable VARCHAR(6); 
	DECLARE v_bTable VARCHAR(6); 
	DECLARE v_beginM VARCHAR(6); 
	DECLARE v_endM VARCHAR(6); 
	DECLARE v_tblName VARCHAR(100); 
	DECLARE v_gameName VARCHAR(20); 
	DECLARE v_orderBy VARCHAR(100); 
	DECLARE v_recordTotal INT; 
	DECLARE v_CellScore BIGINT; 
	DECLARE v_Profit BIGINT; 
	DECLARE v_Revenue BIGINT; 
	DECLARE v_GameNum BIGINT; 

	SET v_sql = ''; 
	SET v_totalSql = ''; 
	SET v_sql_tmp=''; 
	SET v_aTable = ''; 
	SET v_bTable = ''; 
	SET v_beginM = DATE_FORMAT(beginDate,'%Y%m'); 
	SET v_endM = DATE_FORMAT(endDate,'%Y%m'); 

	IF kindId > 0 THEN
		SET v_aTable = 'a.'; 
		SET v_bTable = 'b.'; 
	END IF; 

	SET v_sqlWhere = CONCAT(' WHERE `StatisDate` >= "',beginDate,'" AND `StatisDate` <= "',endDate,'"'); 
	IF channelId > 0 THEN   -- 代理商后台
		SET v_sqlWhere = CONCAT(v_sqlWhere,' AND ',v_aTable,'ChannelID = ',channelId); 
	END IF; 

	IF LENGTH(accounts) > 0 THEN
		SET v_sqlWhere = CONCAT(v_sqlWhere,' AND ',v_aTable,'Account = ''',accounts,''''); 
	END IF; 

	IF LENGTH(linecode) > 0 THEN
		set v_sqlWhere = CONCAT(v_sqlWhere,' AND ',v_bTable,'LineCode = ''',linecode,''''); 
	END IF; 

  IF ServerId > 0 THEN
    SET v_sqlWhere = CONCAT(v_sqlWhere , ' AND ServerID = ' , ServerId ); 
  END IF; 

	IF ProxyId > 0 THEN
		SET v_sqlWhere = CONCAT(' AND ',v_aTable,'ChannelID = ',ProxyId); 
  END IF; 

	SET v_selectName = CONCAT(' ',v_aTable,'Account, ', v_bTable,'LineCode, ', v_aTable,'ChannelID, ', v_aTable,'CellScore, (', v_aTable,'WinGold + ', v_aTable,'LostGold) AS Profit, ',v_aTable,'Revenue, (', v_aTable,'WinNum + ', v_aTable,'LostNum) AS GameNum, ',v_aTable,'currency ' ); 

	IF kindId = 0 THEN  -- 不选游戏
		SET v_tblName = CONCAT('statis_allgames',v_beginM,'_users'); 
		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblName) THEN
			SET v_sql = CONCAT('SELECT ', v_selectName ,' FROM KYStatisUsers.',v_tblName, v_sqlWhere); 
		END IF; 

		IF v_beginM <> v_endM THEN
			SET v_tblName = CONCAT('statis_allgames',v_endM,'_users'); 
			IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblName) THEN
				SET v_sql = CONCAT(v_sql,' UNION ALL SELECT ', v_selectName ,' FROM KYStatisUsers.',v_tblName, v_sqlWhere); 
			END IF; 
		END IF; 

	ELSE  -- 分游戏查询
		SELECT GameParameter INTO @gameName FROM KYDB_NEW.GameInfo WHERE Gameid = kindId; 
		IF kindId = 620 THEN
			SET @gameName = 'dzpk'; 
		END IF; 
		IF ServerId > 0 THEN
			SET v_tblName = CONCAT('statis_',@gameName,v_beginM,'_users_room'); 
		ELSE
      SET v_tblName = CONCAT('statis_',@gameName,v_beginM,'_users'); 
    END IF; 
		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblName) THEN
			SET v_sql = CONCAT('SELECT ', v_selectName,' FROM KYStatisUsers.',v_tblName, v_sqlWhere); 
		END IF; 
		IF v_beginM <> v_endM THEN
			IF ServerId > 0 THEN
				SET v_tblName = CONCAT('statis_',@gameName,v_endM,'_users_room'); 
			ELSE
				SET v_tblName = CONCAT('statis_',@gameName,v_endM,'_users'); 
			END IF; 
			IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblName) THEN
				SET v_sql = CONCAT(v_sql,' UNION ALL SELECT ',v_selectName,' FROM KYStatisUsers.',v_tblName, v_sqlWhere); 
			END IF; 
		END IF; 
	END IF; 

	IF LENGTH(v_sql) > 0 THEN
		SET v_sql = CONCAT('SELECT Account, LineCode, ChannelID, SUM(CellScore) AS CellScore, SUM(Profit) AS Profit, SUM(Revenue) AS Revenue,SUM(GameNum) AS GameNum, currency 
							FROM (', v_sql,') AS main 
							GROUP BY Account, ChannelID, currency '); 
		IF sortType = 0 THEN
			SET v_orderBy = ' ORDER BY AllProfit DESC'; 
		ELSEIF sortType = 1 THEN
			SET v_orderBy = ' ORDER BY AllProfit'; 
		ELSEIF sortType = 2 THEN
			SET v_orderBy = ' ORDER BY Profit DESC'; 
		ELSEIF sortType = 3 THEN
			SET v_orderBy = ' ORDER BY Profit'; 
		END IF; 

		SET v_sql = CONCAT('SELECT A.Account, A.LineCode, (B.WinNum + B.LostNum) AS AllGameNum, B.CellScore AS AllCellScore, 
								(B.WinGold+B.LostGold) AS AllProfit, B.Revenue AS AllRevenue, A.CellScore, A.Profit, 
								A.Revenue, A.GameNum, B.CreateTime, B.UpdateTime, A.currency 
							FROM (', v_sql,') A  
							JOIN  KYStatisUsers.statis_all_users AS B ON B.account = A.Account AND B.currency = A.currency
							',v_orderBy,''); 

		-- 对数据进行去重求和
		SET v_sql_tmp = CONCAT('SELECT Account, SUM(AllGameNum) AS AllGameNum, SUM(AllCellScore) AS AllCellScore, SUM(AllProfit) AS AllProfit,
									SUM(AllRevenue) AS AllRevenue, CellScore, Profit, Revenue, GameNum, CreateTime, UpdateTime, currency 
								FROM (',v_sql,') main1 
								GROUP BY Account, currency'); 

		IF tmpRecordCount <> 0 THEN
			SET v_recordTotal = tmpRecordCount; 
		ELSE
			SET v_totalSql = CONCAT('SELECT COUNT(Account) AS totalCount, SUM(CellScore) AS CellScore,SUM(Profit) AS Profit,
										SUM(Revenue) AS Revenue, SUM(GameNum) AS GameNum, currency
									FROM (', v_sql_tmp,') AS main
									GROUP BY currency'); 
			IF isPage = 1 THEN
				SET v_totalSql = CONCAT(v_sql,' LIMIT ',pageOffset,',',pageLimit); 
			END IF; 
			SET @v_totalSql = v_totalSql; 

			PREPARE stmt FROM @v_totalSql; 
			EXECUTE stmt; 
			DEALLOCATE PREPARE stmt; 
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
DROP PROCEDURE IF EXISTS `sp_InsertDataToStatisTable`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_InsertDataToStatisTable`(IN `in_StatisDate` date,IN `in_GameType` varchar(20),IN `in_GameID` int,IN `in_Type` int)
BEGIN
	declare v_sql LONGTEXT; 

	DECLARE v_tblNmae varchar(200); 

	declare v_date varchar(6); 

	set v_date = DATE_FORMAT(in_StatisDate,'%Y%m'); 

	set v_tblNmae = CONCAT('statis_', in_GameType, v_date,'_users'); 

	if in_Type = 0 then   

		if exists(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblNmae) THEN

			set v_sql = concat('replace into statis_game_reg_users(StatisDate, GameID, RegCount) select ''', in_StatisDate, ''',', in_GameID, ', count(distinct A.account) from KYStatisUsers.accounts_yesterday A inner join KYStatisUsers.', v_tblNmae, ' B on A.account = B.Account and B.StatisDate = ''', in_StatisDate,''''); 

			set @v_sql = v_sql; 

			PREPARE stmt from @v_sql; 

			EXECUTE stmt; 

			DEALLOCATE PREPARE stmt; 

		end if; 

	ELSEIF in_Type = 1 then 

		if exists(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_allgames', v_date,'_users')) THEN

			set v_sql = CONCAT('select ''',in_StatisDate,''',count(distinct main.account) from KYStatisUsers.statis_allgames', v_date,'_users as main inner join KYStatisUsers.accounts_yesterday B on main.account = B.account and main.StatisDate = ''', in_StatisDate,''''); 

			set v_sql = CONCAT('replace into KYStatisUsers.statis_reg_users(StatisDate,RegCount)',v_sql); 

			set @v_sql = v_sql; 

			PREPARE stmt from @v_sql; 

			EXECUTE stmt; 

			DEALLOCATE PREPARE stmt; 

		end if; 

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
DROP PROCEDURE IF EXISTS `sp_StatisUsersData_EveryDay`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisUsersData_EveryDay`(IN `in_StatisDate` date)
BEGIN

	DECLARE v_sql VARCHAR(4000); 

	DECLARE done INT DEFAULT FALSE; 

	DECLARE cur_Gameid, cur_GameParameter LONGTEXT; 

	DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 



	-- 记录开始时间

	SET @timediff = NOW(); 



	IF in_StatisDate IS NULL THEN

		SET in_StatisDate = DATE_ADD(CURDATE(), INTERVAL -1 DAY); 

	END IF; 



	SET @in_StatisDate_start = CONCAT(in_StatisDate,' 00:00:00'); 

	SET @in_StatisDate_end = CONCAT(in_StatisDate,' 23:59:59.998'); 

    

	-- 删除昨日注册玩家

	TRUNCATE TABLE KYStatisUsers.accounts_yesterday; 



	-- 写入昨日新注册玩家

    SET v_sql = CONCAT('REPLACE INTO KYStatisUsers.accounts_yesterday(account) 

		SELECT account FROM KYDB_NEW.accounts 

		WHERE createdate >= ''', @in_StatisDate_start,'''

		AND createdate <= ''', @in_StatisDate_end, ''''); 

	SET @v_sql = v_sql; 



    PREPARE stmt FROM @v_sql; 

	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt; 



	-- 统计各游戏的新增活跃

	OPEN cur1; 

		read_loop: LOOP

			FETCH cur1 INTO cur_Gameid, cur_GameParameter; 

		

			IF done THEN

				LEAVE read_loop; 

			END IF; 



			IF cur_Gameid = 620 THEN

				SET cur_GameParameter = 'dzpk'; 

			END IF; 



			CALL KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate, cur_GameParameter, cur_Gameid, 0); 

		END LOOP; 

	CLOSE cur1; 



	-- 统计平台的新增活跃

	CALL KYStatisUsers.sp_InsertDataToStatisTable(in_StatisDate, NULL, NULL, 1); 



	-- 统计平台的平均在线人数

	IF EXISTS (SELECT * FROM KYStatisUsers.statis_reg_users WHERE StatisDate = in_StatisDate) THEN

		SET v_sql = CONCAT('UPDATE KYStatisUsers.statis_reg_users AS A 

							INNER JOIN(

								SELECT SUM(value)/1440 AS avgOnline 

								FROM KYDB_NEW.online_game_all 

								WHERE createtime >= ''', in_StatisDate,''' AND createtime <= ''', in_StatisDate,' 23:59:59.998'')B SET A.AvgOnline = B.avgOnline 

							WHERE A.StatisDate = ''', in_StatisDate,''''); 

	ELSE

		SET v_sql = CONCAT('INSERT INTO KYStatisUsers.statis_reg_users(StatisDate,AvgOnline)

							SELECT ''', in_StatisDate,''', SUM(value)/1440 as avgOnline 

							FROM KYDB_NEW.online_game_all 

							WHERE createtime >= ''', in_StatisDate,''' AND createtime <= ''', in_StatisDate,' 23:59:59.998'''); 

	END IF; 

	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 

	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt; 



	SET @ts = TIMESTAMPDIFF(SECOND, @timediff, NOW()); 



	INSERT INTO KYStatis.prolog VALUES(NOW(), 'KYStatisUsers.sp_StatisUsersData_EveryDay', @ts); 

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

	DECLARE v_tblname VARCHAR(100); 

	DECLARE v_startTime VARCHAR(100); 

	DECLARE v_ENDTime VARCHAR(100); 

	DECLARE v_sqlWhere VARCHAR(100); 

	DECLARE v_spStartTime TIMESTAMP(3); 

	DECLARE v_spENDtime TIMESTAMP(3); 

	DECLARE v_sqlbase LONGTEXT; 

	DECLARE cur_TABLE_SCHEMA LONGTEXT; 

	DECLARE done INT DEFAULT FALSE; 

	DECLARE cur_Gameid, cur_GameParameter LONGTEXT; 

	DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 



	-- 记录开始时间

	SET v_spStartTime = CURRENT_TIMESTAMP(3); 



	IF in_StatisDate IS NULL THEN

		SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 

END IF; 



	SET v_startTime = CONCAT(in_StatisDate, ' 00:00:00 '); 

	SET v_ENDTime = CONCAT(in_StatisDate, ' 23:59:59 '); 

	SET v_sqlWhere = CONCAT(" WHERE GameENDTime >= '", v_startTime, "' AND GameENDTime <= '", v_ENDTime, "'"); 

	SET v_month = DATE_FORMAT(in_StatisDate, '%Y%m'); 



OPEN cur1; 

read_loop: LOOP

			FETCH cur1 INTO cur_Gameid, cur_GameParameter; 



			IF done THEN

				LEAVE read_loop; 

END IF; 



			IF cur_Gameid = 620 THEN

				SET cur_GameParameter = 'dzpk'; 

END IF; 



			SET v_tblname = CONCAT(cur_GameParameter, '_gameRecord'); 



			IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'detail_record' AND TABLE_NAME = v_tblname) THEN

				IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, v_month, '_users')) THEN

					CALL sp_createStatisticsUsersTable(CONCAT('statis_', cur_GameParameter, v_month, '_users'), 0); 

END IF; 



				SET @v_sqlselect = CONCAT('REPLACE INTO KYStatisUsers.statis_', cur_GameParameter, v_month, '_users

                      (StatisDate, Account, ChannelID, LineCode, AllBet, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum, currency, exchangeRate)

											SELECT ''', in_StatisDate, ''' AS StatisDate, a.Accounts,a.ChannelID,a.LineCode,SUM(a.AllBet),SUM(a.CellScore) CellScore,SUM(CASE WHEN a.Profit>0 THEN a.Profit ELSE 0 END) wingold,

												SUM(CASE WHEN a.Profit<0 THEN a.Profit ELSE 0 END) lostgold,SUM(a.Revenue) Revenue,COUNT(CASE WHEN a.Profit>=0 THEN a.Profit END) winNum,

												COUNT(CASE WHEN a.Profit<0 THEN a.Profit END) lostNum, a.currency, currencyTable.exchangeRate

											FROM detail_record.', v_tblname, ' a ',

											' LEFT JOIN game_manage.rp_currency currencyTable

											ON a.currency = currencyTable.currency ',

											v_sqlWhere, '

											GROUP BY Accounts, ChannelID, LineCode, currency'); 

PREPARE stmt FROM @v_sqlselect; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



SET v_sqlbase = CONCAT(IF(LENGTH(v_sqlbase) > 0, CONCAT(v_sqlbase, ' UNION ALL '), ''), 'SELECT * FROM KYStatisUsers.statis_', cur_GameParameter, v_month, '_users WHERE StatisDate = ''', in_StatisDate, ''''); 

END IF; 

END LOOP; 

CLOSE cur1; 



-- 添加所有游戏当天数据

IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_allgames',v_month,'_users')) THEN

		CALL sp_createStatisticsUsersTable(CONCAT('statis_allgames',v_month,'_users'),0); 

END IF; 

	SET @v_sqlselect = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT('REPLACE INTO KYStatisUsers.statis_allgames', v_month, '_users

                               (StatisDate, Account, ChannelID, LineCode, AllBet, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum, currency, exchangeRate)

																SELECT ''', in_StatisDate, ''' AS StatisDate, Account, ChannelID, LineCode,SUM(AllBet), SUM(CellScore) CellScore, SUM(WinGold) WinGold, SUM(LostGold) LostGold, SUM(Revenue) Revenue,

																	SUM(WinNum) WinNum, SUM(LostNum) LostNum, currency, exchangeRate

																FROM ( ', v_sqlbase), ''), ' ) tmptable

																GROUP BY StatisDate, Account, ChannelID, LineCode, currency'); 

	IF(LENGTH(v_sqlbase)) > 0 THEN

	PREPARE stmt FROM @v_sqlselect; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 

END IF; 



	-- 更新玩家月数据 先更新现有的玩家，然后添加第一次出现的玩家

	IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_month',v_month,'_users')) THEN

		CALL sp_createStatisticsUsersTable(CONCAT('statis_month', v_month, '_users'),1); 

END IF; 

	SET @v_sqlselect = CONCAT('UPDATE KYStatisUsers.statis_allgames', v_month, '_users a

								LEFT JOIN KYStatisUsers.statis_month', v_month, '_users b ON a.Account = b.Account AND a.LineCode = b.LineCode AND a.currency = b.currency

								LEFT JOIN game_manage.rp_currency c ON b.currency = c.currency

								SET b.AllBet = b.AllBet + a.AllBet, b.CellScore = b.CellScore + a.CellScore, b.WinGold = b.WinGold + a.WinGold, b.LostGold = b.LostGold + a.LostGold, b.Revenue = b.Revenue + a.Revenue, b.WinNum = b.WinNum + a.WinNum, b.LostNum = b.LostNum + a.LostNum, b.exchangeRate = c.exchangeRate

								WHERE a.StatisDate = ''',in_StatisDate,''''); 

PREPARE stmt FROM @v_sqlselect; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



-- 添加本月第一次玩游戏的玩家

SET @v_sqlselect = CONCAT('INSERT INTO KYStatisUsers.statis_month', v_month, '_users

                (Account, ChannelID, LineCode, AllBet, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum, currency, exchangeRate)

								SELECT a.Account, a.ChannelID, a.LineCode, a.AllBet, a.CellScore, a.WinGold, a.LostGold, a.Revenue, a.WinNum, a.LostNum, a.currency, a.exchangeRate

								FROM KYStatisUsers.statis_allgames', v_month, '_users  a

								LEFT JOIN KYStatisUsers.statis_month', v_month, '_users b ON b.Account = a.Account AND b.LineCode = a.LineCode AND a.currency = b.currency

								WHERE a.StatisDate = ''', in_StatisDate, ''' AND b.Account IS NULL;'); 

PREPARE stmt FROM @v_sqlselect; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



-- 更新玩家历史输赢数据 先update 再insert

IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_all_users')) THEN

		CALL sp_createStatisticsUsersTable(CONCAT('statis_all_users'),1); 

END IF; 

	SET @v_sqlselect = CONCAT('UPDATE KYStatisUsers.statis_allgames', v_month, '_users a

								LEFT JOIN KYStatisUsers.statis_all_users b  ON a.Account = b.Account AND a.LineCode = b.LineCode AND a.currency = b.currency

								LEFT JOIN game_manage.rp_currency c ON b.currency = c.currency

								SET b.AllBet = b.AllBet + a.AllBet, b.CellScore = b.CellScore + a.CellScore, b.WinGold = b.WinGold + a.WinGold, b.LostGold = b.LostGold + a.LostGold, b.Revenue = b.Revenue + a.Revenue, b.WinNum = b.WinNum + a.WinNum, b.LostNum = b.LostNum + a.LostNum, b.currency = a.currency, b.exchangeRate = c.exchangeRate

								WHERE a.StatisDate=''', in_StatisDate, ''''); 

PREPARE stmt FROM @v_sqlselect; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



-- 添加第一次玩游戏的玩家

SET @v_sqlselect = CONCAT('INSERT INTO KYStatisUsers.statis_all_users

                (Account, ChannelID, LineCode, AllBet, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum, currency, exchangeRate)

								SELECT a.Account ,a.ChannelID, a.LineCode, a.AllBet, a.CellScore, a.WinGold, a.LostGold, a.Revenue, a.WinNum, a.LostNum, a.currency, a.exchangeRate

								FROM KYStatisUsers.statis_allgames', v_month, '_users  a

								LEFT JOIN KYStatisUsers.statis_all_users b ON b.Account = a.Account AND b.LineCode = a.LineCode AND b.currency = a.currency

								WHERE a.StatisDate=''', in_StatisDate, ''' AND b.Account IS NULL;'); 

PREPARE stmt FROM @v_sqlselect; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



-- 记录结束时间

SET v_spENDtime = CURRENT_TIMESTAMP(); 



	-- 添加执行日志

INSERT INTO KYStatisUsers.event_log_record (sp_name, starttime, ENDtime, exectime,mark) VALUES ('sp_StatisUsersDayData', v_spStartTime, v_spENDtime, TIMESTAMPDIFF(SECOND,v_spStartTime,v_spENDtime),''); 

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

	-- 北京时间 2018-09-26

	DECLARE v_month VARCHAR(30); 

	DECLARE v_tblname VARCHAR(100); 

	DECLARE v_starttime TIMESTAMP(3); 

	DECLARE v_ENDtime TIMESTAMP(3); 

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



	SET v_month = DATE_FORMAT(in_StatisDate, '%Y%m'); 



	OPEN cur1; 

		read_loop: LOOP

			FETCH cur1 INTO cur_Gameid, cur_GameParameter; 

			

			IF done THEN

				LEAVE read_loop; 

			END IF; 

			

			IF cur_Gameid = 620 THEN

				SET cur_GameParameter = 'dzpk'; 

			END IF; 

			SET v_tblname = CONCAT(cur_GameParameter, '_gameRecord'); 



			IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'detail_record' AND TABLE_NAME = v_tblname) THEN

				IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, v_month, '_users')) THEN

					CALL sp_createStatisticsUsersTable(CONCAT('statis_', cur_GameParameter, v_month, '_users'),0); 

				END IF; 



				SET @v_sqlselect = CONCAT('REPLACE INTO KYStatisUsers.statis_', cur_GameParameter, v_month,'_users (StatisDate,Account,ChannelID,LineCode,AllBet,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) 

												SELECT ''',in_StatisDate, ''' AS StatisDate, Accounts,ChannelID,LineCode,SUM(AllBet) AllBet,SUM(CellScore) CellScore,SUM(CASE when Profit>0 THEN Profit else 0 END) wingold,

													SUM(CASE when Profit<0 THEN Profit else 0 END) lostgold,SUM(Revenue) Revenue, COUNT(CASE when Profit > =0 THEN Profit END) winNum,

													COUNT(CASE when Profit < 0 THEN Profit END) lostNum 

													FROM detail_record.', v_tblname, ' 

													GROUP BY Accounts,ChannelID,LineCode'); 

				PREPARE stmt FROM @v_sqlselect; 

				EXECUTE stmt; 

				DEALLOCATE PREPARE stmt; 



				SET v_sqlbase= CONCAT(IF(LENGTH(v_sqlbase) > 0, CONCAT(v_sqlbase,' UNION ALL '),''),'SELECT * FROM KYStatisUsers.statis_', cur_GameParameter,v_month, '_users WHERE StatisDate=''',in_StatisDate,''''); 

			END IF; 

		END LOOP; 

	CLOSE cur1; 



		-- 添加所有游戏当天数据

		IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_allgames',v_month,'_users')) THEN

			CALL sp_createStatisticsUsersTable(CONCAT('statis_allgames',v_month,'_users'),0); 

		END IF; 



		SET @v_sqlselect = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT('REPLACE INTO KYStatisUsers.statis_allgames',v_month,'_users (StatisDate,Account,ChannelID,LineCode,AllBet,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) 

																	SELECT ''',in_StatisDate,''' AS StatisDate, Account,ChannelID,LineCode,SUM(AllBet) AllBet,SUM(CellScore) CellScore,SUM(WinGold) WinGold,SUM(LostGold) LostGold,

																		SUM(Revenue) Revenue,SUM(WinNum) WinNum,SUM(LostNum) LostNum  

																		FROM ( ',v_sqlbase),''),' ) tmptable 

																		GROUP BY StatisDate,Account,ChannelID,LineCode'); 



		IF(LENGTH(v_sqlbase)) > 0 THEN

			PREPARE stmt FROM @v_sqlselect; 

			EXECUTE stmt; 

			DEALLOCATE PREPARE stmt; 

		END IF; 



		-- 更新玩家月数据 先更新现有的玩家，然后添加第一次出现的玩家

		IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_month',v_month,'_users')) THEN

			CALL sp_createStatisticsUsersTable(CONCAT('statis_month',v_month,'_users'),1); 

		END IF; 



		SET @v_sqlselect = CONCAT('UPDATE KYStatisUsers.statis_allgames',v_month,'_users a 

									LEFT JOIN KYStatisUsers.statis_month',v_month,'_users b ON a.Account=b.Account AND a.LineCode=b.LineCode 

									SET b.AllBet = b.AllBet + a.AllBet, b.CellScore = b.CellScore+a.CellScore, b.WinGold = b.WinGold + a.WinGold, b.LostGold = b.LostGold + a.LostGold, b.Revenue = b.Revenue + a.Revenue, b.WinNum = b.WinNum + a.WinNum, b.LostNum = b.LostNum+a.LostNum

									WHERE a.StatisDate=''',in_StatisDate,''''); 

		PREPARE stmt FROM @v_sqlselect; 

		EXECUTE stmt; 

		DEALLOCATE PREPARE stmt; 



		-- 添加本月第一次玩游戏的玩家

		SET @v_sqlselect = CONCAT('INSERT INTO KYStatisUsers.statis_month',v_month,'_users (Account,ChannelID,LineCode,AllBet,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) 

									SELECT a.Account,a.ChannelID,a.LineCode,a.AllBet,a.CellScore,a.WinGold,a.LostGold,a.Revenue,a.WinNum,a.LostNum

									FROM KYStatisUsers.statis_allgames',v_month,'_users  a 

									LEFT JOIN KYStatisUsers.statis_month',v_month,'_users b ON b.Account = a.Account AND b.LineCode=a.LineCode 

									WHERE a.StatisDate=''',in_StatisDate,''' AND b.Account IS NULL;'); 

		PREPARE stmt FROM @v_sqlselect; 

		EXECUTE stmt; 

		DEALLOCATE PREPARE stmt; 



		-- 更新玩家历史输赢数据 先update 再insert

		IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_all_users')) THEN

			CALL sp_createStatisticsUsersTable(CONCAT('statis_all_users'),1); 

		END if; 

		SET @v_sqlselect = CONCAT('UPDATE KYStatisUsers.statis_allgames',v_month,'_users a 

									LEFT JOIN KYStatisUsers.statis_all_users b  ON a.Account=b.Account AND a.LineCode=b.LineCode 

									SET b.AllBet = b.AllBet + a.AllBet, b.CellScore = b.CellScore + a.CellScore, b.WinGold = b.WinGold + a.WinGold, b.LostGold = b.LostGold + a.LostGold, b.Revenue = b.Revenue + a.Revenue, b.WinNum = b.WinNum + a.WinNum, b.LostNum = b.LostNum + a.LostNum

									WHERE a.StatisDate=''',in_StatisDate,''''); 

		PREPARE stmt FROM @v_sqlselect; 

		EXECUTE stmt; 

		DEALLOCATE PREPARE stmt; 



		-- 添加第一次玩游戏的玩家

		SET @v_sqlselect = CONCAT('INSERT INTO KYStatisUsers.statis_all_users (Account,ChannelID,LineCode,AllBet,CellScore,WinGold,LostGold,Revenue,WinNum,LostNum) 

									SELECT a.Account,a.ChannelID,a.LineCode,a.AllBet,a.CellScore,a.WinGold,a.LostGold,a.Revenue,a.WinNum,a.LostNum

									FROM KYStatisUsers.statis_allgames',v_month,'_users  a 

									LEFT JOIN KYStatisUsers.statis_all_users b ON b.Account=a.Account AND b.LineCode=a.LineCode 

									WHERE a.StatisDate=''',in_StatisDate,''' AND b.Account IS NULL;'); 

		PREPARE stmt FROM @v_sqlselect; 

		EXECUTE stmt; 

		DEALLOCATE PREPARE stmt; 



		-- 记录结束时间

		SET v_ENDtime=CURRENT_TIMESTAMP(); 



		-- 添加执行日志

		INSERT INTO KYStatisUsers.event_log_record (sp_name, starttime, ENDtime, exectime,mark) VALUES ('sp_StatisUsersDayData', v_starttime, v_ENDtime, TIMESTAMPDIFF(SECOND,v_starttime,v_ENDtime),''); 

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

	DECLARE v_month VARCHAR(30); 

	DECLARE v_starttime TIMESTAMP(3); 

	DECLARE v_endtime TIMESTAMP(3); 



	SET v_starttime = CURRENT_TIMESTAMP(3); 

	IF in_StatisDate IS NULL THEN

	SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 

	END IF; 

	SET v_month = DATE_FORMAT(in_StatisDate,'%Y%m'); 



	SET @v_sqlselect = CONCAT('UPDATE (SELECT Account, ChannelID, SUM(CellScore) CellScore, SUM(WinGold) WinGold, SUM(LostGold) LostGold, SUM(Revenue)Revenue, SUM(WinNum)WinNum, SUM(LostNum)LostNum, currency

	FROM KYStatisUsers.statis_allgames', v_month, '_users where StatisDate = ''', in_StatisDate, ''' GROUP BY Account, ChannelID, currency) a LEFT JOIN KYStatisUsers.statis_all_users_unique b  ON a.Account = b.Account AND a.currency = b.currency

	SET b.CellScore = b.CellScore + a.CellScore, b.WinGold = b.WinGold + a.WinGold, b.LostGold = b.LostGold + a.LostGold, b.Revenue = b.Revenue + a.Revenue, b.WinNum = b.WinNum + a.WinNum, b.LostNum = b.LostNum + a.LostNum'); 

	PREPARE stmt FROM @v_sqlselect; 

	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt; 



	SET @v_sqlselect = CONCAT('INSERT INTO KYStatisUsers.statis_all_users_unique (Account, ChannelID, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum, currency) 

	SELECT a.Account, a.ChannelID, a.CellScore, a.WinGold, a.LostGold, a.Revenue, a.WinNum, a.LostNum, a.currency

	FROM (SELECT Account, ChannelID, SUM(CellScore) CellScore, SUM(WinGold) WinGold, SUM(LostGold) LostGold, SUM(Revenue) Revenue, SUM(WinNum) WinNum, SUM(LostNum) LostNum, currency

	FROM KYStatisUsers.statis_allgames', v_month, '_users where StatisDate = ''', in_StatisDate, ''' GROUP BY Account, ChannelID, currency)  a LEFT JOIN KYStatisUsers.statis_all_users_unique b ON b.Account = a.Account AND b.currency = a.currency where b.Account IS NULL;'); 

	PREPARE stmt FROM @v_sqlselect; 

	EXECUTE stmt; 

	DEALLOCATE PREPARE stmt; 



	SET v_endtime=CURRENT_TIMESTAMP(); 



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
DROP PROCEDURE IF EXISTS `sp_StatisUsersDayData_Rerun`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisUsersDayData_Rerun`(	IN `in_StatisDate` date )
BEGIN
    DECLARE v_month VARCHAR(30); 
    DECLARE v_gameTable varchar(100); 
    DECLARE v_statisTable varchar(100); 
    DECLARE v_dayStartTime varchar(100); 
    DECLARE v_sqlWhere varchar(100); 
    DECLARE v_dayEndTime varchar(100); 
    DECLARE v_startTime TIMESTAMP(3); 
    DECLARE v_endTime TIMESTAMP(3); 
    DECLARE v_sqlBase LONGTEXT; 
    DECLARE done INT DEFAULT FALSE; 
    DECLARE cur_GameId, cur_GameParameter LONGTEXT; 
	DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 



    #记录开始时间
    SET v_startTime = CURRENT_TIMESTAMP(3); 
    IF in_StatisDate IS NULL THEN
        SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
    END IF; 
    SET v_month = DATE_FORMAT(in_StatisDate,'%Y%m'); 

    SET v_dayStartTime = CONCAT(in_StatisDate, ' 00:00:00 '); 
	SET v_dayEndTime = CONCAT(in_StatisDate, ' 23:59:59 '); 
	SET v_sqlWhere = CONCAT(" WHERE GameENDTime >= '", v_dayStartTime, "' AND GameENDTime <= '", v_dayEndTime, "'"); 

	OPEN cur1; 
		read_loop: LOOP
			FETCH cur1 INTO cur_GameId, cur_GameParameter; 
			IF done THEN
				LEAVE read_loop; 
			END IF; 

			IF cur_GameId = 620 THEN
				SET cur_GameParameter = 'dzpk'; 
			END IF; 
			SET v_gameTable = CONCAT(cur_GameParameter, '_gameRecord'); 
    		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'detail_record' AND TABLE_NAME = v_gameTable) THEN
        		IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, v_month, '_users')) THEN
					CALL sp_createStatisticsUsersTable(CONCAT('statis_', cur_GameParameter, v_month, '_users'),0); 
				END IF; 
				SET @v_sqlSelect = CONCAT('REPLACE INTO KYStatisUsers.statis_', cur_GameParameter, v_month,'_users (StatisDate, Account, ChannelID, LineCode, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum, currency, exchangeRate) 
                                        SELECT ''',in_StatisDate,''' AS StatisDate, a.Accounts, a.ChannelID, a.LineCode, SUM(a.CellScore) AS CellScore,
                                            SUM(CASE WHEN a.Profit > 0 THEN a.Profit ELSE 0 END) AS wingold, SUM(CASE WHEN a.Profit < 0 THEN a.Profit ELSE 0 END) AS lostgold,
                                            SUM(a.Revenue) AS Revenue, COUNT(CASE WHEN a.Profit >= 0 THEN a.Profit END) AS winNum, COUNT(CASE WHEN a.Profit < 0 THEN a.Profit END) AS lostNum,
                                            a.currency, currencyTable.exchangeRate
                                        FROM detail_record.',v_gameTable,' AS a 
                                        LEFT JOIN game_manage.rp_currency AS currencyTable ON a.currency = currencyTable.currency'
                                        , v_sqlWhere, '
                                        GROUP BY Accounts, ChannelID, LineCode, currency'); 
                PREPARE stmt FROM @v_sqlSelect; 
                EXECUTE stmt; 
                DEALLOCATE PREPARE stmt; 
                SET v_sqlBase = CONCAT(IF(LENGTH(v_sqlBase) > 0,CONCAT(v_sqlBase,' UNION ALL '),''),'SELECT * FROM KYStatisUsers.statis_', cur_GameParameter, v_month, '_users WHERE StatisDate=''',in_StatisDate,''''); 
            END IF; 
        END LOOP; 
	CLOSE cur1; 

    #添加所有游戏当天数据
    SET v_statisTable = CONCAT('statis_allgames',v_month,'_users'); 
    IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_statisTable) THEN
        CALL sp_createStatisticsUsersTable(v_statisTable,0); 
    END IF; 
    SET @v_sqlSelect = CONCAT(IF(LENGTH(v_sqlBase) > 0,CONCAT('
        REPLACE INTO KYStatisUsers.',v_statisTable,' (StatisDate, Account, ChannelID, LineCode, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum, currency, exchangeRate) 
        SELECT ''',in_StatisDate,''' AS StatisDate, Account, ChannelID, LineCode, SUM(CellScore) AS CellScore, SUM(WinGold) AS WinGold,
            SUM(LostGold) AS LostGold, SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, currency, exchangeRate 
        FROM ( ',v_sqlBase),''),' ) AS tmpTable 
        GROUP BY StatisDate, Account, ChannelID, LineCode, currency'); 
    IF(LENGTH(v_sqlBase)) > 0 THEN
        PREPARE stmt FROM @v_sqlSelect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
    END IF; 
    #记录结束时间
    SET v_endTime=CURRENT_TIMESTAMP(); 
    #添加执行日志
    INSERT INTO KYStatisUsers.event_log_record (sp_name, starttime, endtime, exectime,mark) VALUES ('sp_StatisUsersDayData_Rerun', v_startTime, v_endTime, TIMESTAMPDIFF(SECOND,v_startTime,v_endTime), in_StatisDate); 

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



			CALL sp_StatisUsersGameDayData_room(in_StatisDate, cur_GameParameter); 

		END LOOP; 

	CLOSE cur1; 



	-- 记录结束时间

	SET v_endtime = CURRENT_TIMESTAMP(); 



	-- 添加执行日志

	INSERT INTO KYStatisUsers.event_log_record (sp_name, starttime, endtime, exectime,mark) VALUES ('sp_StatisUsersDayData_room', v_starttime, v_endtime, TIMESTAMPDIFF(SECOND,v_starttime,v_endtime),in_StatisDate); 

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
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisUsersGameDayData_room`(IN in_StatisDate date, IN in_GameName varchar(100))
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

        SET v_endTime =  CONCAT(in_StatisDate, ' 23:59:59.998'); 

        SET v_month = DATE_FORMAT(in_StatisDate,'%Y%m'); 

        SET v_tblname = CONCAT(in_GameName, '_gameRecord'); 

        IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_', in_GameName, v_month, '_users_room')) THEN

                CALL sp_createStatisticsUsersTable(CONCAT('statis_', in_GameName, v_month, '_users_room'), 2); 

        END IF; 

        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'detail_record' AND TABLE_NAME = v_tblname) THEN

                SET v_sqlbase = CONCAT('REPLACE INTO KYStatisUsers.statis_', in_GameName,v_month, '_users_room (StatisDate, Account, ChannelID, ServerID, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum, currency, exchangeRate) 

                        SELECT ''', in_StatisDate, ''' AS StatisDate, Accounts, ChannelID, ServerID,

                                SUM(CellScore) CellScore,

                                SUM(CASE WHEN Profit > 0 THEN Profit ELSE 0 END) wingold, 

                                SUM(CASE WHEN Profit < 0 THEN Profit ELSE 0 END) lostgold, 

                                SUM(Revenue) Revenue, 

                                COUNT(CASE WHEN Profit >= 0 THEN Profit END) winNum, 

                                COUNT(CASE WHEN Profit < 0 THEN Profit END) lostNum, 

                                A.currency, 

                B.exchangeRate 

                                FROM detail_record.',v_tblname,' AS A 

                LEFT JOIN game_manage.rp_currency AS B ON A.currency = B.currency 

                                WHERE GameEndTime >= ''',v_startTime,''' 

                                AND GameEndTime <= ''',v_endTime,''' 

                                GROUP BY Accounts, ChannelID, ServerID, currency'); 

        SET @v_sqlselect = v_sqlbase;      

        PREPARE stmt FROM @v_sqlselect; 

        EXECUTE stmt; 

        DEALLOCATE PREPARE stmt; 

        IF NOT EXISTS(SELECT 1 FROM information_schema.columns WHERE table_name = CONCAT('statis_',in_GameName,v_month,'_users_room') AND COLUMN_NAME = 'isNew') THEN

                SET @v_sqlselect = CONCAT('ALTER TABLE KYStatisUsers.statis_', in_GameName,v_month, '_users_room add `isNew` int(11) DEFAULT 0;'); 

                PREPARE stmt FROM @v_sqlselect; 

                EXECUTE stmt; 

                DEALLOCATE PREPARE stmt; 

        END IF; 

        SET @v_sqlselect = CONCAT('UPDATE KYStatisUsers.statis_', in_GameName,v_month, '_users_room set isNew=1 

        WHERE StatisDate = ''', in_StatisDate, ''' AND Account in (SELECT account FROM KYDB_NEW.accounts WHERE createdate >= ''', in_StatisDate, ' 00:00:00'' AND createdate <= ''', in_StatisDate, ' 23:59:59'')');                 

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
DROP PROCEDURE IF EXISTS `sp_StatisVvipUsers`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisVvipUsers`(IN `in_StatisDate` DATE)
BEGIN

    DECLARE v_sql LONGTEXT; 

    DECLARE v_sqlStatisM LONGTEXT; 

    DECLARE v_sqlVvipName VARCHAR(200); 

    DECLARE v_sqlFieldName VARCHAR(200); 

    DECLARE v_StatisDate2Week VARCHAR(10); 

    DECLARE v_starttime TIMESTAMP(3); 

    DECLARE v_endtime TIMESTAMP(3); 



    SET v_starttime = CURRENT_TIMESTAMP(3); 

    

    -- 清空既有資訊

    TRUNCATE KYStatisUsers.statis_vvip_users; 

        

    IF in_StatisDate IS NULL THEN

        SET in_StatisDate = CURDATE(); 

    END IF; 

        

    SET v_StatisDate2Week = DATE_ADD(in_StatisDate, INTERVAL -14 DAY); 

        

    SET v_sql = ""; 

    SET v_sqlStatisM = ""; 

    SET v_sqlVvipName = "StatisDate, Account, ChannelID, LineCode, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum"; 

    SET v_sqlFieldName = "StatisDate, Account, ChannelID, LineCode, CellScore, WinGold, LostGold, Revenue, WinNum, LostNum, exchangeRate"; 

        

    SET @v_StatisM = DATE_FORMAT(v_StatisDate2Week, '%Y%m'); 

    SET @in_StatisM = DATE_FORMAT(in_StatisDate, '%Y%m'); 

    IF EXISTS(SELECT * FROM information_schema.`TABLES` WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = concat('statis_allgames', @in_StatisM,'_users')) THEN

        SET v_sqlStatisM = CONCAT("SELECT ", v_sqlFieldName, " FROM KYStatisUsers.statis_allgames", @in_StatisM, "_users WHERE StatisDate < DATE('", in_StatisDate, "') "); 

        SET @v_sqlWhere = CONCAT("AND StatisDate >= DATE('", v_StatisDate2Week, "')"); 

        IF NOT @in_StatisM = @v_StatisM THEN

            SET v_sqlStatisM = CONCAT(v_sqlStatisM, " UNION ALL "); 

        END IF; 

    END IF; 

    IF NOT @in_StatisM = @v_StatisM THEN

		IF EXISTS(SELECT * FROM information_schema.`TABLES` WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = concat('statis_allgames', @v_StatisM,'_users')) THEN

            SET v_sqlStatisM = CONCAT(v_sqlStatisM, " SELECT ", v_sqlFieldName, " FROM KYStatisUsers.statis_allgames", @v_StatisM, "_users "); 

            SET @v_sqlWhere = CONCAT("WHERE StatisDate >= DATE('", v_StatisDate2Week, "')"); 

		END IF; 

    END IF; 

    SET v_sqlStatisM = CONCAT(" select StatisDate, Account, ChannelID, LineCode, SUM(CellScore * exchangeRate) AS CellScore, SUM(WinGold * exchangeRate) WinGold, SUM(LostGold * exchangeRate) LostGold, SUM(Revenue * exchangeRate) Revenue, SUM(WinNum), SUM(LostNum) FROM ( ", v_sqlStatisM, @v_sqlWhere, " ) A GROUP BY StatisDate, Account, ChannelID, LineCode "); 

        

    -- 取得名单，并取得相关统计资讯

    SET v_sql = CONCAT("INSERT INTO KYStatisUsers.statis_vvip_users (", v_sqlVvipName,", lastlogintime, AccountCreateTime) SELECT s.*, u.lastlogintime, u.AccountCreateTime FROM dayrecord_vvip_users u INNER JOIN (", v_sqlStatisM, ") s ON u.StatisDate = '", in_StatisDate, "' AND u.account = s.Account"); 

     

    SET @v_sql = v_sql; 

    SELECT @v_sql; 

    PREPARE stmt FROM @v_sql; 

    EXECUTE stmt; 

    DEALLOCATE PREPARE stmt; 



    SET v_endtime = CURRENT_TIMESTAMP(); 

    INSERT INTO KYStatisUsers.event_log_record (sp_name, starttime, endtime, exectime,mark) VALUES ("sp_StatisVvipUsers", v_starttime, v_endtime, TIMESTAMPDIFF(SECOND, v_starttime, v_endtime), in_StatisDate); 



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
DROP PROCEDURE IF EXISTS `sp_UpdateDayrecordVvipUsers`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_UpdateDayrecordVvipUsers`(IN `in_StatisDate` DATE)
BEGIN

    DECLARE v_sql LONGTEXT; 

    DECLARE v_sqlStatisM LONGTEXT; 

    DECLARE v_StatisDateMonth VARCHAR(10); 

    DECLARE v_StatisDate2Week VARCHAR(10); 

    DECLARE v_MaxCount VARCHAR(10); 

    DECLARE v_ranking VARCHAR(200); 

    DECLARE v_starttime TIMESTAMP(3); 

    DECLARE v_endtime TIMESTAMP(3); 

        

    SET v_starttime = CURRENT_TIMESTAMP(3); 

        

    IF in_StatisDate IS NULL THEN

        SET in_StatisDate = CURDATE(); 

    END IF; 

    

    SET v_MaxCount = "200"; 

    SET v_StatisDateMonth = DATE_ADD(in_StatisDate, INTERVAL -30 DAY); 

    SET v_StatisDate2Week = DATE_ADD(in_StatisDate, INTERVAL -14 DAY); 



    -- 近一个月内有上线

    SET v_sql = ""; 

    SET v_ranking = ""; 

    SET v_sql = CONCAT("INSERT IGNORE INTO KYStatisUsers.dayrecord_vvip_users (StatisDate, account, lastlogintime, AccountCreateTime) SELECT '", in_StatisDate,"' StatisDate, acc.account, acc.lastlogintime, acc.createdate FROM KYDB_NEW.accounts acc INNER JOIN  (select Account, ChannelID, SUM(AllBet * exchangeRate) AS AllBet, SUM(CellScore * exchangeRate) AS CellScore, SUM(WinGold * exchangeRate) AS WinGold , SUM(LostGold * exchangeRate) AS LostGold from KYStatisUsers.statis_all_users GROUP BY Account, ChannelID) s ON DATE_FORMAT(acc.lastlogintime, '%y-%m-%d') >= DATE('", v_StatisDateMonth,"') AND acc.account = s.Account "); 



    -- 近一个月内有上线 且 总投注金额前两百名

    SET v_ranking = CONCAT("ORDER BY s.CellScore DESC LIMIT 0, ", v_MaxCount); 

    SET @v_sql = CONCAT(v_sql, v_ranking); 

    PREPARE stmt FROM @v_sql; 

    EXECUTE stmt; 

    DEALLOCATE PREPARE stmt; 



    -- 近一个月内有上线 且 总输赢金额前两百名

    SET v_ranking = CONCAT("ORDER BY (s.WinGold + s.LostGold) ASC LIMIT 0, ", v_MaxCount); 

    SET @v_sql = CONCAT(v_sql, v_ranking); 

    PREPARE stmt FROM @v_sql; 

    EXECUTE stmt; 

    DEALLOCATE PREPARE stmt; 



    -- 近14天内有上线

    SET v_sql = ""; 

    SET v_sqlStatisM = ""; 

    SET v_ranking = ""; 

    SET @v_StatisM = DATE_FORMAT(v_StatisDate2Week, '%Y%m'); 

    SET @in_StatisM = DATE_FORMAT(in_StatisDate, '%Y%m'); 

	IF EXISTS(SELECT * FROM information_schema.`TABLES` WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = concat('statis_allgames', @in_StatisM,'_users')) THEN

        SET v_sqlStatisM = CONCAT("SELECT StatisDate, Account, CellScore, (WinGold + LostGold) Profit, exchangeRate FROM KYStatisUsers.statis_allgames", @in_StatisM, "_users WHERE StatisDate < DATE('", in_StatisDate, "') "); 

        SET @v_sqlWhere = CONCAT("AND StatisDate >= DATE('", v_StatisDate2Week, "')"); 

        IF NOT @in_StatisM = @v_StatisM THEN

		    SET v_sqlStatisM = CONCAT(v_sqlStatisM, " UNION ALL "); 

        END IF; 

	END IF; 

    IF NOT @in_StatisM = @v_StatisM THEN

	    IF EXISTS(SELECT * FROM information_schema.`TABLES` WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = concat('statis_allgames', @v_StatisM,'_users')) THEN

            SET v_sqlStatisM = CONCAT(v_sqlStatisM, " SELECT StatisDate, Account, CellScore, (WinGold + LostGold) Profit, exchangeRate FROM KYStatisUsers.statis_allgames", @v_StatisM, "_users "); 

            SET @v_sqlWhere = CONCAT("WHERE StatisDate >= DATE('", v_StatisDate2Week, "')"); 

        END IF; 

    END IF; 

    SET v_sqlStatisM = CONCAT('select StatisDate, Account, SUM(CellScore * exchangeRate) AS CellScore, SUM(Profit * exchangeRate) Profit FROM (', v_sqlStatisM, @v_sqlWhere, ' ) A GROUP BY StatisDate, Account '); 



    SET v_sql = CONCAT("INSERT IGNORE INTO KYStatisUsers.dayrecord_vvip_users (StatisDate, account, lastlogintime, AccountCreateTime) SELECT '", in_StatisDate,"' StatisDate, acc.account, acc.lastlogintime, acc.createdate FROM KYDB_NEW.accounts acc INNER JOIN (", v_sqlStatisM, ") s ON DATE_FORMAT(acc.lastlogintime, '%y-%m-%d') >= DATE('", v_StatisDate2Week,"') AND acc.account = s.Account "); 



    -- 近14天内有上线 且 14天内合计投注金额前两百名

    SET v_ranking = CONCAT("ORDER BY s.CellScore DESC LIMIT 0, ", v_MaxCount); 

    SET @v_sql = CONCAT(v_sql, v_ranking); 

    PREPARE stmt FROM @v_sql; 

    EXECUTE stmt; 

    DEALLOCATE PREPARE stmt; 



    -- 近14天内有上线 且 14天内合计输赢金额前两百名

    SET v_ranking = CONCAT("ORDER BY s.Profit DESC LIMIT 0, ", v_MaxCount); 

    SET @v_sql = CONCAT(v_sql, v_ranking); 

    PREPARE stmt FROM @v_sql; 

    EXECUTE stmt; 

    DEALLOCATE PREPARE stmt; 



    SET v_endtime = CURRENT_TIMESTAMP(); 

    INSERT INTO KYStatisUsers.event_log_record (sp_name, starttime, endtime, exectime,mark) VALUES ("sp_UpdateDayrecordVvipUsers", v_starttime, v_endtime, TIMESTAMPDIFF(SECOND, v_starttime, v_endtime), in_StatisDate); 



    CALL sp_StatisVvipUsers(in_StatisDate); 

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
DROP EVENT IF EXISTS `event_00_20_sp_StatisUsersDayData`;
CREATE DEFINER=`root`@`%` EVENT `event_00_20_sp_StatisUsersDayData` ON SCHEDULE EVERY 1 DAY STARTS '2021-06-21 00:20:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call KYStatisUsers.sp_StatisUsersDayData(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_01_20_sp_StatisUsersDayData_allusers`;
CREATE DEFINER=`root`@`%` EVENT `event_01_20_sp_StatisUsersDayData_allusers` ON SCHEDULE EVERY 1 DAY STARTS '2021-06-22 03:20:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call KYStatisUsers.sp_StatisUsersDayData_allusers(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_06_30_sp_StatisUsersDayData_room`;
CREATE DEFINER=`root`@`%` EVENT `event_06_30_sp_StatisUsersDayData_room` ON SCHEDULE EVERY 1 DAY STARTS '2021-06-22 06:30:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO CALL KYStatisUsers.sp_StatisUsersDayData_room (NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_StatisUsersData_EveryDay`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_StatisUsersData_EveryDay` ON SCHEDULE EVERY 1 DAY STARTS '2021-09-08 02:30:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_StatisUsersData_EveryDay(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_UpdateDayrecordVvipUsers_00:30`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_UpdateDayrecordVvipUsers_00:30` ON SCHEDULE EVERY 1 DAY STARTS '2023-01-01 00:30:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call `KYStatisUsers`.`sp_UpdateDayrecordVvipUsers`(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

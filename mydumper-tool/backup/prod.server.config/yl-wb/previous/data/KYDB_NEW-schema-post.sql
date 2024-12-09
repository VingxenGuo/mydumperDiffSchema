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
DROP FUNCTION IF EXISTS `DLRecursive`;
CREATE DEFINER=`root`@`%` FUNCTION `DLRecursive`(`id` int) RETURNS varchar(500) CHARSET utf8mb4
BEGIN
    DECLARE sTemp VARCHAR(4000); 
    DECLARE sTempChd VARCHAR(4000); 

    SET sTemp=''; 
    SET sTempChd = CAST(id AS CHAR); 
    SET sTemp = CONCAT(sTemp,'',sTempChd); 

    SELECT UID INTO sTempChd FROM KYDB_NEW.Sys_ProxyAccount WHERE channelId = sTempChd ORDER BY channelid ASC; 
    WHILE sTempChd <> 0 DO
    SET sTemp = CONCAT(sTemp,',',sTempChd); 
    SELECT UID INTO sTempChd FROM KYDB_NEW.Sys_ProxyAccount WHERE channelId = sTempChd ORDER BY channelid ASC; 
    END WHILE; 
    RETURN sTemp; 
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
DROP FUNCTION IF EXISTS `GetChildrenOrgOfHr`;
CREATE DEFINER=`root`@`%` FUNCTION `GetChildrenOrgOfHr`(`id` int) RETURNS text CHARSET utf8mb4
BEGIN
DECLARE oTemp text; 
DECLARE oTempChild text; 

SET oTemp = ''; 
SET oTempChild = CAST(id AS CHAR); 

WHILE oTempChild IS NOT NULL
DO
SET oTemp = CONCAT(oTemp,',',oTempChild); 
SELECT  GROUP_CONCAT(ChannelID) INTO oTempChild  FROM Sys_ProxyAccount WHERE FIND_IN_SET(UID,oTempChild) > 0; 
END WHILE; 
RETURN oTemp; 
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
DROP FUNCTION IF EXISTS `selRecursive`;
CREATE DEFINER=`root`@`%` FUNCTION `selRecursive`(`id` int) RETURNS longtext CHARSET utf8mb4 COLLATE utf8mb4_bin
BEGIN
	DECLARE v_return longtext; 
	DECLARE v_channelId longtext; 

	SET v_return = '$'; 
	SET v_channelId = CAST(id AS CHAR); 

	WHILE v_channelId IS NOT NULL DO
		SET v_return = CONCAT(v_return,',',v_channelId); 
		SELECT GROUP_CONCAT(channelid) INTO v_channelId FROM KYDB_NEW.Sys_ProxyAccount WHERE FIND_IN_SET(uid,v_channelId); 
	END WHILE; 

	RETURN v_return; 
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
DROP FUNCTION IF EXISTS `selRecursiveWithChild`;
CREATE DEFINER=`root`@`%` FUNCTION `selRecursiveWithChild`(`ids` varchar(1000)) RETURNS text CHARSET utf8mb4
BEGIN
	DECLARE v_return TEXT; 
	DECLARE v_channelId TEXT; 
	DECLARE s_split VARCHAR(3); 

	SET v_return = ''; 
	SET s_split=','; 

	SET @i = LENGTH(ids) - LENGTH(replace(ids,s_split,''));  
	SET @left_str = ids; 

	WHILE @i >= 0 DO

		IF @i=0 THEN
			SET @n = trim(@left_str); 
		ELSE
			SET @sub_str = substr(@left_str, 1, instr(@left_str,s_split) - 1); 
			SET @left_str = substr(@left_str, LENGTH(@sub_str) + LENGTH(s_split) + 1);     
			SET @n = trim(@sub_str); 
		END IF; 

		SET v_channelId = CAST(@n AS CHAR); 
	
		WHILE v_channelId IS NOT NULL DO
			SET v_return = CONCAT(v_channelId,',',v_return); 
			SELECT GROUP_CONCAT(id) INTO v_channelId FROM KYDB_NEW.agent WHERE FIND_IN_SET(uid,v_channelId); 
		END WHILE; 
		
		SET @i = @i-1; 
	
	END WHILE; 
	
	RETURN LEFT(v_return, LENGTH(v_return) - 1); 
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
DROP FUNCTION IF EXISTS `UserRecursive1`;
CREATE DEFINER=`root`@`%` FUNCTION `UserRecursive1`(`_id` int) RETURNS varchar(500) CHARSET utf8mb4
BEGIN
DECLARE sTemp VARCHAR(4000); 
DECLARE sTempChd VARCHAR(4000); 

SET sTemp=''; 
SET sTempChd = CAST(_id AS CHAR); 
SET sTemp = CONCAT(sTemp,'',sTempChd); 

SELECT UID INTO sTempChd FROM game_manage.rp_user  WHERE id = sTempChd order by id asc  ; 
WHILE sTempChd <> 0 DO
SET sTemp = CONCAT(sTemp,',',sTempChd); 
SELECT UID INTO sTempChd FROM game_manage.rp_user  WHERE id = sTempChd order by id asc  ; 
END WHILE; 
RETURN sTemp; 
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
DROP PROCEDURE IF EXISTS `sp_AgentAccessGame`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_AgentAccessGame`(IN `limits` INT,IN `beginDate` varchar(30))
BEGIN
    DECLARE s_date VARCHAR(30); 
    DECLARE e_date VARCHAR(30); 
    DECLARE s_month VARCHAR(30); 
    DECLARE e_month VARCHAR(30); 
    DECLARE v_starttime TIMESTAMP(3); 
    DECLARE v_endtime TIMESTAMP(3); 
    DECLARE h_date VARCHAR(30); 

    set v_starttime=CURRENT_TIMESTAMP(3); 

    IF limits IS NULL THEN
        SET limits=2; 
    END IF; 


    IF beginDate IS NOT NULL THEN
        SET s_date=DATE_ADD(beginDate,INTERVAL -3 DAY); 
        SET e_date=DATE_ADD(beginDate,INTERVAL -1 DAY); 
        SET h_date=DATE_ADD(beginDate,INTERVAL -2 DAY); 
        SET s_month=CONCAT(DATE_FORMAT(DATE_ADD(beginDate,INTERVAL -1 MONTH),'%Y-%m'),'-0'); 
        SET e_month=CONCAT(DATE_FORMAT(beginDate,'%Y-%m'),'-0'); 
    ELSE
        SET s_date=DATE_ADD(CURRENT_DATE(),INTERVAL -3 DAY); 
        SET e_date=DATE_ADD(CURRENT_DATE(),INTERVAL -1 DAY); 
        SET h_date=DATE_ADD(CURRENT_DATE(),INTERVAL -2 DAY); 
        SET s_month=CONCAT(DATE_FORMAT(DATE_ADD(CURRENT_DATE(),INTERVAL -1 MONTH),'%Y-%m'),'-0'); 
        SET e_month=CONCAT(DATE_FORMAT(CURRENT_DATE(),'%Y-%m'),'-0'); 
    END IF; 


    REPLACE INTO KYStatis.agent_access_game_history(`ChannelID`,`GameID`,`GameStatus`,`GameName`,`CellScore`,`StatisDate`)
    SELECT `ChannelID`,`GameID`,`GameStatus`,`GameName`,`CellScore`,h_date
    FROM `KYStatis`.`agent_access_game`; 

    TRUNCATE KYStatis.agent_access_game; 

    TRUNCATE KYStatis.agent_access_game_3d; 

    INSERT INTO KYStatis.agent_access_game_3d
    SELECT *
    FROM KYStatis.statis_record_agent_game
    WHERE StatisDate >= s_date and StatisDate <=  e_date; 

    INSERT INTO KYStatis.agent_access_game (`ChannelID`,`GameID`,`GameStatus`,`GameName`,`CellScore`)
    SELECT b.`ChannelID`,a.`GameID`,1, a.`GameName`,0
    FROM  KYDB_NEW.GameInfo a
    INNER JOIN KYDB_NEW.Sys_ProxyAccount b ON b.ChannelID IS NOT NULL; 

    UPDATE KYStatis.agent_access_game as a,
    ( SELECT DISTINCT ChannelID,GameID
      FROM KYStatis.agent_access_game_3d
      WHERE ActiveUsers >= limits AND StatisDate BETWEEN s_date AND e_date) as b
    SET a.`GameStatus` = 0
    WHERE a.`ChannelID`= b.ChannelID AND  a.`GameID`=b.GameID; 

    UPDATE KYStatis.agent_access_game as a,
    (
        SELECT SUM( CellScore * exchangeRate ) AS CellScore,ChannelID
        FROM KYStatis.statis_record_agent_all
        WHERE StatisDate < e_month AND StatisDate > s_month
        GROUP BY ChannelID
    ) as b
    SET a.CellScore=b.CellScore WHERE a.ChannelID=b.ChannelID; 

    set v_endtime=CURRENT_TIMESTAMP(); 

    insert into KYStatis.prolog values(NOW(),'KYDB_NEW.sp_AgentAccessGame',TIMESTAMPDIFF(SECOND,v_starttime,v_endtime)); 
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
DROP PROCEDURE IF EXISTS `sp_createTableMonthly`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_createTableMonthly`(IN `in_StatisDate` DATE)
BEGIN
    DECLARE this_month VARCHAR(30); 
    DECLARE next_month VARCHAR(30); 
    DECLARE v_tblname VARCHAR(100); 
    DECLARE done INT DEFAULT FALSE; 
    DECLARE cur_Gameid INT; 
    DECLARE cur_GameParameter VARCHAR(255); 
    DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

    -- 判斷輸入日期是否為 NULL
    IF in_StatisDate IS NULL THEN
        SET in_StatisDate = CURDATE(); 
    END IF; 

    -- 設置當前月份和下個月份
    SET this_month = DATE_FORMAT(in_StatisDate, '%Y%m'); 
    SET next_month = DATE_FORMAT(DATE_ADD(in_StatisDate, INTERVAL 1 month), '%Y%m'); 

-- KYStatisUsers 各遊戲月表

    OPEN cur1; 

    read_loop: LOOP
        FETCH cur1 INTO cur_Gameid, cur_GameParameter; 

        IF done THEN
            LEAVE read_loop; 
        END IF; 

        -- 如果 Gameid 為 620，將參數設置為 'dzpk'
        IF cur_Gameid = 620 THEN
            SET cur_GameParameter = 'dzpk'; 
        END IF; 

        SET v_tblname = CONCAT(cur_GameParameter, '_gameRecord'); 

        -- 檢查表是否存在於 'detail_record' 中
        IF EXISTS (SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'detail_record' 
                    AND TABLE_NAME = v_tblname) THEN 

--             -- 檢查統計用戶的表是否存在於當月
            IF NOT EXISTS (SELECT * FROM information_schema.TABLES 
                            WHERE TABLE_SCHEMA = 'KYStatisUsers' 
                            AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, this_month, '_users')) THEN
                CALL `KYStatisUsers`.`sp_createStatisticsUsersTable`(CONCAT('statis_', cur_GameParameter, this_month, '_users'), 0); 
            END IF; 

            IF NOT EXISTS (SELECT * FROM information_schema.TABLES 
                            WHERE TABLE_SCHEMA = 'KYStatisUsers' 
                            AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, this_month, '_users_room')) THEN
                CALL `KYStatisUsers`.`sp_createStatisticsUsersTable`(CONCAT('statis_', cur_GameParameter, this_month, '_users_room'), 2); 
            END IF; 

            IF NOT EXISTS (SELECT * FROM information_schema.TABLES 
                            WHERE TABLE_SCHEMA = 'KYStatisUsers_BST' 
                            AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, this_month, '_users')) THEN
                CALL `KYStatisUsers_BST`.`sp_createStatisticsUsersTable`(CONCAT('statis_', cur_GameParameter, this_month, '_users'), 0); 
            END IF; 

            IF NOT EXISTS (SELECT * FROM information_schema.TABLES 
                            WHERE TABLE_SCHEMA = 'KYStatisUsers_EST' 
                            AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, this_month, '_users')) THEN
                CALL `KYStatisUsers_EST`.`sp_createStatisticsUsersTable`(CONCAT('statis_', cur_GameParameter, this_month, '_users'), 0); 
            END IF; 

            -- 檢查統計用戶的表是否存在於下個月
            IF NOT EXISTS (SELECT * FROM information_schema.TABLES 
                            WHERE TABLE_SCHEMA = 'KYStatisUsers' 
                            AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, next_month, '_users')) THEN
                CALL `KYStatisUsers`.`sp_createStatisticsUsersTable`(CONCAT('statis_', cur_GameParameter, next_month, '_users'), 0); 
            END IF; 

            IF NOT EXISTS (SELECT * FROM information_schema.TABLES 
                            WHERE TABLE_SCHEMA = 'KYStatisUsers' 
                            AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, next_month, '_users_room')) THEN                        
                CALL `KYStatisUsers`.`sp_createStatisticsUsersTable`(CONCAT('statis_', cur_GameParameter, next_month, '_users_room'), 2); 
            END IF; 

            IF NOT EXISTS (SELECT * FROM information_schema.TABLES 
                            WHERE TABLE_SCHEMA = 'KYStatisUsers_BST' 
                            AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, next_month, '_users')) THEN    
                CALL `KYStatisUsers_BST`.`sp_createStatisticsUsersTable`(CONCAT('statis_', cur_GameParameter, next_month, '_users'), 0); 
            END IF; 

            IF NOT EXISTS (SELECT * FROM information_schema.TABLES 
                            WHERE TABLE_SCHEMA = 'KYStatisUsers_EST' 
                            AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, next_month, '_users')) THEN  
                CALL `KYStatisUsers_EST`.`sp_createStatisticsUsersTable`(CONCAT('statis_', cur_GameParameter, next_month, '_users'), 0); 
            END IF; 

        END IF; 

    END LOOP; 

    -- 關閉游標
    CLOSE cur1; 

-- KYStatisUsers 月總表

    IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisUsers' 
                    AND TABLE_NAME = CONCAT('statis_allgames',this_month,'_users')) THEN
		CALL `KYStatisUsers`.`sp_createStatisticsUsersTable`(CONCAT('statis_allgames',this_month,'_users'),0); 
		CALL `KYStatisUsers_BST`.`sp_createStatisticsUsersTable`(CONCAT('statis_allgames',this_month,'_users'),0); 
        CALL `KYStatisUsers_EST`.`sp_createStatisticsUsersTable`(CONCAT('statis_allgames',this_month,'_users'),0); 
    END IF; 

    IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisUsers' 
                    AND TABLE_NAME = CONCAT('statis_allgames',next_month,'_users')) THEN
		CALL `KYStatisUsers`.`sp_createStatisticsUsersTable`(CONCAT('statis_allgames',next_month,'_users'),0); 
        CALL `KYStatisUsers_BST`.`sp_createStatisticsUsersTable`(CONCAT('statis_allgames',next_month,'_users'),0); 
        CALL `KYStatisUsers_EST`.`sp_createStatisticsUsersTable`(CONCAT('statis_allgames',next_month,'_users'),0); 
    END IF; 

    IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisUsers' 
                    AND TABLE_NAME = CONCAT('statis_month',this_month,'_users')) THEN
        CALL `KYStatisUsers`.`sp_createStatisticsUsersTable`(CONCAT('statis_month', this_month, '_users'),1); 
    END IF; 

    IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisUsers' 
                    AND TABLE_NAME = CONCAT('statis_month',next_month,'_users')) THEN
		CALL `KYStatisUsers`.`sp_createStatisticsUsersTable`(CONCAT('statis_month',next_month,'_users'),1); 
    END IF; 

    IF NOT EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = CONCAT('statis_all_users')) THEN
		CALL `KYStatisUsers`.`sp_createStatisticsUsersTable`(CONCAT('statis_all_users'),1); 
    END IF; 


-- KYStatisLogin 月總表

-- statis_keep_login users/validusers
	IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_keep_login_users_', this_month)) THEN
		CALL `KYStatisLogin`.`sp_createKeepLoginTable`(CONCAT('statis_keep_login_users_', this_month),0);	
    END IF; 

    IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_keep_login_users_', next_month)) THEN
		CALL `KYStatisLogin`.`sp_createKeepLoginTable`(CONCAT('statis_keep_login_users_', next_month),0);	
    END IF; 

	IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_keep_login_validusers_', this_month)) THEN
		CALL `KYStatisLogin`.`sp_createKeepLoginTable`(CONCAT('statis_keep_login_validusers_', this_month),0);	
    END IF; 

    IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_keep_login_validusers_', next_month)) THEN
		CALL `KYStatisLogin`.`sp_createKeepLoginTable`(CONCAT('statis_keep_login_validusers_', next_month),0);	
    END IF; 

-- KYStatisLogin.sp_createTable 

-- 0. statis_login_game_detail_this_month
	IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_login_game_detail_', this_month)) THEN
		CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_login_game_detail_', this_month),0); 
	END IF; 

    IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_login_game_detail_', next_month)) THEN
		CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_login_game_detail_', next_month),0); 
	END IF; 

-- 1. statis_login_game_sum_this_month
	IF NOT EXISTS(SELECT * FROM information_schema.TABLES
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_login_game_sum_', this_month)) THEN
		CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_login_game_sum_', this_month),1); 
	END IF; 

    IF NOT EXISTS(SELECT * FROM information_schema.TABLES
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_login_game_sum_', next_month)) THEN
		CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_login_game_sum_', next_month),1); 
	END IF; 

-- 3. statis_login_hall_month_this_month
	IF NOT EXISTS(SELECT * FROM information_schema.TABLES
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_login_hall_month_', this_month)) THEN
		CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_login_hall_month_', this_month),3); 
	END IF; 

	IF NOT EXISTS(SELECT * FROM information_schema.TABLES
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_login_hall_month_', next_month)) THEN
		CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_login_hall_month_', next_month),3); 
	END IF; 

-- 4. statis_agent_orders_detail_this_month
	IF NOT EXISTS(SELECT * FROM information_schema.TABLES
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_agent_orders_detail_', this_month)) THEN
		CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_agent_orders_detail_', this_month),4); 
	END IF; 

    IF NOT EXISTS(SELECT * FROM information_schema.TABLES
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_agent_orders_detail_', next_month)) THEN
		CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_agent_orders_detail_', next_month),4); 
	END IF; 

-- 5. statis_login_game_month_this_month
	IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_login_game_month_', this_month)) THEN
		CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_login_game_month_', this_month),5); 
	END IF; 

    IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_login_game_month_', next_month)) THEN
		CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_login_game_month_', next_month),5); 
	END IF; 


-- 6. statis_agent_orders_month_
	IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_agent_orders_month_', this_month)) THEN
		CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_agent_orders_month_', this_month),6); 
	END IF; 

    IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_agent_orders_month_', next_month)) THEN
		CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_agent_orders_month_', next_month),6); 
	END IF; 


-- 7. statis_login_hall_detail_this_month
    IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_login_hall_detail_', this_month)) THEN
		CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_login_hall_detail_', this_month),7); 
	END IF; 

    IF NOT EXISTS(SELECT * FROM information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_login_hall_detail_', next_month)) THEN
		CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_login_hall_detail_', next_month),7); 
	END IF; 

-- 8. statis_location_game_this_month
    IF NOT EXISTS (SELECT * from information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_location_game_',this_month)) THEN
        CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_location_game_',this_month), 8); 
    END IF; 

    IF NOT EXISTS (SELECT * from information_schema.TABLES 
                    WHERE TABLE_SCHEMA = 'KYStatisLogin' 
                    AND TABLE_NAME = CONCAT('statis_location_game_',next_month)) THEN
        CALL `KYStatisLogin`.`sp_createTable`(CONCAT('statis_location_game_',next_month), 8); 
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
DROP PROCEDURE IF EXISTS `sp_cron_partition`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_cron_partition`()
BEGIN

	DECLARE v_sql LONGTEXT; 

	DECLARE v_nextDate varchar(12);	

	DECLARE v_nextPartitionAbbr varchar(20); 

	DECLARE v_nextPartitionDateFormat varchar(20); 

	DECLARE v_nextIntervalForDay INT; 

	DECLARE v_accumulator INT; 

	

	DECLARE v_starttime TIMESTAMP(3); 

	DECLARE v_endtime TIMESTAMP(3); 



	DECLARE cursorPartitionDatabase varchar(30); 

	DECLARE cursorPartitionTable varchar(50); 

	DECLARE cursorPartitionType varchar(20); 

	DECLARE cursorPartitionColumns varchar(20); 

	DECLARE cursorPartitionFunction varchar(30); 

	

	DECLARE done BOOLEAN DEFAULT 0; 

	-- 取Sys_cron_partition 這張表的資料

	DECLARE cronPartition CURSOR FOR select PartitionDatabase, PartitionTable, PartitionType, PartitionColumns, PartitionFunction from KYDB_NEW.Sys_cron_partition where PartitionStatus = 1; 

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

	

	set v_starttime = CURRENT_TIMESTAMP(3); 

	-- 	loop partition procedure

	OPEN cronPartition; 

		partitionLoop: LOOP

			FETCH cronPartition INTO cursorPartitionDatabase, cursorPartitionTable, cursorPartitionType, cursorPartitionColumns, cursorPartitionFunction; 

			-- 如果找不到值就跳出

			IF done THEN

				LEAVE partitionLoop; 

			END IF; 

					

			set v_sql = '';														

			-- 判斷時間類型(月)

			IF cursorPartitionType = 'month' THEN

				set v_nextDate = DATE_FORMAT(DATE_ADD(NOW(), interval 1 MONTH), '%Y%m');				

				set v_nextPartitionAbbr = concat('p_', v_nextDate); 

				set @v_nextDate = DATE_FORMAT(DATE_ADD(NOW(), interval 2 MONTH), '%Y%m'); 

				set @v_nextPartitionAbbr = concat('p_', @v_nextDate);		

				IF cursorPartitionFunction = 'UNIX_TIMESTAMP' THEN

					set v_nextPartitionDateFormat = concat(DATE_FORMAT(DATE_ADD(NOW(), interval 1 MONTH), '%Y-%m'),'-01 00:00:00');				

					set @v_nextPartitionDateFormat = concat(DATE_FORMAT(DATE_ADD(NOW(), interval 2 MONTH), '%Y-%m'),'-01 00:00:00');				

				ELSEIF cursorPartitionFunction = 'TO_DAYS' THEN

					set v_nextPartitionDateFormat = concat(DATE_FORMAT(DATE_ADD(NOW(), interval 1 MONTH), '%Y-%m'),'-01');				

					set @v_nextPartitionDateFormat = concat(DATE_FORMAT(DATE_ADD(NOW(), interval 2 MONTH), '%Y-%m'),'-01');		

				END IF; 

				-- 如果完全沒有宣告過partition

				IF EXISTS( SELECT PARTITION_NAME FROM information_schema.`PARTITIONS` WHERE table_schema = cursorPartitionDatabase AND table_name = cursorPartitionTable and partition_name IS NULL) THEN					

					set v_sql = concat( 'ALTER TABLE ', cursorPartitionDatabase, '.', cursorPartitionTable, ' PARTITION BY RANGE ( ', cursorPartitionFunction, '(`', cursorPartitionColumns, '`)) ( PARTITION ', v_nextPartitionAbbr, ' VALUES LESS THAN (', cursorPartitionFunction, '(''', v_nextPartitionDateFormat, ''')))' );						

					select v_sql; 

					set @v_sql = v_sql; 

					PREPARE stmt from @v_sql; 

					execute stmt; 

					DEALLOCATE PREPARE stmt; 

				END IF; 

				-- 如果下次要新增的partition沒有

				IF NOT EXISTS( SELECT * FROM information_schema.`PARTITIONS` WHERE table_schema = cursorPartitionDatabase AND table_name = cursorPartitionTable and partition_name = @v_nextPartitionAbbr) THEN    																

					set v_sql = concat( 'ALTER TABLE ', cursorPartitionDatabase, '.', cursorPartitionTable , ' ADD PARTITION ( PARTITION ', @v_nextPartitionAbbr , ' VALUES LESS THAN (', cursorPartitionFunction, '(''', @v_nextPartitionDateFormat, ''')))' );									

					select v_sql; 

					set @v_sql = v_sql;					

					PREPARE stmt from @v_sql; 

					execute stmt; 

					DEALLOCATE PREPARE stmt; 

				END IF;								

			END IF;	

			-- 判斷時間類型(日) -> 往後加兩天

			IF cursorPartitionType = 'day' THEN

				set v_accumulator = 0; 

				set v_nextIntervalForDay = 2; 

				while v_accumulator <= v_nextIntervalForDay DO

					set v_nextDate = DATE_FORMAT(DATE_ADD(NOW(), interval v_accumulator + 1 DAY), '%Y%m%d'); 

					select v_nextDate; 

					set v_nextPartitionAbbr = concat('p_', v_nextDate); 

					IF cursorPartitionFunction = 'UNIX_TIMESTAMP' THEN

						set v_nextPartitionDateFormat = concat(DATE_FORMAT(DATE_ADD(NOW(), interval v_accumulator + 1 DAY), '%Y-%m-%d'),' 00:00:00'); 

					ELSEIF cursorPartitionFunction = 'TO_DAYS' THEN

						set v_nextPartitionDateFormat = DATE_FORMAT(DATE_ADD(NOW(), interval v_accumulator + 1 DAY), '%Y-%m-%d'); 

					END IF; 

					-- 如果完全沒有宣告過partition

					IF EXISTS( SELECT PARTITION_NAME FROM information_schema.`PARTITIONS` WHERE table_schema = cursorPartitionDatabase AND table_name = cursorPartitionTable and partition_name IS NULL) THEN					

						set v_sql = concat( 'ALTER TABLE ', cursorPartitionDatabase, '.', cursorPartitionTable, ' PARTITION BY RANGE ( ', cursorPartitionFunction, '(`', cursorPartitionColumns, '`)) ( PARTITION ', v_nextPartitionAbbr, ' VALUES LESS THAN (', cursorPartitionFunction, '(''', v_nextPartitionDateFormat, ''')))' );									

						select v_sql; 

						set @v_sql = v_sql; 

						PREPARE stmt from @v_sql; 

						execute stmt; 

						DEALLOCATE PREPARE stmt; 

					END IF; 

					-- 如果下次要新增的partition沒有

					IF NOT EXISTS( SELECT * FROM information_schema.`PARTITIONS` WHERE table_schema = cursorPartitionDatabase AND table_name = cursorPartitionTable and partition_name = v_nextPartitionAbbr) THEN    											

						set v_sql = concat( 'ALTER TABLE ', cursorPartitionDatabase, '.', cursorPartitionTable , ' ADD PARTITION ( PARTITION ', v_nextPartitionAbbr , ' VALUES LESS THAN (', cursorPartitionFunction, '(''', v_nextPartitionDateFormat, ''')))' );									

						select v_sql; 

						set @v_sql = v_sql;					

						PREPARE stmt from @v_sql; 

						execute stmt; 

						DEALLOCATE PREPARE stmt; 

					END IF;	

					set v_accumulator = v_accumulator + 1; 

				end while; 

			END IF;								

			END LOOP partitionLoop; 

	CLOSE cronPartition; 

	-- 	紀錄備查

	set v_endtime = CURRENT_TIMESTAMP(); 

	insert into KYStatis.prolog values(NOW(),'KYDB_NEW.sp_cron_partition',TIMESTAMPDIFF(SECOND,v_starttime,v_endtime)); 


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
DROP PROCEDURE IF EXISTS `sp_cron_partition_single_table`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_cron_partition_single_table`(IN `NewDatabase` VARCHAR(30), IN `NewTable` VARCHAR(50))
BEGIN
    DECLARE v_sql LONGTEXT; 
    DECLARE v_nextDate VARCHAR(12);    
    DECLARE v_nextPartitionAbbr VARCHAR(20); 
    DECLARE v_nextPartitionDateFormat VARCHAR(20); 
    DECLARE v_nextIntervalForDay INT; 
    DECLARE v_accumulator INT; 
    DECLARE v_startTime TIMESTAMP(3); 
    DECLARE v_endTime TIMESTAMP(3); 

    DECLARE errorMessage VARCHAR(50); 
    DECLARE cursorPartitionDatabase VARCHAR(50); 
    DECLARE cursorPartitionTable VARCHAR(50); 
    DECLARE cursorPartitionType VARCHAR(50); 
    DECLARE cursorPartitionColumns VARCHAR(50); 
    DECLARE cursorPartitionFunction VARCHAR(50);   

    -- 取Sys_cron_partition 這張表的資料
    SELECT 
        PartitionDatabase,
        PartitionTable,
        PartitionType,
        PartitionColumns,
        PartitionFunction
    INTO 
        cursorPartitionDatabase,
        cursorPartitionTable,
        cursorPartitionType,
        cursorPartitionColumns,
        cursorPartitionFunction
    FROM Sys_cron_partition
    WHERE PartitionStatus = 1
    AND PartitionDatabase = NewDatabase
    AND PartitionTable = NewTable; 

    SET v_startTime = CURRENT_TIMESTAMP(3); 

    SET v_sql = ''; 
    SET errorMessage = ''; 

    -- 沒資料就跳訊息
    IF cursorPartitionType IS NULL THEN
        SELECT 'No data found. Execution cancelled.' INTO errorMessage; 
    END IF; 

    -- 判斷時間類型(月)
    IF cursorPartitionType = 'month' THEN
        SET v_nextDate = DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 1 MONTH), '%Y%m'); 
        SET v_nextPartitionAbbr = CONCAT('p_', v_nextDate); 
        SET @v_nextDate = DATE_FORMAT(DATE_ADD(NOW(), INTERVAL 2 MONTH), '%Y%m'); 
        SET @v_nextPartitionAbbr = CONCAT('p_', @v_nextDate); 

        IF cursorPartitionFunction = 'UNIX_TIMESTAMP' THEN
            SET v_nextPartitionDateFormat = CONCAT(DATE_FORMAT(DATE_ADD(NOW(), interval 1 MONTH), '%Y-%m'),'-01 00:00:00'); 
            SET @v_nextPartitionDateFormat = CONCAT(DATE_FORMAT(DATE_ADD(NOW(), interval 2 MONTH), '%Y-%m'),'-01 00:00:00'); 
        ELSEIF cursorPartitionFunction = 'TO_DAYS' THEN
            SET v_nextPartitionDateFormat = CONCAT(DATE_FORMAT(DATE_ADD(NOW(), interval 1 MONTH), '%Y-%m'),'-01'); 
            SET @v_nextPartitionDateFormat = CONCAT(DATE_FORMAT(DATE_ADD(NOW(), interval 2 MONTH), '%Y-%m'),'-01'); 
        END IF; 

		-- 如果完全沒有宣告過partition
		IF EXISTS( SELECT PARTITION_NAME FROM information_schema.`PARTITIONS` WHERE table_schema = cursorPartitionDatabase AND table_name = cursorPartitionTable AND partition_name IS NULL) THEN					
			SET v_sql = CONCAT( 
                'ALTER TABLE ', cursorPartitionDatabase, '.', cursorPartitionTable, 
                ' PARTITION BY RANGE ( ', cursorPartitionFunction, '(`', cursorPartitionColumns, '`)) 
                ( PARTITION ', v_nextPartitionAbbr, ' VALUES LESS THAN (', cursorPartitionFunction, '(''', v_nextPartitionDateFormat, ''')))' ); 
            SELECT v_sql; 
            SET @v_sql = v_sql; 
            PREPARE stmt FROM @v_sql; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt;				
		END IF; 
		-- 如果下次要新增的partition沒有
		IF NOT EXISTS( SELECT * FROM information_schema.`PARTITIONS` WHERE table_schema = cursorPartitionDatabase AND table_name = cursorPartitionTable AND partition_name = @v_nextPartitionAbbr) THEN
            SET v_sql = CONCAT( 
                'ALTER TABLE ', cursorPartitionDatabase, '.', cursorPartitionTable ,
                ' ADD PARTITION ( PARTITION ', @v_nextPartitionAbbr , ' VALUES LESS THAN (', cursorPartitionFunction, '(''', @v_nextPartitionDateFormat, ''')))' ); 
            SELECT v_sql; 
            SET @v_sql = v_sql; 
            PREPARE stmt FROM @v_sql; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
        END IF; 
    END IF; 

    -- 判斷時間類型(日) -> 往後加兩天
    IF cursorPartitionType = 'day' THEN
        SET v_accumulator = 0; 
        SET v_nextIntervalForDay = 2; 
        WHILE v_accumulator <= v_nextIntervalForDay DO
            SET v_nextDate = DATE_FORMAT(DATE_ADD(NOW(), interval v_accumulator + 1 DAY), '%Y%m%d'); 
            SET v_nextPartitionAbbr = CONCAT('p_', v_nextDate); 
            IF cursorPartitionFunction = 'UNIX_TIMESTAMP' THEN
                SET v_nextPartitionDateFormat = CONCAT(DATE_FORMAT(DATE_ADD(NOW(), interval v_accumulator + 1 DAY), '%Y-%m-%d'),' 00:00:00'); 
            ELSEIF cursorPartitionFunction = 'TO_DAYS' THEN
                SET v_nextPartitionDateFormat = DATE_FORMAT(DATE_ADD(NOW(), interval v_accumulator + 1 DAY), '%Y-%m-%d'); 
            END IF; 

			-- 如果完全沒有宣告過partition
			IF EXISTS( SELECT PARTITION_NAME FROM information_schema.`PARTITIONS` WHERE table_schema = cursorPartitionDatabase AND table_name = cursorPartitionTable AND partition_name IS NULL) THEN					
				SET v_sql = CONCAT( 
                    'ALTER TABLE ', cursorPartitionDatabase, '.', cursorPartitionTable, 
                    ' PARTITION BY RANGE ( ', cursorPartitionFunction, '(`', cursorPartitionColumns, '`)) 
                    ( PARTITION ', v_nextPartitionAbbr, ' VALUES LESS THAN (', cursorPartitionFunction, '(''', v_nextPartitionDateFormat, ''')))' ); 
                SELECT v_sql; 
                SET @v_sql = v_sql; 
                PREPARE stmt FROM @v_sql; 
                EXECUTE stmt; 
                DEALLOCATE PREPARE stmt; 
			END IF; 
			-- 如果下次要新增的partition沒有
			IF NOT EXISTS( SELECT * FROM information_schema.`PARTITIONS` WHERE table_schema = cursorPartitionDatabase AND table_name = cursorPartitionTable AND partition_name = v_nextPartitionAbbr) THEN    											
				SET v_sql = CONCAT( 
                    'ALTER TABLE ', cursorPartitionDatabase, '.', cursorPartitionTable , 
                    ' ADD PARTITION ( PARTITION ', v_nextPartitionAbbr , ' VALUES LESS THAN (', cursorPartitionFunction, '(''', v_nextPartitionDateFormat, ''')))' ); 
                SELECT v_sql; 
                SET @v_sql = v_sql; 
                PREPARE stmt FROM @v_sql; 
                EXECUTE stmt; 
                DEALLOCATE PREPARE stmt;	
            END IF; 

            SET v_accumulator = v_accumulator + 1; 
        END WHILE; 
    END IF; 
    
    -- 紀錄備查
    IF LENGTH(errorMessage) = 0 THEN 
        SET v_endTime = CURRENT_TIMESTAMP(); 
        INSERT INTO KYStatis.prolog VALUES (NOW(),'KYDB_NEW.sp_cron_partition_single_table',TIMESTAMPDIFF(SECOND,v_startTime,v_endTime)); 
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
DROP PROCEDURE IF EXISTS `sp_DeleteStaticData`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_DeleteStaticData`(IN `agent` varchar(10), IN `staticDate` varchar(10))
BEGIN
    DECLARE v_agent varchar(10); 
    DECLARE v_date varchar(10); 
    DECLARE v_ymDate varchar(10); 
    DECLARE v_allgames_tblname varchar(100); 
    DECLARE v_statis_KYSport_tblname varchar(100); 
    DECLARE v_statis_KYSport_room_tblname varchar(100); 
    DECLARE v_sql LONGTEXT; 

    SET v_agent = agent; 
    SET v_date = DATE_FORMAT(staticDate,'%Y-%m-%d'); 
    SET v_ymDate = DATE_FORMAT(staticDate,'%Y%m'); 
    SET v_allgames_tblname = CONCAT('statis_allgames', v_ymDate, '_users');  
    SET v_statis_KYSport_tblname = CONCAT('statis_KYSport2', v_ymDate, '_users');  
    SET v_statis_KYSport_room_tblname = CONCAT(v_statis_KYSport_tblname, '_room');  

    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers_EST' AND  TABLE_NAME = v_allgames_tblname))
    THEN
        SET v_sql = CONCAT('DELETE FROM KYStatisUsers_EST.', v_allgames_tblname, " WHERE StatisDate = '", v_date, "' AND ChannelID = ", v_agent, ';'); 
        SET @v_sql = v_sql;  
        PREPARE stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt;    
    END IF; 

    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND  TABLE_NAME = v_statis_KYSport_tblname))
    THEN
        SET v_sql = CONCAT('DELETE FROM KYStatisUsers.', v_statis_KYSport_tblname, " WHERE StatisDate = '", v_date, "' AND ChannelID = ", v_agent, ';'); 
        SET @v_sql = v_sql;  
        PREPARE stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt;            
    END IF; 
    
    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND  TABLE_NAME = v_statis_KYSport_room_tblname))
    THEN
        SET v_sql = CONCAT(' DELETE FROM KYStatisUsers.', v_statis_KYSport_room_tblname, " WHERE StatisDate = '", v_date, "' AND ChannelID = ", v_agent, '; '); 
        SET @v_sql = v_sql;  
        PREPARE stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt;            
    END IF; 
    
    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND  TABLE_NAME = 'statis_reg_users'))
    THEN
        SET v_sql = CONCAT(" DELETE FROM KYStatisUsers.statis_reg_users WHERE StatisDate = '", v_date, "';"); 
        SET @v_sql = v_sql;  
        PREPARE stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt;    
    END IF; 
    
    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KYStatis' AND  TABLE_NAME = 'statis_record_agent_all'))
    THEN
        SET v_sql = CONCAT(" DELETE FROM KYStatis.statis_record_agent_all WHERE StatisDate = '", v_date, "' AND ChannelID = ", v_agent, '; '); 
        SET @v_sql = v_sql;  
        PREPARE stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt;            
    END IF;    
    
    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KYStatis' AND  TABLE_NAME = 'statis_record_agent_game'))
    THEN
        SET v_sql = CONCAT(" DELETE FROM KYStatis.statis_record_agent_game WHERE StatisDate = '", v_date, "' AND ChannelID = ", v_agent, ' AND GameID = 7470; ');    
        SET @v_sql = v_sql;  
        PREPARE stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt;            
    END IF;    

    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KYStatis' AND  TABLE_NAME = 'statis_record_agent_linecode'))
    THEN
        SET v_sql = CONCAT(" DELETE FROM KYStatis.statis_record_agent_linecode WHERE StatisDate = '", v_date, "' AND ChannelID = ", v_agent, '; ');    
        SET @v_sql = v_sql;  
        PREPARE stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt;            
    END IF; 
    
    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KYStatis' AND  TABLE_NAME = 'statis_record_agent_linecode_game'))
    THEN
        SET v_sql = CONCAT(" DELETE FROM KYStatis.statis_record_agent_linecode_game WHERE StatisDate = '", v_date, "' AND ChannelID = ", v_agent, ' AND GameID = 7470; '); 
        SET @v_sql = v_sql;  
        PREPARE stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt;            
    END IF;    
    
    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KYStatis' AND  TABLE_NAME = 'statis_record_agent_month'))
    THEN
        SET v_sql = CONCAT(" DELETE FROM KYStatis.statis_record_agent_month WHERE StatisDate = '", v_date, "' AND ChannelID = ", v_agent, '; '); 
        SET @v_sql = v_sql;  
        PREPARE stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt;            
    END IF;    
    
    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KYStatis' AND  TABLE_NAME = 'statis_record_agent_all_reguser'))
    THEN
        SET v_sql = CONCAT(" DELETE FROM KYStatis.statis_record_agent_all_reguser WHERE StatisDate = '", v_date, "' AND ChannelID = ", v_agent, '; '); 
        SET @v_sql = v_sql;  
        PREPARE stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt;            
    END IF;        
    
    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KYStatis' AND  TABLE_NAME = 'statis_record_agent_all_EST'))
    THEN
        SET v_sql = CONCAT(" DELETE FROM KYStatis.statis_record_agent_all_EST WHERE StatisDate = '", v_date, "' AND ChannelID = ", v_agent, '; '); 
        SET @v_sql = v_sql;  
        PREPARE stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt;                
    END IF;        
    
    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KYStatis' AND  TABLE_NAME = 'statis_record_agent_game_EST'))
    THEN
        SET v_sql = CONCAT(" DELETE FROM KYStatis.statis_record_agent_game_EST WHERE StatisDate = '", v_date, "' AND ChannelID = ", v_agent, ' AND GameID = 7470; '); 
        SET @v_sql = v_sql;  
        PREPARE stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt;            
    END IF;        
    
    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KYStatis' AND  TABLE_NAME = 'statis_record_agent_linecode_EST')) 
    THEN
        SET v_sql = CONCAT(" DELETE FROM KYStatis.statis_record_agent_linecode_EST WHERE StatisDate = '", v_date, "' AND ChannelID = ", v_agent, '; '); 
        SET @v_sql = v_sql;  
        PREPARE stmt FROM @v_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt;            
    END IF; 
    
    IF (EXISTS (SELECT * FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'KYStatis' AND  TABLE_NAME = 'statis_record_agent_linecode_game_EST'))
    THEN
        SET v_sql = CONCAT(" DELETE FROM KYStatis.statis_record_agent_linecode_game_EST WHERE StatisDate = '", v_date, "' AND ChannelID = ", v_agent, ' AND GameID = 7470; ');    
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
DROP PROCEDURE IF EXISTS `sp_gameRecordSort`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_gameRecordSort`(IN `currency` varchar(50), IN `kindId` int,IN `accounts` varchar(190),IN `linecode` varchar(190),IN `beginDate` date,IN `endDate` date,IN `sortType` int,IN `pageOffset` int,IN `pageLimit` int,IN `channelId` int,IN `isPage` bit,IN `tmpRecordCount` int, IN `ServerId` int, IN `ProxyId` int)
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
	SET v_sql_tmp = ''; 
	SET v_aTable = ''; 
	SET v_bTable = ''; 
	SET v_beginM = DATE_FORMAT(beginDate,'%Y%m'); 
	SET v_endM = DATE_FORMAT(endDate,'%Y%m'); 

	IF kindId > 0 THEN
		SET v_aTable = 'a.'; 
		SET v_bTable = 'b.'; 
	END IF; 

	-- 組 WHERE
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
		SET v_sqlWhere = CONCAT(v_sqlWhere , ' AND ',v_aTable,'ChannelID = ',ProxyId); 
    END IF; 

    IF LENGTH(currency) > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND ',v_aTable,'currency = ''',currency,''''); 
        SET v_selectName = CONCAT(' ',v_aTable,'Account, ', v_bTable,'LineCode, ', v_aTable,'ChannelID, ', v_aTable,'CellScore, (', v_aTable,'WinGold + ', v_aTable,'LostGold) AS Profit, ',v_aTable,'Revenue, (', v_aTable,'WinNum + ', v_aTable,'LostNum) AS GameNum ' ); 
    ELSE
        SET v_selectName = CONCAT(' ',v_aTable,'Account, ', v_bTable,'LineCode, ', v_aTable,'ChannelID, (', v_aTable,'CellScore * ' , v_aTable,'exchangeRate) AS  CellScore , (', v_aTable,'WinGold + ', v_aTable,'LostGold) * ', v_aTable,'exchangeRate  AS Profit, ',v_aTable,'Revenue *', v_aTable,'exchangeRate AS Revenue, (', v_aTable,'WinNum + ', v_aTable,'LostNum) AS GameNum '); 
    END IF; 



	-- 不選遊戲
	IF kindId = 0 THEN
		SET v_tblName = CONCAT('statis_allgames',v_beginM,'_users'); 
		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblName) THEN
			SET v_sql = CONCAT('SELECT ', v_selectName ,' FROM KYStatisUsers.',v_tblName, v_sqlWhere); 
		END IF; 
		IF v_beginM <> v_endM THEN
			SET v_tblName = CONCAT('statis_allgames',v_endM,'_users'); 
			IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblName) THEN
				SET v_sql = CONCAT(v_sql,' UNION ALL SELECT ', v_selectName,' FROM KYStatisUsers.',v_tblName, v_sqlWhere); 
			END IF; 
		END IF; 
	ELSE  -- 分游戏查询
		SELECT GameParameter INTO v_gameName FROM KYDB_NEW.GameInfo WHERE Gameid = kindId; 

		IF kindId = 620 THEN
			SET v_gameName = 'dzpk'; 
		END IF; 

		IF ServerId > 0 THEN
            SET v_tblName = CONCAT('statis_',v_gameName,v_beginM,'_users_room'); 
		ELSE
            SET v_tblName = CONCAT('statis_',v_gameName,v_beginM,'_users'); 
        END IF ; 

		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblName) THEN
			SET v_sql = CONCAT('SELECT ',v_selectName,'
								FROM KYStatisUsers.',v_tblName,' AS a
								LEFT JOIN game_api.accounts AS b ON a.Account = b.account ',v_sqlWhere); 
		END IF; 
		IF v_beginM <> v_endM THEN
            IF ServerId > 0 THEN
                SET v_tblName = CONCAT('statis_',v_gameName,v_endM,'_users_room'); 
            ELSE
                SET v_tblName = CONCAT('statis_',v_gameName,v_endM,'_users'); 
            END IF ; 

			IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblName) THEN
				SET v_sql = CONCAT(v_sql,' UNION ALL
											SELECT ', v_selectName,'
											FROM KYStatisUsers.',v_tblName,' AS a
											LEFT JOIN game_api.accounts AS b ON a.Account = b.account ',v_sqlWhere); 
			END IF; 
		END IF; 
	END IF; 

	IF LENGTH(v_sql) > 0 THEN

		SET v_sql = CONCAT('SELECT Account, LineCode, ChannelID, SUM(CellScore) AS CellScore, SUM(Profit) AS Profit,
								SUM(Revenue) AS Revenue, SUM(GameNum) AS GameNum
							FROM (', v_sql,') main
							GROUP BY Account, ChannelID'); 

		IF sortType = 0 THEN
			SET v_orderBy = ' ORDER BY AllProfit DESC'; 
		ELSEIF sortType = 1 THEN
			SET v_orderBy = ' ORDER BY AllProfit'; 
		ELSEIF sortType = 2 THEN
			SET v_orderBy = ' ORDER BY Profit DESC'; 
		ELSEIF sortType = 3 THEN
			SET v_orderBy = ' ORDER BY Profit'; 
		END IF; 

    IF LENGTH(currency) > 0 THEN
        SET v_sql = CONCAT('SELECT A.Account, A.LineCode, (B.WinNum+B.LostNum) AS AllGameNum, B.CellScore AS AllCellScore,
							(B.WinGold+B.LostGold) AS AllProfit,B.Revenue AS AllRevenue ,A.CellScore, A.Profit, A.Revenue,
							A.GameNum, B.CreateTime, B.UpdateTime
							FROM (', v_sql,') AS A
							JOIN KYStatisUsers.statis_all_users B ON B.Account = A.Account
                            WHERE B.currency =''',currency,''''); 
    ELSE
		SET v_sql = CONCAT('SELECT A.Account, A.LineCode, (B.WinNum+B.LostNum) AS AllGameNum, B.CellScore * B.exchangeRate AS AllCellScore,
							(B.WinGold+B.LostGold)* B.exchangeRate AS AllProfit,B.Revenue * B.exchangeRate AS AllRevenue ,A.CellScore, A.Profit, A.Revenue,
							A.GameNum, B.CreateTime, B.UpdateTime
							FROM (', v_sql,') AS A
							JOIN KYStatisUsers.statis_all_users B ON B.Account = A.Account'); 
    END IF; 


		SET v_sql_tmp = CONCAT('SELECT Account, LineCode, SUM(AllGameNum) AS AllGameNum,SUM(AllCellScore) AS AllCellScore, SUM(AllProfit) AS AllProfit,
									SUM(AllRevenue) AS AllRevenue, CellScore, Profit, Revenue, GameNum, CreateTime, UpdateTime
								FROM (',v_sql,') AS main1
								GROUP BY Account ',v_orderBy,''); 

		IF tmpRecordCount <> 0 THEN
			SET v_recordTotal = tmpRecordCount; 
		ELSE
			SET v_totalSql = CONCAT('SELECT COUNT(Account), SUM(CellScore) AS CellScore, SUM(Profit) AS Profit,
										SUM(Revenue) AS Revenue, SUM(GameNum) AS GameNum
										INTO @recordCount,@CellScore,@Profit,@Revenue,@GameNum
										FROM (', v_sql_tmp,') T'); 
			SET @v_totalSql = v_totalSql; 
			PREPARE stmt FROM @v_totalSql; 
			EXECUTE stmt; 
			DEALLOCATE PREPARE stmt; 
			SET v_recordTotal = @recordCount; 
			SET v_CellScore = @CellScore; 
			SET v_Profit = @Profit; 
			SET v_Revenue = @Revenue; 
			SET v_GameNum = @GameNum; 
		END if; 

		IF isPage = 1 THEN
			SET v_sql_tmp = CONCAT(v_sql_tmp,' LIMIT ',pageOffset,',',pageLimit); 
		END IF; 
		SET @v_sql = v_sql_tmp; 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		SELECT v_recordTotal,v_CellScore,v_Profit,v_Revenue,v_GameNum; 
	END if; 
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
DROP PROCEDURE IF EXISTS `sp_gameRecordSort2`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_gameRecordSort2`(IN `kindId` int,IN `accounts` varchar(190),IN `beginDate` date,IN `endDate` date,IN `sortType` int,IN `pageOffset` int,IN `pageLimit` int,IN `channelId` int,IN `isPage` bit,IN `tmpRecordCount` int)
BEGIN
	declare v_sql LONGTEXT; 
	declare v_totalSql LONGTEXT; 
	declare v_sqlWhere LONGTEXT; 
	declare v_beginM varchar(6); 
	declare v_endM varchar(6); 
	declare v_tblName varchar(100); 
	declare v_gameName varchar(20); 
	declare v_orderBy varchar(100); 
	declare v_recordTotal int; 
	declare v_CellScore BIGINT; 
	declare v_Profit BIGINT; 
	declare v_Revenue BIGINT; 
	DECLARE v_GameNum bigint; 

	set v_sql = ''; 
	set v_totalSql = ''; 
	set v_sqlWhere = ''; 

	set v_beginM = DATE_FORMAT(beginDate,'%Y%m'); 
	set v_endM = DATE_FORMAT(endDate,'%Y%m'); 
	if channelId > 0 then   
		set v_sqlWhere = concat(' and ChannelID = ',channelId); 
	end if; 
	if LENGTH(accounts) > 0 then
		set v_sqlWhere = concat(v_sqlWhere,' and Account = ''',accounts,''''); 
	end if; 

	if kindId = 0 THEN  
		set v_tblName = concat('statis_allgames',v_beginM,'_users'); 
		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblName) THEN
			set v_sql = concat('select Account,ChannelID,CellScore,(WinGold + LostGold) as Profit,Revenue,(WinNum + LostNum) as GameNum from KYStatisUsers.',v_tblName,' where StatisDate >= ''',beginDate,''' and StatisDate <= ''',endDate,'''',v_sqlWhere); 
		end if; 
		if v_beginM <> v_endM THEN
			set v_tblName = concat('statis_allgames',v_endM,'_users'); 
			IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblName) THEN
				set v_sql = concat(v_sql,' union all select Account,ChannelID,CellScore,(WinGold + LostGold) as Profit,Revenue,(WinNum + LostNum) as GameNum from KYStatisUsers.',v_tblName,' where StatisDate >= ''',beginDate,''' and StatisDate <= ''',endDate,'''',v_sqlWhere); 
			end if; 
		end if; 
	ELSE  
		if kindId = 220 THEN set v_gameName = 'gflower'; 
			elseif kindId = 230 THEN set v_gameName = 'jsgflower'; 
			elseif kindId = 380 THEN set v_gameName = 'luckyfive'; 
			elseif kindId = 390 THEN set v_gameName = 'slm'; 
			elseif kindId = 600 THEN SET v_gameName = 'black'; 
			elseif kindId = 610 THEN set v_gameName = 'ddz'; 
			elseif kindId = 620 THEN set v_gameName = 'dzpk'; 
			elseif kindId = 630 then set v_gameName = 'sss'; 
			elseif kindId = 720 THEN set v_gameName = 'erba'; 
			elseif kindId = 730 THEN set v_gameName = 'qzpj'; 
			elseif kindId = 830 THEN set v_gameName = 'qznn'; 
			elseif kindId = 860 THEN set v_gameName = 'sang'; 
			elseif kindId = 870 THEN set v_gameName = 'tbnn'; 
			elseif kindId = 880 THEN set v_gameName = 'hongb'; 
			elseif kindId = 900 THEN set v_gameName = 'lh'; 
			elseif kindId = 910 THEN set v_gameName = 'bjl'; 
			elseif kindId = 920 THEN set v_gameName = 'forestparty'; 
			elseif kindId = 890 THEN set v_gameName = 'mpnn'; 
			elseif kindId = 930 THEN set v_gameName = 'brnn'; 
			elseif kindId = 950 THEN set v_gameName = 'hhdz'; 
			elseif kindId = 740 THEN set v_gameName = 'erren'; 
			elseif kindId = 550 THEN set v_gameName = 'qztb'; 
			elseif kindId = 680 THEN set v_gameName = 'ddznew'; 
			elseif kindId = 1950 THEN set v_gameName = 'wrzjh'; 
			elseif kindId = 650 THEN set v_gameName = 'xlch'; 
			elseif kindId = 1940 THEN set v_gameName = 'goldenshark'; 
			elseif kindId = 8120 THEN set v_gameName = 'xzdd'; 
			elseif kindId = 1350 THEN set v_gameName = 'xyzp'; 
			elseif kindId = 3930 THEN set v_gameName = 'tb'; 
			elseif kindId = 8130 THEN set v_gameName = 'pdk'; 
			elseif kindId = 510 THEN set v_gameName = 'hbby'; 
			elseif kindId = 8150 THEN set v_gameName = 'ksznn'; 
			elseif kindId = 1960 THEN set v_gameName = 'jackpotbenz'; 
			elseif kindId = 1980 THEN set v_gameName = 'brtb'; 
			elseif kindId = 8180 THEN set v_gameName = 'bsxxl'; 
			elseif kindId = 3100 THEN set v_gameName = 'db'; 
			elseif kindId = 8160 THEN set v_gameName = 'lznn'; 
			elseif kindId = 1660 THEN set v_gameName = 'kyxzdd'; 
			elseif kindId = 8210 THEN set v_gameName = 'byb'; 
			elseif kindId = 8200 THEN set v_gameName = 'qzwxs'; 
			elseif kindId = 8190 THEN set v_gameName = 'wrttz'; 
			elseif kindId = 1355 THEN set v_gameName = 'bybk'; 
			elseif kindId = 1810 THEN set v_gameName = 'dtnn'; 
			elseif kindId = 1990 THEN set v_gameName = 'zjn'; 
			elseif kindId = 1850 THEN set v_gameName = 'ybqznn'; 
			elseif kindId = 1370 THEN set v_gameName = 'gswzp'; 
			elseif kindId = 201 THEN set v_gameName = 'sxbrnnii'; 
			elseif kindId = 204 THEN set v_gameName = 'sxzjh'; 
			elseif kindId = 1890 THEN set v_gameName = 'sgj'; 
			elseif kindId = 1610 THEN set v_gameName = 'yydb'; 
			elseif kindId = 1690 THEN set v_gameName = 'xztb'; 
			elseif kindId = 1860 THEN set v_gameName = 'dcpk'; 
			elseif kindId = 1970 THEN set v_gameName = 'fivestars'; 
		end if; 
		set v_tblName = concat('statis_',v_gameName,v_beginM,'_users'); 
		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblName) THEN
			set v_sql = concat('select Account,ChannelID,CellScore,(WinGold + LostGold) as Profit,Revenue,(WinNum + LostNum) as GameNum from KYStatisUsers.',v_tblName,' where StatisDate >= ''',beginDate,''' and StatisDate <= ''',endDate,'''',v_sqlWhere); 
		end if; 
		if v_beginM <> v_endM THEN
		set v_tblName = concat('statis_',v_gameName,v_endM,'_users'); 
			IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblName) THEN
				set v_sql = concat(v_sql,' union all select Account,ChannelID,CellScore,(WinGold + LostGold) as Profit,Revenue,(WinNum + LostNum) as GameNum from KYStatisUsers.',v_tblName,' where StatisDate >= ''',beginDate,''' and StatisDate <= ''',endDate,'''',v_sqlWhere); 
			end if; 
		end if; 
	end if; 

	if length(v_sql) > 0 then 
		set v_sql = concat('SELECT Account, ChannelID, sum(CellScore) AS CellScore, sum(Profit) AS Profit, sum(Revenue) AS Revenue,sum(GameNum) AS GameNum from (', v_sql,')main group by Account,ChannelID'); 


		if sortType = 0 THEN
			set v_orderBy = ' order by (B.winGold+B.lostGold) desc'; 
		elseif sortType = 1 THEN
			set v_orderBy = ' order by (B.winGold+B.lostGold)'; 
		elseif sortType = 2 THEN
			set v_orderBy = ' order by Profit desc'; 
		elseif sortType = 3 THEN 
			set v_orderBy = ' order by Profit'; 
		end if; 
		set v_sql = concat('SELECT A.Account, (B.WinNum+B.LostNum) AS AllGameNum,
												B.CellScore AS AllCellScore,
												(
													B.WinGold+B.LostGold
												) AS AllProfit,
												B.Revenue AS AllRevenue, A.CellScore, A.Profit, A.Revenue, A.GameNum, B.CreateTime, B.UpdateTime from (', v_sql,')A JOIN  KYStatisUsers.statis_all_users B ON B.account = A.Account ',v_orderBy,''); 
		
		IF tmpRecordCount <> 0 THEN
			SET v_recordTotal = tmpRecordCount; 
		ELSE
			set v_totalSql = concat('select count(Account),sum(CellScore) as CellScore,sum(Profit) as Profit,sum(Revenue) as Revenue,sum(GameNum) as GameNum into @recordCount,@CellScore,@Profit,@Revenue,@GameNum from (', v_sql,')T'); 
			SET @v_totalSql = v_totalSql;  
			PREPARE stmt from @v_totalSql; 
			EXECUTE stmt; 
			DEALLOCATE PREPARE stmt; 
			SET v_recordTotal = @recordCount; 
			set v_CellScore = @CellScore; 
			set v_Profit = @Profit; 
			set v_Revenue = @Revenue; 
			set v_GameNum = @GameNum; 
		end if; 

		IF isPage = 1 THEN
			SET v_sql = CONCAT(v_sql,' limit ',pageOffset,',',pageLimit); 
		END IF; 
		SET @v_sql = v_sql; 
		PREPARE stmt from @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		select v_recordTotal,v_CellScore,v_Profit,v_Revenue,v_GameNum; 
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
DROP PROCEDURE IF EXISTS `sp_gameRecordSortGroupByLinecode`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_gameRecordSortGroupByLinecode`(
    IN `currency` varchar(50),
    IN `kindId` int,
    IN `accounts` varchar(190),
    IN `linecode` varchar(190),
    IN `beginDate` date,
    IN `endDate` date,
    IN `sortType` int,
    IN `pageOffset` int,
    IN `pageLimit` int,
    IN `channelId` int,
    IN `isPage` bit,
    IN `tmpRecordCount` int,
    IN `ServerId` int,
    IN `ProxyId` int
)
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
    SET v_sql_tmp = ''; 
    SET v_aTable = ''; 
    SET v_bTable = ''; 
    SET v_beginM = DATE_FORMAT(beginDate, '%Y%m'); 
    SET v_endM = DATE_FORMAT(endDate, '%Y%m'); 
    SET v_aTable = 'a.'; 
    SET v_bTable = 'a.'; 

    IF kindId > 0 THEN
        SET v_bTable = 'b.'; 
    END IF; 

-- 組 WHERE

    SET v_sqlWhere = CONCAT('
        WHERE `StatisDate` >= ?
        AND `StatisDate` <= ?'); 

    IF channelId > 0 THEN -- 代理商后台
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND ', v_aTable, 'ChannelID = ?'); 
    ELSE
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @channelId = ?'); 
    END IF; 

    IF LENGTH(accounts) > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND ', v_aTable, 'Account = ?'); 
    ELSE
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @accounts = ?'); 
    END IF; 

    IF LENGTH(linecode) > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND ', v_bTable, 'LineCode = ?'); 
    ELSE
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @linecode = ?'); 
    END IF; 

    IF ServerId > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere, ' AND ServerID = ?'); 
    ELSE
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @ServerId = ?'); 
    END IF; 

    IF ProxyId > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND ', v_aTable, 'ChannelID = ?'); 
    ELSE
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @ProxyId = ?'); 
    END IF; 

    IF LENGTH(currency) > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND ', v_aTable, 'currency = ?'); 

        SET v_selectName = CONCAT(
                ' ',
                v_aTable, 'Account, ',
                v_bTable, 'LineCode, ',
                v_aTable, 'ChannelID, ',
                v_aTable, 'CellScore,
                (', v_aTable, 'WinGold + ', v_aTable, 'LostGold) AS Profit, ',
                v_aTable, 'Revenue,
                (', v_aTable, 'WinNum + ', v_aTable, 'LostNum) AS GameNum,
                b.firstBetTime AS CreateTime,
                b.updatedate AS UpdateTime'
            ); 
    ELSE
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @currency = ?'); 

        SET v_selectName = CONCAT(
                ' ',
                v_aTable, 'Account, ',
                v_bTable, 'LineCode, ',
                v_aTable, 'ChannelID, (',
                v_aTable, 'CellScore * ',
                v_aTable, 'exchangeRate) AS  CellScore ,
                (', v_aTable, 'WinGold + ', v_aTable, 'LostGold) * ' ,v_aTable, 'exchangeRate  AS Profit, ',
                v_aTable, 'Revenue *' ,v_aTable, 'exchangeRate AS Revenue,
                (', v_aTable, 'WinNum + ', v_aTable, 'LostNum) AS GameNum,
                b.firstBetTime AS CreateTime,
                b.updatedate AS UpdateTime'
            ); 
    END IF; 

-- 不選遊戲

    IF kindId = 0 THEN

        SET v_tblName = CONCAT('statis_allgames', v_beginM, '_users'); 

        IF EXISTS(
            SELECT *
            FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = 'KYStatisUsers'
            AND TABLE_NAME = v_tblName
        ) THEN

            SET v_sql = CONCAT(
                    'SELECT ',
                    v_selectName,
                    ' FROM KYStatisUsers.', v_tblName,' AS a 
					LEFT JOIN game_api.accounts AS b ON a.Account = b.account ',
                    v_sqlWhere
                ); 

        END IF; 

        IF v_beginM <> v_endM THEN

            SET v_tblName = CONCAT('statis_allgames', v_endM, '_users'); 

            IF EXISTS(
                SELECT *
                FROM information_schema.TABLES
                WHERE TABLE_SCHEMA = 'KYStatisUsers'
                AND TABLE_NAME = v_tblName
            ) THEN

                SET v_sql = CONCAT(
                    v_sql,
                    ' UNION ALL
                    SELECT ',
                    v_selectName,
                    ' FROM KYStatisUsers.', v_tblName,' AS a 
					LEFT JOIN game_api.accounts AS b ON a.Account = b.account ',
                    v_sqlWhere

                    ); 

            END IF; 

        END IF; 

    ELSE -- 分游戏查询

        SELECT GameParameter INTO v_gameName
        FROM KYDB_NEW.GameInfo
        WHERE Gameid = kindId; 

        IF kindId = 620 THEN

            SET v_gameName = 'dzpk'; 

        END IF; 

        IF ServerId > 0 THEN

            SET v_tblName = CONCAT('statis_', v_gameName, v_beginM, '_users_room'); 

        ELSE

            SET v_tblName = CONCAT('statis_', v_gameName, v_beginM, '_users'); 

        END IF; 

        IF EXISTS(
            SELECT *
            FROM information_schema.TABLES
            WHERE TABLE_SCHEMA = 'KYStatisUsers'
            AND TABLE_NAME = v_tblName
        ) THEN

            SET v_sql = CONCAT(
                'SELECT ',
                    v_selectName,'
                FROM KYStatisUsers.', v_tblName, ' AS a
                LEFT JOIN game_api.accounts AS b ON a.Account = b.account ',
                v_sqlWhere
                ); 

        END IF; 

        IF v_beginM <> v_endM THEN

            IF ServerId > 0 THEN

                SET v_tblName = CONCAT('statis_', v_gameName, v_endM, '_users_room'); 

            ELSE

                SET v_tblName = CONCAT('statis_', v_gameName, v_endM, '_users'); 

            END IF; 

            IF EXISTS(
                SELECT *
                FROM information_schema.TABLES
                WHERE TABLE_SCHEMA = 'KYStatisUsers'
                AND TABLE_NAME = v_tblName
            ) THEN

                SET v_sql = CONCAT(
                v_sql,
                ' UNION ALL
                SELECT ',
                v_selectName,'
                FROM KYStatisUsers.', v_tblName, ' AS a
                LEFT JOIN game_api.accounts AS b ON a.Account = b.account ',
                v_sqlWhere
                ); 

            END IF; 

        END IF; 

    END IF; 

    IF LENGTH(v_sql) > 0 THEN

        IF LENGTH(linecode) > 0 THEN

            SET v_sql = CONCAT(
                'SELECT
                    main.Account,
                    LineCode,
                    main.ChannelID,
                    SUM(CellScore) AS CellScore,
                    SUM(Profit) AS Profit,
                    SUM(main.Revenue) AS Revenue,
                    SUM(GameNum) AS GameNum,
					main.CreateTime,
					main.UpdateTime
                FROM (', v_sql, ') main
                JOIN KYDB_NEW.agent AS ag ON ag.id = main.ChannelID
                GROUP BY
                    Account,
                    ChannelID'
                ); 

        ELSE

            SET v_sql = CONCAT(
                'SELECT
                    main.Account,
                    LineCode,
                    main.ChannelID,
                    SUM(CellScore) AS CellScore,
                    SUM(Profit) AS Profit,
                    SUM(main.Revenue) AS Revenue,
                    SUM(GameNum) AS GameNum,
					main.CreateTime,
					main.UpdateTime
                FROM (', v_sql, ') main
                JOIN KYDB_NEW.agent AS ag ON ag.id = main.ChannelID
                GROUP BY
                    Account,
                    LineCode,
                    ChannelID'
                ); 

        END IF; 

        IF LENGTH(currency) > 0 THEN

            SET v_sql = CONCAT(
                'SELECT
                    A.Account,
                    A.LineCode,
                    (B.WinNum+B.LostNum) AS AllGameNum,
                    B.CellScore AS AllCellScore,
                    (B.WinGold+B.LostGold) AS AllProfit,
                    B.Revenue AS AllRevenue,
                    A.CellScore,
                    A.Profit,
                    A.Revenue,
                    A.GameNum,
                    A.CreateTime,
                    A.UpdateTime
                FROM (', v_sql, ') AS A
                JOIN KYStatisUsers.statis_all_users B ON B.Account = A.Account
                WHERE B.currency = ?'
                ); 

        ELSE

            SET v_sql = CONCAT(
                'SELECT
                    A.Account,
                    A.LineCode,
                    (B.WinNum+B.LostNum) AS AllGameNum,
                    B.CellScore * B.exchangeRate AS AllCellScore,
                    (B.WinGold+B.LostGold)* B.exchangeRate AS AllProfit,
                    B.Revenue * B.exchangeRate AS AllRevenue ,
                    A.CellScore,
                    A.Profit,
                    A.Revenue,
                    A.GameNum,
                    A.CreateTime,
                    A.UpdateTime
                FROM (', v_sql, ') AS A
                JOIN KYStatisUsers.statis_all_users B ON B.Account = A.Account
                WHERE @currency = ?'); 

        END IF; 

        IF LENGTH(linecode) > 0 THEN
            SET v_sql_tmp = CONCAT(
                'SELECT
                    Account,
                    LineCode,
                    SUM(AllGameNum) AS AllGameNum,
                    SUM(AllCellScore) AS AllCellScore,
                    SUM(AllProfit) AS AllProfit,
                    SUM(AllRevenue) AS AllRevenue,
                    CellScore,
                    Profit,
                    Revenue,
                    GameNum,
                    CreateTime,
                    UpdateTime
                FROM (', v_sql, ') AS main1
                GROUP BY Account '); 
        ELSE
            SET v_sql_tmp = CONCAT(
                'SELECT
                    Account,
                    LineCode,
                    SUM(AllGameNum) AS AllGameNum,
                    SUM(AllCellScore) AS AllCellScore,
                    SUM(AllProfit) AS AllProfit,
                    SUM(AllRevenue) AS AllRevenue,
                    CellScore,
                    Profit,
                    Revenue,
                    GameNum,
                    CreateTime,
                    UpdateTime
                FROM (', v_sql, ') AS main1
                GROUP BY Account, LineCode '); 
        END IF; 

        SET @beginDate = beginDate; 
        SET @endDate = endDate; 
        SET @channelId = channelId; 
        SET @currency = currency; 
        SET @accounts = accounts; 
        SET @linecode = linecode; 
        SET @pageOffset = pageOffset; 
        SET @pageLimit = pageLimit; 
        SET @ServerId = ServerId; 
        SET @ProxyId = ProxyId; 

        IF tmpRecordCount <> 0 THEN

            SET v_recordTotal = tmpRecordCount; 

        ELSE

            SET v_totalSql = CONCAT(
                'SELECT
                    COUNT(Account),
                    SUM(CellScore) AS CellScore,
                    SUM(Profit) AS Profit,
                    SUM(Revenue) AS Revenue,
                    SUM(GameNum) AS GameNum
                INTO @recordCount,@CellScore,@Profit,@Revenue,@GameNum
                FROM (', v_sql_tmp, ') T' ); 

            SET @v_totalSql = v_totalSql; 

            PREPARE stmt FROM @v_totalSql; 

            IF v_beginM <> v_endM THEN
                EXECUTE stmt USING @beginDate, @endDate, @channelId, @accounts, @linecode, @ServerID, @ProxyId, @currency, @beginDate, @endDate, @channelId, @accounts, @linecode, @ServerID, @ProxyId, @currency, @currency; 
            ELSE
                EXECUTE stmt USING @beginDate, @endDate, @channelId, @accounts, @linecode, @ServerID, @ProxyId, @currency, @currency; 
            END IF; 

            DEALLOCATE PREPARE stmt; 

            SET v_recordTotal = @recordCount; 
            SET v_CellScore = @CellScore; 
            SET v_Profit = @Profit; 
            SET v_Revenue = @Revenue; 
            SET v_GameNum = @GameNum; 

        END IF; 

        IF isPage <> 1 THEN
            SET v_sql = CONCAT(v_sql, ' AND @pageOffset = ? AND @pageLimit = ?'); 
        END IF; 

        IF sortType = 0 THEN
            SET v_orderBy = ' ORDER BY AllProfit DESC'; 
        ELSEIF sortType = 1 THEN
            SET v_orderBy = ' ORDER BY AllProfit'; 
        ELSEIF sortType = 2 THEN
            SET v_orderBy = ' ORDER BY Profit DESC'; 
        ELSEIF sortType = 3 THEN
            SET v_orderBy = ' ORDER BY Profit'; 
        END IF; 

        IF LENGTH(linecode) > 0 THEN
            SET v_sql = CONCAT(
                'SELECT
                    Account,
                    LineCode,
                    SUM(AllGameNum) AS AllGameNum,
                    SUM(AllCellScore) AS AllCellScore,
                    SUM(AllProfit) AS AllProfit,
                    SUM(AllRevenue) AS AllRevenue,
                    CellScore,
                    Profit,
                    Revenue,
                    GameNum,
                    CreateTime,
                    UpdateTime
                FROM (', v_sql, ') AS main1
                GROUP BY Account ',' ',
                v_orderBy, ''); 
        ELSE
            SET v_sql = CONCAT(
                'SELECT
                    Account,
                    LineCode,
                    SUM(AllGameNum) AS AllGameNum,
                    SUM(AllCellScore) AS AllCellScore,
                    SUM(AllProfit) AS AllProfit,
                    SUM(AllRevenue) AS AllRevenue,
                    CellScore,
                    Profit,
                    Revenue,
                    GameNum,
                    CreateTime,
                    UpdateTime
                FROM (', v_sql, ') AS main1
                GROUP BY Account, LineCode ',
                v_orderBy ); 
        END IF; 

        IF isPage = 1 THEN
            SET v_sql = CONCAT(v_sql, ' LIMIT ?, ?'); 
        END IF; 

        SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		
        IF v_beginM <> v_endM THEN                
            EXECUTE stmt USING @beginDate, @endDate, @channelId, @accounts, @linecode, @ServerID, @ProxyId, @currency, @beginDate, @endDate, @channelId, @accounts, @linecode, @ServerID, @ProxyId, @currency, @currency, @pageOffset, @pageLimit; 
        ELSE
            EXECUTE stmt USING @beginDate, @endDate, @channelId, @accounts, @linecode, @ServerID, @ProxyId, @currency, @currency, @pageOffset, @pageLimit;	
        END IF; 

		DEALLOCATE PREPARE stmt; 

        SELECT
            v_recordTotal,
            v_CellScore,
            v_Profit,
            v_Revenue,
            v_GameNum; 

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
DROP PROCEDURE IF EXISTS `sp_get30DaysNonLoginData`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_get30DaysNonLoginData`(IN `gameIds` LONGTEXT,IN `beginDate` date,IN `endDate` date)
BEGIN
	declare v_sql LONGTEXT; 
	
	declare v_i int; 
	declare v_date varchar(6); 
	declare v_date1 varchar(6); 
	declare v_date2 varchar(6); 

	if beginDate is null then 
		set beginDate = DATE_ADD(CURDATE(),INTERVAL -30 DAY); 
	end if; 
	if endDate is null then 
		set endDate = DATE_ADD(CURDATE(),INTERVAL -1 DAY); 
	end if; 
	set v_date1 = DATE_FORMAT(beginDate,'%Y%m'); 
	set v_date2 = DATE_FORMAT(endDate,'%Y%m'); 
	if exists(select * from information_schema.`TABLES` where TABLE_SCHEMA = 'KYStatisLogin' and TABLE_NAME = concat('statis_login_game_sum_',DATE_FORMAT(beginDate,'%Y%m'))) then
		set v_date = DATE_FORMAT(beginDate,'%Y%m'); 
		set v_sql = concat('select StatisDate,GameID,LoginCount as loginNum from KYStatisLogin.statis_login_game_sum_', v_date,' where StatisDate >= ''', beginDate,''' and StatisDate <= ''', endDate,''' and GameID in (',gameIds,')'); 
	end if; 
	if exists(select * from information_schema.`TABLES` where TABLE_SCHEMA = 'KYStatisLogin' and TABLE_NAME = concat('statis_login_game_sum_',DATE_FORMAT(endDate,'%Y%m'))) then
		if v_date1<>v_date2 then
    set v_date = DATE_FORMAT(endDate,'%Y%m'); 
		set v_sql = concat(if(LENGTH(v_sql) > 0,concat(v_sql,' union all '), ''),'select StatisDate,GameID,LoginCount as loginNum from KYStatisLogin.statis_login_game_sum_', v_date,' where StatisDate >= ''', beginDate,''' and StatisDate <= ''', endDate,''' and GameID in (',gameIds,')'); 
	  end if; 
  end if; 

	if LENGTH(v_sql) > 0 THEN
		set v_sql = concat('select StatisDate,GameID,sum(loginNum) as loginNum from (', v_sql,') main group by StatisDate,GameID order by StatisDate'); 
		set @v_sql = v_sql; 
		PREPARE stmt from @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	end if; 
	SELECT v_sql; 
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
CREATE DEFINER=`root`@`%` PROCEDURE `sp_GetAccountCellScore`(OUT `recordTotal` int, IN `gameSQL` LONGTEXT,	IN `pageSize` int, IN `pageIndex` int, IN `isPage` bit)
BEGIN
    DECLARE v_sqlCount LONGTEXT; 
    DECLARE v_sqlSelect LONGTEXT; 
    DECLARE v_sqlStatis LONGTEXT; 
    DECLARE v_sqlBase LONGTEXT; 

    SET v_sqlBase = gameSQL; 

    IF LENGTH(v_sqlBase) <> 0 THEN
        SET v_sqlBase = CONCAT('SELECT main.ChannelID AS agentId, b.account AS agentAccount, main.Accounts AS account, SUM(main.CellScore) AS cellScore, SUM(main.AllBet) AS allBet, SUM(main.Profit) AS profit, a.lastlogintime AS lastLoginTime, main.currency
								FROM (',v_sqlBase,') AS main
								LEFT JOIN KYDB_NEW.accounts AS a ON main.Accounts = a.account
								LEFT JOIN KYDB_NEW.agent AS b ON main.ChannelID = b.id
								GROUP BY main.Accounts, main.currency
								ORDER BY main.CellScore DESC'); 
        IF isPage = 1 THEN
            SET v_sqlSelect = CONCAT(v_sqlBase,' LIMIT ',pageIndex,',',pageSize); 
        ELSE
            SET v_sqlSelect = v_sqlBase; 
        END IF; 
        SET @v_sqlSelect = v_sqlSelect; 
        PREPARE stmt FROM @v_sqlSelect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 

        SET v_sqlCount = CONCAT('SELECT count(*) INTO @recordCount FROM ','(',v_sqlBase,') AS main'); 
        SET @v_sqlCount = v_sqlCount; 
        PREPARE stmt FROM @v_sqlCount; 
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
DROP PROCEDURE IF EXISTS `sp_getBetNumAndRemoveDuplicates`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_getBetNumAndRemoveDuplicates`(IN `startDate` VARCHAR(30), IN `endDate` VARCHAR(30), IN `whereString` LONGTEXT)
BEGIN
    DECLARE v_sqlbase LONGTEXT; 
    DECLARE v_tableName VARCHAR(100); 

    DECLARE no_more_maps INT DEFAULT 0; 
    DECLARE dept_csr CURSOR FOR
        SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'detail_record'; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_maps = 1; 

    SET v_sqlbase = ''; 

    SET no_more_maps = 0; 
    OPEN dept_csr; 

    dept_loop: REPEAT
        FETCH dept_csr INTO v_tableName; 
        IF no_more_maps = 0 THEN
            SET v_sqlbase = CONCAT(
                IF(LENGTH(v_sqlbase) <> 0, CONCAT(v_sqlbase, ' UNION ALL '), ''),
                'SELECT Accounts FROM detail_record.', v_tableName,
                ' WHERE GameEndTime BETWEEN ''', startDate, ''' AND ''', endDate, '''',
                IF(whereString IS NOT NULL AND whereString != '', CONCAT(' AND ChannelID IN (', whereString, ')'), '')
            ); 
        END IF; 
    UNTIL no_more_maps END REPEAT dept_loop; 

    CLOSE dept_csr; 

    IF LENGTH(v_sqlbase) <> 0 THEN
        SET v_sqlbase = CONCAT('SELECT DISTINCT A.Accounts FROM (', v_sqlbase, ') A'); 
        SET @v_sqlbase = v_sqlbase; 
        PREPARE stmt FROM @v_sqlbase; 
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
DROP PROCEDURE IF EXISTS `sp_getBetSumByAccount`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_getBetSumByAccount`(IN `startDate` VARCHAR(30), IN `endDate` VARCHAR(30), IN `whereString` LONGTEXT)
BEGIN
    DECLARE v_sqlbase LONGTEXT; 
    DECLARE v_tableName VARCHAR(100); 

    DECLARE no_more_maps INT DEFAULT 0; 
    DECLARE dept_csr CURSOR FOR
    SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'detail_record'; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_maps = 1; 

    SET v_sqlbase = ''; 

    SET no_more_maps = 0; 
    OPEN dept_csr; 

    dept_loop: REPEAT
    FETCH dept_csr INTO v_tableName; 
    IF no_more_maps = 0 THEN
        SET v_sqlbase = CONCAT(
            IF(LENGTH(v_sqlbase) <> 0, CONCAT(v_sqlbase, ' UNION ALL '), ''),
            'SELECT Accounts AS account, SUM(CellScore) AS total, ChannelID AS agentId FROM detail_record.', v_tableName,
            ' WHERE GameEndTime BETWEEN ''', startDate, ''' AND ''', endDate, '''',
            IF(whereString IS NOT NULL AND whereString != '', CONCAT(' AND ChannelID IN (', whereString, ')'), ''),
                ' GROUP BY Accounts'
            ); 
    END IF; 
    UNTIL no_more_maps END REPEAT dept_loop; 

    CLOSE dept_csr; 

    IF LENGTH(v_sqlbase) <> 0 THEN
        SET @v_sqlbase = v_sqlbase; 
        PREPARE stmt FROM @v_sqlbase; 
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
DROP PROCEDURE IF EXISTS `sp_getGameGroupSort`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_getGameGroupSort`(IN groupId INT, IN defaultFlag INT)
BEGIN
    DECLARE recordCount INT DEFAULT 0; 

    -- 刪除已存在的臨時表
    DROP TEMPORARY TABLE IF EXISTS temp_result; 

    -- 創建臨時表來存儲查詢結果
    CREATE TEMPORARY TABLE temp_result (
        groupId INT,
        gameId INT,
        sort INT,
        lang VARCHAR(50),
        langId INT
    ); 

    -- 檢查 gameGroupInfo 中是否存在 groupId
    SELECT COUNT(*) INTO recordCount
    FROM gameGroupInfo
    WHERE id = groupId; 

    -- 如果 gameGroupInfo 中不存在 groupId，則返回空結果並終止過程
    IF recordCount > 0 THEN
        -- 查詢 gameGroupSort 中是否有 infoId = groupId 的資料
        SELECT COUNT(*) INTO recordCount
        FROM gameGroupSort
        WHERE infoId = groupId; 

        -- 如果有資料，則直接插入臨時表，且 groupId 等於 groupId
        IF defaultFlag = 0 AND recordCount > 0 THEN
            INSERT INTO temp_result (groupId, gameId, sort, lang, langId)
            SELECT
                groupId AS groupId,
                A.GameID AS gameId,
                COALESCE(
                    (SELECT C.sort FROM gameGroupSort AS C WHERE C.gameId = A.GameID AND C.lang = B.id AND C.infoId = groupId),
                    (SELECT C.sort FROM gameGroupSort AS C WHERE C.gameId = A.GameID AND C.lang = B.id AND C.infoId = 1),
                    0
                ) AS sort,
                B.abbreviation AS lang,
                B.id AS langId
            FROM
                (SELECT DISTINCT GameID FROM GameInfo WHERE GameStatus = 0) AS A
            CROSS JOIN
                (SELECT DISTINCT b.id, b.abbreviation FROM gameGroupSort AS a JOIN Sys_Language AS b ON a.lang = b.id) AS B
            WHERE
                A.GameID NOT IN (SELECT gameId FROM gameGroupData WHERE infoId = groupId); 
        ELSE
            -- 如果 gameGroupSort 中沒有 infoId = groupId 的資料
            INSERT INTO temp_result (groupId, gameId, sort, lang, langId)
            SELECT
                groupId AS groupId,
                A.GameID AS gameId,
                COALESCE(C.sort, 0) AS sort,
                B.abbreviation AS lang,
                B.id AS langId
            FROM
                (SELECT DISTINCT GameID FROM GameInfo WHERE GameStatus = 0) AS A
            CROSS JOIN
                (SELECT DISTINCT b.id, b.abbreviation FROM gameGroupSort AS a JOIN Sys_Language AS b ON a.lang = b.id) AS B
            LEFT JOIN
                gameGroupSort AS C ON A.GameID = C.gameId AND C.lang = B.id AND C.infoId = 1
            WHERE
                A.GameID NOT IN (SELECT gameId FROM gameGroupData WHERE infoId = groupId); 
        END IF; 
    END IF; 

    -- 返回臨時表中的資料
    SELECT * FROM temp_result; 

    -- 刪除臨時表
    TRUNCATE TABLE temp_result; 
    DROP TEMPORARY TABLE temp_result; 
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
DROP PROCEDURE IF EXISTS `sp_GetGameLogin1`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_GetGameLogin1`(OUT `recordTotal` int,IN `pageSize` int,IN `pageIndex` int,IN `orderString` varchar(100),IN `whereString` varchar(200),IN `tmpRecordCount` int,IN `ipblack` varchar(5),IN `IsPage` bit)
BEGIN
	DECLARE v_sqlcount VARCHAR(4000); 
	DECLARE v_sqlselect VARCHAR(4000); 
	DECLARE v_sqlbase VARCHAR(4000); 

	IF ipblack = '' THEN
		SET v_sqlbase = 'select A.id, A.account as Account, A.agent AS ChannelID, A.ip AS LoginIP, A.createdate AS LoginTime, CASE WHEN B.IPAddress IS NULL THEN 0 ELSE 1 END AS IpBlack,
							B.Mark,A.info,A.os,A.browser,case A.platform when 0 then ''PC'' else ''Mobile'' end platform,A.ipLocal from KYDB_NEW.statistics_login_hall A'; 
		SET v_sqlbase = CONCAT(v_sqlbase,' left join KYDB_NEW.Sys_IPBlack B ON A.ip = B.IPAddress where 1=1'); 
	ELSEIF ipblack = '1' THEN
		SET v_sqlbase = 'select A.id, A.account as Account, A.agent AS ChannelID, A.ip AS LoginIP, A.createdate AS LoginTime, CASE WHEN B.IPAddress IS NULL THEN 0 ELSE 1 END AS IpBlack,
							B.Mark,A.info,A.os,A.browser,case A.platform when 0 then ''PC'' else ''Mobile'' end as platform,A.ipLocal from KYDB_NEW.statistics_login_hall A'; 
		SET v_sqlbase = CONCAT(v_sqlbase,' inner join KYDB_NEW.Sys_IPBlack B ON A.ip = B.IPAddress where 1=1'); 
	ELSEIF ipblack = '0' THEN
		set v_sqlbase = 'select id, account as Account, agent AS ChannelID, ip AS LoginIP, createdate AS LoginTime, 0 AS IpBlack,
							'''' as Mark,info,os,browser,case platform when 0 then ''PC'' else ''Mobile'' end as platform,ipLocal from KYDB_NEW.statistics_login_hall where ip not in (select IPAddress from KYDB_NEW.Sys_IPBlack)'; 
END IF; 
	SET v_sqlbase = CONCAT(v_sqlbase,whereString); 

	IF tmpRecordCount = 0 THEN
		SET v_sqlcount = CONCAT('SELECT COUNT(*) into @recordTotal FROM (',v_sqlbase,') AS my_temp'); 
		SET @v_sqlcount = v_sqlcount; 
PREPARE stmt from @v_sqlcount; 
EXECUTE stmt; 
DEALLOCATE PREPARE stmt; 
SET recordTotal = @recordTotal; 
ELSE
		SET recordTotal = tmpRecordCount; 
END IF; 

	SET v_sqlselect = CONCAT('SELECT * FROM (', v_sqlbase,') main ORDER BY ',orderString); 

	IF IsPage = 1 THEN
		SET v_sqlselect = CONCAT(v_sqlselect,' LIMIT ',pageIndex,',',pageSize); 
END IF; 
	SET @v_sqlselect = v_sqlselect; 
PREPARE stmt from @v_sqlselect; 
execute stmt; 
DEALLOCATE PREPARE stmt; 
select recordTotal; 
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
DROP PROCEDURE IF EXISTS `sp_GetGameRecord`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_GetGameRecord`(
	OUT `recordTotal` INT,
	IN `gameSQL` LONGTEXT,
	IN `pageSize` INT,
	IN `pageIndex` INT,
	IN `orderString` VARCHAR(100),
	IN `isPage` BIT
)
BEGIN

	DECLARE v_sqlcount LONGTEXT; 
	DECLARE v_sqlselect LONGTEXT; 
	DECLARE v_sqlbase LONGTEXT; 

	SET v_sqlbase = gameSQL; 

	IF LENGTH(v_sqlbase) <> 0 THEN		

		SET v_sqlbase = CONCAT('
        SELECT 
            main.*, 
            g.GameName, 
            r.ServerName, 
            g.category 
		FROM (', v_sqlbase, ') AS main 
		LEFT JOIN KYDB_NEW.GameInfo AS g ON main.KindId = g.GameID 
		LEFT JOIN KYDB_NEW.GameRoomInfo AS r ON main.ServerID = r.ServerId 
		ORDER BY ', orderString); 

		IF isPage = 1 THEN

			IF (pageSize-pageIndex) > 1000 THEN

				SET pageSize = pageIndex + 1000; 

			END IF; 

			SET v_sqlselect = CONCAT(v_sqlbase, ' LIMIT ', pageIndex, ',', pageSize); 

		ELSE

			SET v_sqlselect = v_sqlbase; 
		
		END IF; 

		SET @v_sqlselect = v_sqlselect; 

		PREPARE stmt FROM @v_sqlselect; 

		EXECUTE stmt; 

		DEALLOCATE PREPARE stmt; 

		SET v_sqlcount = CONCAT('
        SELECT 
            COUNT(*) AS totalCount, 
            SUM(CellScore) AS CellScore, 
            SUM(Profit) AS Profit, 
			SUM(Revenue) AS Revenue, 
            SUM(AllBet) AS AllBet, 
            currency
		FROM (', v_sqlbase, ') AS main  
		GROUP BY currency'); 

		SET @v_sqlcount = v_sqlcount;  

		PREPARE stmt FROM @v_sqlcount; 

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
DROP PROCEDURE IF EXISTS `sp_GetGameRecord3`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_GetGameRecord3`(OUT `recordTotal` int, IN `ChannelID` varchar(20), IN `v_tblname` varchar(20), IN `beginDate` varchar(100), IN `endDate` varchar(100))
BEGIN
	DECLARE v_sqlcount LONGTEXT; 
	DECLARE v_sqlbase LONGTEXT; 
	DECLARE v_schema varchar(30); 
    DECLARE done BOOLEAN DEFAULT 0; 
	DECLARE gameRecordCursor CURSOR FOR SELECT TABLE_SCHEMA FROM information_schema.TABLES WHERE TABLE_NAME = v_tblname; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
	
	SET v_sqlbase = ''; 	
	
	OPEN gameRecordCursor; 
		read_loop : LOOP
			FETCH gameRecordCursor INTO v_schema; 
			IF done = 1 THEN 
				LEAVE read_loop; 
			END IF; 
            IF channelid <> '' THEN
				SET v_sqlbase = CONCAT(IF(LENGTH(v_sqlbase) > 0, CONCAT(v_sqlbase, ' union all '), ''),'select GameID, Accounts, ServerID, RoomType, KindID, TableID, ChairID,UserCount, HandCard, CellScore, AllBet, Profit, CurScore, TakeScore, Revenue, GameStartTime, GameEndTime, CardValue, OpValue, ChannelID, LineCode, GameUserNO, CreateTime from ', v_schema, '.' , v_tblname, ' where GameEndTime between "', beginDate, '" and "', endDate, '" and ChannelID ="', ChannelID,'"'); 
            END IF; 
			IF channelid = '' THEN
				SET v_sqlbase = CONCAT(IF(LENGTH(v_sqlbase) > 0, CONCAT(v_sqlbase, ' union all '), ''),'select GameID, Accounts, ServerID, RoomType, KindID, TableID, ChairID,UserCount, HandCard, CellScore, AllBet, Profit, CurScore, TakeScore, Revenue, GameStartTime, GameEndTime, CardValue, OpValue, ChannelID, LineCode, GameUserNO, CreateTime from ', v_schema, '.' , v_tblname, ' where GameEndTime between "', beginDate, '" and "', endDate, '"'); 
            END IF; 
		END LOOP read_loop; 
    CLOSE gameRecordCursor; 
        
	IF LENGTH(v_sqlbase) <> 0 THEN	
		SET v_sqlbase = CONCAT('select main.*, g.GameName, r.ServerName from (', v_sqlbase, ') as main left join KYDB_NEW.GameInfo g on main.KindId = g.GameID left join KYDB_NEW.GameRoomInfo r on main.ServerID = r.ServerId order by GameEndTime DESC'); 
		SET v_sqlcount = CONCAT('select count(*),SUM(CellScore) as CellScore,SUM(Profit) as Profit,SUM(Revenue) as Revenue,SUM(AllBet) as AllBet into @recordCount,@CellScore,@Profit,@Revenue,@AllBet from ','(',v_sqlbase,') as main'); 
		SET @v_sqlcount = v_sqlcount;  
        
		PREPARE stmt from @v_sqlcount; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		SET recordTotal = @recordCount; 
		SELECT @CellScore as CellScore,@Profit as Profit,@Revenue as Revenue,@AllBet as AllBet; 
		select recordTotal; 
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
DROP PROCEDURE IF EXISTS `sp_GetGameRecord_test`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_GetGameRecord_test`(OUT `recordTotal` int,IN `gameSQL` text,IN `pageSize` int,IN `pageIndex` int,IN `orderString` varchar(100),IN `isPage` bit)
BEGIN
	DECLARE v_sqlcount LONGTEXT; 
	DECLARE v_sqlselect LONGTEXT; 
	DECLARE v_sqlbase LONGTEXT; 

	SET v_sqlbase = gameSQL; 

	IF LENGTH(v_sqlbase) <> 0 THEN		
		SET v_sqlbase = CONCAT('SELECT main.*, g.GameName, r.ServerName FROM (', v_sqlbase, ') AS main 
								LEFT JOIN KYDB_NEW.GameInfo AS g ON main.KindId = g.GameID 
								LEFT JOIN KYDB_NEW.GameRoomInfo AS r ON main.ServerID = r.ServerId 
								ORDER BY ', orderString); 
		IF isPage = 1 THEN
			SET v_sqlselect = CONCAT(v_sqlbase, ' LIMIT ', pageIndex, ',', pageSize); 
		ELSE
			SET v_sqlselect = v_sqlbase; 
		END IF; 
select v_sqlselect; 
		SET @v_sqlselect = v_sqlselect; 
		PREPARE stmt FROM @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_sqlcount = CONCAT('SELECT COUNT(*) AS totalCount, SUM(CellScore) AS CellScore, SUM(Profit) AS Profit, 
								SUM(Revenue) AS Revenue, SUM(AllBet) AS AllBet, currency
								FROM ', '(', v_sqlbase, ') AS main 
								GROUP BY currency'); 
		SET @v_sqlcount = v_sqlcount;  
		PREPARE stmt FROM @v_sqlcount; 
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
DROP PROCEDURE IF EXISTS `sp_GetLoginReportByType`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_GetLoginReportByType`(IN `beginDate` datetime,IN `endDate` datetime,IN `account` varchar(190),IN `type` varchar(50),IN `groupKey` varchar(50))
BEGIN
	declare strSql LONGTEXT; 
	declare strWhere varchar(1000); 
	declare strRecord varchar(1000); 
	declare recordCount varchar(50); 
	declare orderby varchar(100); 

	set @rows = 0; 
	set strWhere = ''; 
	set strSql = ''; 
	set strRecord = ''; 
	set orderby = ''; 

	if beginDate is not null then
		set strWhere = CONCAT(strWhere,' AND createdate >= ''', beginDate,''''); 
end if; 
	if endDate is not null then
		set strWhere = CONCAT(strWhere,' AND createdate < ''', endDate,' 23:59:59.998'''); 
end if; 
	if LENGTH(IFNULL(account,'')) > 0 then
		set strWhere = CONCAT(strWhere,' AND Account = ''', account,''''); 
end if; 

	if groupKey = 'num' then
		set orderby = CONCAT(orderby,'order by logincount DESC'); 
		set strRecord = CONCAT(strRecord,'select count(1) into @recordCount from KYDB_NEW.statistics_login_hall where 1=1 ',strWhere); 
else
		set orderby = CONCAT(orderby,'order by mcount DESC'); 
		set strRecord = CONCAT(strRecord,'select sum(num) into @recordCount from (select count(distinct account) as num from KYDB_NEW.statistics_login_hall where 1=1 ', strWhere,' group by ', type,') temp'); 
end if; 
	SET @v_sql = strRecord; 
PREPARE stmt from @v_sql; 
EXECUTE stmt; 
DEALLOCATE PREPARE stmt; 
set recordCount = @recordCount; 

	if type = 'ip' THEN
		if groupKey = 'num' THEN
			set strSql = CONCAT(strSql,'select ip as LoginIP,ipLocal as typeName,count(1) as num,count(distinct Account) as mcount,', recordCount,' as recordCount from KYDB_NEW.statistics_login_hall where 1=1 ', strWhere,' group by ip,ipLocal'); 
ELSE
			set strSql = CONCAT(strSql,'select ip as LoginIP,ipLocal as typeName,count(1) as num,count(distinct Account) as mcount,count(distinct Account) as recordCount from KYDB_NEW.statistics_login_hall where 1=1 ', strWhere,' group by ip,ipLocal'); 
end if; 

	elseif type = 'platform' THEN
		set strSql = CONCAT(strSql,'select rowIndex,case when rowIndex <= 10 then platform else ''其他'' end typeName,loginCount as num,mcount,', recordCount,' as recordCount from (
																select @rows=case when @rows is null then 1 else @rows+1 end as rowIndex, platform,COUNT(1) as loginCount,COUNT(distinct Account) as mcount
																from KYDB_NEW.statistics_login_hall where 1=1 ', strWhere,' group by ', type,'
																) as main ',orderby); 
	elseif type = 'os' THEN
		set strSql = CONCAT(strSql,'select rowIndex,case when rowIndex <= 10 then os else ''其他'' end typeName,loginCount as num,mcount,', recordCount,' as recordCount from (
																select @rows=case when @rows is null then 1 else @rows+1 end as rowIndex, os,COUNT(1) as loginCount,COUNT(distinct Account) as mcount
																from KYDB_NEW.statistics_login_hall where 1=1 ', strWhere,' group by ', type,'
																) as main ',orderby); 
	elseif type = 'browser' THEN
		set strSql = CONCAT(strSql,'select rowIndex,case when rowIndex <= 10 then browser else ''其他'' end typeName,loginCount as num,mcount,', recordCount,' as recordCount from (
																select @rows=case when @rows is null then 1 else @rows+1 end as rowIndex, browser,COUNT(1) as loginCount,COUNT(distinct Account) as mcount
																from KYDB_NEW.statistics_login_hall where 1=1 ', strWhere,' group by ', type,'
																) as main ',orderby); 
end if; 
	SET @v_sql = strSql; 
PREPARE stmt from @v_sql; 
EXECUTE stmt; 
DEALLOCATE PREPARE stmt; 

SET @rows = 0; 
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
DROP PROCEDURE IF EXISTS `sp_GetLoginReportByType1_test`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_GetLoginReportByType1_test`(IN `beginDate` datetime,IN `endDate` datetime,IN `account` varchar(190),IN `type` varchar(50),IN `groupKey` varchar(50))
BEGIN
	declare strSql LONGTEXT; 
	declare strWhere varchar(1000); 
	declare strRecord varchar(1000); 
	declare recordCount varchar(50); 
	declare orderby varchar(100); 
	
	set @rows = 0; 
	set strWhere = ''; 
	set strSql = ''; 
	set strRecord = ''; 
	set orderby = ''; 

	if beginDate is not null then
		set strWhere = CONCAT(strWhere,' AND createdate >= ''', beginDate,''''); 
	end if; 
	if endDate is not null then
		set strWhere = CONCAT(strWhere,' AND createdate < ''', endDate,' 23:59:59.998'''); 
	end if; 
	if LENGTH(IFNULL(account,'')) > 0 then
		set strWhere = CONCAT(strWhere,' AND Account = ''', account,''''); 
	end if; 
	
	if groupKey = 'num' then
		set orderby = CONCAT(orderby,'order by logincount DESC'); 
		set strRecord = CONCAT(strRecord,'select count(1) into @recordCount from KYDB_NEW.statistics_login_hall where 1=1 ',strWhere); 
	else
		set orderby = CONCAT(orderby,'order by mcount DESC'); 
		set strRecord = CONCAT(strRecord,'select sum(num) into @recordCount from (select count(distinct account) as num from KYDB_NEW.statistics_login_hall where 1=1 ', strWhere,' group by ', type,') temp'); 
	end if; 
	SET @v_sql = strRecord; 
	PREPARE stmt from @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
	set recordCount = @recordCount; 
	
	if type = 'ip' THEN
		if groupKey = 'num' THEN
			set strSql = CONCAT(strSql,'select ip as LoginIP,ipLocal as typeName,count(1) as num,count(distinct Account) as mcount,', recordCount,' as recordCount from KYDB_NEW.statistics_login_hall where 1=1 ', strWhere,' group by ip,ipLocal'); 
		ELSE
			set strSql = CONCAT(strSql,'select ip as LoginIP,ipLocal as typeName,count(1) as num,count(distinct Account) as mcount,count(distinct Account) as recordCount from KYDB_NEW.statistics_login_hall where 1=1 ', strWhere,' group by ip,ipLocal'); 
		end if; 
		
	elseif type = 'platform' THEN
		set strSql = CONCAT(strSql,'select rowIndex,case when rowIndex <= 10 then platform else ''其他'' end typeName,loginCount as num,mcount,', recordCount,' as recordCount from (
																select @rows=case when @rows is null then 1 else @rows+1 end as rowIndex, platform,COUNT(1) as loginCount,COUNT(distinct Account) as mcount 
																from KYDB_NEW.statistics_login_hall where 1=1 ', strWhere,' group by ', type,'
																) as main ',orderby); 
	elseif type = 'os' THEN
		set strSql = CONCAT(strSql,'select rowIndex,case when rowIndex <= 10 then os else ''其他'' end typeName,loginCount as num,mcount,', recordCount,' as recordCount from (
																select @rows=case when @rows is null then 1 else @rows+1 end as rowIndex, os,COUNT(1) as loginCount,COUNT(distinct Account) as mcount 
																from KYDB_NEW.statistics_login_hall where 1=1 ', strWhere,' group by ', type,'
																) as main ',orderby); 
	elseif type = 'browser' THEN
		set strSql = CONCAT(strSql,'select rowIndex,case when rowIndex <= 10 then browser else ''其他'' end typeName,loginCount as num,mcount,', recordCount,' as recordCount from (
																select @rows=case when @rows is null then 1 else @rows+1 end as rowIndex, browser,COUNT(1) as loginCount,COUNT(distinct Account) as mcount 
																from KYDB_NEW.statistics_login_hall where 1=1 ', strWhere,' group by ', type,'
																) as main ',orderby); 
	end if; 
	SET @v_sql = strSql; 
	PREPARE stmt from @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	SET @rows = 0; 
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
DROP PROCEDURE IF EXISTS `sp_getProfitAndValidBetGroupByGame`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_getProfitAndValidBetGroupByGame`(IN start_time DATETIME, IN end_time DATETIME)
BEGIN
    DECLARE done INT DEFAULT 0; 
    DECLARE tablename VARCHAR(255); 
    DECLARE cur CURSOR FOR
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'detail_record'; 

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

    -- 創建臨時表來存儲查詢結果
    DROP TEMPORARY TABLE IF EXISTS results; 
    CREATE TEMPORARY TABLE results (
        gameId INT,
        validBet DECIMAL(20,5),
        profit DECIMAL(20,5)
    ) ENGINE=MEMORY; 

    OPEN cur; 
    read_loop: LOOP
        FETCH cur INTO tablename; 
        IF done THEN
            LEAVE read_loop; 
        END IF; 

        -- 動態生成 sql 語句
        SET @sql = CONCAT('
            INSERT INTO results (gameId, validBet, profit)
            SELECT A.KindID AS gameId,
                   SUM(A.CellScore * B.exchangeRate) AS validBet,
                   SUM(A.profit * B.exchangeRate) AS profit
            FROM detail_record.', tablename, ' AS A
            JOIN game_manage.rp_currency AS B ON A.currency = B.currency
            WHERE A.GameEndTime BETWEEN ? AND ?
            GROUP BY A.KindID
        '); 

        PREPARE stmt FROM @sql; 
        SET @start_time = start_time; 
        SET @end_time = end_time; 
        EXECUTE stmt USING @start_time, @end_time; 
        DEALLOCATE PREPARE stmt; 
    END LOOP; 

    CLOSE cur; 

    -- 返回臨時表中的資料
    SELECT * FROM results; 

    -- 刪除臨時表
    DROP TEMPORARY TABLE results; 
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
DROP PROCEDURE IF EXISTS `sp_GetSameTableCount`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_GetSameTableCount`(OUT `recordTotal` int,IN `gameSQL` text,IN `pageSize` int,IN `pageIndex` int,IN `tmpRecordCount` int,IN `isdetail` bit, IN `isPage` bit)
BEGIN
    DECLARE v_sqlselect LONGTEXT; 
    DECLARE v_sqlbase LONGTEXT; 
    DECLARE v_SameTableCount INT; 

    SET v_sqlbase = gameSQL; 

    IF v_sqlbase IS NOT NULL THEN
        SET v_sqlselect = CONCAT('SELECT SQL_CALC_FOUND_ROWS * FROM ( ',v_sqlbase,' ) detail_record'); 
        IF isPage = 1 THEN
            SET v_sqlselect = CONCAT(v_sqlselect,' LIMIT ',pageIndex,',',pageSize); 
        END IF; 

        SET @v_sqlselect = v_sqlselect; 
        PREPARE stmt FROM @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 

        SET @v_sqlselect = ' SELECT FOUND_ROWS() INTO @tmpROWCounts;'; 
        PREPARE stmt FROM @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 

    END IF; 

    IF v_sqlbase IS NOT NULL THEN
        IF isdetail = 0 THEN   -- 统计同桌次数
            SET v_sqlselect = CONCAT('SELECT COUNT(1) AS SameTableCount INTO @SameTableCount
										FROM (SELECT GameID,COUNT(1) AS gamecount
												FROM (', v_sqlbase,') AS main
												GROUP BY GameEndTime, GameID, currency) AS C
										WHERE gamecount > 1 '); 
            SET @v_sqlselect = v_sqlselect; 
            PREPARE stmt FROM @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            SET v_SameTableCount = @SameTableCount; 

            SET v_sqlselect = CONCAT('SELECT Accounts,COUNT(1) AS GameNum,', v_SameTableCount,' AS SameTableCount
										FROM (', v_sqlbase,') AS main
										GROUP BY Accounts, currency'); 
            SET @v_sqlselect = v_sqlselect; 
            PREPARE stmt FROM @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
        ELSE   -- 统计同桌详情
            SET v_sqlbase = CONCAT('SELECT main.*,g.GameName,r.ServerName
									FROM (',v_sqlbase,' AND GameID IN (
										SELECT GameID
										FROM (
											SELECT GameID,COUNT(1) rowcount
											FROM (', v_sqlbase,') AS A
											GROUP BY GameID, currency) AS B
											WHERE rowcount > 1)) AS main
									LEFT JOIN KYDB_NEW.GameInfo g ON main.KindId = g.GameID
									LEFT JOIN KYDB_NEW.GameRoomInfo r ON main.ServerID = r.ServerId
									ORDER BY GameEndTime DESC'); 

            SET v_sqlselect = CONCAT('SELECT * FROM (', v_sqlbase,') AS main LIMIT ',pageIndex,',',pageSize); 
            SET @v_sqlselect = v_sqlselect; 
            PREPARE stmt FROM @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            IF tmpRecordCount = 0 THEN
                SET v_sqlselect = CONCAT('SELECT COUNT(*)  AS totalCount, SUM(CellScore) AS CellScore, SUM(Profit) AS Profit,
										SUM(Revenue) AS Revenue, SUM(AllBet) AS AllBet, currency
										FROM ', '(', v_sqlbase, ') AS main
										GROUP BY currency'); 
                SET @v_sqlselect = v_sqlselect; 
                PREPARE stmt FROM @v_sqlselect; 
                EXECUTE stmt; 
                DEALLOCATE PREPARE stmt; 
            END IF; 
        END IF; 
    END IF; 



    SET @v_sqlselect = ' SELECT @tmpROWCounts AS detail_record_search_total_count;'; 
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
DROP PROCEDURE IF EXISTS `sp_gridViewPager`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_gridViewPager`(OUT `recordTotal` int,IN `viewName` varchar(100),IN `fieldName` varchar(200),IN `keyName` varchar(50),IN `pageSize` int,IN `pageIndex` int,IN `orderString` varchar(100),IN `whereString` varchar(500),IN `tmpRecordCount` int,IN `isPage` bit)
BEGIN
	DECLARE v_sqlcount VARCHAR(4000); 
	DECLARE v_sqlselect VARCHAR(4000); 

	IF tmpRecordCount = 0 THEN
		SET v_sqlcount = CONCAT('SELECT COUNT(*) INTO @recordTotal FROM (SELECT ', keyName,' FROM ', viewName,' WHERE 1 = 1 ', whereString,') AS my_temp'); 
		SET @v_sqlcount = v_sqlcount; 
		PREPARE stmt FROM @v_sqlcount; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		SET recordTotal = @recordTotal; 
	ELSE
		SET recordTotal = tmpRecordCount; 
	END IF; 

	SET v_sqlselect = CONCAT('SELECT ',fieldName,' FROM ',viewName,' WHERE 1 = 1 ',whereString,' ORDER BY ',orderString); 

	IF isPage = 1 THEN
		SET v_sqlselect = CONCAT(v_sqlselect,' LIMIT ',pageIndex,',',pageSize); 
	END IF; 

	SET @v_sqlselect = v_sqlselect; 
	PREPARE stmt FROM @v_sqlselect; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	SELECT recordTotal; 
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
DROP PROCEDURE IF EXISTS `sp_memberBetDetail`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_memberBetDetail`(
    IN `accounts` VARCHAR(190),
    IN `linecode` VARCHAR(190),
    IN `beginDate` DATE,
    IN `endDate` DATE,
    IN `channelId` INT
)
BEGIN

    DECLARE v_sql LONGTEXT; 
    DECLARE v_sqlWhere LONGTEXT; 
    DECLARE v_selectName LONGTEXT; 
    DECLARE v_beginM VARCHAR(6); 
    DECLARE v_endM VARCHAR(6); 
    DECLARE v_tblName VARCHAR(100); 

    SET v_sql = ''; 
    SET v_beginM = DATE_FORMAT(beginDate, '%Y%m'); 
    SET v_endM = DATE_FORMAT(endDate, '%Y%m'); 

    -- 组 WHERE 子句
    SET v_sqlWhere = '
        WHERE `StatisDate` BETWEEN ? AND ?
        AND channelId = ? 
        AND account = ? 
        AND lineCode = ?'; 
        
    SET v_selectName = '
        account, 
        lineCode, 
        channelId, 
        (cellScore * exchangeRate) AS cellScore,
        (WinGold + LostGold) * exchangeRate AS profit'; 

    -- 动态设置表名
    SET v_tblName = CONCAT('statis_allgames', v_beginM, '_users'); 

    -- 检查表是否存在并生成查询
    IF EXISTS (SELECT * FROM information_schema.TABLES 
               WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblName) THEN
        SET v_sql = CONCAT(
            'SELECT ', v_selectName, ' FROM KYStatisUsers.', v_tblName, ' ', v_sqlWhere
        ); 
    END IF; 

    -- 如果日期范围跨月份
    IF v_beginM <> v_endM THEN
        SET v_tblName = CONCAT('statis_allgames', v_endM, '_users'); 
        IF EXISTS (SELECT * FROM information_schema.TABLES 
                   WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = v_tblName) THEN
            SET v_sql = CONCAT(
                v_sql, ' UNION ALL SELECT ', v_selectName, 
                ' FROM KYStatisUsers.', v_tblName, ' ', v_sqlWhere
            ); 
        END IF; 
    END IF; 

    -- 构建聚合查询
    SET v_sql = CONCAT(
        'SELECT
            account,
            lineCode,
            channelId,
            SUM(cellScore) AS cellScore,
            SUM(profit) AS Profit
        FROM (', v_sql, ') main
        GROUP BY account, lineCode, channelId'
    ); 

    -- 构建最终查询
    SET v_sql = CONCAT(
        'SELECT
            SUM(B.cellScore * B.exchangeRate) AS allCellScore,
            SUM((B.WinGold + B.LostGold) * B.exchangeRate) AS allProfit,
            A.cellScore AS monthCellScore,
            A.Profit AS monthProfit,
            acct.createdate AS createDate,
            acct.lastlogintime AS lastLoginTime
        FROM game_api.accounts AS acct
        LEFT JOIN (', v_sql, ') AS A ON acct.Account = A.Account
        LEFT JOIN KYStatisUsers.statis_all_users B ON acct.Account = B.Account
        WHERE acct.agent = ?
        AND acct.Account = ?
        AND acct.LineCode = ?
        GROUP BY acct.Account'
    ); 

    -- 设置参数
    SET @beginDate = beginDate; 
    SET @endDate = endDate; 
    SET @channelId = channelId; 
    SET @account = accounts; 
    SET @linecode = linecode; 

    -- 执行动态 SQL
    SET @v_sql = v_sql; 
    PREPARE stmt FROM @v_sql; 
    EXECUTE stmt USING @beginDate, @endDate, @channelId, @account, @linecode, @channelId, @account, @linecode; 
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
DROP PROCEDURE IF EXISTS `sp_ProxyOrderDetail`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_ProxyOrderDetail`(
    OUT `recordTotal` int,
    IN `pageSize` int,
    IN `pageIndex` int,
    IN `whereString` varchar(500),
    IN `tmpRecordCount` int,
    IN `orderType` int,
    IN `isPage` bit)
BEGIN

	DECLARE v_sqlselect LONGTEXT; 
	DECLARE v_sqlcount LONGTEXT; 
	DECLARE v_sqlbase LONGTEXT; 
	DECLARE v_sqlplayer LONGTEXT; 

	IF LENGTH(whereString) <> 0 THEN

		SET v_sqlplayer = CONCAT('
			SELECT 
				OrderID, 
				OrderTime, 
				ChannelID, 
				OrderType, 
				OrderStatus, 
				CurScore, 
				AddScore, 
				NewScore, OrderIP, CreateUser,'''' AS OrderObject 
			FROM orders_record.agent_orders FORCE index(index_ordertime) 
			WHERE 1 = 1 ', whereString); 

		IF orderType = -1 THEN

			SET v_sqlbase = CONCAT(v_sqlplayer, ' 
			UNION ALL 
				SELECT 
					OrderID, 
					OrderTime, 
					ChannelID, 
					OrderType, 
					OrderStatus, 
					CurScore, 
					AddScore, 
					NewScore, 
					OrderIP, 
					CreateUser, 
					OrderObject 
				FROM KYDB_NEW.Sys_HT_ProxyOrderDetails FORCE index(index_ordertime) 
				WHERE 1 = 1 ', whereString); 

		ELSEIF orderType = 0 OR orderType = 1 OR orderType = 4 OR orderType = 5 OR orderType = 6 OR orderType = 7 THEN

			SET v_sqlbase = CONCAT('
				SELECT 
					OrderID, 
					OrderTime, 
					ChannelID, 
					OrderType, 
					OrderStatus, 
					CurScore, 
					AddScore, 
					NewScore, 
					OrderIP, 
					CreateUser, 
					OrderObject 
				FROM KYDB_NEW.Sys_HT_ProxyOrderDetails FORCE index(index_ordertime) 
				WHERE 1 = 1 ',whereString);	

		ELSE

			SET v_sqlbase = v_sqlplayer; 

		END IF; 

		IF LENGTH(v_sqlbase) <> 0 THEN

			SET v_sqlselect = CONCAT('
				SELECT 
					main.*, 
					g.account AS ChannelName, 
					IFNULL(r.account,''system'') AS PChannelName 
				FROM (',v_sqlbase,') AS main 
				LEFT JOIN KYDB_NEW.agent AS g ON main.ChannelId = g.id 
				LEFT JOIN KYDB_NEW.agent AS r ON g.uid = r.id '); 

			IF tmpRecordCount <> 0 THEN
				SET recordTotal = tmpRecordCount; 
			ELSE
				SET v_sqlcount = CONCAT('SELECT COUNT(*) INTO @recordCount FROM ','(',v_sqlselect,') AS main'); 

				SET @v_sqlcount = v_sqlcount;  

				PREPARE stmt FROM @v_sqlcount; 

				EXECUTE stmt; 

				DEALLOCATE PREPARE stmt; 

				SET recordTotal = @recordCount; 

			END IF; 

			IF isPage = 1 THEN
				SET v_sqlselect = CONCAT(v_sqlselect,' ORDER BY OrderTime Desc LIMIT ?,?'); 
			ELSE
				SET v_sqlselect = CONCAT(v_sqlselect,' AND @pageIndex = ? AND @pageSize = ? ORDER BY OrderTime Desc'); 
			END IF; 

			SET @pageIndex = pageIndex; 
			SET @pageSize = pageSize; 

			SET @v_sqlselect = v_sqlselect; 

			PREPARE stmt FROM @v_sqlselect; 

			EXECUTE stmt USING @pageIndex, @pageSize; 

			DEALLOCATE PREPARE stmt; 

			SELECT recordTotal; 

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
DROP PROCEDURE IF EXISTS `sp_singleWalletDetail`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_singleWalletDetail`(
	IN `beginDate` varchar(30),
	IN `endDate` varchar(30),
	IN `channelId` varchar(10),
	IN `account` varchar(50),
	IN `orderId` varchar(200),
	IN `gameNo` varchar(200),
	IN `OrderType` int,
	IN `orderStatus` int,
	IN `searchType` int,
	IN `pageSize` int,
	IN `pageIndex` int,
	IN `isPage` bit
)
BEGIN 

    DECLARE v_sql LONGTEXT; 
    DECLARE v_sqlWhere LONGTEXT; 
    DECLARE v_schema varchar(20); 
    DECLARE v_tableName varchar(50); 
    DECLARE v_days varchar(6); 
    DECLARE v_i int; 
    DECLARE v_date varchar(20); 
    DECLARE v_select LONGTEXT; 
    DECLARE v_selectTotal LONGTEXT; 
    DECLARE recordTotal int; 

    SET v_sql = ''; 

    SET v_sqlWhere = ''; 

    IF LENGTH(IFNULL(beginDate,'')) > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere, ' AND a.OrderTime >= ?'); 
    ELSE
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @beginDate = ?'); 
    END IF; 

    IF LENGTH(IFNULL(endDate,'')) > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere, ' AND a.OrderTime <= ?'); 
    ELSE
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @endDate = ?'); 
    END IF; 

    IF  LENGTH(IFNULL(channelId,'')) > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere, ' AND a.ChannelID = ?'); 
    ELSE
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @channelId = ?'); 
    END IF; 

    IF LENGTH(IFNULL(account,'')) > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere, ' AND a.CreateUser = ?'); 
    ELSE
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @account = ?'); 
    END IF; 

    IF IFNULL(orderType,0) > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere, ' AND a.OrderType = ?'); 
    ELSE
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @orderType = ?'); 
    END IF; 

    IF IFNULL(orderStatus,0) > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere, ' AND a.OrderStatus = ?'); 
    ELSE
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @orderStatus = ?'); 
    END IF; 

    IF LENGTH(IFNULL(orderId,'')) > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere, ' AND a.OrderID = ?'); 
    ELSE
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @orderId = ?'); 
    END IF; 

    IF LENGTH(IFNULL(gameNo,'')) > 0 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere, ' AND a.GameNo = ?'); 
    ELSE
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @gameNo = ?'); 
    END IF; 

    IF isPage <> 1 THEN
        SET v_sqlWhere = CONCAT(v_sqlWhere,' AND @pageSize = ? AND @pageIndex = ?'); 
    END IF; 

    IF searchType = 2 THEN
        SET
            v_sql = CONCAT('
            SELECT
                a.OrderID AS orderId,
                a.OrderTime AS orderTime,
                a.ChannelID AS channelId,
                a.currency AS currency,
                a.GameNo AS gameNo,
                a.CreateUser AS createUser,
                a.OrderType AS orderType,
                a.CurScore AS curScore,
                a.AddScore AS addScore,
                a.NewScore AS newScore,
                a.OrderStatus AS orderStatus,
                a.OrderAction AS orderAction
            FROM orders_record.single_orders a
            WHERE 1=1 ',
            v_sqlWhere,'
            ORDER BY
                OrderTime DESC,
                a.id DESC'
                    ); 
    ELSE
        SET v_sql = CONCAT('
            SELECT
                a.OrderID AS orderId,
                a.OrderTime AS orderTime,
                a.ChannelID AS channelId,
                a.currency AS currency,
                a.GameNo AS gameNo,
                a.CreateUser AS createUser,
                a.OrderType AS orderType,
                a.CurScore AS curScore,
                a.AddScore AS addScore,
                a.NewScore AS newScore,
                a.OrderStatus AS orderStatus,
                a.OrderAction AS orderAction
            FROM orders_record.single_orders a
            INNER JOIN (
                SELECT
                    CASE WHEN SUBSTRING(a.OrderID, 1, 1) REGEXP \'[0-9]\' 
                    THEN SUBSTRING_INDEX(a.OrderID, \'_\', 1)
                    ELSE a.OrderID
                    END AS orderIDPrefix,
                    CASE WHEN SUBSTRING(a.OrderID, 1, 1) REGEXP \'[0-9]\' 
                    THEN MAX(a.id)
                    ELSE a.id
                    END AS maxID
                FROM orders_record.single_orders a
                WHERE 1=1 '
                ,v_sqlWhere,'
                GROUP BY
                CASE WHEN SUBSTRING(a.OrderID, 1, 1) REGEXP \'[0-9]\' 
                THEN orderIDPrefix
                ELSE a.OrderID
                END
                ORDER BY
                    a.OrderTime DESC, 
                    a.id DESC
            ) maxIds ON a.id = maxIds.maxID
            ORDER BY
                OrderTime DESC, 
                a.id DESC'
            ); 
    END IF; 

    IF isPage = 1 THEN
        SET v_select = CONCAT(v_sql, ' LIMIT ?, ? '); 
    ELSE
        SET v_select = v_sql; 
    END IF; 

    SET @beginDate = beginDate; 
    SET @endDate = endDate; 
    SET @channelId = channelId; 
    SET @account = account; 
    SET @orderId = orderId; 
    SET @gameNo = gameNo; 
    SET @OrderType = IFNULL(OrderType, 0); 
    SET @orderStatus = IFNULL(orderStatus, 0); 
    SET @pageSize = pageSize; 
    SET @pageIndex = pageIndex; 

    SET @v_select = v_select; 

    PREPARE stmt FROM @v_select; 

    EXECUTE stmt USING @beginDate, @endDate, @channelId, @account, @OrderType, @orderStatus, @orderId, @gameNo, @pageIndex, @pageSize; 

    DEALLOCATE PREPARE stmt; 

    SET v_selectTotal = CONCAT('SELECT COUNT(*) into @recordCount FROM (', v_sql, ' )main' ); 

    SET @v_selectTotal = v_selectTotal; 

    PREPARE stmt FROM @v_selectTotal; 

    IF isPage <> 1 THEN
        EXECUTE stmt USING @beginDate, @endDate, @channelId, @account, @OrderType, @orderStatus, @orderId, @gameNo, @pageIndex, @pageSize; 
    ELSE
        EXECUTE stmt USING @beginDate, @endDate, @channelId, @account, @OrderType, @orderStatus, @orderId, @gameNo; 
    END IF; 

    DEALLOCATE PREPARE stmt; 

    SET recordTotal = @recordCount; 

    SELECT recordTotal; 

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
DROP PROCEDURE IF EXISTS `sp_statisAgentRecordInfo_BST_everyMonth`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisAgentRecordInfo_BST_everyMonth`(IN `in_StatisDate` date)
BEGIN
	DECLARE v_sqlbase LONGTEXT; 
	DECLARE v_sqlselect LONGTEXT; 
	DECLARE v_startTime TIMESTAMP(3); 
	DECLARE v_endTime TIMESTAMP(3); 
	DECLARE v_date VARCHAR(30); 
	DECLARE v_tblname VARCHAR(100); 
	DECLARE v_dbName VARCHAR(100); 
	DECLARE v_exchangeRate VARCHAR(30); 
	DECLARE v_currency VARCHAR(30); 
	DECLARE v_gameId VARCHAR(30); 
	DECLARE cur_TABLE_SCHEMA LONGTEXT; 
	DECLARE done INT DEFAULT FALSE; 
	DECLARE cur_Gameid, cur_GameParameter LONGTEXT; 
	DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

		-- 填補資料默認 currrency 與 gameId
	SELECT currency, exchangeRate INTO v_currency, v_exchangeRate FROM game_manage.rp_currency WHERE isPlayer = 1 ORDER BY id LIMIT 1; 
	SELECT Gameid INTO v_gameId FROM KYDB_NEW.GameInfo ORDER BY Gameid LIMIT 1; 

	SET v_startTime = CURRENT_TIMESTAMP(3); 
		SET v_sqlbase = ''; 

		IF in_StatisDate IS NULL THEN
			SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
	END IF; 

		SET v_date = DATE_FORMAT(in_StatisDate,'%Y%m'); 
		SET v_dbName = 'KYStatisUsers_BST'; 

	OPEN cur1; 
	read_loop: LOOP
		FETCH cur1 INTO cur_Gameid, cur_GameParameter; 

		IF done THEN
			LEAVE read_loop; 
		END IF; 

		IF cur_Gameid = 620 THEN
			SET cur_GameParameter = 'dzpk'; 
		END IF; 

		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = v_dbName AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, v_date, '_users')) THEN
			SET v_sqlbase = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' UNION ALL '),''),
							'SELECT Account, WinGold, LostGold, CellScore, Revenue, WinNum, LostNum, ChannelID, ', cur_Gameid, ' AS KindID, LineCode, currency
							FROM ',v_dbName,'.',CONCAT('statis_', cur_GameParameter, v_date, '_users'),'
							WHERE StatisDate = ''', in_StatisDate, ''''); 
		END IF; 
	
	END LOOP; 
	CLOSE cur1; 

	IF LENGTH(v_sqlbase) <> 0 THEN
		SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_all_BST(StatisDate, ChannelID, WinGold, LostGold, CellScore, Revenue, WinNum, LostNum, ActiveUsers, currency, exchangeRate)
									SELECT ''', in_StatisDate,''' AS StatisDate,ChannelID,SUM(WinGold) AS WinGold,SUM(LostGold) AS LostGold,SUM(CellScore) AS CellScore,
										SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, COUNT(distinct Account) AS ActiveUsers, A.currency, B.exchangeRate
									FROM ',v_dbName,'.statis_allgames',v_date,'_users AS A
									LEFT JOIN game_manage.rp_currency AS B ON A.currency = B.currency
									WHERE StatisDate = ''',in_StatisDate,'''
									GROUP BY ChannelID, currency'); 
		
		SET @v_sqlselect = v_sqlselect; 
		
		PREPARE stmt FROM @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		
		REPLACE INTO KYStatis.statis_record_agent_all_BST(StatisDate,ChannelID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum, currency, exchangeRate)
        SELECT in_StatisDate, id AS ChannelID, 0, 0, 0, 0, 0, 0, v_currency, v_exchangeRate 
        FROM KYDB_NEW.agent
        WHERE id NOT IN (SELECT ChannelID FROM KYStatis.statis_record_agent_all_BST WHERE statisdate = in_StatisDate); 

		SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_game_BST(StatisDate, ChannelID, GameID, WinGold, LostGold, CellScore, Revenue, WinNum, LostNum, ActiveUsers, currency, exchangeRate)
									SELECT ''', in_StatisDate,''' AS StatisDate, ChannelID, KindID, SUM(WinGold) AS WinGold, SUM(LostGold) AS LostGold, SUM(CellScore) AS CellScore,
										SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, COUNT(distinct Account) AS ActiveUsers, main.currency, B.exchangeRate
									FROM (', v_sqlbase,') AS main
									LEFT JOIN game_manage.rp_currency AS B ON main.currency = B.currency
									GROUP BY ChannelID, KindID, currency'); 
		
		SET @v_sqlselect = v_sqlselect; 
		PREPARE stmt FROM @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		REPLACE INTO KYStatis.statis_record_agent_game_BST(StatisDate,ChannelID,GameID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum, currency, exchangeRate)
        SELECT
            in_StatisDate, a.ChannelID, a.GameID, 0, 0, 0, 0, 0, 0, a.currency, a.exchangeRate 
        FROM
        (
            SELECT * FROM  (
                SELECT a.id AS ChannelID, gi.GameID, g.currency, g.exchangeRate  
                FROM KYDB_NEW.agent a ,KYDB_NEW.GameInfo gi ,game_manage.rp_currency g
                WHERE g.isPlayer =1
            ) main WHERE NOT EXISTS (
                SELECT * FROM KYStatis.statis_record_agent_game_BST agl
                WHERE statisdate = in_StatisDate AND agl.ChannelID =main.ChannelID AND agl.GameID =main.GameID AND agl.currency=main.currency)
        ) a; 

		SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_linecode_BST(StatisDate, ChannelID, LineCode, WinGold, LostGold, CellScore, Revenue, WinNum, LostNum, ActiveUsers, currency, exchangeRate)
									SELECT ''', in_StatisDate,''' AS StatisDate, ChannelID, LineCode, SUM(WinGold) AS WinGold, SUM(LostGold) AS LostGold, SUM(CellScore) AS CellScore,
										SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, COUNT(distinct Account) AS ActiveUsers, main.currency, B.exchangeRate
									FROM (', v_sqlbase,') AS main
									LEFT JOIN game_manage.rp_currency AS B ON main.currency = B.currency
									GROUP BY ChannelID, LineCode, currency'); 
		
		SET @v_sqlselect = v_sqlselect; 

		PREPARE stmt FROM @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_linecode_game_BST(StatisDate,ChannelID,LineCode,GameID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers, currency, exchangeRate)
									SELECT ''', in_StatisDate,''' AS StatisDate,ChannelID,LineCode,KindID,SUM(WinGold) AS WinGold,SUM(LostGold) AS LostGold,SUM(CellScore) AS CellScore,
										SUM(Revenue) AS Revenue,SUM(WinNum) AS WinNum,SUM(LostNum) AS LostNum,COUNT(distinct Account) AS ActiveUsers, main.currency, B.exchangeRate
									FROM (', v_sqlbase,') AS main
									LEFT JOIN game_manage.rp_currency AS B ON main.currency = B.currency
									GROUP BY ChannelID, LineCode, KindID, currency'); 
		
		SET @v_sqlselect = v_sqlselect; 

		PREPARE stmt FROM @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

	END IF; 

	SET v_endTime = CURRENT_TIMESTAMP(3); 

	INSERT INTO KYStatis.prolog VALUES(NOW(),'sp_statisAgentRecordInfo_BST_everyMonth',TIMESTAMPDIFF(SECOND,v_startTime,v_endTime)); 

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
DROP PROCEDURE IF EXISTS `sp_statisAgentRecordInfo_EST_everyMonth`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisAgentRecordInfo_EST_everyMonth`(IN `in_StatisDate` date)
BEGIN
	DECLARE v_sqlbase LONGTEXT; 
	DECLARE v_sqlselect LONGTEXT; 
	DECLARE v_startTime TIMESTAMP(3); 
	DECLARE v_endTime TIMESTAMP(3); 
	DECLARE v_date VARCHAR(30); 
	DECLARE v_tblname VARCHAR(100); 
	DECLARE v_dbName VARCHAR(100); 
	DECLARE v_exchangeRate VARCHAR(30); 
	DECLARE v_currency VARCHAR(30); 
	DECLARE v_gameId VARCHAR(30); 
	DECLARE cur_TABLE_SCHEMA LONGTEXT; 
	DECLARE done INT DEFAULT FALSE; 
	DECLARE cur_Gameid, cur_GameParameter LONGTEXT; 
	DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

	-- 填補資料默認 currrency 與 gameId
	SELECT currency, exchangeRate INTO v_currency, v_exchangeRate FROM game_manage.rp_currency WHERE isPlayer = 1 ORDER BY id LIMIT 1; 
	SELECT Gameid INTO v_gameId FROM KYDB_NEW.GameInfo ORDER BY Gameid LIMIT 1; 

	SET v_startTime = CURRENT_TIMESTAMP(3); 
	SET v_sqlbase = ''; 

	IF in_StatisDate IS NULL THEN
		SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
	END IF; 

	SET v_date = DATE_FORMAT(in_StatisDate,'%Y%m'); 
	SET v_dbName = 'KYStatisUsers_EST'; 

	OPEN cur1; 
		read_loop: LOOP
			FETCH cur1 INTO cur_Gameid, cur_GameParameter; 

			IF done THEN
				LEAVE read_loop; 
			END IF; 

			IF cur_Gameid = 620 THEN
				SET cur_GameParameter = 'dzpk'; 
			END IF; 

			IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = v_dbName AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, v_date, '_users')) THEN
				SET v_sqlbase = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase,' UNION ALL '),''),
								'SELECT Account, WinGold, LostGold, CellScore, Revenue, WinNum, LostNum, ChannelID, ', cur_Gameid, ' AS KindID, LineCode, currency
								FROM ',v_dbName,'.',CONCAT('statis_', cur_GameParameter, v_date, '_users'),'
								WHERE StatisDate = ''', in_StatisDate, ''''); 
			END IF; 
		END LOOP; 
	CLOSE cur1; 

	IF LENGTH(v_sqlbase) <> 0 THEN
		SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_all_EST(StatisDate, ChannelID, WinGold, LostGold, CellScore, Revenue, WinNum, LostNum, ActiveUsers, currency, exchangeRate)
									SELECT ''', in_StatisDate,''' AS StatisDate,ChannelID,SUM(WinGold) AS WinGold,SUM(LostGold) AS LostGold,SUM(CellScore) AS CellScore,
										SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, COUNT(distinct Account) AS ActiveUsers, A.currency, B.exchangeRate
									FROM ',v_dbName,'.statis_allgames',v_date,'_users AS A
									LEFT JOIN game_manage.rp_currency AS B ON A.currency = B.currency
									WHERE StatisDate = ''',in_StatisDate,'''
									GROUP BY ChannelID, currency'); 
		
		SET @v_sqlselect = v_sqlselect; 
		
		PREPARE stmt FROM @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		
		REPLACE INTO KYStatis.statis_record_agent_all_EST(StatisDate,ChannelID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum, currency, exchangeRate)
        SELECT in_StatisDate, id AS ChannelID, 0, 0, 0, 0, 0, 0, v_currency, v_exchangeRate 
        FROM KYDB_NEW.agent
        WHERE id NOT IN (SELECT ChannelID FROM KYStatis.statis_record_agent_all_EST WHERE statisdate = in_StatisDate); 

		SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_game_EST(StatisDate, ChannelID, GameID, WinGold, LostGold, CellScore, Revenue, WinNum, LostNum, ActiveUsers, currency, exchangeRate)
										SELECT ''', in_StatisDate,''' AS StatisDate, ChannelID, KindID, SUM(WinGold) AS WinGold, SUM(LostGold) AS LostGold, SUM(CellScore) AS CellScore,
											SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, COUNT(distinct Account) AS ActiveUsers, main.currency, B.exchangeRate
										FROM (', v_sqlbase,') AS main
										LEFT JOIN game_manage.rp_currency AS B ON main.currency = B.currency
										GROUP BY ChannelID, KindID, currency'); 
		
		SET @v_sqlselect = v_sqlselect; 
		
		PREPARE stmt FROM @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		REPLACE INTO KYStatis.statis_record_agent_game_EST(StatisDate,ChannelID,GameID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum, currency, exchangeRate)
        SELECT
            in_StatisDate, a.ChannelID, a.GameID, 0, 0, 0, 0, 0, 0, a.currency, a.exchangeRate 
        FROM
        (
            SELECT * FROM  (
                SELECT a.id AS ChannelID, gi.GameID, g.currency, g.exchangeRate  
                FROM KYDB_NEW.agent a ,KYDB_NEW.GameInfo gi ,game_manage.rp_currency g
                WHERE g.isPlayer =1
            ) main WHERE NOT EXISTS (
                SELECT * FROM KYStatis.statis_record_agent_game_EST agl
                WHERE statisdate = in_StatisDate AND agl.ChannelID =main.ChannelID AND agl.GameID =main.GameID AND agl.currency=main.currency)
        ) a; 

		SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_linecode_EST(StatisDate, ChannelID, LineCode, WinGold, LostGold, CellScore, Revenue, WinNum, LostNum, ActiveUsers, currency, exchangeRate)
									SELECT ''', in_StatisDate,''' AS StatisDate, ChannelID, LineCode, SUM(WinGold) AS WinGold, SUM(LostGold) AS LostGold, SUM(CellScore) AS CellScore,
										SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, COUNT(distinct Account) AS ActiveUsers, main.currency, B.exchangeRate
									FROM (', v_sqlbase,') AS main
									LEFT JOIN game_manage.rp_currency AS B ON main.currency = B.currency
									GROUP BY ChannelID, LineCode, currency'); 
		
		SET @v_sqlselect = v_sqlselect; 
		
		PREPARE stmt FROM @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_linecode_game_EST(StatisDate,ChannelID,LineCode,GameID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers, currency, exchangeRate)
									SELECT ''', in_StatisDate,''' AS StatisDate,ChannelID,LineCode,KindID,SUM(WinGold) AS WinGold,SUM(LostGold) AS LostGold,SUM(CellScore) AS CellScore,
										SUM(Revenue) AS Revenue,SUM(WinNum) AS WinNum,SUM(LostNum) AS LostNum,COUNT(distinct Account) AS ActiveUsers, main.currency, B.exchangeRate
									FROM (', v_sqlbase,') AS main
									LEFT JOIN game_manage.rp_currency AS B ON main.currency = B.currency
									GROUP BY ChannelID, LineCode, KindID, currency'); 
		SET @v_sqlselect = v_sqlselect; 
		
		PREPARE stmt FROM @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		/*-- 插入月数据
		SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_month(StatisDate,ChannelID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers, currency, exchangeRate)
									SELECT DATE_FORMAT(StatisDate,''%Y-%m''),ChannelID,SUM(WinGold) AS WinGold,SUM(LostGold) AS LostGold,SUM(CellScore) AS CellScore,
										SUM(Revenue) AS Revenue,SUM(WinNum) AS WinNum,SUM(LostNum) AS LostNum,COUNT(distinct account) AS ActiveUsers, A.currency, B.exchangeRate
									FROM KYStatisUsers.statis_allgames', v_date,'_users AS A
									LEFT JOIN game_manage.rp_currency AS B ON A.currency = B.currency
									GROUP BY DATE_FORMAT(StatisDate,''%Y-%m''), ChannelID, currency'); 
		SET @v_sqlselect = v_sqlselect; 
		PREPARE stmt FROM @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		-- 插入历史数据
		SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_history(ChannelID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers, currency, exchangeRate)
									SELECT ChannelID,SUM(WinGold) AS WinGold,SUM(LostGold) AS LostGold,SUM(CellScore) AS CellScore,SUM(Revenue) AS Revenue,
										SUM(WinNum) AS WinNum,SUM(LostNum) AS LostNum,COUNT(account) AS ActiveUsers, A.currency, B.exchangeRate
									FROM KYStatisUsers.statis_all_users AS A
									LEFT JOIN game_manage.rp_currency AS B ON A.currency = B.currency
									GROUP BY ChannelID, currency'); 
		SET @v_sqlselect = v_sqlselect; 
		PREPARE stmt FROM @v_sqlselect; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt;*/
	END IF; 

	SET v_endTime = CURRENT_TIMESTAMP(3); 

	INSERT INTO KYStatis.prolog VALUES(NOW(),'sp_statisAgentRecordInfo_EST_everyMonth',TIMESTAMPDIFF(SECOND,v_startTime,v_endTime)); 
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
DROP PROCEDURE IF EXISTS `sp_statisAgentRecordInfo_everyMonth`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisAgentRecordInfo_everyMonth`(IN `in_StatisDate` date)
BEGIN
    DECLARE v_sqlbase LONGTEXT; 
    DECLARE v_sqlselect LONGTEXT; 
    DECLARE v_startTime TIMESTAMP(3); 
    DECLARE v_endTime TIMESTAMP(3); 
    DECLARE v_date VARCHAR(30); 
    DECLARE v_tblname VARCHAR(100); 
    DECLARE v_dbName VARCHAR(100); 
    DECLARE v_exchangeRate VARCHAR(30); 
    DECLARE v_currency VARCHAR(30); 
    DECLARE v_gameId VARCHAR(30); 
    DECLARE done INT DEFAULT FALSE; 
    DECLARE cur_Gameid, cur_GameParameter LONGTEXT; 
    DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

    -- 填補資料默認 currrency 與 gameId
    SELECT currency, exchangeRate INTO v_currency, v_exchangeRate FROM game_manage.rp_currency WHERE isPlayer=1 ORDER BY id LIMIT 1; 
    SELECT Gameid INTO v_gameId FROM KYDB_NEW.GameInfo ORDER BY Gameid LIMIT 1; 

    SET v_startTime = CURRENT_TIMESTAMP(3); 
    SET v_sqlbase = ''; 

    IF in_StatisDate IS NULL THEN
        SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
    END IF; 

    SET v_date = DATE_FORMAT(in_StatisDate,'%Y%m'); 
    SET v_dbName = 'KYStatisUsers'; 

    OPEN cur1; 
        read_loop: LOOP
            FETCH cur1 INTO cur_Gameid, cur_GameParameter; 

            IF done THEN
                LEAVE read_loop; 
            END IF; 

            IF cur_Gameid = 620 THEN
                SET cur_GameParameter = 'dzpk'; 
            END IF; 

            IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = v_dbName AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, v_date, '_users')) THEN
                SET v_sqlbase = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase, ' UNION ALL '),''),
                                'SELECT 
                                    Account, 
                                    WinGold, 
                                    LostGold, 
                                    CellScore, 
                                    Revenue, 
                                    WinNum, 
                                    LostNum, 
                                    ChannelID,', 
                                    cur_Gameid, ' AS KindID, 
                                    LineCode, 
                                    currency
                                FROM ', v_dbName,'.',CONCAT('statis_', cur_GameParameter, v_date, '_users'),'
                                WHERE StatisDate = ''', in_StatisDate, ''''); 
            END IF; 
        END LOOP; 
    CLOSE cur1; 

    IF LENGTH(v_sqlbase) <> 0 THEN
        SET v_sqlselect = CONCAT(
                                'REPLACE INTO KYStatis.statis_record_agent_all(StatisDate,ChannelID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers, currency, exchangeRate)
                                SELECT 
                                    ''', in_StatisDate,''' AS StatisDate,
                                    ChannelID,
                                    SUM(WinGold) AS WinGold,
                                    SUM(LostGold) AS LostGold, 
                                    SUM(CellScore) AS CellScore,
                                    SUM(Revenue) AS Revenue, 
                                    SUM(WinNum) AS WinNum, 
                                    SUM(LostNum) AS LostNum, 
                                    COUNT(distinct Account) AS ActiveUsers, 
                                    A.currency, 
                                    B.exchangeRate
                                FROM ',v_dbName,'.statis_allgames',v_date,'_users AS A
                                LEFT JOIN game_manage.rp_currency AS B ON A.currency = B.currency
                                WHERE StatisDate = ''',in_StatisDate,'''
                                GROUP BY ChannelID, currency'); 

        SET @v_sqlselect = v_sqlselect; 
        
        PREPARE stmt FROM @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 

        REPLACE INTO KYStatis.statis_record_agent_all(StatisDate,ChannelID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum, currency, exchangeRate)
        SELECT in_StatisDate, id AS ChannelID, 0, 0, 0, 0, 0, 0, v_currency, v_exchangeRate 
        FROM KYDB_NEW.agent
        WHERE id NOT IN (SELECT ChannelID FROM KYStatis.statis_record_agent_all WHERE statisdate = in_StatisDate); 

        SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_game(StatisDate,ChannelID,GameID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers, currency, exchangeRate)
                                    SELECT 
                                        ''', in_StatisDate,''' AS StatisDate, 
                                        ChannelID, 
                                        KindID, 
                                        SUM(WinGold) AS WinGold, 
                                        SUM(LostGold) AS LostGold, 
                                        SUM(CellScore) AS CellScore,
                                        SUM(Revenue) AS Revenue, 
                                        SUM(WinNum) AS WinNum, 
                                        SUM(LostNum) AS LostNum, 
                                        COUNT(distinct Account) AS ActiveUsers, 
                                        main.currency, 
                                        B.exchangeRate
                                    FROM (', v_sqlbase,') AS main
                                    LEFT JOIN game_manage.rp_currency AS B ON main.currency = B.currency
                                    GROUP BY ChannelID, KindID, currency'); 

        SET @v_sqlselect = v_sqlselect; 
        
        PREPARE stmt FROM @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 

        REPLACE INTO KYStatis.statis_record_agent_game(StatisDate,ChannelID,GameID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum, currency, exchangeRate)
        SELECT
            in_StatisDate, a.ChannelID, a.GameID, 0, 0, 0, 0, 0, 0, a.currency, a.exchangeRate 
        FROM
        (
            SELECT * FROM  (
                SELECT a.id AS ChannelID, gi.GameID, g.currency, g.exchangeRate  
                FROM KYDB_NEW.agent a ,KYDB_NEW.GameInfo gi ,game_manage.rp_currency g
                WHERE g.isPlayer =1
            ) main WHERE NOT EXISTS (
                SELECT * FROM KYStatis.statis_record_agent_game agl
                WHERE statisdate = in_StatisDate AND agl.ChannelID =main.ChannelID AND agl.GameID =main.GameID AND agl.currency=main.currency)
        ) a; 

        SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_linecode(StatisDate,ChannelID,LineCode,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers, currency, exchangeRate)
                                    SELECT ''', in_StatisDate,''' AS StatisDate, ChannelID, LineCode, SUM(WinGold) AS WinGold, SUM(LostGold) AS LostGold, SUM(CellScore) AS CellScore,
                                        SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, COUNT(distinct Account) AS ActiveUsers, main.currency, B.exchangeRate
                                    FROM (', v_sqlbase,') AS main
                                    LEFT JOIN game_manage.rp_currency AS B ON main.currency = B.currency
                                    GROUP BY ChannelID, LineCode, currency'); 
        SET @v_sqlselect = v_sqlselect; 
        
        PREPARE stmt FROM @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 

        SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_linecode_game(StatisDate,ChannelID,LineCode,GameID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers, currency, exchangeRate)
                                    SELECT ''', in_StatisDate,''' AS StatisDate, ChannelID, LineCode, KindID, SUM(WinGold) AS WinGold, SUM(LostGold) AS LostGold, SUM(CellScore) AS CellScore,
                                        SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, COUNT(distinct Account) AS ActiveUsers, main.currency, B.exchangeRate
                                    FROM (', v_sqlbase,') AS main
                                    LEFT JOIN game_manage.rp_currency AS B ON main.currency = B.currency
                                    GROUP BY ChannelID, LineCode,KindID, currency'); 
        SET @v_sqlselect = v_sqlselect; 
        
        PREPARE stmt FROM @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        -- 插入月数据
        SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_month(StatisDate,ChannelID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers,currency, exchangeRate )
                                    SELECT DATE_FORMAT(StatisDate,''%Y-%m''), ChannelID, SUM(WinGold) AS WinGold, SUM(LostGold) AS LostGold, SUM(CellScore) AS CellScore, SUM(Revenue) AS Revenue,
                                        SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, COUNT(distinct account) AS ActiveUsers, A.currency, B.exchangeRate
                                    FROM KYStatisUsers.statis_allgames', v_date,'_users AS A
                                    LEFT JOIN game_manage.rp_currency AS B ON A.currency = B.currency
                                    GROUP BY DATE_FORMAT(StatisDate,''%Y-%m''), ChannelID, currency'); 
        SET @v_sqlselect = v_sqlselect; 
        
        PREPARE stmt FROM @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        -- 插入历史数据
        SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_history(ChannelID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers,currency, exchangeRate)
                                    SELECT ChannelID,SUM(WinGold) AS WinGold,SUM(LostGold) AS LostGold,SUM(CellScore) AS CellScore,SUM(Revenue) AS Revenue,
                                        SUM(WinNum) AS WinNum,SUM(LostNum) AS LostNum,COUNT(account) AS ActiveUsers ,A.currency, B.exchangeRate
                                    FROM KYStatisUsers.statis_all_users AS A
                                    LEFT JOIN game_manage.rp_currency AS B ON A.currency = B.currency
                                    GROUP BY ChannelID, currency'); 
        
        SET @v_sqlselect = v_sqlselect; 
        
        PREPARE stmt FROM @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
        -- 插入新超神人數
        SET v_sqlselect = CONCAT('UPDATE KYStatis.statis_record_agent_game AS main
                                    INNER JOIN (
                                        SELECT a.ChannelID, a.KindID, COUNT(a.Account) AS DayNewBetUsers, a.currency
                                        FROM (
                                            SELECT account
                                            FROM KYDB_NEW.accounts
                                            WHERE createdate >= ''', in_StatisDate,''' AND createdate <= ''', in_StatisDate,' 23:59:59.998'') AS m
                                            INNER JOIN (', v_sqlbase,') AS a ON m.account = a.Account
                                            GROUP BY a.ChannelID, a.KindID, a.currency) AS T ON main.ChannelID = T.ChannelID AND main.GameID = T.KindID AND main.currency = T.currency
                                        LEFT JOIN game_manage.rp_currency AS B ON main.currency = B.currency
                                        SET main.DayNewBetUsers = T.DayNewBetUsers, main.exchangeRate = B.exchangeRate WHERE StatisDate = ''',in_StatisDate ,''''); 
        SET @v_sqlselect = v_sqlselect; 
        
        PREPARE stmt FROM @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
    
    END IF; 
    
    SET v_endTime = CURRENT_TIMESTAMP(3); 
    
    INSERT INTO KYStatis.prolog VALUES(NOW(),'sp_statisAgentRecordInfo_everyMonth',TIMESTAMPDIFF(SECOND,v_startTime,v_endTime)); 

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
DROP PROCEDURE IF EXISTS `sp_statisAgentRecordInfo_everyMonth_debug`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisAgentRecordInfo_everyMonth_debug`(IN `in_StatisDate` date)
BEGIN
	DECLARE v_sqlbase LONGTEXT; 
	DECLARE v_sqlselect LONGTEXT; 
	DECLARE v_startTime TIMESTAMP(3); 
	DECLARE v_endTime TIMESTAMP(3); 
	DECLARE v_date VARCHAR(30); 
	DECLARE v_tblname VARCHAR(100); 
	DECLARE v_dbName VARCHAR(100); 
	DECLARE v_exchangeRate VARCHAR(30); 
	DECLARE v_currency VARCHAR(30); 
	DECLARE v_gameId VARCHAR(30); 
	DECLARE done INT DEFAULT FALSE; 
	DECLARE cur_Gameid, cur_GameParameter LONGTEXT; 
	DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

select '** stage 1' AS '** DEBUG:'; 

	-- 填補資料默認 currrency 與 gameId
SELECT currency, exchangeRate INTO v_currency, v_exchangeRate FROM game_manage.rp_currency WHERE isPlayer=1 ORDER BY id LIMIT 1; 
SELECT Gameid INTO v_gameId FROM KYDB_NEW.GameInfo ORDER BY Gameid LIMIT 1; 

SET v_startTime = CURRENT_TIMESTAMP(3); 
	SET v_sqlbase = ''; 

IF in_StatisDate IS NULL THEN
		SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
END IF; 

	SET v_date = DATE_FORMAT(in_StatisDate,'%Y%m'); 
	SET v_dbName = 'KYStatisUsers'; 

OPEN cur1; 
read_loop: LOOP
			FETCH cur1 INTO cur_Gameid, cur_GameParameter; 
IF done THEN
				LEAVE read_loop; 
END IF; 
IF cur_Gameid = 620 THEN
				SET cur_GameParameter = 'dzpk'; 
END IF; 
-- select CONCAT('** cur_Gameid: ',cur_Gameid) AS '** DEBUG:'; 
-- select CONCAT('** cur_GameParameter: ',cur_GameParameter) AS '** DEBUG:'; 
IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = v_dbName AND TABLE_NAME = CONCAT('statis_', cur_GameParameter, v_date, '_users')) THEN
				SET v_sqlbase = CONCAT(IF(LENGTH(v_sqlbase) > 0,CONCAT(v_sqlbase, ' UNION ALL '),''),'SELECT Account, WinGold, LostGold, CellScore, Revenue, WinNum, LostNum, ChannelID,', cur_Gameid, ' AS KindID, LineCode, currency FROM ', v_dbName,'.',CONCAT('statis_', cur_GameParameter, v_date, '_users'),' WHERE StatisDate = ''', in_StatisDate, ''''); 

END IF; 
END LOOP; 
CLOSE cur1; 

IF LENGTH(v_sqlbase) <> 0 THEN
		SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_all(StatisDate,ChannelID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers, currency, exchangeRate)
									SELECT ''', in_StatisDate,''' AS StatisDate,ChannelID,SUM(WinGold) AS WinGold,SUM(LostGold) AS LostGold, SUM(CellScore) AS CellScore,
										SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, COUNT(distinct Account) AS ActiveUsers, A.currency, B.exchangeRate
									FROM ',v_dbName,'.statis_allgames',v_date,'_users AS A
									LEFT JOIN game_manage.rp_currency AS B ON A.currency = B.currency
									WHERE StatisDate = ''',in_StatisDate,'''
									GROUP BY ChannelID, currency'); 
		SET @v_sqlselect = v_sqlselect; 
		SELECT CONCAT('IF EXISTS @v_sqlselect: ', v_sqlselect); 
-- PREPARE stmt FROM @v_sqlselect; 
-- EXECUTE stmt; 
-- DEALLOCATE PREPARE stmt; 
-- REPLACE INTO KYStatis.statis_record_agent_all(StatisDate,ChannelID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum, currency, exchangeRate)
SELECT in_StatisDate, ChannelID, 0, 0, 0, 0, 0, 0, v_currency, v_exchangeRate FROM Sys_ProxyAccount WHERE UserStatus = 0
                                                                                                      AND ChannelID NOT IN (SELECT ChannelID FROM KYStatis.statis_record_agent_all WHERE statisdate = in_StatisDate); 

SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_game(StatisDate,ChannelID,GameID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers, currency, exchangeRate)
									SELECT ''', in_StatisDate,''' AS StatisDate, ChannelID, KindID, SUM(WinGold) AS WinGold, SUM(LostGold) AS LostGold, SUM(CellScore) AS CellScore,
										SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, COUNT(distinct Account) AS ActiveUsers, main.currency, B.exchangeRate
									FROM (', v_sqlbase,') AS main
									LEFT JOIN game_manage.rp_currency AS B ON main.currency = B.currency
									GROUP BY ChannelID, KindID, currency'); 
		SET @v_sqlselect = v_sqlselect; 
-- PREPARE stmt FROM @v_sqlselect; 
-- EXECUTE stmt; 
-- DEALLOCATE PREPARE stmt; 
-- REPLACE INTO KYStatis.statis_record_agent_game(StatisDate,ChannelID,GameID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum, currency, exchangeRate)
SELECT in_StatisDate, ChannelID, v_gameId, 0, 0, 0, 0, 0, 0, v_currency, v_exchangeRate FROM Sys_ProxyAccount WHERE UserStatus = 0
                                                                                                                AND ChannelID NOT IN (SELECT ChannelID FROM KYStatis.statis_record_agent_game WHERE statisdate = in_StatisDate); 

		SET 
			v_sqlselect = CONCAT(
				'REPLACE INTO KYStatis.statis_record_agent_linecode(StatisDate,ChannelID,LineCode,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers, currency, exchangeRate) SELECT ''', 
				in_StatisDate, ''' AS StatisDate, ChannelID, LineCode, SUM(WinGold) AS WinGold, SUM(LostGold) AS LostGold, SUM(CellScore) AS CellScore, SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, COUNT(distinct Account) AS ActiveUsers, main.currency, B.exchangeRate FROM (', 
				v_sqlbase, ') AS main LEFT JOIN game_manage.rp_currency AS B ON main.currency = B.currency GROUP BY ChannelID, LineCode, currency'
			); 

		SET @v_sqlselect = v_sqlselect; 

select CONCAT('** stage 3',v_sqlselect) AS '** DEBUG:'; 

PREPARE stmt FROM @v_sqlselect; 
EXECUTE stmt; 
DEALLOCATE PREPARE stmt; 

SET v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_linecode_game(StatisDate,ChannelID,LineCode,GameID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers, currency, exchangeRate)
									SELECT ''', in_StatisDate,''' AS StatisDate, ChannelID, LineCode, KindID, SUM(WinGold) AS WinGold, SUM(LostGold) AS LostGold, SUM(CellScore) AS CellScore,
										SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, COUNT(distinct Account) AS ActiveUsers, main.currency, B.exchangeRate
									FROM (', v_sqlbase,') AS main
									LEFT JOIN game_manage.rp_currency AS B ON main.currency = B.currency
									GROUP BY ChannelID, LineCode,KindID, currency'); 
		SET @v_sqlselect = v_sqlselect; 
PREPARE stmt FROM @v_sqlselect; 
EXECUTE stmt; 
DEALLOCATE PREPARE stmt; 

END IF; 
	SET v_endTime = CURRENT_TIMESTAMP(3); 
-- INSERT INTO KYStatis.prolog VALUES(NOW(),'sp_statisAgentRecordInfo_everyMonth',TIMESTAMPDIFF(SECOND,v_startTime,v_endTime)); 
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
DROP PROCEDURE IF EXISTS `sp_statisAgentRecordInfo_everyMonth_reguser`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisAgentRecordInfo_everyMonth_reguser`( IN `in_StatisDate` date )
BEGIN
    DECLARE v_sqlSelect LONGTEXT; 
    DECLARE v_startTime TIMESTAMP(3); 
    DECLARE v_endTime TIMESTAMP(3); 
    DECLARE v_date varchar(30); 
    DECLARE v_dbName varchar(100); 

    SET v_startTime = CURRENT_TIMESTAMP(3); 

    IF in_StatisDate IS NULL THEN
        SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
    END IF; 
    SET v_date = DATE_FORMAT(in_StatisDate,'%Y%m'); 
    SET v_dbName = 'KYStatisUsers'; 

    SET v_sqlSelect = CONCAT('REPLACE INTO KYStatis.statis_record_agent_all_reguser (StatisDate,ChannelID,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,ActiveUsers, currency, exchangeRate) 
    SELECT ''', in_StatisDate,''' AS StatisDate,ChannelID,SUM(WinGold) AS WinGold,SUM(LostGold) AS LostGold,SUM(CellScore) AS CellScore,SUM(Revenue) AS Revenue,SUM(WinNum) AS WinNum,SUM(LostNum) AS LostNum,count(distinct Account) AS ActiveUsers, A.currency, B.exchangeRate 
    FROM ',v_dbName,'.statis_allgames',v_date,'_users AS A
    LEFT JOIN game_manage.rp_currency AS B ON A.currency = B.currency
    WHERE StatisDate = ''',in_StatisDate,''' 
    AND Account IN(SELECT account FROM KYDB_NEW.accounts WHERE createdate>=''',in_StatisDate,''' AND createdate<=''',in_StatisDate,' 23:59:59'') 
    GROUP BY ChannelID, currency');        
    SET @v_sqlSelect = v_sqlSelect; 
    PREPARE stmt FROM @v_sqlSelect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt; 

SET v_endTime = CURRENT_TIMESTAMP(3); 
INSERT INTO KYStatis.prolog VALUES (NOW(),'sp_statisAgentRecordInfo_everyMonth_reguser',TIMESTAMPDIFF(SECOND,v_startTime,v_endTime)); 
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
DROP PROCEDURE IF EXISTS `sp_StatisGameRoomData`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisGameRoomData`(`in_StatisDate` date,`in_GameName` varchar(100),`in_gameId` int)
BEGIN

    DECLARE v_tblname VARCHAR(100); 
    DECLARE v_sqlbase LONGTEXT; 
    DECLARE v_sqlWhere LONGTEXT; 
    DECLARE v_startTime VARCHAR(100); 
    DECLARE v_endTime VARCHAR(100); 

    IF in_StatisDate IS NULL THEN
        SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
    END IF; 

    SET v_startTime = CONCAT(in_StatisDate, ' 00:00:00 '); 
    SET v_endTime = CONCAT(in_StatisDate, ' 23:59:59 '); 
    SET v_sqlWhere = CONCAT(" WHERE GameEndTime >= '", v_startTime, "' AND GameEndTime <= '", v_endTime, "' "); 

    SET v_tblname = CONCAT(in_GameName, '_gameRecord'); 
    IF(in_GameName = 'hbby') THEN
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA ='detail_record' AND TABLE_NAME = v_tblname) THEN
            SET v_sqlbase=CONCAT('SELECT ''',in_StatisDate,''',',in_gameId,',ServerID,IFNULL(SUM(CellScore),0) validBet,IFNULL(SUM(Revenue),0) revenue,IFNULL(SUM(Profit),0) profit,0,0,0,0,
										IFNULL(COUNT(1),0) gameNum,0,
										IFNULL(SUM(NormalProfit)*-1,0) robotProfit,
										IFNULL(SUM(KillProfit)*-1,0) killRobotProfit,
										IFNULL(SUM(DiveProfit)*-1,0) revRobotProfit,0,0,0,
										0 killGameNum,
										0 diveGameNum,
										0 normalValidbet,
										a.currency,
										d.exchangeRate
									FROM detail_record.',v_tblname ,' a
									LEFT JOIN (
										SELECT currency, exchangeRate
										FROM game_manage.rp_currency) d ON a.currency = d.currency'
                ,v_sqlWhere,'
									GROUP BY a.ServerID, a.currency'); 
        END IF; 
    ELSE
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA ='detail_record' AND TABLE_NAME = v_tblname) THEN
            SET v_sqlbase=CONCAT('SELECT ''',in_StatisDate,''',',in_gameId,',ServerID,IFNULL(SUM(CellScore),0) validBet,IFNULL(SUM(Revenue),0) revenue,IFNULL(SUM(Profit),0) profit,0,0,0,0,
										IFNULL(COUNT(1),0) gameNum,0,
										IFNULL(SUM(CASE WHEN RoomType IN(1,2,3,6) THEN Profit END*-1),0) robotProfit,
										IFNULL(SUM(CASE WHEN RoomType IN(4,8,9,10) THEN Profit END)*-1,0) killRobotProfit,
										IFNULL(SUM(CASE WHEN RoomType=5 THEN Profit END)*-1,0) revRobotProfit,0,0,0,
										IFNULL(COUNT(CASE WHEN RoomType IN (4,8,9,10) THEN 1 END),0) killGameNum,
										IFNULL(COUNT(CASE WHEN RoomType=5 THEN 1 END),0) diveGameNum,
										IFNULL(SUM(CASE WHEN RoomType in(1,2,3,6) THEN CellScore END),0) normalValidbet,
										a.currency,
										d.exchangeRate
									FROM detail_record.',v_tblname ,' a
									LEFT JOIN (
										SELECT currency, exchangeRate
										FROM game_manage.rp_currency) d ON a.currency = d.currency'
                ,v_sqlWhere,'
									GROUP BY a.ServerID, a.currency'); 
        END IF; 
    END IF; 

    IF(LENGTH(v_sqlbase) > 0) THEN
        SET v_sqlbase=CONCAT('REPLACE INTO KYStatis.statis_room_monitoring (
												createdate, gameId, roomId, validBet, revenue, profit, avgOnline, maxOnline, logCount, activeCount, gameNum, singleTime, robotProfit,
												killRobotProfit, revRobotProfit, dayKillGold, dayDiveGold, gameTime, killGameNum, diveGameNum, normalValidbet, currency, exchangeRate) ',
                             v_sqlbase); 

        SET @v_sqlselect =v_sqlbase; 
        PREPARE stmt from @v_sqlselect; 
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
DROP PROCEDURE IF EXISTS `sp_StatisGameRoomData_everyDay`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisGameRoomData_everyDay`(IN `in_StatisDate` date)
BEGIN
	-- 房间数据统计
	DECLARE v_tblname VARCHAR(100); 
	DECLARE v_starttime TIMESTAMP(3); 
	DECLARE v_endtime TIMESTAMP(3); 
	DECLARE done INT DEFAULT FALSE; 
	DECLARE cur_Gameid, cur_GameParameter LONGTEXT; 
	DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

	-- 记录开始时间
	SET v_starttime = CURRENT_TIMESTAMP(3); 

	IF in_StatisDate IS NULL THEN
		SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
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
		CALL sp_StatisGameRoomData(in_StatisDate, cur_GameParameter, cur_Gameid); 
		END LOOP; 
	CLOSE cur1;	

	-- 添加所有房间登录人数与汇率
	SET @v_sqlselect = CONCAT('UPDATE KYStatis.statis_room_monitoring a JOIN (
								SELECT roomId,COUNT(DISTINCT account) logcouont 
								FROM KYDB_NEW.statistics_login_room 
								WHERE createdate >=''',in_StatisDate,''' AND createdate <= ''',in_StatisDate,' 23:59:59.998'' AND gameid IS NOT NULL
								GROUP BY roomId) b ON a.roomId = b.roomId 
								LEFT JOIN (
									SELECT roomId,AVG(`value`) avgOnline,MAX(`value`) maxOnline 
									FROM KYDB_NEW.online_room 
									WHERE createtime >=''',in_StatisDate,''' AND createtime <=''',in_StatisDate,' 23:59:59.998''  
									GROUP BY roomId) c ON c.roomId = a.roomId
								LEFT JOIN (
									SELECT currency, exchangeRate
									FROM game_manage.rp_currency) d ON a.currency = d.currency
								SET a.logCount = IFNULL(b.logcouont,0), a.dayKillGold = a.killRobotProfit*-1, a.dayDiveGold = a.revRobotProfit*-1, a.avgOnline = IFNULL(c.avgOnline,0), a.maxOnline = IFNULL(c.maxOnline,0), a.exchangeRate = d.exchangeRate
								WHERE  a.createdate=''',in_StatisDate,''''); 
	PREPARE stmt FROM @v_sqlselect; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	-- 记录结束时间
	SET v_endtime = CURRENT_TIMESTAMP(); 

	-- 添加执行日志
	INSERT INTO KYStatis.prolog VALUES(NOW(),'KYDB_NEW.sp_StatisGameRoomData_everyDay',TIMESTAMPDIFF(SECOND,v_starttime,v_endtime)); 
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
DROP PROCEDURE IF EXISTS `sp_StatisGameRoomData_reguser`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisGameRoomData_reguser`(`in_StatisDate` date,`in_GameName` varchar(100),`in_gameId` int)
BEGIN

    DECLARE v_tblname VARCHAR(100); 
    DECLARE v_sqlbase LONGTEXT; 
    DECLARE v_sqlWhere LONGTEXT; 
    DECLARE v_startTime VARCHAR(100); 
    DECLARE v_endTime VARCHAR(100); 

    IF in_StatisDate IS NULL THEN
        SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
    END IF; 

    SET v_startTime = CONCAT(in_StatisDate, ' 00:00:00 '); 
    SET v_endTime = CONCAT(in_StatisDate, ' 23:59:59 '); 
    SET v_sqlWhere = CONCAT(" WHERE GameEndTime >= '", v_startTime, "' AND GameEndTime <= '", v_endTime, "' "); 

    SET v_tblname = CONCAT(in_GameName, '_gameRecord'); 
    IF(in_GameName = 'hbby') THEN
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'detail_record' AND TABLE_NAME = v_tblname) THEN
            SET v_sqlbase = CONCAT('SELECT ''',in_StatisDate,''',',in_gameId,',ServerID,IFNULL(SUM(CellScore),0) validBet, IFNULL(SUM(Revenue),0) revenue, IFNULL(SUM(Profit),0) profit, 0, 0, 0, 0,
											IFNULL(COUNT(1),0) gameNum, 0,
											IFNULL(SUM(NormalProfit)*-1,0) robotProfit,
											IFNULL(SUM(KillProfit)*-1,0) killRobotProfit,
											IFNULL(SUM(DiveProfit)*-1,0) revRobotProfit, 0, 0, 0,
											0 killGameNum,
											0 diveGameNum,
											0 normalValidbet,
											a.currency,
										  d.exchangeRate
										FROM detail_record.',v_tblname,' a
										JOIN KYStatis.statis_reguser_account b ON a.Accounts = b.account
										LEFT JOIN (
										SELECT currency, exchangeRate
										FROM game_manage.rp_currency) d ON a.currency = d.currency'
                ,v_sqlWhere,'
									GROUP BY a.ServerID, a.currency'); 
        END if; 
    ELSE
        IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = 'detail_record' AND TABLE_NAME = v_tblname) THEN
            SET v_sqlbase = CONCAT('SELECT ''',in_StatisDate,''',',in_gameId,',ServerID, IFNULL(SUM(CellScore),0) validBet, IFNULL(SUM(Revenue),0) revenue,IFNULL(SUM(Profit),0) profit,0,0,0,0,
										IFNULL(COUNT(1),0) gameNum, 0,
										IFNULL(SUM(CASE WHEN RoomType in(1,2,3,6) THEN Profit END*-1),0) robotProfit,
										IFNULL(SUM(CASE WHEN RoomType IN (4,8,9,10) THEN Profit END)*-1,0) killRobotProfit,
										IFNULL(SUM(CASE WHEN RoomType=5 THEN Profit END)*-1,0) revRobotProfit, 0, 0, 0,
										IFNULL(COUNT(CASE WHEN RoomType IN (4,8,9,10) THEN 1 END),0) killGameNum,
										IFNULL(COUNT(CASE WHEN RoomType=5 THEN 1 END),0) diveGameNum,
										IFNULL(SUM(CASE WHEN RoomType in(1,2,3,6) THEN CellScore END),0) normalValidbet,
										a.currency,
										d.exchangeRate
									FROM detail_record.',v_tblname,' a
									JOIN KYStatis.statis_reguser_account b ON a.Accounts = b.account
									LEFT JOIN (
										SELECT currency, exchangeRate
										FROM game_manage.rp_currency) d ON a.currency = d.currency'
                ,v_sqlWhere, '
									GROUP BY a.ServerID, a.currency'); 
        END IF; 
    END IF; 

    IF(LENGTH(v_sqlbase) > 0) THEN
        SET v_sqlbase = CONCAT('REPLACE INTO KYStatis.statis_room_monitoring_reguser
								(createdate, gameId, roomId, validBet, revenue,profit, avgOnline, maxOnline, logCount, activeCount, gameNum, singleTime,
									robotProfit, killRobotProfit, revRobotProfit, dayKillGold, dayDiveGold, gameTime, killGameNum, diveGameNum, normalValidbet, currency, exchangeRate) '
            ,v_sqlbase); 

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
DROP PROCEDURE IF EXISTS `sp_StatisGameRoomData_reguser_everyDay`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisGameRoomData_reguser_everyDay`(IN `in_StatisDate` date)
BEGIN
	-- 房间数据统计
	DECLARE v_tblname VARCHAR(100); 
	DECLARE v_starttime TIMESTAMP(3); 
	DECLARE v_endtime TIMESTAMP(3); 
	DECLARE done INT DEFAULT FALSE; 
	DECLARE cur_Gameid, cur_GameParameter LONGTEXT; 
	DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

	-- 记录开始时间
	SET v_starttime=CURRENT_TIMESTAMP(3); 

	IF in_StatisDate IS NULL THEN
		SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
	END IF; 

	-- 截断当前表，清除数据
	TRUNCATE TABLE KYStatis.statis_reguser_account; 

	-- 昨天注册玩家放进临时表
	SET @v_sqlselect = CONCAT('INSERT INTO KYStatis.statis_reguser_account (account,createtime) 
								SELECT account,createdate 
								FROM KYDB_NEW.accounts 
								WHERE createdate>=''',in_StatisDate,''' AND createdate<=''',in_StatisDate,' 23:59:59.998'';'); 
	PREPARE stmt FROM @v_sqlselect; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	OPEN cur1; 
		read_loop: LOOP
			FETCH cur1 INTO cur_Gameid, cur_GameParameter; 
			
			IF done THEN
				LEAVE read_loop; 
			END IF; 
			
			IF cur_Gameid = 620 THEN
				SET cur_GameParameter = 'dzpk'; 
			END IF; 

			CALL sp_StatisGameRoomData_reguser(in_StatisDate, cur_GameParameter, cur_Gameid); 
		END LOOP; 
	CLOSE cur1;	

	-- 添加所有房间登录人数与汇率
	SET @v_sqlselect = CONCAT('UPDATE KYStatis.statis_room_monitoring_reguser a 
								JOIN (
									SELECT a1.roomId,COUNT(DISTINCT a1.account) logcouont 
									FROM KYDB_NEW.statistics_login_room a1 
									JOIN KYStatis.statis_reguser_account a2 ON a1.account = a2.account 
									WHERE a1.createdate >=''',in_StatisDate,''' AND a1.createdate <= ''',in_StatisDate,' 23:59:59.998'' AND a1.gameid IS NOT NULL
									GROUP BY a1.roomId) b ON a.roomId = b.roomId 
								LEFT JOIN (
									SELECT currency, exchangeRate
									FROM game_manage.rp_currency) c ON a.currency = c.currency
								SET a.logCount = IFNULL(b.logcouont,0), a.dayKillGold = a.killRobotProfit*-1, a.dayDiveGold = a.revRobotProfit*-1 , a.exchangeRate = c.exchangeRate
								WHERE  a.createdate=''',in_StatisDate,''''); 
	PREPARE stmt FROM @v_sqlselect; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	-- 记录结束时间
	SET v_endtime = CURRENT_TIMESTAMP(); 

	-- 添加执行日志
	INSERT INTO KYStatis.prolog VALUES(NOW(),'KYDB_NEW.sp_StatisGameRoomData_reguser_everyDay',TIMESTAMPDIFF(SECOND,v_starttime,v_endtime)); 
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
DROP PROCEDURE IF EXISTS `sp_StatisLinecodeMonitoring_everyDay`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_StatisLinecodeMonitoring_everyDay`(IN `in_StatisDate` date)
BEGIN
	DECLARE v_tblname VARCHAR(100); 
	DECLARE v_starttime TIMESTAMP(3); 
	DECLARE v_endtime TIMESTAMP(3); 
	DECLARE v_date VARCHAR(30); 
	DECLARE v_month VARCHAR(30); 

	SET v_starttime = CURRENT_TIMESTAMP(3); 
	IF in_StatisDate IS NULL THEN
		SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
    END IF; 
		SET v_date = DATE_FORMAT(in_StatisDate,'%Y%m%d'); 
		SET v_month = DATE_FORMAT(in_StatisDate,'%Y%m'); 

	SET @v_sqlselect = CONCAT('REPLACE INTO KYStatis.statis_linecode_monitoring (StatisDate, ChannelID, LineCode, DWinGold, DLostGold, DCellScore, DRevenue, DWinNum, DLostNum, DActiveUsers, currency, exchangeRate)
                                SELECT ''',in_StatisDate,''', ChannelID, LineCode, SUM(WinGold), SUM(LostGold), SUM(CellScore), SUM(Revenue), SUM(WinNum), SUM(LostNum), COUNT(1) AS activeusers, currency, exchangeRate
                                FROM KYStatisUsers.statis_allgames',v_month,'_users
                                WHERE StatisDate=''',in_StatisDate,'''
                                GROUP BY ChannelID, LineCode, currency;'); 
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt; 

    SET @v_sqlselect = CONCAT('UPDATE KYStatis.statis_linecode_monitoring AS a
                                JOIN (
                                    SELECT ChannelID, LineCode, SUM(WinGold) AS WinGold, SUM(LostGold) AS LostGold, SUM(CellScore) AS CellScore, SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, COUNT(1) AS activeusers, currency, exchangeRate
                                    FROM KYStatisUsers.statis_month',v_month,'_users
                                    GROUP BY ChannelID, LineCode, currency) AS b ON a.ChannelID = b.ChannelID AND a.LineCode = b.LineCode AND a.currency = b.currency
                                SET a.MWinGold = b.WinGold, a.MLostGold = b.LostGold, a.MCellScore = b.CellScore, a.MRevenue = b.Revenue, a.MWinNum = b.WinNum, a.MLostNum = b.LostNum, a.MActiveUsers = b.activeusers, a.exchangeRate = b.exchangeRate
                                WHERE a.StatisDate = ''',in_StatisDate,''';'); 
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt; 

    SET @v_sqlselect = CONCAT('UPDATE KYStatis.statis_linecode_monitoring AS a
                                JOIN (
                                    SELECT ChannelID, LineCode, SUM(WinGold) AS WinGold, SUM(LostGold) AS LostGold, SUM(CellScore) AS CellScore, SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum,COUNT(1) AS activeusers, currency, exchangeRate
                                    FROM KYStatisUsers.statis_all_users
                                    GROUP BY ChannelID, LineCode, currency) AS b ON a.ChannelID = b.ChannelID AND a.LineCode = b.LineCode AND a.currency = b.currency
                                SET a.HWinGold = b.WinGold, a.HLostGold = b.LostGold, a.HCellScore = b.CellScore, a.HRevenue = b.Revenue, a.HWinNum = b.WinNum, a.HLostNum = b.LostNum, a.HActiveUsers = b.activeusers, a.exchangeRate = b.exchangeRate
                                WHERE a.StatisDate=''',in_StatisDate,''';'); 
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt; 

    SET v_endtime = CURRENT_TIMESTAMP(); 

    INSERT INTO KYStatis.prolog VALUES(NOW(),'KYDB_NEW.sp_StatisLinecodeMonitoring_everyDay',TIMESTAMPDIFF(SECOND,v_starttime,v_endtime)); 
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
DROP PROCEDURE IF EXISTS `sp_statisRecordGameMonth`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisRecordGameMonth`(IN `in_StatisDate` varchar(10),IN `in_GameType` varchar(20),IN `in_GameID` int)
BEGIN
	DECLARE v_sqlbase LONGTEXT; 
	DECLARE v_date VARCHAR(6); 
	DECLARE v_dbName VARCHAR(100); 
	
	SET v_sqlbase = ''; 
	IF in_StatisDate IS NULL THEN
		SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
	END IF; 
	SET v_date = DATE_FORMAT(in_StatisDate,'%Y%m'); 
	SET v_dbName = 'KYStatisUsers'; 

	IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = v_dbName AND TABLE_NAME = CONCAT('statis_',in_GameType, v_date,'_users')) THEN
			SET v_sqlbase = CONCAT('SELECT ''', DATE_FORMAT(in_StatisDate,'%Y-%m'),''' AS StatisDate,', in_GameID,' AS GameID, COUNT(distinct Account) AS ActiveUsers,SUM(WinGold) AS WinGold,
										SUM(LostGold) AS LostGold, SUM(CellScore) AS CellScore, SUM(Revenue) AS Revenue, SUM(WinNum) AS WinNum, SUM(LostNum) AS LostNum, A.Currency, B.exchangeRate 
									FROM ',v_dbName,'.statis_',in_GameType, v_date,'_users AS A 
									LEFT JOIN game_manage.rp_currency AS B ON A.currency = B.currency 
									GROUP BY currency'); 
			SET v_sqlbase = CONCAT('REPLACE INTO KYStatis.statis_record_game_month(StatisDate,GameID,ActiveUsers,WinGold,LostGold,CellScore,Revenue,WinNum,LostNum,Currency,exchangeRate)', v_sqlbase); 
			SET @v_sqlbase = v_sqlbase; 
			PREPARE stmt FROM @v_sqlbase; 
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
DROP PROCEDURE IF EXISTS `sp_statisRecordGameMonth_reguser`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisRecordGameMonth_reguser`(IN `in_StatisDate` varchar(10),IN `in_GameType` varchar(20),IN `in_GameID` int)
BEGIN
	DECLARE v_sqlbase LONGTEXT; 
	DECLARE v_date VARCHAR(6); 
	DECLARE v_dbName VARCHAR(100); 
			
	SET v_sqlbase = ''; 
	IF in_StatisDate IS NULL THEN
		SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
	END IF; 
	set v_date = DATE_FORMAT(in_StatisDate,'%Y%m'); 
	SET v_dbName = 'KYStatisUsers'; 

	IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = v_dbName AND TABLE_NAME = CONCAT('statis_',in_GameType, v_date,'_users')) THEN
			SET v_sqlbase = CONCAT('SELECT ''', DATE_FORMAT(in_StatisDate,'%Y-%m'),''' AS StatisDate,', in_GameID,' AS GameID, COUNT(distinct Account) AS ActiveUsers,SUM(WinGold) AS WinGold,
										SUM(LostGold) AS LostGold,SUM(CellScore) AS CellScore,SUM(Revenue) AS Revenue,SUM(WinNum) AS WinNum,SUM(LostNum) AS LostNum, A.currency, B.exchangeRate 
									FROM ',v_dbName,'.statis_',in_GameType, v_date,'_users AS A
									LEFT JOIN game_manage.rp_currency AS B ON A.currency = B.currency
									WHERE Account IN(
										SELECT account 
										FROM KYStatis.statis_reguser_account)
									GROUP BY currency'); 
			SET v_sqlbase = CONCAT('REPLACE INTO KYStatis.statis_record_game_month_reguser(StatisDate, GameID, ActiveUsers, WinGold, LostGold, CellScore, Revenue, WinNum, LostNum, currency, exchangeRate)', v_sqlbase); 
			SET @v_sqlbase = v_sqlbase; 
			PREPARE stmt FROM @v_sqlbase; 
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
DROP PROCEDURE IF EXISTS `sp_statisRecord_month`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisRecord_month`(IN `in_StatisDate` date)
BEGIN
	DECLARE v_startTime TIMESTAMP(3); 
	DECLARE v_endTime TIMESTAMP(3); 
	DECLARE done INT DEFAULT FALSE; 
	DECLARE cur_Gameid, cur_GameParameter LONGTEXT; 
	DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

	SET v_startTime = CURRENT_TIMESTAMP(3); 

	IF in_StatisDate is null THEN
		SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
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

		CALL KYDB_NEW.sp_statisRecordGameMonth(in_StatisDate, cur_GameParameter, cur_Gameid); 
		END LOOP; 
	CLOSE cur1;	

	SET v_endTime = CURRENT_TIMESTAMP(3); 
	INSERT INTO KYStatis.prolog VALUES(NOW(),'sp_statisRecord_month',TIMESTAMPDIFF(SECOND,v_startTime,v_endTime)); 
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
DROP PROCEDURE IF EXISTS `sp_statisRecord_month_reguser`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statisRecord_month_reguser`(IN `in_StatisDate` date)
BEGIN
	DECLARE v_startTime TIMESTAMP(3); 
	DECLARE v_endTime TIMESTAMP(3); 
	DECLARE done INT DEFAULT FALSE; 
	DECLARE cur_Gameid, cur_GameParameter LONGTEXT; 
	DECLARE cur1 CURSOR FOR SELECT Gameid, GameParameter FROM KYDB_NEW.GameInfo; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

	SET v_startTime = CURRENT_TIMESTAMP(3); 

	IF in_StatisDate is null THEN
		SET in_StatisDate = DATE_ADD(CURDATE(),INTERVAL -1 day); 
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

			CALL KYDB_NEW.sp_statisRecordGameMonth_reguser(in_StatisDate, cur_GameParameter, cur_Gameid); 
		END LOOP; 
	CLOSE cur1;	

	SET v_endTime = CURRENT_TIMESTAMP(3); 

	INSERT INTO KYStatis.prolog VALUES(NOW(),'sp_statisRecord_month_reguser',TIMESTAMPDIFF(SECOND,v_startTime,v_endTime)); 
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
	SET v_tblname = CONCAT(in_GameName, '_gamerecord'); 
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
				WHERE GameEndTime >= ',v_startTime,'
				AND GameEndTime <= ',v_endTime,'
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
DROP PROCEDURE IF EXISTS `sp_statis_agent`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statis_agent`()
BEGIN
	DECLARE done BOOLEAN DEFAULT FALSE; 
	DECLARE agentId int(11) UNSIGNED; 
	DECLARE cur CURSOR FOR select agent from KYDB_NEW.agents where status =0; 
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 

	set @timediff = NOW(); 

	OPEN cur; 
		agentLoop : LOOP
			FETCH cur INTO agentId; 
		
			IF done THEN
				LEAVE agentLoop; 
			END IF; 

			replace into KYStatis.statis_agent(agent,count,mstatus0,mstatus1,mstatus2,mstatus3)
			select agent,count(1) as MemberCount,
			sum(CASE WHEN accounts.mstatus =0 THEN 1 ELSE 0 END) as mstatus0,
			sum(CASE WHEN accounts.mstatus =1 THEN 1 ELSE 0 END) as mstatus1,
			sum(CASE WHEN accounts.mstatus =2 THEN 1 ELSE 0 END) as mstatus2,
			sum(CASE WHEN accounts.mstatus =3 THEN 1 ELSE 0 END) as mstatus3
			from KYDB_NEW.accounts as accounts where agent = agentId group by agent; 

			END LOOP agentLoop; 
	CLOSE cur; 

	set @ts = TIMESTAMPDIFF(SECOND,@timediff,NOW()); 
	insert into KYStatis.prolog values(NOW(),'KYDB_NEW.sp_statis_agent',@ts); 

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
DROP PROCEDURE IF EXISTS `sp_statis_agent_month_activeUsers_reguser`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statis_agent_month_activeUsers_reguser`(IN `in_statisDate` date)
BEGIN
	DECLARE v_startTime TIMESTAMP(3); 
	DECLARE v_endTime TIMESTAMP(3); 
    DECLARE v_sqlBase LONGTEXT; 
	DECLARE v_date VARCHAR(30); 
	DECLARE v_date2 VARCHAR(30); 

	SET v_startTime = CURRENT_TIMESTAMP(3); 
    SET v_sqlBase = ''; 

	IF in_statisDate IS NULL THEN
		SET in_statisDate = DATE_ADD(CURDATE(),INTERVAL -1 DAY); 
	END IF; 

	SET v_date = DATE_FORMAT(in_statisDate,'%Y-%m'); 
	SET v_date2 = DATE_FORMAT(DATE_ADD(in_statisDate,INTERVAL 1 MONTH),'%Y-%m'); 

	SET v_sqlBase = CONCAT('
        UPDATE KYStatis.statis_record_agent_month AS a FORCE index(PRIMARY) 
        JOIN (
            SELECT 
			''',v_date,''' AS statisDate, 
			agent AS ChannelID, 
			COUNT(DISTINCT Account) userCount
            FROM game_api.accounts 
            WHERE firstBetTime >= ''',v_date,'-02 00:00:00'' 
            AND firstBetTime <= ''',v_date2,'-01 23:59:59'' 
            GROUP BY agent) AS b ON a.ChannelID = b.ChannelID AND a.StatisDate = b.statisDate
            SET a.ActiveUsers_reguser = b.userCount;'); 

	SET @v_sqlBase = v_sqlBase; 
	PREPARE stmt from @v_sqlBase; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	SET v_endTime = CURRENT_TIMESTAMP(3); 
	INSERT INTO KYStatis.prolog VALUES (NOW(), 'sp_statis_agent_month_activeUsers_reguser', TIMESTAMPDIFF(SECOND,v_startTime,v_endTime)); 

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
DROP PROCEDURE IF EXISTS `sp_statis_agent_top_all_line`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statis_agent_top_all_line`(IN `u_channelid` int)
BEGIN
    declare v_sql longtext; 
    declare v_i int; 
    declare v_channelId int; 
    declare v_channelName VARCHAR(50); 
    declare v_nickName VARCHAR(50); 
    declare v_channelIdList LONGTEXT; 
    set v_channelId=0; 
    set v_channelName=''; 
    set v_nickName=''; 
    set v_channelIdList=''; 



    drop table if exists TEMP_AGENT_TOP; 
    create temporary table TEMP_AGENT_TOP (
                                              ChannelID int not null,
                                              TopUID int not null
    ) DEFAULT CHARSET=utf8; 

    set v_sql = ''; 

    set v_i = 0; 
    agent_loop:LOOP
        select ChannelID,Accounts,NickName into v_channelId,v_channelName,v_nickName from KYDB_NEW.Sys_ProxyAccount where UID = u_channelid limit v_i,1; 
        if v_channelId = 0 then
            leave agent_loop; 
        end if; 

        select KYDB_NEW.selRecursive(v_channelId) into v_channelIdList; 
        set v_sql = concat('insert into TEMP_AGENT_TOP(ChannelID,TopUID)'); 
        set v_sql = concat(v_sql, 'select ChannelID,', v_channelId,' as TopUID from KYDB_NEW.Sys_ProxyAccount',
                           ' where FIND_IN_SET(ChannelId,''', v_channelIdList,''')'); 
        set @v_sql = v_sql; 
        prepare stmt from @v_sql; 
        execute stmt; 
        deallocate prepare stmt; 

        set v_i = v_i +1; 
        set v_channelId = 0; 
    end loop agent_loop; 

    update KYDB_NEW.Sys_ProxyAccount A inner join TEMP_AGENT_TOP B on A.ChannelID = B.ChannelID set A.topuid = B.TopUID; 
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
DROP PROCEDURE IF EXISTS `sp_Statis_GetUsers`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_Statis_GetUsers`(IN `beginDate` varchar(10), IN `endDate` varchar(10))
BEGIN

	DECLARE v_sql VARCHAR(4000); 

	DECLARE Y_NonLoginUsers INT; 

	DECLARE Y_RegUsers INT; 

	DECLARE Y_PayUsers INT; 

	DECLARE monthNonLoginUsers INT; 

	DECLARE monthRegUsers INT; 

	DECLARE monthPayUsers INT; 

	DECLARE historyNonLoginUsers INT; 

	DECLARE historyRegUsers INT; 

	DECLARE historyPayUsers INT; 

	DECLARE NextRegisterUser INT; 

	DECLARE NextLoginUser INT; 

	DECLARE ValidNextRegisterUser INT; 

	DECLARE ValidNextLoginUser INT; 

	DECLARE SevenRegisterUser INT; 

	DECLARE SevenLoginUser INT; 

	DECLARE ValidSevenRegisterUser INT; 

	DECLARE ValidSevenLoginUser INT; 

	DECLARE MonthRegisterUser INT; 

	DECLARE MonthLoginUser INT; 

	DECLARE ValidMonthRegisterUser INT; 

	DECLARE ValidMonthLoginUser INT; 

	DECLARE j INT; 

	DECLARE v_tblName_order_detail VARCHAR(100); 

	DECLARE v_tblName_login_detail VARCHAR(100); 

	DECLARE v_tblName_order_history VARCHAR(100); 

	DECLARE v_tblName_login_history VARCHAR(100); 

	DECLARE v_tblName_login_month VARCHAR(100); 

	DECLARE v_tblName_order_month VARCHAR(100); 



	SET @timediff = NOW(); 



	IF beginDate IS NULL AND endDate IS NULL THEN

		SET beginDate = DATE_ADD(CURDATE(),INTERVAL -1 DAY); 

		SET endDate = beginDate; 

END IF; 



	SET @days = DATEDIFF(endDate,beginDate); 

	SET @i = 0; 



	WHILE @i <= @days DO

		SET @curDate = DATE_ADD(beginDate,INTERVAL @i DAY); 

		SET @curDate_end = CONCAT(@curDate,' 23:59:59.998'); 

		SET @f_date = DATE_ADD(@curDate,INTERVAL -day(@curDate)+1 DAY); 



		SET @f_date_end = CONCAT(@curDate,' 23:59:59.998'); 

		SET @y_date = DATE_ADD(@curDate,INTERVAL -1 DAY); 

		SET @s_date = DATE_ADD(@curDate,INTERVAL -7 DAY); 

		SET @m_date = DATE_ADD(@curDate,INTERVAL -30 DAY); 

		SET @tblName = CONCAT('agent_orders',DATE_FORMAT(@curDate,'%Y%m%d')); 

		SET v_tblName_order_detail = CONCAT('KYStatisLogin.statis_agent_orders_detail_', DATE_FORMAT(@curDate,'%Y%m')); 

		SET v_tblName_login_detail = CONCAT('KYStatisLogin.statis_login_hall_detail_', DATE_FORMAT(@curDate,'%Y%m')); 

		SET v_tblName_order_history = CONCAT('KYStatisLogin.statis_agent_orders_history_', DATE_FORMAT(@curDate,'%Y%m')); 

		SET v_tblName_login_history = CONCAT('KYStatisLogin.statis_login_hall_history_', DATE_FORMAT(@curDate,'%Y%m')); 

		SET v_tblName_login_month = CONCAT('KYStatisLogin.statis_login_hall_month_', DATE_FORMAT(@curDate,'%Y%m')); 

		SET v_tblName_order_month = CONCAT('KYStatisLogin.statis_agent_orders_month_', DATE_FORMAT(@curDate,'%Y%m')); 



		REPLACE INTO KYStatis.statisusers(StatisDate, ChannelId)

SELECT @curDate AS StatisDate, ChannelID FROM KYDB_NEW.Sys_ProxyAccount; 





SET v_sql = CONCAT('UPDATE KYStatis.statisusers AS a

                    INNER JOIN (

                        SELECT ChannelId, COUNT(Accounts) AS Y_NonLoginUsers

                        FROM ', v_tblName_login_detail,'

                        WHERE StatisDate = ''', @curDate,'''

                        GROUP BY ChannelId) AS b

                    SET a.Y_NonLoginUsers = b.Y_NonLoginUsers WHERE StatisDate = ''', @curDate,''' AND a.ChannelID = b.ChannelId'); 

		SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 





SET v_sql = CONCAT('UPDATE KYStatis.statisusers AS a

                            INNER JOIN (

                                SELECT m.agent, COUNT(m.account) AS dayNewLogin

                                FROM (

                                    SELECT agent, account

                                    FROM KYDB_NEW.accounts

                                    WHERE createdate >= ''', @curDate,''' AND createdate <= ''', @curDate,' 23:59:59.998'') AS m

								INNER JOIN (

									SELECT ChannelId, Accounts

                                    FROM ', v_tblName_login_detail,'

                                    WHERE StatisDate = ''', @curDate,''') AS login ON m.account = login.Accounts AND m.agent = login.ChannelId

                                    GROUP BY m.agent) AS T ON a.ChannelID = T.agent

							SET a.dayNewLogin = T.dayNewLogin WHERE StatisDate = ''', @curDate,''''); 

		SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



UPDATE KYStatis.statisusers AS a

    INNER JOIN (

    SELECT agent, COUNT(account) AS Y_RegUsers

    FROM KYDB_NEW.accounts

    WHERE createdate >= @curDate AND createdate <= @curDate_end

    GROUP BY agent) AS b

SET a.Y_RegUsers = b.Y_RegUsers WHERE StatisDate = @curDate AND a.ChannelID = b.agent; 



SET v_sql = CONCAT('UPDATE KYStatis.statisusers AS a

                            INNER JOIN (

                                SELECT ChannelId, COUNT(Accounts) AS Y_PayUsers

                                FROM ', v_tblName_order_detail,'

                                WHERE StatisDate = ''', @curDate,'''

                                GROUP BY ChannelId) AS b

                            SET a.Y_PayUsers = b.Y_PayUsers WHERE StatisDate = ''', @curDate,''' AND a.ChannelId = b.ChannelId'); 

		SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 





SET v_sql = CONCAT('UPDATE KYStatis.statisusers AS c

                            INNER JOIN (

                                SELECT a.ChannelId, COUNT(1) AS Y_NewLoginUsers

                                FROM (

                                    SELECT Accounts, ChannelId

                                    FROM KYStatisLogin.`statis_login_hall_detail_',DATE_FORMAT(@curDate,'%Y%m'),'`

                                    WHERE StatisDate=''',@curDate,''') AS a

                                LEFT JOIN KYStatisLogin.statis_login_hall_history AS b ON a.ChannelId = b.ChannelId AND a.Accounts = b.Accounts WHERE ISNULL(b.Accounts)

                                GROUP BY a.ChannelId)AS d

                                SET c.Y_NewLoginUsers = d.Y_NewLoginUsers WHERE StatisDate = ''',@curDate,''' AND c.ChannelID = d.ChannelID'); 

        SET @v_sql = v_sql; 

prepare stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE prepare stmt; 



SET v_sql = concat('UPDATE KYStatis.statisusers AS a

                            INNER JOIN (

                                SELECT ChannelId, COUNT(accounts) AS monthNonLoginUsers

                                FROM ', v_tblName_login_month,'

                                GROUP BY ChannelId) AS b

                            SET a.M_NonLoginUsers = b.monthNonLoginUsers WHERE StatisDate = ''', @curDate,''' AND a.ChannelID = b.ChannelId'); 

		SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



SET v_sql = CONCAT('UPDATE KYStatis.statisusers AS a

                            INNER JOIN (

                                SELECT ChannelID, SUM(Y_RegUsers) AS monthRegUsers

                                FROM KYStatis.statisusers

                                WHERE StatisDate >= ''',@f_date,''' AND StatisDate <= ''',@curDate,'''

                                GROUP BY ChannelID) AS b

                            SET a.M_RegUsers = b.monthRegUsers WHERE StatisDate = ''', @curDate,''' AND a.ChannelID = b.ChannelID'); 

		SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



SET v_sql = concat('UPDATE KYStatis.statisusers AS a

                            INNER JOIN (

                                SELECT ChannelId, COUNT(accounts) AS monthPayUsers

                                FROM ', v_tblName_order_month,'

                                GROUP BY ChannelId) AS b

                                SET a.M_PayUsers = b.monthPayUsers WHERE StatisDate = ''', @curDate,''' AND a.ChannelID = b.ChannelId'); 

		SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



SET v_sql = concat('UPDATE KYStatis.statisusers AS a

                            INNER JOIN (

                                SELECT ChannelId, COUNT(accounts) AS historyNonLoginUsers

                                FROM KYStatisLogin.statis_login_hall_history

                                GROUP BY ChannelId) AS b

                            SET a.H_NonLoginUsers = b.historyNonLoginUsers WHERE StatisDate = ''', @curDate,''' AND a.ChannelID = b.ChannelId'); 

		SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



SET v_sql = concat('UPDATE KYStatis.statisusers AS a

                            INNER JOIN (

                                SELECT ChannelID, SUM(Y_RegUsers) AS historyRegUsers

                                FROM KYStatis.statisusers WHERE StatisDate <= ''', @curDate,'''

                                GROUP BY ChannelID) AS b

                            SET a.H_RegUsers = b.historyRegUsers WHERE StatisDate = ''', @curDate,''' AND a.ChannelID = b.ChannelID;'); 

		SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



SET v_sql = concat('UPDATE KYStatis.statisusers AS a

                            INNER JOIN (

                                SELECT ChannelId, COUNT(accounts) AS historyPayUsers

                                FROM KYStatisLogin.statis_agent_orders_history

                                GROUP BY ChannelId) AS b

                                SET a.H_PayUsers = b.historyPayUsers WHERE StatisDate = ''', @curDate,''' AND a.ChannelID = b.ChannelId'); 

		SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



SET v_sql = CONCAT('UPDATE KYStatis.statisusers AS main

                    INNER JOIN (

                       SELECT a.agent, COUNT(a.account) AS NextRegisterUser, COUNT(b.Accounts) AS NextLoginUser

                       FROM ( SELECT agent, account

                              FROM KYDB_NEW.accounts

                              WHERE createdate >= ''', @y_date,''' AND createdate <= ''', @y_date,' 23:59:59.998''

                       ) AS a

                       LEFT JOIN (

									            SELECT ChannelID, Accounts

                              FROM ', v_tblName_login_detail,'

                              WHERE StatisDate = ''', @curDate,'''

                       ) b ON a.account = b.Accounts

                       GROUP BY a.agent) AS T ON main.ChannelID = T.agent

                    SET main.NextRegisterUser = T.NextRegisterUser,main.NextLoginUser = T.NextLoginUser WHERE StatisDate = ''',@curDate,''''); 

		SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



IF EXISTS(SELECT * FROM information_schema.`TABLES` WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = concat('statis_allgames', DATE_FORMAT(@y_date,'%Y%m'),'_users')) THEN

			SET v_sql = CONCAT('UPDATE KYStatis.statisusers AS main

                          INNER JOIN (

                              SELECT a.agent, COUNT(a.account) AS ValidNextRegisterUser, COUNT(b.Accounts) AS ValidNextLoginUser

                              FROM (  SELECT m.agent, m.account

                                      FROM (

                                          SELECT agent, account

                                          FROM KYDB_NEW.accounts

                                          WHERE createdate >= ''', @y_date,''' AND createdate <= ''', @y_date,' 23:59:59.998''

																			) AS m

																			INNER JOIN (

																					SELECT ChannelID, Account

                                          FROM KYStatisUsers.statis_allgames', DATE_FORMAT(@y_date,'%Y%m'),'_users

                                          WHERE StatisDate = ''', @y_date,'''

                                          GROUP BY ChannelID, Account

																			) AS n ON m.account = n.Account

															) AS a

                              LEFT JOIN ( SELECT ChannelID,Accounts

                                          FROM ', v_tblName_login_detail,'

                                          WHERE StatisDate = ''', @curDate,'''

                              ) AS b ON a.account = b.Accounts

                              GROUP BY a.agent

                          ) AS T ON main.ChannelID = T.agent

                          SET main.ValidNextRegisterUser = T.ValidNextRegisterUser, main.ValidNextLoginUser = T.ValidNextLoginUser WHERE StatisDate = ''',@curDate,''''); 

			SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 

END IF; 



		SET v_sql = CONCAT('UPDATE KYStatis.statisusers AS main

                        INNER JOIN (

                          SELECT a.agent, COUNT(a.account) AS SevenRegisterUser, COUNT(b.Accounts) AS SevenLoginUser

                          FROM (

															SELECT agent, account

                              FROM KYDB_NEW.accounts

															WHERE createdate >= ''', @s_date,''' AND createdate <= ''', @s_date,' 23:59:59.998''

													) AS a

                          LEFT JOIN (

															SELECT ChannelID,Accounts

                              FROM ', v_tblName_login_detail,'

                              WHERE StatisDate = ''', @curDate,'''

													) AS b ON a.account = b.Accounts

                          GROUP BY a.agent

												) AS T ON main.ChannelID = T.agent

                        SET main.SevenRegisterUser = T.SevenRegisterUser, main.SevenLoginUser = T.SevenLoginUser WHERE StatisDate = ''',@curDate,''''); 

		SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



IF EXISTS(SELECT * FROM information_schema.`TABLES` WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = concat('statis_allgames', DATE_FORMAT(@s_date,'%Y%m'),'_users')) THEN

			SET v_sql = CONCAT('UPDATE KYStatis.statisusers AS main

                          INNER JOIN (

                              SELECT a.agent, COUNT(a.account) AS ValidSevenRegisterUser, COUNT(b.Accounts) AS ValidSevenLoginUser

                              FROM (

																	SELECT m.agent, m.account

                                  FROM (

                                      SELECT agent, account

                                      FROM KYDB_NEW.accounts

                                      WHERE createdate >= ''', @s_date,''' AND createdate <= ''', @s_date,' 23:59:59.998''

																	) AS m

																	INNER JOIN (

																			SELECT ChannelID, Account

                                      FROM KYStatisUsers.statis_allgames', DATE_FORMAT(@s_date,'%Y%m'),'_users

                                      WHERE StatisDate = ''', @s_date,'''

																			GROUP BY ChannelID, Account

																	) AS n ON m.account = n.Account

															) AS a

                              LEFT JOIN (

																	SELECT ChannelID, Accounts

                                  FROM ', v_tblName_login_detail,'

                                  WHERE StatisDate = ''', @curDate,'''

															) AS b ON a.account = b.Accounts

                              GROUP BY a.agent

													) AS T ON main.ChannelID = T.agent

                          SET main.ValidSevenRegisterUser = T.ValidSevenRegisterUser, main.ValidSevenLoginUser = T.ValidSevenLoginUser

													WHERE StatisDate = ''',@curDate,''''); 

			SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 

END IF; 



		SET v_sql = CONCAT('UPDATE KYStatis.statisusers AS main

                        INNER JOIN (

														SELECT a.agent, COUNT(a.account) AS MonthRegisterUser, COUNT(b.Accounts) AS MonthLoginUser

                            FROM (

																SELECT agent,account

                                FROM KYDB_NEW.accounts

                                WHERE createdate >= ''', @m_date,''' AND createdate <= ''', @m_date,' 23:59:59.998''

														) AS a

														LEFT JOIN (

																SELECT ChannelID,Accounts

                                FROM ', v_tblName_login_detail,' WHERE StatisDate = ''', @curDate,'''

														) b ON a.account = b.Accounts

                            GROUP BY a.agent

												) AS T ON main.ChannelID = T.agent

                        SET main.MonthRegisterUser = T.MonthRegisterUser, main.MonthLoginUser = T.MonthLoginUser WHERE StatisDate = ''',@curDate,''''); 

		SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



IF EXISTS(SELECT * FROM information_schema.`TABLES` WHERE TABLE_SCHEMA = 'KYStatisUsers' AND TABLE_NAME = concat('statis_allgames', DATE_FORMAT(@m_date,'%Y%m'),'_users')) THEN

            SET v_sql = CONCAT('UPDATE KYStatis.statisusers AS main

                                INNER JOIN (

                                    SELECT a.agent, COUNT(a.account) AS ValidMonthRegisterUser, COUNT(b.Accounts) AS ValidMonthLoginUser

                                    FROM (

																				SELECT m.agent, m.account

                                        FROM (

                                            SELECT agent, account

                                            FROM KYDB_NEW.accounts

                                            WHERE createdate >= ''', @m_date,''' AND createdate <= ''', @m_date,' 23:59:59.998''

																				) AS m

																				INNER JOIN (

																						SELECT ChannelID, Account

                                            FROM KYStatisUsers.statis_allgames', DATE_FORMAT(@m_date,'%Y%m'),'_users

                                            WHERE StatisDate = ''', @m_date,'''

																						GROUP BY ChannelID, Account

																				) AS n ON m.account = n.Account

																		) AS a

                                    LEFT JOIN (

																				SELECT ChannelID, Accounts

                                        FROM ', v_tblName_login_detail,'

                                        WHERE StatisDate = ''', @curDate,'''

																		) b ON a.account = b.Accounts

																		GROUP BY a.agent

																) AS T ON main.ChannelID = T.agent

                                SET main.ValidMonthRegisterUser = T.ValidMonthRegisterUser,main.ValidMonthLoginUser = T.ValidMonthLoginUser WHERE StatisDate = ''',@curDate,''''); 

			SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 

END IF; 



		SET v_sql = CONCAT('UPDATE KYStatis.statisusers AS main

                        INNER JOIN (

                           SELECT m.agent, COUNT(m.account) AS DayNewBetUsers

                           FROM (

                             SELECT agent,account

                             FROM KYDB_NEW.accounts

                             WHERE createdate >= ''', @curDate,''' AND createdate <= ''', @curDate,' 23:59:59.998''

                             GROUP BY agent,account

                           ) AS m

								           INNER JOIN (

                             SELECT ChannelID, Account

                             FROM KYStatisUsers.statis_allgames', DATE_FORMAT(@curDate,'%Y%m'),'_users

                             WHERE StatisDate = ''', @curDate,'''

                             GROUP BY ChannelID,Account

                           ) a ON m.account = a.Account

                           GROUP BY m.agent

												) AS T ON main.ChannelID = T.agent

                        SET main.DayNewBetUsers = T.DayNewBetUsers WHERE StatisDate = ''',@curDate ,''''); 

		SET @v_sql = v_sql; 

PREPARE stmt FROM @v_sql; 

EXECUTE stmt; 

DEALLOCATE PREPARE stmt; 



SET @i = @i + 1; 

END WHILE; 



	SET @ts = TIMESTAMPDIFF(SECOND,@timediff,NOW()); 

INSERT INTO KYStatis.prolog VALUES(NOW(),'KYDB_NEW.sp_Statis_GetUsers',@ts); 



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
DROP PROCEDURE IF EXISTS `sp_statis_record_agent_all_repair`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statis_record_agent_all_repair`(IN in_StatisDate DATE)
BEGIN

    DECLARE v_sqlselect LONGTEXT; 
    DECLARE v_startTime TIMESTAMP(3); 
    DECLARE v_endTime TIMESTAMP(3); 
    DECLARE v_date VARCHAR(30); 
    DECLARE v_dbName VARCHAR(100); 

    SET v_startTime = CURRENT_TIMESTAMP(3); 
    
    IF in_StatisDate IS NULL THEN
        SET in_StatisDate = CURDATE(); 
    END IF; 

    SET v_date = DATE_FORMAT(in_StatisDate,'%Y%m'); 

    SET v_sqlselect = CONCAT(
        'REPLACE INTO KYStatis.statis_record_agent_all(StatisDate, ChannelID, WinGold, LostGold, CellScore, Revenue, WinNum, LostNum, ActiveUsers, currency, exchangeRate)
            SELECT 
                StatisDate,
                ChannelID,
                SUM(WinGold) AS WinGold,
                SUM(LostGold) AS LostGold, 
                SUM(CellScore) AS CellScore,
                SUM(Revenue) AS Revenue, 
                SUM(WinNum) AS WinNum, 
                SUM(LostNum) AS LostNum, 
                COUNT(distinct Account) AS ActiveUsers, 
                A.currency, 
                B.exchangeRate
            FROM KYStatisUsers.statis_allgames',v_date,'_users AS A
            LEFT JOIN game_manage.rp_currency AS B ON A.currency = B.currency
            GROUP BY ChannelID, currency, StatisDate'); 

    SET @v_sqlselect = v_sqlselect; 
        
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt; 
    
    SET v_endTime = CURRENT_TIMESTAMP(3); 
    
    INSERT INTO KYStatis.prolog VALUES(NOW(),'sp_statis_record_agent_all_repair',TIMESTAMPDIFF(SECOND,v_startTime,v_endTime)); 
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
DROP PROCEDURE IF EXISTS `sp_updateGameTagSort`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_updateGameTagSort`(IN `targetId` BIGINT, IN `newName` varchar(100), IN `newSort` BIGINT, `subTagStatus` int)
BEGIN
    DECLARE v_languageId BIGINT; 
    DECLARE v_currentSort BIGINT; 
    DECLARE v_existingId BIGINT; 

    -- 获取目标资料的 languageId 和 sort 值
    SELECT languageId, sort INTO v_languageId, v_currentSort
    FROM gameTag
    WHERE id = targetId; 

    -- 检查是否存在相同 languageId 且 sort 值为新值的其他资料
    SELECT id INTO v_existingId
    FROM gameTag
    WHERE languageId = v_languageId AND sort = newSort AND id <> targetId
    LIMIT 1; 

    -- 如果存在相同 languageId 和 sort 值的其他资料，先更换其他资料
    IF v_existingId IS NOT NULL THEN
        -- target.sort => -1
        UPDATE gameTag SET sort = -1 WHERE id = targetId; 
        -- existing.sort => currentSort
        UPDATE gameTag SET sort = v_currentSort WHERE id = v_existingId; 
    END IF; 
    -- target.sort => newSort
    UPDATE gameTag SET sort = newSort, name = newName, subTagStatus = subTagStatus WHERE id = targetId; 
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
DROP PROCEDURE IF EXISTS `sp_updateResultData`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_updateResultData`(OUT `recordTotal` int,IN `KindID` int,IN `gameNo` varchar(30),IN `cardValue` varchar(1000))
BEGIN
	DECLARE v_sqlcount LONGTEXT; 
	DECLARE v_tblname varchar(100); 

	SELECT GameParameter INTO @cur_GameParameter FROM KYDB_NEW.GameInfo WHERE Gameid =  kindId; 
	SET v_tblname = CONCAT(@cur_GameParameter, '_gameRecord'); 
	SET v_sqlcount = CONCAT("UPDATE detail_record.", v_tblname, " SET CardValue = '", cardValue, "' WHERE GameUserNO = '", gameNo, "'"); 
		
	SET @v_sqlcount = v_sqlcount; 
	PREPARE stmt FROM @v_sqlcount; 
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
DROP PROCEDURE IF EXISTS `sp_UpdateyxhdAward`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_UpdateyxhdAward`(IN `Accounts` VARCHAR ( 190 ),IN `ChannelIDs` INT)
BEGIN
DECLARE
	counts INT; 
DECLARE
	IsGets INT; 
DECLARE
	Num INT; 
DECLARE
	result_code INT DEFAULT 0; 
DECLARE
 CONTINUE HANDLER FOR SQLEXCEPTION 
	SET result_code =- 1; 

START TRANSACTION; 

SELECT 	COUNT( 1 ),
	IsGet,
	IFNULL(a.Banking,-1) 
INTO @counts, @IsGet,@Banking
	FROM
(
SELECT *,
(@i :=@i + 1) AS Banking
FROM KYStatis.statis_activity_users,
(SELECT @i:=0) as it
ORDER BY CellScore DESC ) a
WHERE Account=Accounts AND ChannelID=ChannelIDs; 

SET counts = @counts; 
SET IsGets = @IsGet; 
SET Num=@Banking; 

IF
	counts = 0 THEN
 ROLLBACK; 
SELECT
2 AS statuscode,Num AS Nums; 

ELSEIF IsGets = 1 THEN
 ROLLBACK; 
SELECT
1 AS statuscode,Num AS Nums; 

ELSE UPDATE KYStatis.statis_activity_users 
SET IsGet = 1 
WHERE
Account = Accounts AND ChannelID=ChannelIDs; 
IF
result_code = 0 THEN
 COMMIT; 
SELECT
0 AS statuscode,Num AS Nums; 
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
DROP PROCEDURE IF EXISTS `sp_UserOrderDetail`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_UserOrderDetail`(OUT `recordTotal` int,IN `gameSQL` text,IN `pageSize` int,IN `pageIndex` int,IN `orderString` varchar(50),IN `tmpRecordCount` int,IN `orderType` int,IN `orderStatus` int,IN `beginDate` varchar(30),IN `endDate` varchar(30),IN `accounts` varchar(190),IN `createUser` varchar(100),IN `channelId` int,IN `isPage` bit,IN `isStatis` bit,IN `currency` varchar(100))
BEGIN
	DECLARE v_sqlcount LONGTEXT; 
	DECLARE v_sqlselect LONGTEXT; 
	DECLARE v_sqlrecord LONGTEXT; 
	DECLARE v_sqlorder LONGTEXT; 
	DECLARE v_sqlbase LONGTEXT; 
	DECLARE v_sqlstatis LONGTEXT; 
	DECLARE v_orderwhere VARCHAR(1000); 
	DECLARE v_ht_orderwhere VARCHAR(1000); 
	DECLARE v_days INT; 

	SET v_sqlcount = ''; 
	SET v_sqlselect = ''; 
	SET v_sqlrecord = gameSQL; 
	SET v_sqlorder = ''; 
	SET v_sqlbase = ''; 

	-- 拼接where条件
	SET v_orderwhere = CONCAT(' AND OrderTime >= ''',beginDate,''' AND OrderTime <= ''',endDate,''' AND AddScore <> 0'); 
	SET v_ht_orderwhere = CONCAT(' AND OrderTime >= ''',beginDate,''' AND OrderTime <= ''',endDate,''' AND AddScore <> 0'); 

	IF orderType <> -1 AND orderType <> -2 THEN
		SET v_orderwhere = CONCAT(v_orderwhere,' AND type = ',orderType); 
		SET v_ht_orderwhere = CONCAT(v_ht_orderwhere,' AND type =',orderType); 
	ELSEIF orderType = -2 THEN
		SET v_orderwhere = CONCAT(v_orderwhere,' AND (OrderType = 6 OR OrderType = 7)'); 
END IF; 

	IF orderStatus <> -1 THEN
		SET v_orderwhere = CONCAT(v_orderwhere,' AND OrderStatus = ',orderStatus); 
END IF; 

	IF LENGTH(createUser) > 0 THEN
		SET v_orderwhere = CONCAT(v_orderwhere,' AND CreateUser = ''',createUser,''''); 
		SET v_ht_orderwhere = CONCAT(v_ht_orderwhere,' AND CreateUser =''',createUser,''''); 
END IF; 

	IF channelId > 0 THEN
		SET v_orderwhere = CONCAT(v_orderwhere,' AND ChannelID = ''',channelId,''''); 
		SET v_ht_orderwhere = CONCAT(v_ht_orderwhere,' AND agentId =',channelId); 
END IF; 

	IF LENGTH(accounts) > 0 THEN
		SET v_orderwhere = CONCAT(v_orderwhere,' AND CreateUser = ''',accounts,''''); 
		SET v_ht_orderwhere = CONCAT(v_ht_orderwhere,' AND playerAccount = ''',accounts,''''); 
END IF; 

	IF LENGTH(currency) > 0 THEN
		SET v_orderwhere = CONCAT(v_orderwhere,' AND currency = ''',currency,''''); 
		SET v_ht_orderwhere = CONCAT(v_ht_orderwhere,' AND currency =''',currency,''''); 
END IF; 

	IF orderType = -1 OR orderType = -2 OR orderType = 6 OR orderType = 7 OR orderType = 12 OR orderType = 13 OR orderType = 14 OR orderType = 15 THEN
		-- 现金网上下分
		SET v_sqlorder = CONCAT('SELECT OrderID, OrderTime, ChannelID, OrderType, OrderStatus,
										CurScore, AddScore, NewScore, OrderIP, CreateUser AS account, CreateUser, currency
									FROM orders_record.player_orders
									WHERE 1 = 1',v_orderwhere); 
END IF; 

	IF (orderType = -1 OR orderType = 0 OR orderType = 1) AND (orderStatus = -1 OR orderStatus = 0) THEN
		-- 后台上下分
		SET v_sqlorder = CONCAT(IF(LENGTH(v_sqlorder) <> 0,CONCAT(v_sqlorder,' UNION ALL '),''),
						' SELECT OrderNo As orderId, OrderTime, agentId AS ChannelID, type AS OrderType, 0 AS OrderStatus, originScore AS CurScore, AddScore,
								NewScore, ip AS OrderIP, playerAccount AS account,CreateUser, currency
							FROM KYOrder.view_playerHTOrder
							WHERE 1 = 1',v_ht_orderwhere); 
END IF; 

	SET v_sqlbase = CONCAT(IFNULL(v_sqlorder,''),IF(LENGTH(v_sqlorder) <> 0 AND LENGTH(v_sqlrecord) <> 0,CONCAT(' UNION ALL ', v_sqlrecord),v_sqlrecord)); 

	IF LENGTH(v_sqlbase) <> 0 THEN
		SET v_sqlselect = CONCAT('SELECT main.*, p.Accounts AS ChannelName
									FROM (',v_sqlbase,') AS main
									LEFT JOIN KYDB_NEW.Sys_ProxyAccount AS p ON main.ChannelId = p.ChannelId ',orderString); 
		IF isPage = 1 THEN
			SET v_sqlselect = CONCAT(v_sqlselect,' LIMIT ',pageIndex,',',pageSize); 
END IF; 
        SET @v_sqlselect = v_sqlselect; 
PREPARE stmt FROM @v_sqlselect; 
EXECUTE stmt; 
DEALLOCATE PREPARE stmt; 

IF isStatis = 1 AND tmpRecordCount = 0 THEN
			SET v_sqlstatis = CONCAT('SELECT COUNT(*), SUM(CASE WHEN OrderType = 8 AND AddScore < 0 THEN AddScore ELSE 0 END),
											SUM(CASE WHEN OrderType = 9 OR (ordertype = 8 AND addscore > 0) THEN AddScore ELSE 0 END),
											SUM(CASE WHEN OrderType = 6 OR OrderType = 13 OR OrderType = 14 OR ordertype = 15 THEN AddScore ELSE 0 END),
											SUM(CASE WHEN OrderType = 7 OR OrderType = 12  THEN AddScore ELSE 0 END)
										INTO @recordCount,@LoseProfit,@WinProfit,@AddScore,@LowScore
										FROM(', v_sqlbase,') AS main'); 
			SET @v_sqlstatis = v_sqlstatis; 
PREPARE stmt FROM @v_sqlstatis; 
EXECUTE stmt; 
DEALLOCATE PREPARE stmt; 
SET recordTotal = @recordCount; 
			SET @v_LoseProfit = IFNULL(@LoseProfit,0); 
			SET @v_WinProfit = IFNULL(@WinProfit,0); 
			SET @v_AddScore = IFNULL(@AddScore,0); 
			SET @v_LowScore = IFNULL(@LowScore,0); 
			SET @v_profit = @v_LoseProfit + @v_WinProfit; 

			-- 获取开始分数
			SET v_sqlstatis = CONCAT('SELECT CurScore INTO @StartScore FROM(', v_sqlbase,') AS main ORDER BY OrderTime LIMIT 0,1'); 
			SET @v_sqlstatis = v_sqlstatis; 
PREPARE stmt FROM @v_sqlstatis; 
EXECUTE stmt; 
DEALLOCATE PREPARE stmt; 
SET @v_StartScore = IFNULL(@StartScore,0); 
			-- 获取结束分数
			SET v_sqlstatis = CONCAT('SELECT NewScore INTO @EndScore FROM(', v_sqlbase,') AS main ORDER BY OrderTime DESC LIMIT 0,1'); 
			SET @v_sqlstatis = v_sqlstatis; 
PREPARE stmt FROM @v_sqlstatis; 
EXECUTE stmt; 
DEALLOCATE PREPARE stmt; 
SET @v_EndScore = IFNULL(@EndScore,0); 
SELECT @v_LoseProfit AS LoseProfit,@v_WinProfit AS WinProfit,@v_profit AS Profit,@v_AddScore AS AddScore,@v_LowScore AS LowScore,@v_StartScore AS StartScore,@v_EndScore AS EndScore; 
SELECT recordTotal; 
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
DROP PROCEDURE IF EXISTS `sp_userOrderStatis`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_userOrderStatis`(OUT `recordTotal` int,IN `gameSQL` text)
BEGIN
	DECLARE v_sqlbase LONGTEXT; 
	DECLARE v_sqlstatis LONGTEXT; 

	SET v_sqlbase = gameSQL; 

	IF LENGTH(v_sqlbase) <> 0 THEN
		SET v_sqlstatis = CONCAT('SELECT IFNULL(A.LoseProfit, 0) AS LoseProfit, IFNULL(A.WinProfit, 0) AS WinProfit, 
										(LoseProfit + WinProfit) AS Profit,
										IFNULL(A.AddScore, 0) AS AddScore, IFNULL(A.LowScore, 0) AS LowScore, A.currency, 
										IFNULL(N.CurScore, 0) AS StartScore, IFNULL(N.NewScore, 0) AS EndScore, 
										IFNULL(N.NewScore, 0) AS NewScore 
									FROM (
										SELECT 
										SUM(CASE WHEN OrderType = 8 AND AddScore < 0 THEN AddScore ELSE 0 END) AS LoseProfit, 
										SUM(CASE WHEN OrderType = 9 OR (ordertype = 8 AND addscore > 0) THEN AddScore ELSE 0 END) AS WinProfit, 
										SUM(CASE WHEN OrderType = 6 OR OrderType = 13 OR OrderType = 14 OR ordertype = 15 THEN AddScore ELSE 0 END) AS AddScore, 
										SUM(CASE WHEN OrderType = 7 OR OrderType = 12  THEN AddScore ELSE 0 END) AS LowScore, 
										currency
										FROM(', v_sqlbase,') AS mainA 
										GROUP BY currency) AS A
									LEFT JOIN (
										SELECT B.currency, B.CurScore, B.curOrderTime, C.NewScore, C.newOrderTime 
										FROM (
											SELECT currency, CurScore, OrderTime AS curOrderTime 
											FROM (
												SELECT currency, CurScore, OrderTime, 
													IF(@prevB <> currency, @rn:=0, @rn), 
													@prevB := currency,
													@rn := @rn + 1 AS rn 
												FROM (', v_sqlbase,') AS mainB,
												(SELECT @rn := 0) AS rn, 
												(SELECT @prevB := \"\") AS prev 
												ORDER BY currency, OrderTime ASC) AS tableB 
											WHERE rn = 1) AS B 
											LEFT JOIN (
												SELECT currency, NewScore, OrderTime AS newOrderTime 
												FROM (
													SELECT currency, NewScore, OrderTime, 
														IF(@prevC <> currency, @rn:=0, @rn), 
														@prevC := currency,
														@rn := @rn + 1 AS rn 
													FROM (', v_sqlbase,') AS mainC,
													(SELECT @rn := 0) AS rn, 
													(SELECT @prevC := \"\") AS prev 
													ORDER BY currency, OrderTime DESC) AS tableC 
												WHERE rn = 1)  AS C ON B.currency = C.currency) AS N ON N.currency = A.currency'); 
		SET @v_sqlstatis = v_sqlstatis; 
		PREPARE stmt FROM @v_sqlstatis; 
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
DROP EVENT IF EXISTS `event_call_sp_cron_partition`;
CREATE DEFINER=`root`@`%` EVENT `event_call_sp_cron_partition` ON SCHEDULE EVERY 1 DAY STARTS '2023-01-17 03:00:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO CALL sp_cron_partition();
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_create_table_monthly_everyMonth1st00:10`;
CREATE DEFINER=`root`@`%` EVENT `event_create_table_monthly_everyMonth1st00:10` ON SCHEDULE EVERY 1 MONTH STARTS '2024-10-01 00:10:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO CALL `KYDB_NEW`.`sp_createTableMonthly`(NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_AgentAccessGame`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_AgentAccessGame` ON SCHEDULE EVERY 1 DAY STARTS '2020-02-22 06:00:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO CALL KYDB_NEW.sp_AgentAccessGame (2, NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_StatisGameRoomData_everyDay_2:00`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_StatisGameRoomData_everyDay_2:00` ON SCHEDULE EVERY 1 DAY STARTS '2018-11-16 02:00:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_StatisGameRoomData_everyDay(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_StatisGameRoomData_reguser_everyDay_01:30`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_StatisGameRoomData_reguser_everyDay_01:30` ON SCHEDULE EVERY 1 DAY STARTS '2018-11-16 01:30:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO CALL sp_StatisGameRoomData_reguser_everyDay(NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_StatisLinecodeMonitoring_everyDay_2:30`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_StatisLinecodeMonitoring_everyDay_2:30` ON SCHEDULE EVERY 1 DAY STARTS '2021-11-16 03:30:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_StatisLinecodeMonitoring_everyDay(NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_statisRecord_month`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_statisRecord_month` ON SCHEDULE EVERY 1 DAY STARTS '2021-09-06 02:50:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_statisRecord_month(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_statis_agent_month_activeUsers_reguser2:10`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_statis_agent_month_activeUsers_reguser2:10` ON SCHEDULE EVERY 1 MONTH STARTS '2019-01-01 02:10:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_statis_agent_month_activeUsers_reguser(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_sp_Statis_GetUsers`;
CREATE DEFINER=`root`@`%` EVENT `event_sp_Statis_GetUsers` ON SCHEDULE EVERY 1 DAY STARTS '2021-07-21 02:30:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_Statis_GetUsers(null,null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_statisAgentRecordInfo`;
CREATE DEFINER=`root`@`%` EVENT `event_statisAgentRecordInfo` ON SCHEDULE EVERY 1 DAY STARTS '2021-05-16 00:40:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call KYDB_NEW.sp_statisAgentRecordInfo_everyMonth(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_statisAgentRecordInfo_BST09:30`;
CREATE DEFINER=`root`@`%` EVENT `event_statisAgentRecordInfo_BST09:30` ON SCHEDULE EVERY 1 DAY STARTS '2023-01-17 09:30:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call `KYDB_NEW`.`sp_statisAgentRecordInfo_BST_everyMonth`(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_statisAgentRecordInfo_EST`;
CREATE DEFINER=`root`@`%` EVENT `event_statisAgentRecordInfo_EST` ON SCHEDULE EVERY 1 DAY STARTS '2023-06-17 14:30:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call KYDB_NEW.sp_statisAgentRecordInfo_EST_everyMonth(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_statisAgentRecordInfo_reguser02:00`;
CREATE DEFINER=`root`@`%` EVENT `event_statisAgentRecordInfo_reguser02:00` ON SCHEDULE EVERY 1 DAY STARTS '2018-05-22 02:00:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_statisAgentRecordInfo_everyMonth_reguser(null);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP EVENT IF EXISTS `event_statis_agent`;
CREATE DEFINER=`root`@`%` EVENT `event_statis_agent` ON SCHEDULE EVERY 1 DAY STARTS '2021-05-31 05:00:00' ON COMPLETION NOT PRESERVE DISABLE ON SLAVE DO call sp_statis_agent;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

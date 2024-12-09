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
DROP FUNCTION IF EXISTS `getTopUid`;
CREATE DEFINER=`root`@`%` FUNCTION `getTopUid`(`IN_id` int) RETURNS int(11)
BEGIN
    DECLARE v_pointer int; 
    DECLARE v_topUid int; 

    SET v_pointer = IN_id; 
        SET v_topUid = IN_id; 

    WHILE v_pointer <> 0 DO
                SELECT UID INTO v_topUid FROM Transfer.Sys_ProxyAccount WHERE ChannelID = v_pointer; 

                IF v_topUid <> 0 AND NOT v_topUid = v_pointer THEN
                        SET v_pointer = v_topUid; 
                ELSE
                        RETURN v_pointer; 
                END IF; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersByGame_shift`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersByGame_shift`(IN `in_GameParameter` VARCHAR(255), IN `in_statismonth` VARCHAR(6))
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

	SET v_src_db = 'Transfer_KYStatisUsers'; 
	SET v_src_table = CONCAT('statis_', in_GameParameter, in_statismonth, '_users'); 

	SET v_dist_db = 'KYStatisUsers'; 
	SET v_dist_table = CONCAT('statis_', in_GameParameter, in_statismonth, '_users'); 

	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		call KYStatisUsers.sp_createStatisticsUsersTable(v_dist_table, 0); 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_sql = CONCAT('select old.StatisDate, old.Account, old.ChannelID, old.LineCode, 0 Allbet, SUM(old.CellScore) CellScore, SUM(old.WinGold) WinGold, SUM(old.LostGold) LostGold, SUM(old.Revenue) Revenue, SUM(old.WinNum) WinNum, SUM(old.LostNum) LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from ', v_src_db,'.', v_dist_table,' old GROUP BY old.StatisDate, old.Account, old.LineCode'); 
		SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersByRoom_shift`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersByRoom_shift`(IN `in_GameParameter` VARCHAR(255), IN `in_statismonth` VARCHAR(6))
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 


	SET v_src_db = 'Transfer_KYStatisUsers'; 
	SET v_src_table = CONCAT('statis_', in_GameParameter, in_statismonth, '_users_room'); 

	SET v_dist_db = 'KYStatisUsers'; 
	SET v_dist_table = CONCAT('statis_', in_GameParameter, in_statismonth, '_users_room'); 

	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		call KYStatisUsers.sp_createStatisticsUsersTable(v_dist_table, 2); 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


		SET v_sql = CONCAT('select old.StatisDate, old.Account, old.ChannelID, old.ServerID, old.CellScore, old.WinGold, old.LostGold, old.Revenue, old.WinNum, old.LostNum, 0 isNew, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from ', v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersESTByGame_shift`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersESTByGame_shift`(IN `in_GameParameter` VARCHAR(255), IN `in_statismonth` VARCHAR(6))
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
    END; 

	SET v_src_db = 'Transfer_KYStatisUsers_EST'; 
	SET v_src_table = CONCAT('statis_', in_GameParameter, in_statismonth, '_users'); 

	SET v_dist_db = 'KYStatisUsers_EST'; 
	SET v_dist_table = CONCAT('statis_', in_GameParameter, in_statismonth, '_users'); 

	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		BEGIN
			call KYStatisUsers_EST.sp_createStatisticsUsersTable(v_dist_table, 0); 
		END; 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_sql = CONCAT('select old.StatisDate, old.Account, old.ChannelID, old.LineCode, 0 Allbet, SUM(old.CellScore) CellScore, SUM(old.WinGold) WinGold, SUM(old.LostGold) LostGold, SUM(old.Revenue) Revenue, SUM(old.WinNum) WinNum, SUM(old.LostNum) LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from ', v_src_db,'.', v_dist_table,' old GROUP BY old.StatisDate, old.Account, old.LineCode'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
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
DROP PROCEDURE IF EXISTS `SP_SplitString`;
CREATE DEFINER=`root`@`%` PROCEDURE `SP_SplitString`()
BEGIN
	DECLARE agentNum INT DEFAULT NULL; 
	DECLARE channelID INT DEFAULT NULL; 
	DECLARE front TEXT DEFAULT NULL; 
	DECLARE frontlen INT DEFAULT NULL; 
    DECLARE TempValue TEXT DEFAULT NULL; 
	DECLARE Value LONGTEXT DEFAULT NULL; 

	TRUNCATE TABLE KYDB_NEW.sys_agent_linecode; 
	SELECT COUNT(agent) INTO agentNum FROM agents; 
	
	repeat
	SET agentNum = agentNum - 1; 
	SELECT agent into channelID FROM agents ORDER BY id LIMIT 1 OFFSET agentNum; 

	SELECT lineCodes INTO Value FROM agents where agent = channelID; 
    iterator:
    LOOP  
    IF LENGTH(TRIM(Value)) = 0 OR Value IS NULL THEN
    LEAVE iterator; 
    END IF; 
    SET front = SUBSTRING_INDEX(Value, ',', 1); 
    SET frontlen = LENGTH(front); 
    SET TempValue = TRIM(front); 
	SET TempValue = replace(TempValue, '"', ''); 
	SET TempValue = replace(TempValue, '[', ''); 
	SET TempValue = replace(TempValue, ']', ''); 
    INSERT INTO KYDB_NEW.sys_agent_linecode (agentId, linecode) VALUES (channelID, TempValue); 
    SET Value = INSERT(Value,1,frontlen + 1,''); 
    END LOOP; 
    until agentNum = 0 END repeat; 
END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

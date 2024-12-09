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
DROP FUNCTION IF EXISTS `skinsToThemeList`;
CREATE DEFINER=`root`@`%` FUNCTION `skinsToThemeList`(`skins` varchar(255), `defaultSkin` varchar(255)) RETURNS varchar(20) CHARSET utf8mb4
BEGIN
    DECLARE result varchar(20); 
    DECLARE temp varchar(255); 
	DECLARE front TEXT DEFAULT NULL; 
	DECLARE frontlen INT DEFAULT NULL; 
	DECLARE badItem INT DEFAULT 0; 

	SET temp = (SELECT REPLACE(REPLACE(skins,'[', ''), ']', '')); 
	SET result = ''; 

    iterator:
    LOOP  
    IF LENGTH(TRIM(temp)) = 0 OR temp IS NULL OR badItem = 1 THEN
    LEAVE iterator; 
    END IF; 

    SET front = SUBSTRING_INDEX(temp, ',', 1); 
	SET frontlen = LENGTH(front); 

	IF front = 1 THEN
		SET result = CONCAT(result, '4,'); 
	ELSEIF front = 2 THEN
		SET result = CONCAT(result, ''); 
	ELSEIF front = 4 THEN 
		SET result = CONCAT(result, '3,'); 
	ELSEIF front = 101 THEN 
		SET result = CONCAT(result, ''); 
	ELSE
		SET badItem = 1; 
	END IF; 

    SET temp = INSERT(temp,1,frontlen + 1,''); 
    END LOOP; 
    
	IF LENGTH(result) > 0 THEN 
		SET result = SUBSTRING(result, 1, LENGTH(result) - 1); 
		RETURN result; 
	END IF; 

	IF defaultSkin = '[1]' THEN 
 	    RETURN '4'; 
	ELSE 
		RETURN '3'; 
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
DROP PROCEDURE IF EXISTS `ShiftFBOrders`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftFBOrders`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFBOrders') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = "SELECT old.*, 1 ownCurrency FROM "; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'orders'; 

	SET v_dist_db = 'fb'; 
	SET v_dist_table = 'orders'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE fb.orders; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFBOrders') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftFinanceManageDieliveryDetail`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftFinanceManageDieliveryDetail`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFinanceManageDieliveryDetail') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'SELECT
        old.StatisDate,
        old.ChannelID,
        old.ChannelName,
        old.NickName,
        old.AccountingFor,
        old.CellScore,
        old.Profit,
        old.SumProfit,
        old.TimeZone,
        old.CreateTime,
        0 jpMoney,
        0 sumJpMoney,
        0 category
    FROM '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'finance_dielivery_detail'; 

	SET v_dist_db = 'finance_manage'; 
	SET v_dist_table = 'finance_dielivery_detail'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE finance_manage.finance_dielivery_detail; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFinanceManageDieliveryDetail') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftFinanceManageDieliveryList`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftFinanceManageDieliveryList`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFinanceManageDieliveryList') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'SELECT
        old.id,
        old.StatisDate,
        old.ChannelID,
        old.ReceiveChannelID,
        old.LevelID,
        old.ChannelName,
        old.NickName,
        old.AccountingFor,
        old.CellScore,
        old.Profit,
        old.SumProfit,
        old.TimeZone,
        old.SpecialMoney,
        old.Remark,
        old.Status,
        old.CreateTime,
        old.CheckTime,
        old.SendTime,
        old.UpdateTime,
        NULL ref_deliveryMoneyType,
        NULL ref_deliveryExchangeRate,
        \'0\' sumJpInsuranceMoney,
        \'0\' jpInsuranceMoney,
        \'0\' insuranceType,
        NULL jackpotOpenDate,
        \'0\' jpMoney,
        \'0\' sumJpMoney,
        \'0\' category
    FROM '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'finance_dielivery_list'; 

	SET v_dist_db = 'finance_manage'; 
	SET v_dist_table = 'finance_dielivery_list'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE finance_manage.finance_dielivery_list; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFinanceManageDieliveryList') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftFinanceManageSportDieliveryList`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftFinanceManageSportDieliveryList`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFinanceManageSportDieliveryList') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'SELECT
        old.id,
        old.StatisDate,
        old.ChannelID,
        old.ReceiveChannelID,
        old.LevelID,
        old.ChannelName,
        old.NickName,
        old.AccountingFor,
        old.CellScore,
        old.Profit,
        old.SumProfit,
        old.TimeZone,
        old.SpecialMoney,
        old.Remark,
        old.Status,
        old.CreateTime,
        old.CheckTime,
        old.SendTime,
        old.UpdateTime
    FROM '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'finance_sportdielivery_list'; 

	SET v_dist_db = 'finance_manage'; 
	SET v_dist_table = 'finance_sportdielivery_list'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE finance_manage.finance_sportdielivery_list; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFinanceManageSportDieliveryList') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftGameApiAccounts_updateDate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameApiAccounts_updateDate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_update_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiAccounts_updateDate') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.id, old.account, old.agent, old.mstatus, old.mark, old.lineCode, old.lastlogintime, old.createdate, old.updatedate, null firstBetTime from '; 
	SET v_update_sql = ' ON DUPLICATE KEY UPDATE id = VALUES(id), id = VALUES(id), account = VALUES(account), agent = VALUES(agent), mstatus = VALUES(mstatus), mark = VALUES(mark), lineCode = VALUES(lineCode), lastlogintime = VALUES(lastlogintime), createdate = VALUES(createdate), updatedate = VALUES(updatedate), firstBetTime = VALUES(firstBetTime) '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'accounts'; 

	SET v_dist_db = 'game_api'; 
	SET v_dist_table = 'accounts'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql, ' ', v_update_sql ); 
	SET @v_sql = v_sql; 

	
	ALTER TABLE `game_api`.`accounts` DROP INDEX `index_account`, DROP INDEX `index_createdate`, DROP INDEX `index_createdate_agent`, DROP INDEX `index_agent`, DROP INDEX `agent_mstatus_IDX`; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	ALTER TABLE `game_api`.`accounts` ADD UNIQUE KEY `index_account` (`account`) USING BTREE, ADD KEY `index_createdate` (`createdate`) USING BTREE, ADD KEY `index_createdate_agent` (`createdate`,`agent`) USING BTREE, ADD KEY `index_agent` (`agent`) USING BTREE, ADD KEY `agent_mstatus_IDX` (`agent`,`mstatus`) USING BTREE; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiAccounts_updateDate') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftGameApiExternalVendorAccountMapping`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameApiExternalVendorAccountMapping`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiExternalVendorAccountMapping') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'SELECT
		old.agent,
		old.account,
		old.createDate,
		old.displayName,
		old.externalVendorAccount,
		old.lineCode,
		CASE WHEN old.status = 0 THEN 1 ELSE 0 END status
	FROM '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'externalVendorAccountMapping'; 

	SET v_dist_db = 'game_api'; 
	SET v_dist_table = 'externalVendorAccountMapping'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' (agent,account,createDate,displayName,externalVendorAccount,lineCode,status) ', v_sql); 
	SET @v_sql = v_sql; 

	
	TRUNCATE TABLE `game_api`.`externalVendorAccountMapping`; 
	ALTER TABLE `game_api`.`externalVendorAccountMapping` DROP INDEX `index_externalVendorAccount`; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	ALTER TABLE `game_api`.`externalVendorAccountMapping` ADD KEY `index_externalVendorAccount` (`externalVendorAccount`) USING BTREE; 

	ALTER TABLE `game_api`.`externalVendorAccountMapping` CHANGE status status INT(1) DEFAULT 1 COMMENT '玩家狀態 0-關 1-開'; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiExternalVendorAccountMapping') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftGameApiFBAccountMapping`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameApiFBAccountMapping`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiFBAccountMapping') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'SELECT
		old.agent,
		old.account,
		old.lineCode,
		old.fbAccount,
		old.displayName,
		CASE WHEN old.status = 0 THEN 1 ELSE 0 END status,
		old.userGroup,
		old.createDate,
		old.registerChannel
	FROM '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'fbAccountMapping'; 

	SET v_dist_db = 'game_api'; 
	SET v_dist_table = 'fbAccountMapping'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	ALTER TABLE `game_api`.`fbAccountMapping` CHANGE status status INT(1) DEFAULT 1 COMMENT '玩家狀態 0-關 1-開'; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiFBAccountMapping') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftGameApiOrdersGameSys`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameApiOrdersGameSys`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiOrdersGameSys') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.id, old.curMoney, old.money, old.afterMoney, old.status, old.type, old.account, old.createdate, old.updatedate, \'CNY\' currency from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'orders_game_sys'; 

	SET v_dist_db = 'game_api'; 
	SET v_dist_table = 'orders_game_sys'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE game_api.orders_game_sys; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiOrdersGameSys') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftGameApiOrdersSys`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameApiOrdersSys`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiOrdersSys') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.id, old.curMoney, old.money, old.afterMoney, old.status, old.type, old.agent, old.createdate, old.updatedate, \'CNY\' currency from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'orders_sys'; 

	SET v_dist_db = 'game_api'; 
	SET v_dist_table = 'orders_sys'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE game_api.orders_sys; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiOrdersSys') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftGameApiSingleOrders`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameApiSingleOrders`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiSingleOrders') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.id, old.orderId, old.account, old.channelId, old.gameNo, old.curScore, old.addScore, old.newScore, old.status, old.type, old.action, NULL ref_origin_orderId, 0 retCode, \'CNY\' currency, old.createdate, old.updatedate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'single_orders'; 

	SET v_dist_db = 'game_api'; 
	SET v_dist_table = 'single_orders'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

	
    DROP TRIGGER IF EXISTS `game_api`.`tools_single_orders`; 
    
	TRUNCATE TABLE game_api.single_orders; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiSingleOrders') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftGameManageRpUser`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameManageRpUser`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameManageRpUser') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.*, null login2FAKey from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'rp_user'; 

	SET v_dist_db = 'game_manage'; 
	SET v_dist_table = 'rp_user'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE game_manage.rp_user; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameManageRpUser') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWAgent`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWAgent`()
BEGIN
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWAgent') ON DUPLICATE KEY UPDATE `status`= 0; 

	
    INSERT INTO KYDB_NEW.agent (id, uid, topUid, account, roleId, userPwd, nickname, userStatus, moneyType, walletType, revenue, status, channelValue, createUser, createDate, lastLoginTime, accountingFor, businessAccount, callBackType, cooperation, demoOutUrl, demoUrl, aesKey, md5Key, disableBusinessAccount, disableChildAgent, domainBind, exRate, formalUrl, payType, isInheritWhiteIp, isShowPayPopUps, isShowBackLobby, isShowFeedback, isShowHotGame, isShowLinecode, isShowRevenue, isShowWinLosChart, linecodeSet, loadImg, logo, logoUrl, mark, matchRange, offlineBackUrl, proxyUrl, publicId, type, timeZone, whiteIp, lang, theme, themeList, rechargeUrl, rechargeStatus, sbUrl, convertMultiple, gameFrameControl, gameFrameTeachControl, gameFullScreenControl, gameMusicControl, autoMatch, productLine, gameTakesControl, jackpotSupport, jackpotNotice, jackpotAllowGrand, insuranceType, jackpotOpenDate, deliveryMoneyType,gameCurrencyControl,gamePlayedListControl,scrollOrientation)
SELECT
    ChannelID AS id,
    UID AS uid,
    Transfer.getTopUid(ChannelID) AS topUid,
    Accounts AS account,
    roleid AS roleId,
    UserPWD AS userPwd,
    NickName AS nickname,
    UserStatus AS userStatus,
    1 AS moneyType,
    CASE WHEN walletType = 1 THEN 0 ELSE walletType END AS walletType,	
    ProxyRevenue AS revenue,
    IsDelete AS status,
    ChannelValue AS channelValue,
    CreateUser AS createUser,
    Createdate AS createDate,
    LastloginTime AS lastLoginTime,
    AccountingFor AS accountingFor,
    BusinessAccount AS businessAccount,
    CallBackURL AS callBackType,
    Cooperation AS cooperation,
    DemoOutLink AS demoOutUrl,
    DemoLink AS demoUrl,
    Deskey AS aesKey,
    Md5key AS md5Key,
    DisBusinessAccount AS disableBusinessAccount,
    Forbidden AS disableChildAgent,
    DomainBind AS domainBind,
    exRate AS exRate,
    FormalLink AS formalUrl,
    CASE WHEN isAutoPay = 0 THEN 1 ELSE 2 END AS payType,
    ISinheritwhiteIP AS isInheritWhiteIp,
    isPayPopUps AS isShowPayPopUps,
    ISPushbutton AS isShowBackLobby,
    feedEnabled AS isShowFeedback,
    0 AS isShowHotGame,
    Disablelinecode AS isShowLinecode,
    0 AS isShowRevenue,
    Winloschart AS isShowWinLosChart,
    LinecodeSet AS linecodeSet,
    Loadimg AS loadImg,
    Logo AS logo,
    logourl AS logoUrl,
    Mark AS mark,
    MatchRange AS matchRange,
    CallBackLink AS offlineBackUrl,
    ProxyURL AS proxyUrl,
    publicId AS publicId,
    SingleOrSystem AS type,
    Timezone AS timeZone,
    WhiteIP AS whiteIp,
    '1' AS lang,
    8 AS theme,
    '8' AS themeList,
    CallBackLink AS rechargeUrl,
    null AS rechargeStatus,
    null AS sbUrl,
    1 AS convertMultiple,
    1 AS gameFrameControl,
    1 AS gameFrameTeachControl,
    1 AS gameFullScreenControl,
    1 AS gameMusicControl,
    null AS autoMatch,
    1 AS productLine,
    0 AS gameTakesControl,
    null AS jackpotSupport,
    null AS jackpotNotice,
    null AS jackpotAllowGrand,
    null AS insuranceType,
    null AS jackpotOpenDate,
	CASE WHEN MoneyType = 0 THEN 1 ELSE MoneyType END AS deliveryMoneyType,
    1 AS gameCurrencyControl,
	1 AS gamePlayedListControl,
	0 AS scrollOrientation
FROM
    Sys_ProxyAccount
	ON DUPLICATE KEY UPDATE
	    uid = VALUES(uid),
	    topUid = VALUES(topUid),
	    account = VALUES(account),
	    roleId = VALUES(roleId),
	    userPwd = VALUES(userPwd),
	    nickname = VALUES(nickname),
	    userStatus = VALUES(userStatus),
	    moneyType = VALUES(moneyType),
	    walletType = VALUES(walletType),
	    revenue = VALUES(revenue),
	    status = VALUES(status),
	    channelValue = VALUES(channelValue),
	    createUser = VALUES(createUser),
	    createDate = VALUES(createDate),
	    lastLoginTime = VALUES(lastLoginTime),
	    accountingFor = VALUES(accountingFor),
	    businessAccount = VALUES(businessAccount),
	    callBackType = VALUES(callBackType),
	    cooperation = VALUES(cooperation),
	    demoOutUrl = VALUES(demoOutUrl),
	    demoUrl = VALUES(demoUrl),
	    aesKey = VALUES(aesKey),
	    md5Key = VALUES(md5Key),
	    disableBusinessAccount = VALUES(disableBusinessAccount),
	    disableChildAgent = VALUES(disableChildAgent),
	    domainBind = VALUES(domainBind),
	    exRate = VALUES(exRate),
	    formalUrl = VALUES(formalUrl),
	    payType = VALUES(payType),
	    isInheritWhiteIp = VALUES(isInheritWhiteIp),
	    isShowPayPopUps = VALUES(isShowPayPopUps),
	    isShowBackLobby = VALUES(isShowBackLobby),
	    isShowFeedback = VALUES(isShowFeedback),
	    isShowHotGame = VALUES(isShowHotGame),
	    isShowLinecode = VALUES(isShowLinecode),
	    isShowRevenue = VALUES(isShowRevenue),
	    isShowWinLosChart = VALUES(isShowWinLosChart),
	    linecodeSet = VALUES(linecodeSet),
	    loadImg = VALUES(loadImg),
	    logo = VALUES(logo),
	    logoUrl = VALUES(logoUrl),
	    mark = VALUES(mark),
	    matchRange = VALUES(matchRange),
	    offlineBackUrl = VALUES(offlineBackUrl),
	    proxyUrl = VALUES(proxyUrl),
	    publicId = VALUES(publicId),
	    type = VALUES(type),
	    timeZone = VALUES(timeZone),
	    whiteIp = VALUES(whiteIp),
	    lang = VALUES(lang),
	    theme = VALUES(theme),
	    themeList = VALUES(themeList),
	    rechargeUrl = VALUES(rechargeUrl),
	    rechargeStatus = VALUES(rechargeStatus),
	    sbUrl = VALUES(sbUrl),
	    convertMultiple = VALUES(convertMultiple),
	    gameFrameControl = VALUES(gameFrameControl),
	    gameFrameTeachControl = VALUES(gameFrameTeachControl),
	    gameFullScreenControl = VALUES(gameFullScreenControl),
	    gameMusicControl = VALUES(gameMusicControl),
	    autoMatch = VALUES(autoMatch),
	    productLine = VALUES(productLine),
	    gameTakesControl = VALUES(gameTakesControl),
		jackpotSupport = VALUES(jackpotSupport),
		jackpotNotice = VALUES(jackpotNotice),
		jackpotAllowGrand = VALUES(jackpotAllowGrand),
		insuranceType = VALUES(insuranceType),
		jackpotOpenDate = VALUES(jackpotOpenDate),
		deliveryMoneyType = VALUES(deliveryMoneyType),
		gameCurrencyControl= VALUES(gameCurrencyControl),
		gamePlayedListControl= VALUES(gamePlayedListControl),
		scrollOrientation= VALUES(scrollOrientation); 

	
	INSERT INTO wallet.agents
	(channelId, money)
	SELECT
		agent,
		money
	FROM
		agents
	ON DUPLICATE KEY UPDATE
		money = VALUES(money); 

	
	CALL SP_SplitString(); 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWAgent') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWCompany`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWCompany`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWCompany') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = "SELECT
        old.companyid,
        old.companyPWD,
        old.companyname,
        old.abbreviation,
        old.whiteip,
        old.mark,
        old.updatetime,
        old.status,
        NULL game_launch_url,
        NULL game_launch_param,
        CASE WHEN old.companyid in ('21019', '21020', '21021') THEN 2 ELSE 0 END type,
        CASE WHEN old.companyid in ('21019', '21020', '21021') THEN 1 ELSE 0 END showBackIcon
    FROM "; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'company'; 

	SET v_dist_db = 'KYDB_NEW'; 
	SET v_dist_table = 'company'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYDB_NEW.company; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWCompany') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWKillRate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWKillRate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWKillRate') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.ID, old.ChannelIDLinecode, old.KillRate, old.Type, NULL gameRoomId, old.CreateUser, old.UpdateUser, old.CreateTime, old.UpdateTime from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'Sys_KillRate'; 

	SET v_dist_db = 'KYDB_NEW'; 
	SET v_dist_table = 'Sys_KillRate'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYDB_NEW.Sys_KillRate; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWKillRate') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisAgentAccessGame3d`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisAgentAccessGame3d`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisAgentAccessGame3d') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.GameID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, NULL DayNewBetUsers, \'CNY\' currency, 1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'agent_access_game_3d'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'agent_access_game_3d'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.agent_access_game_3d; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisAgentAccessGame3d') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisLinecodeMonitoring`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisLinecodeMonitoring`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisLinecodeMonitoring') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate,old.ChannelID,old.LineCode,old.DWinGold,old.DLostGold,old.DCellScore,old.DRevenue,old.DWinNum,old.DLostNum,old.DActiveUsers,old.MWinGold,old.MLostGold,old.MCellScore,old.MRevenue,old.MWinNum,old.MLostNum,old.MActiveUsers,old.HWinGold,old.HLostGold,old.HCellScore,old.HRevenue,old.HWinNum,old.HLostNum,old.HActiveUsers,old.CreateTime,old.UpdateTime,\'CNY\' currency,1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_linecode_monitoring'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_linecode_monitoring'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_linecode_monitoring; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisLinecodeMonitoring') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisLoginGameDetail`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisLoginGameDetail`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_create_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
	DECLARE v_month VARCHAR(6); 
    DECLARE v_month_counter INT DEFAULT 0; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisLoginGameDetail') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 2 MONTH), '%Y%m'); 

	SET v_month = DATE_FORMAT(NOW(), '%Y%m'); 
	WHILE v_month_counter < 1 DO
		SET v_base_sql = 'SELECT
            old.StatisDate,
            old.ChannelID,
            old.GameID,
            old.Accounts 
        FROM '; 

		SET v_src_db = 'Transfer'; 
		SET v_src_table = CONCAT('statis_login_game_detail_', v_month); 

		SET v_dist_db = 'KYStatisLogin'; 
		SET v_dist_table = CONCAT('statis_login_game_detail_', v_month); 

		set v_create_sql = CONCAT('
            CREATE TABLE `',v_dist_db,'`.`',v_dist_table,'` (
            `StatisDate` date NOT NULL,
            `ChannelID` int(10) NOT NULL,
            `GameID` int(10) NOT NULL,
            `Accounts` varchar(200) DEFAULT NULL,
            UNIQUE KEY `index_StatisDate_ChannelID_GameId_Accounts` (`StatisDate`,`ChannelID`,`GameID`,`Accounts`) USING BTREE,
            KEY `INDEX_SG` (`StatisDate`,`GameID`) USING BTREE
            ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
		'); 


		SET @v_sql = v_create_sql; 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old GROUP BY old.StatisDate, old.ChannelID, old.GameID, old.Accounts'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_month_counter = v_month_counter + 1; 
		SET v_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_month_counter MONTH), '%Y%m'); 
	END WHILE; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisLoginGameDetail') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisLoginKeepGameUsers`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisLoginKeepGameUsers`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisLoginKeepGameUsers') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate,old.GameID,old.RegUsers,old.GameLoginUsers,old.PlayGameUsers,old.CR,old.QR,old.HYCR,old.HYQR,old.CellScore,old.Profit,old.Revenue,\'CNY\' currency,1 exchangeRate,old.CreateTime,old.UpdateTime from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_keep_game_users'; 

	SET v_dist_db = 'KYStatisLogin'; 
	SET v_dist_table = 'statis_keep_game_users'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatisLogin.statis_keep_game_users; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisLoginKeepGameUsers') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordAgentHistory`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordAgentHistory`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentHistory') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.ChannelID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_history'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_history'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_record_agent_history; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentHistory') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordAgentLinecodeEST_updateDate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordAgentLinecodeEST_updateDate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_update_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeEST_updateDate') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.LineCode, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 
	SET v_update_sql = ' ON DUPLICATE KEY UPDATE StatisDate = VALUES(StatisDate), ChannelID = VALUES(ChannelID), LineCode = VALUES(LineCode), WinGold = VALUES(WinGold), LostGold = VALUES(LostGold), CellScore = VALUES(CellScore), Revenue = VALUES(Revenue), WinNum = VALUES(WinNum), LostNum = VALUES(LostNum), ActiveUsers = VALUES(ActiveUsers), currency =\'CNY\' , exchangeRate = 1 '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_linecode_EST'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_linecode_EST'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql, ' ', v_update_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeEST_updateDate') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordAgentLinecodeGameEST_updateDate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordAgentLinecodeGameEST_updateDate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_update_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeGameEST_updateDate') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.LineCode, old.GameID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 
	SET v_update_sql = ' ON DUPLICATE KEY UPDATE StatisDate = VALUES(StatisDate), ChannelID = VALUES(ChannelID), LineCode = VALUES(LineCode), GameID = VALUES(GameID), WinGold = VALUES(WinGold), LostGold = VALUES(LostGold), CellScore = VALUES(CellScore), Revenue = VALUES(Revenue), WinNum = VALUES(WinNum), LostNum = VALUES(LostNum), ActiveUsers = VALUES(ActiveUsers), currency =\'CNY\' , exchangeRate = 1 '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_linecode_game_EST'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_linecode_game_EST'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql, ' ', v_update_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeGameEST_updateDate') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordAgentLinecodeGame_updateDate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordAgentLinecodeGame_updateDate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_update_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeGame_updateDate') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.LineCode, old.GameID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 
	SET v_update_sql = ' ON DUPLICATE KEY UPDATE StatisDate = VALUES(StatisDate), ChannelID = VALUES(ChannelID), LineCode = VALUES(LineCode), GameID = VALUES(GameID), WinGold = VALUES(WinGold), LostGold = VALUES(LostGold), CellScore = VALUES(CellScore), Revenue = VALUES(Revenue), WinNum = VALUES(WinNum), LostNum = VALUES(LostNum), ActiveUsers = VALUES(ActiveUsers), currency =\'CNY\' , exchangeRate = 1 '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_linecode_game'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_linecode_game'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql, ' ', v_update_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeGame_updateDate') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordAgentLinecode_updateDate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordAgentLinecode_updateDate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_update_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecode_updateDate') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.LineCode, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 
	SET v_update_sql = ' ON DUPLICATE KEY UPDATE StatisDate = VALUES(StatisDate), ChannelID = VALUES(ChannelID), LineCode = VALUES(LineCode), WinGold = VALUES(WinGold), LostGold = VALUES(LostGold), CellScore = VALUES(CellScore), Revenue = VALUES(Revenue), WinNum = VALUES(WinNum), LostNum = VALUES(LostNum), ActiveUsers = VALUES(ActiveUsers), currency =\'CNY\' , exchangeRate = 1 '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_linecode'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_linecode'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql, ' ', v_update_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecode_updateDate') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordAgentMonth`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordAgentMonth`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentMonth') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, old.ActiveUsers_reguser, \'CNY\' currency, 1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_month'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_month'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_record_agent_month; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentMonth') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordGameMonth`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordGameMonth`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordGameMonth') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'SELECT
        old.StatisDate,
        old.GameID,
        old.WinGold,
        old.LostGold,
        old.CellScore,
        old.Revenue,
        old.WinNum,
        old.LostNum,
        old.ActiveUsers,
        \'CNY\' currency, 
        1 exchangeRate 
    FROM '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_game_month'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_game_month'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_record_game_month; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordGameMonth') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordGameMonthReguser`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordGameMonthReguser`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordGameMonthReguser') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'SELECT
        old.StatisDate,
        old.GameID,
        old.WinGold,
        old.LostGold,
        old.CellScore,
        old.Revenue,
        old.WinNum,
        old.LostNum,
        old.ActiveUsers,
        \'CNY\' currency, 
        1 exchangeRate 
    FROM '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_game_month_reguser'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_game_month_reguser'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_record_game_month_reguser; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordGameMonthReguser') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRoomKd`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRoomKd`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_create_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
	DECLARE v_month VARCHAR(6); 
    DECLARE v_month_counter INT DEFAULT 0; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomKd') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 2 MONTH), '%Y%m'); 

	SET v_month = DATE_FORMAT(NOW(), '%Y%m'); 
	WHILE v_month_counter < 1 DO
		SET v_base_sql = 'select old.StatisDate, old.Type, old.MatchType, old.GameType, old.RoomType, old.KDValidBet, old.KDWin, \'CNY\' currency, 1 exchangeRate, old.KDGames, old.KDUsers, old.KDvalue, NULL TotalUsers_userType, old.TotalUsers, old.CreateDate from '; 

		SET v_src_db = 'Transfer'; 
		SET v_src_table = CONCAT('statis_room_kd_', v_month); 

		SET v_dist_db = 'KYStatis'; 
		SET v_dist_table = CONCAT('statis_room_kd_', v_month); 

		set v_create_sql=CONCAT('
			CREATE TABLE IF NOT EXISTS `',v_dist_db,'`.`',v_dist_table,'` (
				`StatisDate` date NOT NULL COMMENT ''统计日期'',
				`Type` tinyint(2) NOT NULL COMMENT ''1新玩家 2老玩家'',
				`MatchType` tinyint(2) NOT NULL COMMENT ''追放类型 4追杀 5放水'',
				`GameType` varchar(64) NOT NULL COMMENT ''游戏'',
				`RoomType` int(11) NOT NULL COMMENT ''房间'',
				`KDValidBet` varchar(255) DEFAULT NULL COMMENT ''追放玩家投注'',
				`KDWin` varchar(255) DEFAULT NULL COMMENT ''追放金额'',
				`currency` varchar(20) NOT NULL COMMENT ''幣別'',
				`exchangeRate` decimal(20,5) NOT NULL COMMENT ''汇率'',
				`KDGames` int(11) DEFAULT NULL COMMENT ''追放局数'',
				`KDUsers` int(11) DEFAULT NULL COMMENT ''追放人数(不分币别)'',
				`KDvalue` varchar(172) NOT NULL COMMENT ''KDvalue'',
				`TotalUsers_userType` int(11) DEFAULT NULL COMMENT ''房间总老/新玩家投注人数(不分币别)'',
				`TotalUsers` int(11) DEFAULT NULL COMMENT ''房间总投注人数(不分币别)'',
				`CreateDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT ''创建时间'',
				PRIMARY KEY (`StatisDate`,`Type`,`MatchType`,`GameType`,`RoomType`,`KDvalue`,`currency`) USING BTREE
			) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
			'); 


		SET @v_sql = v_create_sql; 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_month_counter = v_month_counter + 1; 
		SET v_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_month_counter MONTH), '%Y%m'); 
	END WHILE; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomKd') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRoomMonitoring`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRoomMonitoring`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomMonitoring') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.createdate, old.roomId, old.validBet, old.revenue, \'CNY\' currency, 1 exchangeRate, old.profit, old.avgOnline, old.maxOnline, old.logCount, old.activeCount, old.gameNum, old.singleTime, old.robotProfit, old.killRobotProfit, old.revRobotProfit, old.dayKillGold, old.dayDiveGold, old.gameTime, old.killGameNum, old.diveGameNum, old.normalValidbet, old.gameId  from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_room_monitoring'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_room_monitoring'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old GROUP BY createdate, roomId, gameId'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_room_monitoring; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomMonitoring') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRoomMonitoringReguser`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRoomMonitoringReguser`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomMonitoringReguser') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.createdate, old.roomId, old.validBet, old.revenue, \'CNY\' currency, 1 exchangeRate, old.profit, old.avgOnline, old.maxOnline, old.logCount, old.activeCount, old.gameNum, old.singleTime, old.robotProfit, old.killRobotProfit, old.revRobotProfit, old.dayKillGold, old.dayDiveGold, old.gameTime, old.killGameNum, old.diveGameNum, old.normalValidbet, old.gameId  from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_room_monitoring_reguser'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_room_monitoring_reguser'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old GROUP BY createdate, roomId, gameId'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_room_monitoring_reguser; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomMonitoringReguser') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRoomRecordtypeData`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRoomRecordtypeData`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_create_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
	DECLARE v_month VARCHAR(6); 
    DECLARE v_month_counter INT DEFAULT 0; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomRecordtypeData') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 2 MONTH), '%Y%m'); 

	SET v_month = DATE_FORMAT(NOW(), '%Y%m'); 
	WHILE v_month_counter < 1 DO
		SET v_base_sql = 'select old.StatisDate, old.KindId, old.ServerId, old.oldSumValid, old.oldSumProfit, old.oldSumGameNum, old.oldSumActiveUser, old.oldNormalValid, old.oldNormalProfit, old.oldNormalGameNum, old.oldNormalActiveUser, old.oldKillValid, old.oldKillProfit, old.oldKillGameNum, old.oldKillActiveUser, old.oldClassKillValid, old.oldClassKillProfit, old.oldClassKillGameNum, old.oldClassKillActiveUser, old.oldRevValid, old.oldRevProfit, old.oldRevGameNum, old.oldRevActiveUser, old.oldClassRevValid, old.oldClassRevProfit, old.oldClassRevGameNum, old.oldClassRevActiveUser, old.oldPtkillValid, old.oldPtkillProfit, old.oldPtkillGameNum, old.oldPtkillActiveUser, old.newSumValid, old.newSumProfit, old.newSumGameNum, old.newSumActiveUser, old.newNormalValid, old.newNormalProfit, old.newNormalGameNum, old.newNormalActiveUser, old.newKillValid, old.newKillProfit, old.newKillGameNum, old.newKillActiveUser, old.newClassKillValid, old.newClassKillProfit, old.newClassKillGameNum, old.newClassKillActiveUser, old.newRevValid, old.newRevProfit, old.newRevGameNum, old.newRevActiveUser, old.newClassRevValid, old.newClassRevProfit, old.newClassRevGameNum, old.newClassRevActiveUser, old.newPtkillValid, old.newPtkillProfit, old.newPtkillGameNum, old.newPtkillActiveUser, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.Updatetime from '; 

		SET v_src_db = 'Transfer'; 
		SET v_src_table = CONCAT('statis_room_recordtype_data_', v_month); 

		SET v_dist_db = 'KYStatis'; 
		SET v_dist_table = CONCAT('statis_room_recordtype_data_', v_month); 

		set v_create_sql=CONCAT('
			CREATE TABLE IF NOT EXISTS `',v_dist_db,'`.`',v_dist_table,'` (
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
				) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
				'); 

		SET @v_sql = v_create_sql; 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_month_counter = v_month_counter + 1; 
		SET v_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_month_counter MONTH), '%Y%m'); 
	END WHILE; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomRecordtypeData') ON DUPLICATE KEY UPDATE `status`= 1; 


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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRoomRobot`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRoomRobot`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomRobot') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.createdate, old.ServerId, old.AIID, \'CNY\' currency, 1 exchangeRate, old.DayWin, old.DayLost, old.MonthWin, old.MonthLost, old.Win, old.Lost, old.DayProfit, old.MonthProfit, old.Profit, old.DayWinNum, old.DayLostNum, old.DayHeNum, old.DayTotal, old.MonthWinNum, old.MonthLostNum, old.MonthHeNum, old.MonthTotal, old.WinNum, old.LostNum, old.HeNum, old.TotalNum, old.AllDayProfit, old.AllMonthProfit, old.AllProfit, old.AllDayWinNum, old.AllDayNum, old.AllMonthWinNum, old.AllMonthNum, old.AllTotalWinNum, old.AllTotalNum from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_room_robot'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_room_robot'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_room_robot; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomRobot') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisRecordAgentAll`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisRecordAgentAll`()
BEGIN
	DECLARE v_sql LONGTEXT;
	DECLARE v_base_sql LONGTEXT;
	DECLARE v_exist INT;
	DECLARE v_src_db VARCHAR(255);
	DECLARE v_src_table VARCHAR(255);
	DECLARE v_dist_db VARCHAR(255);
	DECLARE v_dist_table VARCHAR(255);
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentAll') ON DUPLICATE KEY UPDATE `status`= 0;
	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from ';

	SET v_src_db = 'Transfer';
	SET v_src_table = 'statis_record_agent_all_reguser';

	SET v_dist_db = 'KYStatis';
	SET v_dist_table = 'statis_record_agent_all_reguser';

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old');
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql);
	SET @v_sql = v_sql;

  	BEGIN
  	  DECLARE CONTINUE HANDLER FOR 1505 BEGIN END;
  	  ALTER TABLE KYStatis.statis_record_agent_all_reguser REMOVE PARTITIONING;
  	END;

    TRUNCATE TABLE KYStatis.statis_record_agent_all_reguser;

    PREPARE stmt FROM @v_sql;
	EXECUTE stmt;
	DEALLOCATE PREPARE stmt;
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentAll') ON DUPLICATE KEY UPDATE `status`= 1;

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisRecordAgentAllEST_updateDate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisRecordAgentAllEST_updateDate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_update_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentAllEST_updateDate') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 
	SET v_update_sql = ' ON DUPLICATE KEY UPDATE StatisDate = VALUES(StatisDate), ChannelID = VALUES(ChannelID), WinGold = VALUES(WinGold), LostGold = VALUES(LostGold), CellScore = VALUES(CellScore), Revenue = VALUES(Revenue), WinNum = VALUES(WinNum), LostNum = VALUES(LostNum), ActiveUsers = VALUES(ActiveUsers), currency =\'CNY\' , exchangeRate = 1 '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_all_EST'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_all_EST'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql, ' ', v_update_sql); 
	SET @v_sql = v_sql; 

  	BEGIN
  	  DECLARE CONTINUE HANDLER FOR 1505 BEGIN END; 
      ALTER TABLE KYStatis.statis_record_agent_all_EST REMOVE PARTITIONING; 
  	END; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentAllEST_updateDate') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisRecordAgentAll_updateDate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisRecordAgentAll_updateDate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_update_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentAll_updateDate') ON DUPLICATE KEY UPDATE `status`= 0; 
	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 
	SET v_update_sql = ' ON DUPLICATE KEY UPDATE StatisDate = VALUES(StatisDate), ChannelID = VALUES(ChannelID), WinGold = VALUES(WinGold), LostGold = VALUES(LostGold), CellScore = VALUES(CellScore), Revenue = VALUES(Revenue), WinNum = VALUES(WinNum), LostNum = VALUES(LostNum), ActiveUsers = VALUES(ActiveUsers), currency =\'CNY\' , exchangeRate = 1 '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_all'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_all'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql, ' ', v_update_sql); 
	SET @v_sql = v_sql; 

  	BEGIN
  	  DECLARE CONTINUE HANDLER FOR 1505 BEGIN END; 
  	  ALTER TABLE KYStatis.statis_record_agent_all REMOVE PARTITIONING; 
  	END; 

    PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentAll_updateDate') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisRecordAgentGameEST_updateDate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisRecordAgentGameEST_updateDate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_update_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentGameEST_updateDate') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.GameID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 
	SET v_update_sql = ' ON DUPLICATE KEY UPDATE StatisDate = VALUES(StatisDate), ChannelID = VALUES(ChannelID), GameID = VALUES(GameID), WinGold = VALUES(WinGold), LostGold = VALUES(LostGold), CellScore = VALUES(CellScore), Revenue = VALUES(Revenue), WinNum = VALUES(WinNum), LostNum = VALUES(LostNum), ActiveUsers = VALUES(ActiveUsers), currency =\'CNY\' , exchangeRate = 1 '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_game_EST'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_game_EST'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql, ' ', v_update_sql); 
	SET @v_sql = v_sql; 

  	BEGIN
  	  DECLARE CONTINUE HANDLER FOR 1505 BEGIN END; 
      ALTER TABLE KYStatis.statis_record_agent_game_EST REMOVE PARTITIONING; 
  	END; 

    PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentGameEST_updateDate') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisRecordAgentGame_updateDate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisRecordAgentGame_updateDate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_update_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentGame_updateDate') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.GameID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, old.DayNewBetUsers, \'CNY\' currency, 1 exchangeRate from '; 
	SET v_update_sql = ' ON DUPLICATE KEY UPDATE StatisDate = VALUES(StatisDate), ChannelID = VALUES(ChannelID), GameID = VALUES(GameID), WinGold = VALUES(WinGold), LostGold = VALUES(LostGold), CellScore = VALUES(CellScore), Revenue = VALUES(Revenue), WinNum = VALUES(WinNum), LostNum = VALUES(LostNum), ActiveUsers = VALUES(ActiveUsers),  DayNewBetUsers = VALUES(DayNewBetUsers), currency =\'CNY\' , exchangeRate = 1 '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_game'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_game'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql, ' ', v_update_sql); 
	SET @v_sql = v_sql; 

  	BEGIN
  	  DECLARE CONTINUE HANDLER FOR 1505 BEGIN END; 
      ALTER TABLE KYStatis.statis_record_agent_game REMOVE PARTITIONING; 
  	END; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentGame_updateDate') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersAllGames_all`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersAllGames_all`()
BEGIN
	DECLARE done INT DEFAULT FALSE; 
    DECLARE table_names VARCHAR(255); 
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 

    DECLARE cur CURSOR FOR
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'Transfer_KYStatisUsers' AND table_name LIKE 'statis_allgames%_users'; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersAllGames_all') ON DUPLICATE KEY UPDATE `status`= 0; 


	SET v_src_db = 'Transfer_KYStatisUsers'; 
	SET v_dist_db = 'KYStatisUsers'; 
	SET v_base_sql = 'select old.StatisDate, old.Account, old.ChannelID, old.LineCode, 0 AllBet, old.CellScore, old.WinGold, old.LostGold, old.Revenue, old.WinNum, old.LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from '; 

	OPEN cur; 
    read_loop: LOOP
        FETCH cur INTO table_names; 
        IF done THEN
            LEAVE read_loop; 
        END IF; 

		set @v_drpoSql = CONCAT('DROP TABLE IF EXISTS ', v_dist_db,'.', table_names, ';'); 
		PREPARE stmt FROM @v_drpoSql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		
		call KYStatisUsers.sp_createStatisticsUsersTable(table_names, 0); 

		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', table_names,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', table_names, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
               
    END LOOP; 
    CLOSE cur; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersAllGames_all') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersAllUsers`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersAllUsers`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersAllUsers') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.Account, old.ChannelID, old.LineCode, 0 AllBet, old.CellScore, old.WinGold, old.LostGold, old.Revenue, old.WinNum, old.LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from '; 

	SET v_src_db = 'Transfer_KYStatisUsers'; 
	SET v_src_table = 'statis_all_users'; 

	SET v_dist_db = 'KYStatisUsers'; 
	SET v_dist_table = 'statis_all_users'; 

	set v_sql = concat('select count(*) into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

        TRUNCATE TABLE KYStatisUsers.statis_all_users; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
        INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersAllUsers') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersAllUsersUnique`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersAllUsersUnique`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersAllUsersUnique') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.Account, old.ChannelID, old.CellScore, old.WinGold, old.LostGold, old.Revenue, old.WinNum, old.LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from '; 

	SET v_src_db = 'Transfer_KYStatisUsers'; 
	SET v_src_table = 'statis_all_users_unique'; 

	SET v_dist_db = 'KYStatisUsers'; 
	SET v_dist_table = 'statis_all_users_unique'; 

	set v_sql = concat('select count(*) into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table, ' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

        TRUNCATE TABLE KYStatisUsers.statis_all_users_unique; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
        INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersAllUsersUnique') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersByGame_all`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersByGame_all`()
BEGIN
	DECLARE done INT DEFAULT FALSE; 
    DECLARE table_names VARCHAR(255); 
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 

    DECLARE cur CURSOR FOR
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'Transfer_KYStatisUsers' AND table_name LIKE 'statis_%20%_users' AND  table_name NOT LIKE 'statis_all%_users' AND  table_name NOT LIKE 'statis_month%_users'; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersByGame_all') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_src_db = 'Transfer_KYStatisUsers'; 
	SET v_dist_db = 'KYStatisUsers'; 

	OPEN cur; 
    read_loop: LOOP
        FETCH cur INTO table_names; 
        IF done THEN
            LEAVE read_loop; 
        END IF; 

		set @v_drpoSql = CONCAT('DROP TABLE IF EXISTS ', v_dist_db,'.', table_names, ';'); 
		PREPARE stmt FROM @v_drpoSql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		
		call KYStatisUsers.sp_createStatisticsUsersTable(table_names, 0); 

		SET v_sql = CONCAT('select old.StatisDate, old.Account, old.ChannelID, old.LineCode, 0 Allbet, SUM(old.CellScore) CellScore, SUM(old.WinGold) WinGold, SUM(old.LostGold) LostGold, SUM(old.Revenue) Revenue, SUM(old.WinNum) WinNum, SUM(old.LostNum) LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from ', v_src_db,'.', table_names,' old GROUP BY old.StatisDate, old.Account, old.LineCode'); 
		SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', table_names, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
               
    END LOOP; 
    CLOSE cur; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersByGame_all') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersByMonth_all`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersByMonth_all`()
BEGIN
	DECLARE done INT DEFAULT FALSE; 
    DECLARE table_names VARCHAR(255); 
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 

    DECLARE cur CURSOR FOR
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'Transfer_KYStatisUsers' AND table_name LIKE 'statis_month%_users'; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersByMonth_all') ON DUPLICATE KEY UPDATE `status`= 0; 


	SET v_src_db = 'Transfer_KYStatisUsers'; 
	SET v_dist_db = 'KYStatisUsers'; 
	SET v_base_sql = 'select old.Account, old.ChannelID, old.LineCode, 0 AllBet, old.CellScore, old.WinGold, old.LostGold, old.Revenue, old.WinNum, old.LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from '; 

	OPEN cur; 
    read_loop: LOOP
        FETCH cur INTO table_names; 
        IF done THEN
            LEAVE read_loop; 
        END IF; 

		set @v_drpoSql = CONCAT('DROP TABLE IF EXISTS ', v_dist_db,'.', table_names, ';'); 
		PREPARE stmt FROM @v_drpoSql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		
		call KYStatisUsers.sp_createStatisticsUsersTable(table_names, 1); 

		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', table_names,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', table_names, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
               
    END LOOP; 
    CLOSE cur; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersByMonth_all') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersByRoom_all`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersByRoom_all`()
BEGIN
	DECLARE done INT DEFAULT FALSE; 
    DECLARE table_names VARCHAR(255); 
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 

    DECLARE cur CURSOR FOR
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'Transfer_KYStatisUsers' AND table_name LIKE 'statis_%20%_users_room'; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersByRoom_all') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_src_db = 'Transfer_KYStatisUsers'; 
	SET v_dist_db = 'KYStatisUsers'; 

	OPEN cur; 
    read_loop: LOOP
        FETCH cur INTO table_names; 
        IF done THEN
            LEAVE read_loop; 
        END IF; 

		set @v_drpoSql = CONCAT('DROP TABLE IF EXISTS ', v_dist_db,'.', table_names, ';'); 
		PREPARE stmt FROM @v_drpoSql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		
		call KYStatisUsers.sp_createStatisticsUsersTable(table_names, 2); 

		SET v_sql = CONCAT('select old.StatisDate, old.Account, old.ChannelID, old.ServerID, old.CellScore, old.WinGold, old.LostGold, old.Revenue, old.WinNum, old.LostNum, 0 isNew, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from ', v_src_db,'.', table_names,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', table_names, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
               
    END LOOP; 
    CLOSE cur; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersByRoom_all') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersESTAllGames_all`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersESTAllGames_all`()
BEGIN
	DECLARE done INT DEFAULT FALSE; 
    DECLARE table_names VARCHAR(255); 
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 

    DECLARE cur CURSOR FOR
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'Transfer_KYStatisUsers_EST' AND table_name LIKE 'statis_allgames%_users'; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersESTAllGames_all') ON DUPLICATE KEY UPDATE `status`= 0; 


	SET v_src_db = 'Transfer_KYStatisUsers_EST'; 
	SET v_dist_db = 'KYStatisUsers_EST'; 
	SET v_base_sql = 'select old.StatisDate, old.Account, old.ChannelID, old.LineCode, 0 AllBet, old.CellScore, old.WinGold, old.LostGold, old.Revenue, old.WinNum, old.LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from '; 


	OPEN cur; 
    read_loop: LOOP
        FETCH cur INTO table_names; 
        IF done THEN
            LEAVE read_loop; 
        END IF; 

		set @v_drpoSql = CONCAT('DROP TABLE IF EXISTS ', v_dist_db,'.', table_names, ';'); 
		PREPARE stmt FROM @v_drpoSql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		
		call KYStatisUsers_EST.sp_createStatisticsUsersTable(table_names, 0); 

		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', table_names,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', table_names, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
               
    END LOOP; 
    CLOSE cur; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersESTAllGames_all') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersESTByGame_all`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersESTByGame_all`()
BEGIN
	DECLARE done INT DEFAULT FALSE; 
    DECLARE table_names VARCHAR(255); 
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 

    DECLARE cur CURSOR FOR
        SELECT table_name
        FROM information_schema.tables
        WHERE table_schema = 'Transfer_KYStatisUsers_EST' AND table_name LIKE 'statis_%20%_users' AND  table_name NOT LIKE 'statis_all%_users' AND  table_name NOT LIKE 'statis_month%_users'; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersESTByGame_all') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_src_db = 'Transfer_KYStatisUsers_EST'; 
	SET v_dist_db = 'KYStatisUsers_EST'; 

	OPEN cur; 
    read_loop: LOOP
        FETCH cur INTO table_names; 
        IF done THEN
            LEAVE read_loop; 
        END IF; 

		set @v_drpoSql = CONCAT('DROP TABLE IF EXISTS ', v_dist_db,'.', table_names, ';'); 
		PREPARE stmt FROM @v_drpoSql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
		
		call KYStatisUsers_EST.sp_createStatisticsUsersTable(table_names, 0); 

		SET v_sql = CONCAT('select old.StatisDate, old.Account, old.ChannelID, old.LineCode, 0 Allbet, SUM(old.CellScore) CellScore, SUM(old.WinGold) WinGold, SUM(old.LostGold) LostGold, SUM(old.Revenue) Revenue, SUM(old.WinNum) WinNum, SUM(old.LostNum) LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from ', v_src_db,'.', table_names,' old GROUP BY old.StatisDate, old.Account, old.LineCode'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', table_names, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
               
    END LOOP; 
    CLOSE cur; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersESTByGame_all') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftOrdersRecordSingleOrders`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftOrdersRecordSingleOrders`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
    DECLARE currentDate DATE; 
    DECLARE startDate DATE; 
    DECLARE endDate DATE; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftOrdersRecordSingleOrders') ON DUPLICATE KEY UPDATE `status`= 0; 

    SET currentDate = CURDATE(); 
    SET startDate = DATE_SUB(currentDate, INTERVAL 3 MONTH); 
    SET endDate = currentDate; 

	SET v_base_sql = 'select old.OrderID, old.ChannelID, old.OrderTime, old.GameNo, old.OrderType, old.OrderAction, old.OrderStatus, old.CurScore, old.AddScore, old.NewScore, old.OrderIP, old.CreateUser, \'CNY\' currency, old.ErrorMsg, old.RetCode, old.DealStatus, old.createdate from '; 

	SET v_src_db = 'Transfer_orders_record'; 

	SET v_dist_db = 'orders_record'; 
	SET v_dist_table = 'single_orders'; 

    TRUNCATE TABLE orders_record.single_orders; 

    WHILE startDate <= endDate DO
		SET v_src_table = CONCAT('single_orders',DATE_FORMAT(startDate, '%Y%m%d')); 
		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = v_src_db AND TABLE_NAME = v_src_table) THEN
			SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
			SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' (`OrderID`,`ChannelID`,`OrderTime`,`GameNo`,`OrderType`,`OrderAction`,`OrderStatus`,`CurScore`,`AddScore`,`NewScore`,`OrderIP`,`CreateUser`,`currency`,`ErrorMsg`,`RetCode`,`DealStatus`,`createdate`) ', v_sql); 
			SET @v_sql = v_sql; 

			PREPARE stmt FROM @v_sql; 
			EXECUTE stmt; 
			DEALLOCATE PREPARE stmt; 

		END IF; 
        SET startDate = DATE_ADD(startDate, INTERVAL 1 DAY); 
    END WHILE; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftOrdersRecordSingleOrders') ON DUPLICATE KEY UPDATE `status`= 1; 
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

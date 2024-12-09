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
DROP PROCEDURE IF EXISTS `ShiftDetailRecordHyfdzpkGameRecord`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftDetailRecordHyfdzpkGameRecord`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftDetailRecordHyfdzpkGameRecord') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select * from Transfer.hyfdzpk_gameRecord where AllBet = 0 and CurScore <> 0 '; 

	SET v_dist_db = 'detail_record'; 
	SET v_dist_table = 'hyfdzpk_gameRecord'; 
		
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_base_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftDetailRecordHyfdzpkGameRecord') ON DUPLICATE KEY UPDATE `status`= 1; 

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
	DECLARE v_columns LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

    TRUNCATE TABLE finance_manage.finance_dielivery_detail; 
    SET v_columns = 'StatisDate, ChannelID, ChannelName, NickName, AccountingFor, CellScore, Profit, SumProfit, TimeZone, CreateTime'; 

    
	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFinanceManageDieliveryDetail') ON DUPLICATE KEY UPDATE `status`= 0; 
	
    SET v_base_sql = concat('select ',  v_columns, ', 0 category from '); 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'finance_dielivery_detail'; 

	SET v_dist_db = 'finance_manage'; 
	SET v_dist_table = 'finance_dielivery_detail'; 
		
	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' (', v_columns,', category) ', v_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFinanceManageDieliveryDetail') ON DUPLICATE KEY UPDATE `status`= 1; 

    
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFinanceManageDieliveryDetailCategory') ON DUPLICATE KEY UPDATE `status`= 0; 
    SET v_base_sql = concat('select ',  v_columns, ', category from '); 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'finance_dielivery_detail_category'; 

	SET v_dist_db = 'finance_manage'; 
	SET v_dist_table = 'finance_dielivery_detail'; 
		
	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' (', v_columns,', category) ', v_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFinanceManageDieliveryDetailCategory') ON DUPLICATE KEY UPDATE `status`= 1; 

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
	DECLARE v_columns LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

    TRUNCATE TABLE finance_manage.finance_dielivery_list; 
    SET v_columns = 'id, StatisDate, ChannelID, LevelID, ChannelName, NickName, AccountingFor, CellScore, Profit, SumProfit, TimeZone, SpecialMoney, Remark, Status, CreateTime, CheckTime, SendTime, ReceiveChannelID, UpdateTime'; 

    
	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFinanceManageDieliveryList') ON DUPLICATE KEY UPDATE `status`= 0; 
	
    SET v_base_sql = concat('select ',  v_columns, ', 0 category from '); 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'finance_dielivery_list'; 

	SET v_dist_db = 'finance_manage'; 
	SET v_dist_table = 'finance_dielivery_list'; 
		
	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' (', v_columns,', category) ', v_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFinanceManageDieliveryList') ON DUPLICATE KEY UPDATE `status`= 1; 

    
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFinanceManageDieliveryListCategory') ON DUPLICATE KEY UPDATE `status`= 0; 
    SET v_base_sql = concat('select ',  v_columns, ', category from '); 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'finance_dielivery_list_category'; 

	SET v_dist_db = 'finance_manage'; 
	SET v_dist_table = 'finance_dielivery_list'; 
		
	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' (', v_columns,', category) ', v_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftFinanceManageDieliveryListCategory') ON DUPLICATE KEY UPDATE `status`= 1; 

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

	SET v_base_sql = 'select old.id, old.account, old.agent, old.mstatus, old.mark, old.lineCode, old.lastlogintime, old.createdate, old.updatedate, null firstBetTime,0 AS PTDStatus from '; 
	SET v_update_sql = ' ON DUPLICATE KEY UPDATE id = VALUES(id), id = VALUES(id), account = VALUES(account), agent = VALUES(agent), mstatus = VALUES(mstatus), mark = VALUES(mark), lineCode = VALUES(lineCode), lastlogintime = VALUES(lastlogintime), createdate = VALUES(createdate), updatedate = VALUES(updatedate), firstBetTime = VALUES(firstBetTime),PTDStatus = VALUES(PTDStatus) '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'accounts'; 

	SET v_dist_db = 'game_api'; 
	SET v_dist_table = 'accounts'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql, ' ', v_update_sql ); 
	SET @v_sql = v_sql; 

	
	

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
DROP PROCEDURE IF EXISTS `ShiftGameApiOrders`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameApiOrders`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
	DECLARE v_previous_date VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiOrders') ON DUPLICATE KEY UPDATE `status`= 0; 

	
	SET v_previous_date = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 2 MONTH), '%Y-%m-01'); 
	SET v_base_sql = 'select old.id, old.orderid, old.money, old.status, old.type, JSON_SET(old.big_data, \'$.addScore\', old.money), old.createdate, old.updatedate, \'CNY\' currency from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'orders'; 

	SET v_dist_db = 'game_api'; 
	SET v_dist_table = 'orders'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old WHERE createdate >= \'',v_previous_date,'\''); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    
    

    TRUNCATE TABLE game_api.orders; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiOrders') ON DUPLICATE KEY UPDATE `status`= 1; 

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

	SET v_base_sql = 'select old.*, 1 isInitPwd from '; 

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
DROP PROCEDURE IF EXISTS `ShiftGameStatisticsOnlineGame`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameStatisticsOnlineGame`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameStatisticsOnlineGame') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.id, old.gameId, old.value, old.ip, NULL abId, old.createtime from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'online_game'; 

	SET v_dist_db = 'game_statistics'; 
	SET v_dist_table = 'online_game'; 
		
	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

	TRUNCATE TABLE game_statistics.online_game; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameStatisticsOnlineGame') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftGameStatisticsOnlineGameAll`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameStatisticsOnlineGameAll`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameStatisticsOnlineGameAll') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.id, old.value, old.ip, NULL abId, old.createtime from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'online_game_all'; 

	SET v_dist_db = 'game_statistics'; 
	SET v_dist_table = 'online_game_all'; 
		
	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

	TRUNCATE TABLE game_statistics.online_game_all; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameStatisticsOnlineGameAll') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftGameStatisticsOnlineRoom`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameStatisticsOnlineRoom`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameStatisticsOnlineRoom') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.id, old.roomId, old.value, old.ip, NULL abId, old.createtime from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'online_room'; 

	SET v_dist_db = 'game_statistics'; 
	SET v_dist_table = 'online_room'; 
		
	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

	TRUNCATE TABLE game_statistics.online_room; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameStatisticsOnlineRoom') ON DUPLICATE KEY UPDATE `status`= 1; 

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

	
	INSERT INTO KYDB_NEW.agent 
	SELECT
		ChannelID AS id,
		UID AS uid,
		Transfer.getTopUid(ChannelID) AS topUid,
		Accounts AS account,
		roleid AS roleId,
		UserPWD AS userPwd,
		NickName AS nickname,
		UserStatus AS userStatus,
		case MoneyType WHEN 26 THEN 28 ELSE MoneyType END AS moneyType,
		CASE sbStatus WHEN 1 THEN 2 WHEN 0 THEN 0 END AS walletType,
		ProxyRevenue AS revenue,
		UserStatus AS status,
		ChannelValue AS channelValue,
		CreateUser AS createUser,
		createdate AS createDate,
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
		0 AS payType,
		ISinheritwhiteIP AS isInheritWhiteIp,
		0 AS isShowPayPopUps,
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
		1 AS lang,
		9 AS theme,
		'' AS themeList,
		null AS rechargeUrl,
		null AS rechargeStatus,
		sbUrl AS sbUrl,
		null AS convertMultiple,
		1 AS gameFrameControl,
		0 AS gameFrameTeachControl,
		1 AS gameFullScreenControl,
		1 AS gameMusicControl,
		null AS autoMatch,
		1 as productLine,
		0 as gameTakesControl,
		case MoneyType WHEN 26 THEN 28 ELSE MoneyType END AS deliveryMoneyType,
		0 jackpotSupport,
		0 jackpotNotice,
		0 jackpotAllowGrand,
		0 insuranceType,
		null jackpotOpenDate,
		0 scrollOrientation,
		0 externalGamesControl,
		1 gameCurrencyControl,
		1 gamePlayedListControl,
		0 fbStatus,
		0 sportCashout,
		0.00 fb_sportAccountingFor,
		0 sportRoute,
		0 sportDomainStatus,
		null sportDomain,
		null sportDomainPC,
		0 tryToPlayStatus,
		'' AS tryToPlayUrl,
		1 isInitPwd
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
		deliveryMoneyType = VALUES(deliveryMoneyType),
		jackpotSupport = VALUES(jackpotSupport),
		jackpotNotice = VALUES(jackpotNotice),
		jackpotAllowGrand = VALUES(jackpotAllowGrand),
		insuranceType = VALUES(insuranceType),
		jackpotOpenDate = VALUES(jackpotOpenDate),
		externalGamesControl = VALUES(externalGamesControl),
		scrollOrientation = VALUES(scrollOrientation),
		gameCurrencyControl = VALUES(gameCurrencyControl),
		gamePlayedListControl = VALUES(gamePlayedListControl),
		fbStatus = VALUES(fbStatus),
		sportCashout = VALUES(sportCashout),
		fb_sportAccountingFor = VALUES(fb_sportAccountingFor),
		sportRoute = VALUES(sportRoute),
		sportDomainStatus = VALUES(sportDomainStatus),
		sportDomain = VALUES(sportDomain),
		sportDomainPC = VALUES(sportDomainPC),
		tryToPlayStatus = VALUES(tryToPlayStatus),
		tryToPlayUrl = VALUES(tryToPlayUrl),
		isInitPwd = VALUES(isInitPwd); 

	
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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWGameInfo`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWGameInfo`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    
	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWGameInfo') ON DUPLICATE KEY UPDATE `status`= 0; 

	update KYDB_NEW.GameInfo set GameStatus = 1 
		where GameID in (select GameID FROM Transfer.`Sys_ProxyGameInfo` x where x.ChannelID = 0 and x.GameStatus <> 0); 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWGameInfo') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWGameRoomInfo`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWGameRoomInfo`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    
	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWGameRoomInfo') ON DUPLICATE KEY UPDATE `status`= 0; 

	update KYDB_NEW.GameRoomInfo set status = 1 
		where ServerID in (select serverid from Transfer.Sys_GameRoomStatus where status = 1 and channelid = 0); 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWGameRoomInfo') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWJackpotLog`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWJackpotLog`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWJackpotLog') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.ID, old.from, old.to, old.fromAfterScore, old.Score, old.toAfterScore, old.type, old.CreateTime, old.CreateUser  from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'jackpot_log'; 

	SET v_dist_db = 'KYDB_NEW'; 
	SET v_dist_table = 'jackpot_log'; 
		
	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWJackpotLog') ON DUPLICATE KEY UPDATE `status`= 1; 

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
	SET v_dist_table = 'Sys_KillRate_bk'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYDB_NEW.sys_killRate; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	
INSERT INTO `KYDB_NEW`.`sys_killRate` (`agentId`, `killRate`, `type`, `createUser`, `createTime`, `updateUser`, `updateTime`)  
	SELECT * 
	FROM (
		SELECT 
			`ChannelIDLinecode` AS `agentId`,
			`KillRate` AS `killRate`,
			`Type` AS `type`,
			`CreateUser` AS `createUser`,
			`CreateTime` AS `createTime`,
			`UpdateUser` AS `updateUser`,
			`UpdateTime` AS `updateTime`
		FROM `KYDB_NEW`.`Sys_KillRate_bk` WHERE `Type` = 0
	) AS A
WHERE NOT EXISTS (
	SELECT 1 
	FROM `KYDB_NEW`.`sys_killRate` 
	WHERE `agentId` = A.`agentId` AND `type` = 0); 



INSERT INTO `KYDB_NEW`.`sys_killRate` (`agentId`, `lineCode`, `killRate`, `type`, `createUser`, `createTime`, `updateUser`, `updateTime`)  
	SELECT * 
	FROM (
		SELECT 
			l.`agentId` AS `agentId`,
			k.`ChannelIDLinecode` AS `lineCode`,
			k.`KillRate` AS `killRate`,
			k.`Type` AS `type`,
			k.`CreateUser` AS `createUser`,
				k.`CreateTime` AS `createTime`,
			k.`UpdateUser` AS `updateUser`,
			k.`UpdateTime` AS `updateTime`
		FROM `KYDB_NEW`.`Sys_KillRate_bk` AS k
		LEFT JOIN `KYDB_NEW`.`sys_agent_linecode` AS l ON k.`ChannelIDLinecode` = l.`linecode`
		WHERE `Type` = 1 
	) AS A
WHERE NOT EXISTS (
	SELECT 1 
	FROM `KYDB_NEW`.`sys_killRate` 
	WHERE `agentId` = A.`agentId` AND `lineCode` = A.`lineCode` AND `type` = 1); 


INSERT INTO  `KYDB_NEW`.`sys_killRate` (`agentId`, `gameId`, `killRate`, `type`, `createUser`, `createTime`, `updateUser`, `updateTime`)  
	SELECT * 
	FROM (
		SELECT 
			`ChannelIDLinecode` AS `agentId`,
			`gameRoomId` AS `gameId`,
			`KillRate` AS `killRate`,
			`Type` AS `type`,
			`CreateUser` AS `createUser`,
			`CreateTime` AS `createTime`,
			`UpdateUser` AS `updateUser`,
			`UpdateTime` AS `updateTime`
		FROM `KYDB_NEW`.`Sys_KillRate_bk`
		WHERE `Type` = 2
	) AS A
WHERE NOT EXISTS (
	SELECT 1 
	FROM `KYDB_NEW`.`sys_killRate` 
	WHERE `agentId` = A.`agentId` AND `gameId` = A.`gameId` AND `type` = 2); 


INSERT INTO  `KYDB_NEW`.`sys_killRate` (`agentId`, `gameId`, `roomId`, `ptk`, `newPtk`, `type`, `createUser`, `createTime`, `updateUser`, `updateTime`)  
    SELECT * 
    FROM (
    SELECT 
        m.`ChannelIDLinecode` AS `agentId`,
        r.`KindID` AS `gameId`,
        m.`gameRoomId` AS `roomId`,
        MAX(CASE WHEN m.`Type` = 3 THEN m.`KillRate` ELSE NULL END) AS `ptk`,
        MAX(CASE WHEN A.`Type` = 4 THEN A.`KillRate` ELSE NULL END) AS `newPtk`,
        3 AS `type`,
        MIN(CASE WHEN m.`createTime` > A.`createTime` THEN m.`createuser` ELSE A.`createuser` END) AS `createuser`,
        Min(m.`createTime`) AS `createTime`,
        MAX(CASE WHEN m.`updateTime` > A.`updateTime` THEN m.`updateUser` ELSE A.`updateUser` END) AS `updateUser`,
        MAX(m.`updateTime`) AS `updateTime`
        FROM `KYDB_NEW`.`Sys_KillRate_bk` AS m
        LEFT JOIN `KYDB_NEW`.`GameRoomInfo` AS r ON m.`gameRoomId` = r.`ServerID`
        JOIN
        (
            SELECT *
            FROM `KYDB_NEW`.`Sys_KillRate_bk`
            WHERE type IN (3,4)
        ) A
        ON A.`ChannelIDLinecode` = m.`ChannelIDLinecode`
        AND A.`gameRoomId` = m.`gameRoomId`
        AND (A.`Type` = m.`Type` + 1 OR A.type = m.type)
        WHERE m.`Type` IN (3,4)
        GROUP BY `agentId`, `roomId`
    ) AS A
    WHERE NOT EXISTS (
    SELECT 1 
    FROM `KYDB_NEW`.`sys_killRate` 
    WHERE `agentId` = A.`agentId` AND `gameId` = A.`gameId` AND `roomId` = A.`roomId` AND `type` = 3); 
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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWProxyGameInfo`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWProxyGameInfo`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWProxyGameInfo') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.GameID, old.ChannelID, old.GameOrderBy, if (old.GameStatus = 0, 0, 1) GameStatus, old.ShowLabel, old.OutLink from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'Sys_ProxyGameInfo'; 

	SET v_dist_db = 'KYDB_NEW'; 
	SET v_dist_table = 'Sys_ProxyGameInfo'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYDB_NEW.Sys_ProxyGameInfo; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWProxyGameInfo') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWProxyOrderDetails`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWProxyOrderDetails`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWProxyOrderDetails') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.OrderID, old.ChannelID, old.OrderTime, old.OrderType, old.OrderStatus, old.CurScore, old.AddScore, old.NewScore, old.OrderIP, old.CreateUser, old.OrderObject, old.ErrorMsg, NULL AddUser, old.AccountingForOrder from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'Sys_HT_ProxyOrderDetails'; 

	SET v_dist_db = 'KYDB_NEW'; 
	SET v_dist_table = 'Sys_HT_ProxyOrderDetails'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYDB_NEW.Sys_HT_ProxyOrderDetails; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWProxyOrderDetails') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWUserOrderDetails`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWUserOrderDetails`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWUserOrderDetails') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.OrderID, old.OrderTime, old.ChannelID, old.UserID, old.Accounts, old.OrderType, old.CurScore, old.AddScore, old.NewScore, old.OrderIP, old.CreateUser ,\'CNY\' currency from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'Game_HT_UserOrderDetails'; 

	SET v_dist_db = 'KYDB_NEW'; 
	SET v_dist_table = 'Game_HT_UserOrderDetails'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYDB_NEW.Game_HT_UserOrderDetails; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWUserOrderDetails') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWVvipListChangelog`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWVvipListChangelog`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWVvipListChangelog') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.ID, old.Account, old.CellScore, old.Profit, old.ChannelID, old.status, \'CNY\' currency, old.fromAfterScore, old.Score, old.toAfterScore, old.CreateTime, old.CreateUser from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'vvip_list_changelog'; 

	SET v_dist_db = 'KYDB_NEW'; 
	SET v_dist_table = 'vvip_list_changelog'; 
		
	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWVvipListChangelog') ON DUPLICATE KEY UPDATE `status`= 1; 

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

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.LineCode, old.DWinGold, old.DLostGold, old.DCellScore, old.DRevenue, old.DWinNum, old.DLostNum, old.DActiveUsers, old.MWinGold, old.MLostGold, old.MCellScore, old.MRevenue, old.MWinNum, old.MLostNum, old.MActiveUsers, old.HWinGold, old.HLostGold, old.HCellScore, old.HRevenue, old.HWinNum, old.HLostNum, old.HActiveUsers, old.CreateTime, old.UpdateTime, \'CNY\' currency, 1 exchangeRate from '; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisLoginStatisLocationGame`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisLoginStatisLocationGame`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_extra_group_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
	DECLARE v_current_month VARCHAR(6); 
	DECLARE v_last_month VARCHAR(6); 

    SET v_current_month = DATE_FORMAT(NOW(), '%Y%m'); 
	SET v_last_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 MONTH), '%Y%m'); 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisLoginStatisLocationGame') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select main.StatisDate, main.Location location, info.GameID, sum(main.BetUsers) BetUsers, sum(main.GameNum) GameNum from '; 
    SET v_extra_group_sql = ' main inner join KYDB_NEW.GameRoomInfo info on info.ServerID = main.ServerID group by main.StatisDate, info.GameID, main.Location'; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = concat('statis_location_game_', v_last_month); 

	SET v_dist_db = 'KYStatisLogin'; 
	SET v_dist_table = concat('statis_location_game_', v_last_month); 

    set v_sql = concat(' select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    IF @v_exist > 0 THEN
		call KYStatisLogin.sp_createTable(concat('statis_location_game_', v_last_month), 8); 

		SET v_sql = CONCAT('insert into ', v_dist_db,'.', v_dist_table, ' ', v_base_sql, v_src_db,'.', v_src_table, v_extra_group_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 

    SET v_src_db = 'Transfer'; 
	SET v_src_table = concat('statis_location_game_', v_current_month); 

	SET v_dist_db = 'KYStatisLogin'; 
	SET v_dist_table = concat('statis_location_game_', v_current_month); 

    set v_sql = concat(' select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    IF @v_exist > 0 THEN
		call KYStatisLogin.sp_createTable(concat('statis_location_game_', v_current_month), 8); 

		SET v_sql = CONCAT('insert into ', v_dist_db,'.', v_dist_table, ' ', v_base_sql, v_src_db,'.', v_src_table, v_extra_group_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 
    

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisLoginStatisLocationGame') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordAgentLinecodeBST_updateDate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordAgentLinecodeBST_updateDate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_update_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeBST_updateDate') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.LineCode, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 
	SET v_update_sql = ' ON DUPLICATE KEY UPDATE StatisDate = VALUES(StatisDate), ChannelID = VALUES(ChannelID), LineCode = VALUES(LineCode), WinGold = VALUES(WinGold), LostGold = VALUES(LostGold), CellScore = VALUES(CellScore), Revenue = VALUES(Revenue), WinNum = VALUES(WinNum), LostNum = VALUES(LostNum), ActiveUsers = VALUES(ActiveUsers), currency =\'CNY\' , exchangeRate = 1 '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_linecode_BST'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_linecode_BST'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql, ' ', v_update_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeBST_updateDate') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordAgentLinecodeGameBST_updateDate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordAgentLinecodeGameBST_updateDate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_update_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeGameBST_updateDate') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.LineCode, old.GameID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 
	SET v_update_sql = ' ON DUPLICATE KEY UPDATE StatisDate = VALUES(StatisDate), ChannelID = VALUES(ChannelID), LineCode = VALUES(LineCode), GameID = VALUES(GameID), WinGold = VALUES(WinGold), LostGold = VALUES(LostGold), CellScore = VALUES(CellScore), Revenue = VALUES(Revenue), WinNum = VALUES(WinNum), LostNum = VALUES(LostNum), ActiveUsers = VALUES(ActiveUsers), currency =\'CNY\' , exchangeRate = 1 '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_linecode_game_BST'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_linecode_game_BST'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql, ' ', v_update_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeGameBST_updateDate') ON DUPLICATE KEY UPDATE `status`= 1; 

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
	WHILE v_month_counter < 2 DO
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisRecordAgentAllBST_updateDate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisRecordAgentAllBST_updateDate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_update_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentAllBST_updateDate') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 
	SET v_update_sql = ' ON DUPLICATE KEY UPDATE StatisDate = VALUES(StatisDate), ChannelID = VALUES(ChannelID), WinGold = VALUES(WinGold), LostGold = VALUES(LostGold), CellScore = VALUES(CellScore), Revenue = VALUES(Revenue), WinNum = VALUES(WinNum), LostNum = VALUES(LostNum), ActiveUsers = VALUES(ActiveUsers), currency =\'CNY\' , exchangeRate = 1 '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_all_BST'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_all_BST'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql, ' ', v_update_sql); 
	SET @v_sql = v_sql; 

  	BEGIN
  	  DECLARE CONTINUE HANDLER FOR 1505 BEGIN END; 
      ALTER TABLE KYStatis.statis_record_agent_all_BST REMOVE PARTITIONING; 
  	END; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentAllBST_updateDate') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisRecordAgentGameBST_updateDate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisRecordAgentGameBST_updateDate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_update_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentGameBST_updateDate') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.GameID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 
	SET v_update_sql = ' ON DUPLICATE KEY UPDATE StatisDate = VALUES(StatisDate), ChannelID = VALUES(ChannelID), GameID = VALUES(GameID), WinGold = VALUES(WinGold), LostGold = VALUES(LostGold), CellScore = VALUES(CellScore), Revenue = VALUES(Revenue), WinNum = VALUES(WinNum), LostNum = VALUES(LostNum), ActiveUsers = VALUES(ActiveUsers), currency =\'CNY\' , exchangeRate = 1 '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_game_BST'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_game_BST'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql, ' ', v_update_sql); 
	SET @v_sql = v_sql; 

  	BEGIN
  	  DECLARE CONTINUE HANDLER FOR 1505 BEGIN END; 
      ALTER TABLE KYStatis.statis_record_agent_game_BST REMOVE PARTITIONING; 
  	END; 

    PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentGameBST_updateDate') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisusers`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisusers`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_column_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisusers') ON DUPLICATE KEY UPDATE `status`= 0; 

	IF EXISTS (select * from information_schema.COLUMNS where TABLE_SCHEMA = 'Transfer' and TABLE_NAME = 'statisusers' and COLUMN_NAME = 'dayNewLogin') THEN
		SET v_column_sql = ' old.dayNewLogin'; 
	ELSE
		SET v_column_sql = ' 0 dayNewLogin'; 
	END IF; 

	SET v_base_sql = CONCAT('select old.StatisDate, old.ChannelId, old.Y_NonLoginUsers, old.M_NonLoginUsers, old.H_NonLoginUsers, old.Y_RegUsers, old.M_RegUsers, old.H_RegUsers, old.Y_PayUsers, old.M_PayUsers, old.H_PayUsers, old.NextRegisterUser, old.NextLoginUser, old.ValidNextRegisterUser, old.ValidNextLoginUser, old.SevenRegisterUser, old.SevenLoginUser, old.ValidSevenRegisterUser, old.ValidSevenLoginUser, old.MonthRegisterUser, old.MonthLoginUser, old.ValidMonthRegisterUser, old.ValidMonthLoginUser, old.DayNewBetUsers, ', v_column_sql,', 0 Y_NewLoginUsers from '); 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statisusers'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statisusers'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statisusers; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisusers') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersBSTAllGames_all`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersBSTAllGames_all`()
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
        WHERE table_schema = 'Transfer_KYStatisUsers_BST' AND table_name LIKE 'statis_allgames%_users'; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersBSTAllGames_all') ON DUPLICATE KEY UPDATE `status`= 0; 


	SET v_src_db = 'Transfer_KYStatisUsers_BST'; 
	SET v_dist_db = 'KYStatisUsers_BST'; 
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
		
		call KYStatisUsers_BST.sp_createStatisticsUsersTable(table_names, 0); 

		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', table_names,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', table_names, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
               
    END LOOP; 
    CLOSE cur; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersBSTAllGames_all') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersBSTByGame_all`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersBSTByGame_all`()
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
        WHERE table_schema = 'Transfer_KYStatisUsers_BST' AND table_name LIKE 'statis_%20%_users' AND  table_name NOT LIKE 'statis_all%_users' AND  table_name NOT LIKE 'statis_month%_users'; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersBSTByGame_all') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_src_db = 'Transfer_KYStatisUsers_BST'; 
	SET v_dist_db = 'KYStatisUsers_BST'; 

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
		
		call KYStatisUsers_BST.sp_createStatisticsUsersTable(table_names, 0); 

		SET v_sql = CONCAT('select old.StatisDate, old.Account, old.ChannelID, old.LineCode, 0 Allbet, SUM(old.CellScore) CellScore, SUM(old.WinGold) WinGold, SUM(old.LostGold) LostGold, SUM(old.Revenue) Revenue, SUM(old.WinNum) WinNum, SUM(old.LostNum) LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from ', v_src_db,'.', table_names,' old GROUP BY old.StatisDate, old.Account, old.LineCode'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', table_names, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
               
    END LOOP; 
    CLOSE cur; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersBSTByGame_all') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersDayrecordVvipUsers`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersDayrecordVvipUsers`()
BEGIN
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersDayrecordVvipUsers') ON DUPLICATE KEY UPDATE `status`= 0; 

	insert into KYStatisUsers.dayrecord_vvip_users
		select * from Transfer_KYStatisUsers.dayrecord_vvip_users; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersDayrecordVvipUsers') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersStatisVvipUsers`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersStatisVvipUsers`()
BEGIN
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersStatisVvipUsers') ON DUPLICATE KEY UPDATE `status`= 0; 

	insert into KYStatisUsers.statis_vvip_users 
		select * from Transfer_KYStatisUsers.statis_vvip_users; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersStatisVvipUsers') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftScoreRecordHyfdzpkGameScoreRecord`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftScoreRecordHyfdzpkGameScoreRecord`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftScoreRecordHyfdzpkGameScoreRecord') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select * from Transfer.hyfdzpk_gameRecord where AllBet <> 0 and CurScore = 0 '; 

	SET v_dist_db = 'score_record'; 
	SET v_dist_table = 'hyfdzpk_gameScoreRecord'; 

	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_base_sql); 
	SET @v_sql = v_sql; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftScoreRecordHyfdzpkGameScoreRecord') ON DUPLICATE KEY UPDATE `status`= 1; 

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
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP PROCEDURE IF EXISTS `updateStatisAgent`;
CREATE DEFINER=`root`@`%` PROCEDURE `updateStatisAgent`()
BEGIN

	DECLARE done BOOLEAN DEFAULT FALSE; 

	DECLARE agentId int(11) UNSIGNED; 

	DECLARE cur CURSOR FOR select agent from KYDB_NEW.agents; 

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

END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

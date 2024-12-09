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
DROP PROCEDURE IF EXISTS `batch_delete`;
CREATE DEFINER=`root`@`%` PROCEDURE `batch_delete`(IN exec_schema VARCHAR(50), IN exec_table VARCHAR(50), IN where_condition VARCHAR(200), IN batch_rows INT, OUT return_last_insert_id INT)
BEGIN
	DECLARE start_ts DOUBLE; 
    DECLARE last_execute_ts DOUBLE; 
    DECLARE current_ts DOUBLE; 
    DECLARE delta_secs DOUBLE; 
    DECLARE delete_rate DOUBLE; 
    # Affected Rows Set 1 To Start The Loop
    DECLARE affected_rows INT DEFAULT 1; 
    DECLARE total_affected_rows INT DEFAULT 0; 
    DECLARE total_delete_rate DOUBLE; 
    DECLARE last_insert_id INT; 
    -- DECLARE estimate_row_number INT; 
    
    SET start_ts = UNIX_TIMESTAMP(NOW(6)); 
    SET last_execute_ts = UNIX_TIMESTAMP(NOW(6)); 
    
    # Set Default Delete Chunk Size
    IF ISNULL(batch_rows) THEN
		SET batch_rows = 10000; 
	END IF; 
    
    -- SELECT TABLE_ROWS INTO estimate_row_number FROM information_schema.TABLES WHERE TABLE_SCHEMA = exec_schema AND TABLE_NAME = exec_table; 
    INSERT INTO batch_delete (`connection_id`, `exec_table`, `where_condition`, `chunk_number`, `created_at`) VALUES (CONNECTION_ID(), CONCAT(exec_schema, '.', exec_table), where_condition, batch_rows, CURRENT_TIMESTAMP()); 
    SET last_insert_id = LAST_INSERT_ID(); 
	SET @sqlstr = CONCAT('DELETE FROM ', exec_schema, '.', exec_table, ' WHERE 1 AND ', where_condition, ' LIMIT ', batch_rows); 
    DEL_LOOP: WHILE affected_rows > 0 DO
		PREPARE stmt FROM @sqlstr; 
		EXECUTE stmt; 
		SET affected_rows = ROW_COUNT(); 
        
        # If Attected Rows = 0 Then Exit The Loop, Cause Finial Delete Rate Doesn't Make Sense
        IF affected_rows = 0 THEN
			LEAVE DEL_LOOP; 
        END IF; 
        
        SET current_ts = UNIX_TIMESTAMP(NOW(6)); 
        SET delta_secs = current_ts - last_execute_ts; 
        IF delta_secs = 0 THEN
			SET delta_secs = 1; 
		END IF; 
		SET delete_rate = affected_rows / delta_secs; 
        SET total_affected_rows = total_affected_rows + affected_rows; 
		DEALLOCATE PREPARE stmt; 
        SET last_execute_ts = current_ts; 
        SET total_delete_rate = total_affected_rows / (last_execute_ts - start_ts); 
        UPDATE batch_delete SET updated_at = CURRENT_TIMESTAMP(), delete_rate = delete_rate, total_delete_rate = total_delete_rate, total_affected_rows = total_affected_rows WHERE id = last_insert_id; 
	END WHILE DEL_LOOP; 
    SET total_delete_rate = total_affected_rows / (last_execute_ts - start_ts); 
	UPDATE batch_delete SET updated_at = CURRENT_TIMESTAMP(), finished_at = CURRENT_TIMESTAMP(), total_delete_rate = total_delete_rate, total_affected_rows = total_affected_rows, duration_second = (last_execute_ts - start_ts) WHERE id = last_insert_id; 
    SET return_last_insert_id = last_insert_id; 
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
DROP PROCEDURE IF EXISTS `delete_process`;
CREATE DEFINER=`root`@`%` PROCEDURE `delete_process`()
FUNC_BODY:BEGIN
	DECLARE start_time DOUBLE; 
    DECLARE end_time DOUBLE; 
    DECLARE delta_time DOUBLE; 
    DECLARE cursor_done INT DEFAULT 0; 
    DECLARE r_sn INT; 
    DECLARE r_exec_database VARCHAR(64); 
    DECLARE r_exec_table VARCHAR(128); 
    DECLARE r_routine_type CHAR(1); 
    DECLARE r_delete_type VARCHAR(16); 
    DECLARE r_delete_key VARCHAR(64); 
    DECLARE r_time_interval INT; 
    DECLARE first_day_of_month INT DEFAULT 0; 
    DECLARE first_day_of_year INT DEFAULT 0; 
    DECLARE string_suffix VARCHAR(16); 
    DECLARE where_condition TEXT; 
    DECLARE enable_flag VARCHAR(64); 
    DECLARE emergency_stop_flag VARCHAR(64); 
    DECLARE schema_exists_flag INT DEFAULT 1; 
    DECLARE exception_flag INT DEFAULT 0; 
    DECLARE lastest_exec_cmd VARCHAR(256); 
    DECLARE mysql_err_msg TEXT; 
    DECLARE mysql_err_no INT; 
    DECLARE batch_delete_id INT; 
    DECLARE is_innodb_table INT DEFAULT 0; 
    DECLARE has_full_text_idx INT DEFAULT 0; 
    DECLARE optimize_innodb VARCHAR(8); 
    DECLARE optimize_innodb_flag INT DEFAULT 0; 
    DECLARE cursor1 CURSOR FOR SELECT `sn`, `exec_database`, `exec_table`, `routine_type`, `delete_type`, `time_interval`, `delete_key` FROM tool.routine_delete_table WHERE `is_enabled` = 1 ORDER BY `delete_type` DESC; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursor_done = 1; 
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
		GET DIAGNOSTICS CONDITION 1 mysql_err_no = MYSQL_ERRNO, mysql_err_msg = MESSAGE_TEXT; 
        SET exception_flag = 1; 
    END; 

    # check config enable flag
    SELECT config_value INTO enable_flag FROM tool.delete_process_config WHERE config_key = 'enable'; 
    IF enable_flag = 0 OR LOWER(enable_flag) = 'off' THEN
		LEAVE FUNC_BODY; 
    END IF; 
    
    # check config optimize innodb flag
    SELECT config_value INTO optimize_innodb FROM tool.delete_process_config WHERE config_key = 'optimize_innodb'; 
    
    # update all lastest_ prefix column for initail purpose
    UPDATE tool.routine_delete_table SET lastest_start_at = null, lastest_finish_at = null, lastest_duration_second = null, lastest_err_msg = null, lastest_exec_cmd = null WHERE 1; 
    # update emergency stop flag for initail purpose
    UPDATE tool.delete_process_config SET config_value = '0' WHERE config_key = 'emergency_stop'; 
    
    # detect attributes of today
    IF DAY(NOW()) = 1 THEN
		 SET first_day_of_month = 1; 
    END IF; 
	IF DAYOFYEAR(NOW()) = 1 THEN
		SET first_day_of_year = 1; 
    END IF; 
    
    #decide optimize innodb flag
    IF first_day_of_month = 1 AND LOWER(optimize_innodb) = 'month' THEN
		SET optimize_innodb_flag = 1; 
	ELSEIF first_day_of_year = 1 AND LOWER(optimize_innodb) = 'year' THEN
		SET optimize_innodb_flag = 1; 
	ELSEIF LOWER(optimize_innodb) = 'day' THEN
		SET optimize_innodb_flag = 1; 
	ELSE 
		SET optimize_innodb_flag = 0; 
	END IF; 
    
    # start delete process
    OPEN cursor1; 
    PROCESS_LOOP: LOOP
		SET start_time = UNIX_TIMESTAMP(NOW(6)); 
        SET schema_exists_flag = 0; 
        SET exception_flag = 0; 
        SET is_innodb_table = 0; 
        SET has_full_text_idx = 0; 
        SET batch_delete_id = null; 
		FETCH cursor1 INTO r_sn, r_exec_database, r_exec_table, r_routine_type, r_delete_type, r_time_interval, r_delete_key; 
        
        IF cursor_done = 1 THEN
			LEAVE PROCESS_LOOP; 
		END IF; 
        
		# check emergency stop flag
		SELECT config_value INTO emergency_stop_flag FROM tool.delete_process_config WHERE config_key = 'emergency_stop'; 
        IF LOWER(emergency_stop_flag) = 1 OR LOWER(emergency_stop_flag) = 'on' THEN
			UPDATE tool.routine_delete_table SET lastest_err_msg = 'stop by emergency stop flag' WHERE sn = r_sn; 
			ITERATE PROCESS_LOOP; 
        END IF; 
        
        # check the process execute time correctly
        IF LOWER(r_routine_type) = 'm' AND first_day_of_month != 1 THEN
			UPDATE tool.routine_delete_table SET lastest_err_msg = 'skip every month process, because isn\'t first day of month' WHERE sn = r_sn; 
			ITERATE PROCESS_LOOP; 
        END IF; 
        IF LOWER(r_routine_type) = 'y' AND first_day_of_year != 1 THEN
			UPDATE tool.routine_delete_table SET lastest_err_msg = 'skip every year process, because isn\'t first day of year' WHERE sn = r_sn; 
			ITERATE PROCESS_LOOP; 
        END IF; 
        
        # prepare suffix string for drop table or drop partition, prepare where_condition for delete_record
        IF LOWER(r_routine_type) = 'd' THEN
			SET string_suffix = DATE_FORMAT(DATE_SUB(DATE(NOW()), INTERVAL r_time_interval DAY), '%Y%m%d'); 
            SET where_condition = CONCAT(r_delete_key, ' < \'', DATE_FORMAT(DATE_SUB(DATE(NOW()), INTERVAL r_time_interval DAY), '%Y-%m-%d 00:00:00'), '\''); 
		ELSEIF LOWER(r_routine_type) = 'm' THEN
			SET string_suffix = DATE_FORMAT(DATE_SUB(DATE(NOW()), INTERVAL r_time_interval MONTH), '%Y%m'); 
			SET where_condition = CONCAT(r_delete_key, ' < \'', DATE_FORMAT(DATE_SUB(DATE(NOW()), INTERVAL r_time_interval MONTH), '%Y-%m-%d 00:00:00'), '\''); 
		ELSEIF LOWER(r_routine_type) = 'y' THEN
			SET string_suffix = DATE_FORMAT(DATE_SUB(DATE(NOW()), INTERVAL r_time_interval YEAR), '%Y'); 
            SET where_condition = CONCAT(r_delete_key, ' < \'', DATE_FORMAT(DATE_SUB(DATE(NOW()), INTERVAL r_time_interval YEAR), '%Y-%m-%d 00:00:00'), '\''); 
		ELSE
			# routine_type not in (y,m,d)
            SET string_suffix = ''; 
            SET where_condition = ''; 
			UPDATE tool.routine_delete_table SET lastest_err_msg = 'routine_type invalid' WHERE sn = r_sn; 
            ITERATE PROCESS_LOOP; 
		END IF; 
        
        # begin delete
        IF LOWER(r_delete_type) = 'drop_partition' THEN
			# check partition exists
            SELECT count(*) INTO schema_exists_flag FROM information_schema.PARTITIONS WHERE TABLE_SCHEMA = r_exec_database AND TABLE_NAME = r_exec_table AND PARTITION_NAME = CONCAT(r_delete_key, string_suffix); 
            IF schema_exists_flag = 0 THEN
				UPDATE tool.routine_delete_table SET lastest_err_msg = CONCAT('partition ', r_delete_key, string_suffix, ' doesn\'t exists') WHERE sn = r_sn; 
				ITERATE PROCESS_LOOP; 
            END IF; 
            
            # delete
			SET @sql_str = CONCAT('ALTER TABLE ', r_exec_database, '.', r_exec_table , ' DROP PARTITION ', r_delete_key, string_suffix); 
            SET lastest_exec_cmd = @sql_str; 
            PREPARE stmt FROM @sql_str; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
            
            SELECT mysql_err_no, mysql_err_msg, exception_flag; 
		ELSEIF  LOWER(r_delete_type) = 'drop_table' THEN
			# check table exists
            SELECT count(*) INTO schema_exists_flag FROM information_schema.TABLES WHERE TABLE_SCHEMA = r_exec_database AND TABLE_NAME = CONCAT(r_exec_table, string_suffix) AND TABLE_TYPE='BASE TABLE'; 
            IF schema_exists_flag = 0 THEN
				UPDATE tool.routine_delete_table SET lastest_err_msg = CONCAT('table ', r_exec_table, string_suffix, ' doesn\'t exists') WHERE sn = r_sn; 
				ITERATE PROCESS_LOOP; 
            END IF; 
        
			# delete
			SET @sql_str = CONCAT('DROP TABLE ', r_exec_database, '.', r_exec_table, string_suffix, ';'); 
            SET lastest_exec_cmd = @sql_str; 
            PREPARE stmt FROM @sql_str; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 
        ELSEIF LOWER(r_delete_type) = 'delete_record' THEN
			#check table column exists
			SELECT COUNT(*) INTO schema_exists_flag FROM information_schema.COLUMNS WHERE TABLE_SCHEMA = r_exec_database AND TABLE_NAME = r_exec_table AND COLUMN_NAME = r_delete_key; 
            IF schema_exists_flag = 0 THEN
				IF r_delete_key IS NULL THEN
					SET r_delete_key = 'null'; 
                END IF; 
				UPDATE tool.routine_delete_table SET lastest_err_msg = CONCAT('column ', r_delete_key, ' doesn\'t exists') WHERE sn = r_sn; 
				ITERATE PROCESS_LOOP; 
            END IF; 
            
            #delete
            SET lastest_exec_cmd = CONCAT('DELETE FROM ', r_exec_database, '.', r_exec_table, ' WHERE ', where_condition); 
			CALL tool.batch_delete(r_exec_database, r_exec_table, where_condition, null, batch_delete_id); 
            
            # can use online DDL to optimize table?
            IF optimize_innodb_flag = 1 THEN
				SELECT COUNT(*) INTO is_innodb_table FROM information_schema.TABLES WHERE TABLE_SCHEMA = r_exec_database AND TABLE_NAME = r_exec_table AND ENGINE='InnoDB'; 
				IF is_innodb_table = 1 THEN
					SELECT COUNT(*) INTO has_full_text_idx FROM information_schema.INNODB_SYS_TABLES a JOIN information_schema.INNODB_SYS_INDEXES b ON a.TABLE_ID = b.TABLE_ID WHERE a.NAME=CONCAT(r_exec_database, '/', r_exec_table) AND b.TYPE=32; 
					IF has_full_text_idx != 1 THEN
						SET lastest_exec_cmd = CONCAT(lastest_exec_cmd, ' ( WITH OPTIMIZE TABLE )'); 
						SET @sql_str = CONCAT('OPTIMIZE NO_WRITE_TO_BINLOG TABLE ', r_exec_database, '.', r_exec_table, ';'); 
						PREPARE stmt FROM @sql_str; 
						EXECUTE stmt; 
						DEALLOCATE PREPARE stmt; 
					END IF; 
				END IF; 
			END IF; 
		ELSE
			UPDATE tool.routine_delete_table SET lastest_err_msg = 'delete_type invalid' WHERE sn = r_sn; 
            ITERATE PROCESS_LOOP; 
        END IF; 
        
        # exception handler catch
        IF exception_flag = 1 THEN
			UPDATE tool.routine_delete_table SET lastest_err_msg = CONCAT(mysql_err_no, ' - ', mysql_err_msg), lastest_exec_cmd = lastest_exec_cmd WHERE sn = r_sn; 
            ITERATE PROCESS_LOOP; 
        END IF; 
        
        SET end_time = UNIX_TIMESTAMP(NOW(6)); 
		SET delta_time = end_time - start_time; 
        
        # update columns that have lastest_ prefix
		UPDATE tool.routine_delete_table SET lastest_start_at = FROM_UNIXTIME(start_time, '%Y-%m-%d %H:%i:%s'), lastest_finish_at = FROM_UNIXTIME(end_time, '%Y-%m-%d %H:%i:%s'), lastest_duration_second = delta_time, lastest_exec_cmd = lastest_exec_cmd, batch_delete_id = batch_delete_id WHERE sn = r_sn; 
    
	END LOOP PROCESS_LOOP; 
    CLOSE cursor1; 
    SELECT 'Finish'; 
END FUNC_BODY;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP PROCEDURE IF EXISTS `reset_events`;
CREATE DEFINER=`root`@`%` PROCEDURE `reset_events`()
BEGIN
	DECLARE r_db_name VARCHAR(64); 
    DECLARE r_event_name VARCHAR(64); 
    DECLARE result_str LONGTEXT DEFAULT ''; 
	DECLARE cursor_done INT DEFAULT 0; 
	DECLARE cur1 CURSOR FOR SELECT EVENT_SCHEMA, EVENT_NAME FROM information_schema.EVENTS; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET cursor_done = 1; 
    
    OPEN cur1; 
    PROCESS_LOOP: LOOP
		FETCH cur1 INTO r_db_name, r_event_name; 
        IF cursor_done = 1 THEN
			LEAVE PROCESS_LOOP; 
        END IF; 
        SET result_str = CONCAT(result_str, 'ALTER EVENT `', r_db_name, '`.`', r_event_name, '` COMMENT \'\';', "\n"); 
    END LOOP PROCESS_LOOP; 
    SELECT result_str; 
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
DROP EVENT IF EXISTS `auto_delete_process`;
CREATE DEFINER=`root`@`%` EVENT `auto_delete_process` ON SCHEDULE EVERY 1 DAY STARTS '2023-04-25 04:00:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL tool.delete_process();
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

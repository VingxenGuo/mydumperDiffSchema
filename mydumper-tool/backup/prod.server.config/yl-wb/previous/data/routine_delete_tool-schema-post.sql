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
DROP PROCEDURE IF EXISTS `detect_routine_record_got_index_partition`;
CREATE DEFINER=`root`@`%` PROCEDURE `detect_routine_record_got_index_partition`()
funcbody:begin
	declare done int default 0; 
    declare detect_database varchar(128); 
    declare detect_table varchar(128); 
    declare detect_delete_type varchar(32); 
    declare detect_delete_key varchar(32); 
    declare detect_sn int; 
    declare index_flag int(1); 
    declare partition_flag varchar(4); 
	declare partition_count int; 
    declare partiname varchar(64); 
	# detect if delete type is 'delete_record' or 'drop pratition, if so then detect whether it has index and partition, both results return to a table named `DetectIndexPartition`
	declare NeededDetectTableCursor cursor for select `exec_database`, `exec_table`, `delete_type`, `delete_key`, `sn` from `routine_delete_tool`.`DetectIndexPartition`; 
	declare continue handler for not found set done=1; 
    
	set sql_safe_updates = 0; 
    # initialize use_index and use_partition value as null
    truncate routine_delete_tool.`DetectIndexPartition`; 
    insert routine_delete_tool.`DetectIndexPartition` (`exec_database`, `exec_table`, `delete_type`, `delete_key`) select `exec_database`, `exec_table`, `delete_type`, `delete_key` from `tool`.`routine_delete_table` where `delete_type` in ('drop_partition', 'delete_record'); 
    update routine_delete_tool.DetectIndexPartition set use_index=null, use_partition=null; 
	
	open NeededDetectTableCursor; 
	detect_loop: loop
		fetch NeededDetectTableCursor into detect_database, detect_table, detect_delete_type, detect_delete_key, detect_sn; 

		if done = 1 then
			leave detect_loop; 
		end if; 

		SELECT SUM(CASE WHEN partition_name IS NOT NULL THEN 1 ELSE 0 END) 
            INTO partition_count
            FROM information_schema.partitions
            WHERE table_schema = detect_database AND table_name = detect_table; 
		
        IF partition_count > 0 THEN
            SET partition_flag = 1; 
        ELSE
            SET partition_flag = 0; 
        END IF; 
-- 		select (SELECT SUM(CASE WHEN partition_name IS NOT NULL THEN 1 ELSE 0 END) 
--             FROM information_schema.partitions
--             WHERE table_schema = detect_database AND table_name = detect_table) partitiion_num, detect_database, detect_table, partition_count, partition_flag, done ; 

		IF detect_delete_type = 'delete_record' THEN
			SELECT COUNT(*)
			INTO index_flag
			FROM information_schema.statistics
			WHERE table_schema = detect_database
				AND table_name = detect_table
				AND column_name = detect_delete_key
				AND SEQ_IN_INDEX = 1; 

			IF index_flag = 0 THEN
				UPDATE `DetectIndexPartition`
				SET `use_index` = 'N'
				WHERE `sn` = detect_sn; 
			ELSE
				UPDATE `DetectIndexPartition`
				SET `use_index` = 'Y'
				WHERE `sn` = detect_sn; 
			END IF; 

			IF partition_flag = 0 THEN
				UPDATE `DetectIndexPartition`
				SET `use_partition` = 'N'
				WHERE `sn` = detect_sn; 
			ELSE
				select partition_name into partiname from information_schema.partitions where table_schema = detect_database and table_name = detect_table limit 1 ; 
                update `DetectIndexPartition`
                set `partition_name` = partiname, `use_partition` = 'Y'
                WHERE `sn` = detect_sn; 

			END IF; 

		ELSEIF detect_delete_type = 'drop_partition' THEN
			IF partition_flag = 0 THEN
				UPDATE `DetectIndexPartition`
				SET `use_partition` = 'N'
				WHERE `sn` = detect_sn; 
			ELSE
                select partition_name into partiname from information_schema.partitions where table_schema = detect_database and table_name = detect_table limit 1 ; 
                update `DetectIndexPartition`
                set `partition_name` = partiname, `use_partition` = 'Y'
                WHERE `sn` = detect_sn; 
			END IF; 
		END IF; 
	end loop detect_loop; 
	close NeededDetectTableCursor; 
	set sql_safe_updates = 1; 
end funcbody;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP PROCEDURE IF EXISTS `fetch_delete_table`;
CREATE DEFINER=`root`@`%` PROCEDURE `fetch_delete_table`()
funcbody: begin
	DECLARE done INT DEFAULT 0; 
	declare routine_type char(1); 
    declare time_interval int(2); 
	declare r_exec_database varchar(64); 
    declare r_exec_table varchar(64); 
    declare db_exist_routine_type_flag int(1); 
	# 抓取game_record schema中名稱前綴為gamerecord_的 table以及DB NAME 後綴為 _record 且不是 game_record 的 DB，裏面表名後綴為日期 (YYYYMMDD)後插入routine_delete_table中
    declare cursor_for_not_game_record cursor for select table_schema, table_name from information_schema.tables where TABLE_SCHEMA regexp '.+record' and table_schema != 'game_record'; 
	declare cursor_for_game_record cursor for select table_schema, table_name from information_schema.tables where table_schema = 'game_record' and table_name regexp 'gamerecord_.*' and table_name not like '%_old2' and table_name not like '%_copy1'; 
    declare continue handler for not found set done = 1; 

	open cursor_for_not_game_record; 
    for_not_game_record_loop: loop
		FETCH cursor_for_not_game_record INTO r_exec_database, r_exec_table; 
		
		IF done = 1 THEN
			LEAVE for_not_game_record_loop; 
		END IF; 
        
        
        
		# 判斷table時間格式，若有8碼將routine_type設為d；若有6碼設m；若為4碼設為y; 
        
        
        if r_exec_table regexp '[a-z]+[0-9]{8}$' then 
			set routine_type = 'd'; 
            set time_interval = 100; 
            set r_exec_table = substring(r_exec_table, 1, length(r_exec_table)-8); 
            # 判斷該database的時間格式，是否已存在於routine_delete_table
			select count(*) into db_exist_routine_type_flag from tool.routine_delete_table where exec_database = r_exec_database and routine_type = 'd'; 
            if db_exist_routine_type_flag = 0 then
				# insert data into depand on routine_type
				INSERT INTO `tool`.`routine_delete_table` ( `exec_database`, `exec_table`, `routine_type`, `delete_type`, `time_interval`, `is_enabled`) values (r_exec_database, r_exec_table, routine_type, 'drop_table', time_interval, 1); 
				iterate for_not_game_record_loop; 
            end if; 
		elseif r_exec_table regexp '[a-z]+[0-9]{6}$' then
			set routine_type = 'm'; 
            set time_interval = 3; 
            set r_exec_table = substring(r_exec_table, 1, length(r_exec_table)-8); 
            # 判斷該database的時間格式，是否已存在於routine_delete_table
			SELECT COUNT(*) INTO db_exist_routine_type_flag FROM tool.routine_delete_table where exec_database = r_exec_database and routine_type = 'm'; 
			if db_exist_routine_type_flag = 0 then
				# insert data into depand on routine_type
				INSERT INTO `tool`.`routine_delete_table` ( `exec_database`, `exec_table`, `routine_type`, `delete_type`, `time_interval`, `is_enabled`) values (r_exec_database, r_exec_table, 				routine_type, 'drop_table', time_interval, 1); 
				iterate for_not_game_record_loop; 
            end if; 
		elseif r_exec_table regexp '[a-z]+[0-9]{4}$' then
			set routine_type = 'y'; 
            set time_interval = 1; 
            set r_exec_table = substring(r_exec_table, 1, length(r_exec_table)-8); 
            # 判斷該database的時間格式，是否已存在於routine_delete_table
			select count(*) into db_exist_routine_type_flag from tool.routine_delete_table where exec_database = r_exec_database and routine_type = 'y'; 
            if db_exist_routine_type_flag = 0 then
				# insert data into depand on routine_type
				INSERT INTO `tool`.`routine_delete_table` ( `exec_database`, `exec_table`, `routine_type`, `delete_type`,  `time_interval`, `is_enabled`) values (r_exec_database, r_exec_table, routine_type, 'drop_table', time_interval, 1); 
				iterate for_not_game_record_loop; 
            end if; 
		elseif r_exec_table like '%gameRecord' then
			insert into `tool`.`routine_delete_table` (`exec_database`, `exec_table`, `routine_type`, `delete_type`, `time_interval`, `delete_key`, `is_enabled`) values (r_exec_database, r_exec_table, 'd', 'delete_record', 100, 'GameEndTime', 1); 
			iterate for_not_game_record_loop; 
        else 
			select concat(r_exec_database, '.', r_exec_table ,' have some format issue with it, please check it twice.') as 'warning'; 
		end if; 

        
    end loop for_not_game_record_loop; 
	close cursor_for_not_game_record; 

	set done = 0; 
	open cursor_for_game_record; 
    for_game_record_loop: loop
    fetch cursor_for_game_record into r_exec_database, r_exec_table; 
	IF done = 1 THEN
		LEAVE for_game_record_loop; 
	END IF; 
	INSERT INTO `tool`.`routine_delete_table` ( `exec_database`, `exec_table`, `routine_type`, `delete_type`,  `time_interval`, `delete_key`, `is_enabled`) values (r_exec_database, r_exec_table, 'd', 'delete_record', 100,  'createtime', 1); 
    # 抓取game_record 中名稱前綴為gamerecord_的table
    end loop for_game_record_loop; 
    close cursor_for_game_record; 
end funcbody;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_general_ci;
DROP PROCEDURE IF EXISTS `revise_partition`;
CREATE DEFINER=`root`@`%` PROCEDURE `revise_partition`()
BEGIN
    DECLARE done INT(1); 
    DECLARE delete_key VARCHAR(32); 
    DECLARE cur_exec_database VARCHAR(128); 
    DECLARE cur_exec_table VARCHAR(128); 
    DECLARE cur_partition_name VARCHAR(128); 
    DECLARE cur_delete_type VARCHAR(128); 

    DECLARE cursor1 CURSOR FOR 
        SELECT `exec_database`, `exec_table`, `partition_name` 
        FROM `DetectIndexPartition` 
        WHERE `delete_type` = 'delete_record' AND `use_partition` = 'Y'; 

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
    
    SET SQL_SAFE_UPDATES = 0; 
    
    OPEN cursor1; 

    cursorloop: LOOP
        FETCH cursor1 INTO cur_exec_database, cur_exec_table, cur_partition_name; 
        IF done = 1 THEN
            LEAVE cursorloop; 
        END IF; 
        # detect partition date format return routine_type and update routine_delete_table
        # set delete_key format according to partition type, it only can match delete_key format like '%_' prefix
        IF cur_partition_name REGEXP '^[a-zA-Z]+_[0-9]{8}$' THEN
            SET delete_key = SUBSTRING(cur_partition_name, 1, LENGTH(cur_partition_name) - 8); 
            UPDATE tool.routine_delete_table 
            SET `routine_type` = 'd', `delete_type` = 'drop_partition', `time_interval` = 100, `delete_key` = delete_key 
            WHERE `exec_database` = cur_exec_database AND `exec_table` = cur_exec_table; 
        ELSEIF cur_partition_name REGEXP '^[a-zA-Z]+_[0-9]{6}$' THEN
            SET delete_key = SUBSTRING(cur_partition_name, 1, LENGTH(cur_partition_name) - 6); 
            UPDATE tool.routine_delete_table 
            SET `routine_type` = 'm', `delete_type` = 'drop_partition', `time_interval` = 3, `delete_key` = delete_key  
            WHERE `exec_database` = cur_exec_database AND `exec_table` = cur_exec_table; 
        ELSEIF cur_partition_name REGEXP '^[a-zA-Z]+_[0-9]{4}$' THEN
            SET delete_key = SUBSTRING(cur_partition_name, 1, LENGTH(cur_partition_name) - 4); 
            UPDATE tool.routine_delete_table 
            SET `routine_type` = 'y', `delete_type` = 'drop_partition', `time_interval` = 1, `delete_key` = delete_key 
            WHERE `exec_database` = cur_exec_database AND `exec_table` = cur_exec_table; 
        END IF; 
    END LOOP cursorloop; 
	
    CLOSE cursor1; 
    SET SQL_SAFE_UPDATES = 1; 
END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

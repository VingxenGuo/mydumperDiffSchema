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
DROP PROCEDURE IF EXISTS `sp_compareAndExportGamePlaysAndGameNo`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_compareAndExportGamePlaysAndGameNo`(IN vendor_id INT, IN vendor_name varchar(100), query_date DATE, IN vendor_totalPlays INT)
BEGIN
    -- 取得廠商下的所有遊戲
    -- 依序取得每款遊戲某日的局數總計、

    DECLARE game_id INT; 
    DECLARE game_name varchar(50); 
    DECLARE vendor_gameId varchar(100); 
    DECLARE ours_totalPlays INT; 
    DECLARE compareResult varchar(50); 
    DECLARE done INT DEFAULT FALSE; 
    DECLARE game_cursor CURSOR FOR SELECT GameID, GameParameter, companyGameId FROM KYDB_NEW.companyGameInfo  WHERE companyid = vendor_id; 
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 


    -- Create a temporary table to store game statistics
    DROP TEMPORARY TABLE IF EXISTS temp_game_statistics; 
    CREATE TEMPORARY TABLE temp_game_statistics (
            game_id INT,
            game_name varchar(50),
            vendor_gameId varchar(100),
            total_plays INT,
            gameNoList longtext
        ); 

    -- enlarge group_concat max length as long as longtext
    SET SESSION group_concat_max_len = 4294967295; 

    OPEN game_cursor; 
        game_loop: LOOP
            FETCH game_cursor INTO game_id, game_name, vendor_gameId ; 
            IF done THEN
                LEAVE game_loop; 
            END IF; 

            SET @selectQuery = CONCAT("SELECT COUNT(*) ,GROUP_CONCAT(GameUserNO) INTO @total_plays, @gameNoList 
            FROM detail_record.",game_name,  "_gameRecord WHERE GameID = ",game_id, " AND GameStartTime >= '", query_date," 00:00:00' AND GameEndTime <= '", query_date," 23:59:59';");   
            -- Calculate total plays for the game on the specified date

            PREPARE selectStatement FROM @selectQuery; 
            EXECUTE selectStatement; 
            DEALLOCATE PREPARE selectStatement; 

            -- Insert the results into the temporary table
            INSERT INTO temp_game_statistics (game_id, game_name, vendor_gameId, total_plays, gameNoList) VALUES (game_id, game_name, vendor_gameId, @total_plays, @gameNoList); 
        END LOOP; 
    CLOSE game_cursor; 

    -- Add into ours_totalPlays
    SELECT SUM(total_plays) INTO ours_totalPlays FROM temp_game_statistics; 

    -- If same count, insert into vendor_dailyCheckRecord
    IF ours_totalPlays = vendor_totalPlays THEN    
        SET compareResult = 'SUCCESS'; 
        SET @compareResultStatus = 1; 

        -- drop the timeChecklist of examing date
        SET @deleteQuery = CONCAT("DROP TABLE IF EXISTS ", vendor_name,  "_timeChecklist", DATE_FORMAT(query_date, '%Y%m%d'));   

		PREPARE deleteStatement FROM @deleteQuery; 
		EXECUTE deleteStatement; 
		DEALLOCATE PREPARE deleteStatement; 

	ELSE 
		SET compareResult = 'FAIL'; 
        SET @compareResultStatus = 0; 

	END IF; 
    
	-- insert compare result into dailyCheckRecord : status :   SUCCESS = 1, FAIL=0
    SET @insertQuery = CONCAT("INSERT INTO ", vendor_name,  "_dailyCheckRecord (vendor_id, date, status, create_time) VALUE ( ",vendor_id, " , '", query_date,  "',", @compareResultStatus,  ",'", NOW(), "' )", " ON DUPLICATE KEY UPDATE status = ", @compareResultStatus, ", update_time = NOW(); ");   
    
	PREPARE insertStatement FROM @insertQuery; 
	EXECUTE insertStatement; 
	DEALLOCATE PREPARE insertStatement; 
    
    -- Select compare result 
    SELECT compareResult; 
    -- Select the results from the temporary table
    SELECT * FROM temp_game_statistics; 

    -- Clean up temporary table
    DROP TEMPORARY TABLE temp_game_statistics; 
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
DROP PROCEDURE IF EXISTS `sp_createTimeChecklistIfNotExistAndExportUnfinishedRows`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_createTimeChecklistIfNotExistAndExportUnfinishedRows`(vendor varchar(50),date DATETIME ,duration INT)
BEGIN

	DECLARE tableName  varchar(50); 
	DECLARE start_time TIMESTAMP; 
	DECLARE end_time TIMESTAMP; 
	DECLARE stop_time TIMESTAMP; 

	SET tableName = CONCAT(vendor,'_timeChecklist',   DATE_FORMAT(date, '%Y%m%d') ); 

	-- 检查表格是否存在
	SET @check = CONCAT("SELECT COUNT(*) INTO @table_exists FROM information_schema.tables WHERE table_name = '", tableName,"';"); 

	PREPARE checkStatement FROM @check; 
	EXECUTE checkStatement; 
	DEALLOCATE PREPARE checkStatement; 

	-- 如果表格不存在，创建它并插入默认数据
	IF @table_exists = 0 THEN
		SET @createQuery = CONCAT("CREATE TABLE IF NOT EXISTS ", tableName, " (
		id INT AUTO_INCREMENT PRIMARY KEY,
		start_time DATETIME COMMENT '拉單開始時間',
		end_time DATETIME COMMENT '拉單結束時間 也是執行拉單的時間',
		done INT COMMENT '1:完成',
		create_time DATETIME COMMENT '完成時間',
		update_time DATETIME COMMENT '重跑時間',
		UNIQUE INDEX `end_time_UNIQUE` (`end_time` ASC)
		)ENGINE=InnoDB DEFAULT CHARSET=utf8mb4"); 

		PREPARE createStatement FROM @createQuery; 
		EXECUTE createStatement; 
		DEALLOCATE PREPARE createStatement; 

		-- 设置开始时间和结束时间
		SET end_time = DATE_ADD(date, INTERVAL 2 MINUTE); 
		SET start_time = DATE_ADD(end_time, INTERVAL -3 MINUTE); 
		SET stop_time = DATE_ADD(date, INTERVAL 1 DAY); 

		-- 使用循环生成时间并插入表格
		WHILE end_time <= stop_time DO
			SET @insertQuery = CONCAT('INSERT INTO ', tableName, " (start_time,end_time) VALUES ('", start_time ,"' , '" , end_time,"')"); 
		
			PREPARE insertStatement FROM @insertQuery; 
			EXECUTE insertStatement; 
			DEALLOCATE PREPARE insertStatement; 
		
			-- 增加2分钟以生成下一个时间戳
			SET end_time = DATE_ADD(end_time, INTERVAL 2 MINUTE); 
			SET start_time = DATE_ADD(start_time, INTERVAL 2 MINUTE); 
		END WHILE; 
	END IF; 

	-- 获取所有未完成的记录
  	SET @selectQuery = CONCAT("SELECT * FROM ", tableName, " WHERE done is null ORDER BY id ASC"); 

	PREPARE selectStatement FROM @selectQuery; 
	EXECUTE selectStatement; 
	DEALLOCATE PREPARE selectStatement; 

END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

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

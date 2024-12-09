/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
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

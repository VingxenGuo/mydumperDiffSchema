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

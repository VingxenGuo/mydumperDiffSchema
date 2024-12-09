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
DROP PROCEDURE IF EXISTS `updateAgentWallet`;
CREATE DEFINER=`root`@`%` PROCEDURE `updateAgentWallet`(IN `in_channelId` bigint(20), IN `in_money` bigint(20), IN `in_action` tinyint(1), IN `in_type` tinyint(3), IN `in_orderId` varchar(190), IN `in_memo` LONGTEXT)
BEGIN
	DECLARE balance bigint(20); 
	DECLARE updateMoney bigint(20); 
	DECLARE errCode smallint(4) DEFAULT 0; 
	DECLARE msg varchar(100); 

	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN #发生异常回滚
		GET CURRENT DIAGNOSTICS CONDITION 1 errCode = MYSQL_ERRNO, msg = MESSAGE_TEXT; 
		SELECT errCode, msg; 
		ROLLBACK; 
		SET errCode = 1000; 
		SELECT errCode; 
	END; 

	SELECT money into balance FROM `agents` WHERE `channelId` = in_channelId; 

	IF balance is null THEN  #代理不存在
		SET errCode = 91; 
	ELSEIF in_action = 0 and balance < in_money THEN #钱包金额不足
		SET errCode = 89; 
	ELSE
		IF in_action = 0 THEN #0钱包下分/3钱包上分回滾
			SET updateMoney = balance - in_money; 
			
			UPDATE `agents` SET money = money - in_money, updateDate = now() 
				WHERE `channelId` = in_channelId 
					AND `money` >= in_money; 
		ELSEIF in_action = 1 THEN #1钱包上分/2钱包下分回滾
			SET updateMoney = balance + in_money; 
			
			UPDATE `agents` SET money = money + in_money, updateDate = now() 
				WHERE `channelId` = in_channelId; 
		END IF; 

		#建立订单
		INSERT INTO `agents_history` (`orderId`, `channelId`, `originMoney`, `money`, `action`, `type`, `memo`, `createDate`) VALUES (in_orderId, in_channelId, balance, in_money, in_action, in_type, in_memo, now()); 
	END IF; 

	#回传状态
	SELECT errCode as errCode,updateMoney as money, LAST_INSERT_ID() as id; 
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
DROP PROCEDURE IF EXISTS `updatePlayerWallet`;
CREATE DEFINER=`root`@`%` PROCEDURE `updatePlayerWallet`(IN `in_name` varchar(190), IN `in_money` bigint(20),IN `in_action` tinyint(1), IN `in_type` tinyint(3), IN `in_currency` varchar(20), IN `in_orderId` varchar(190), IN `in_obj` json)
BEGIN

    DECLARE balance bigint(20); 

    DECLARE updateMoney bigint(20); 

    DECLARE errCode smallint(4) DEFAULT 0; 

	DECLARE msg varchar(100); 
    
    DECLARE gameUserNo_from_obj  varchar(50) DEFAULT NULL; 
    
    DECLARE memo_from_obj  longtext DEFAULT NULL; 



	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN #发生异常回滚

        GET CURRENT DIAGNOSTICS CONDITION 1 errCode = MYSQL_ERRNO, msg = MESSAGE_TEXT; 

		SELECT errCode, msg; 

        ROLLBACK; 

        SET errCode = 1000; 

        SELECT errCode; 
        SELECT  msg; 

    END; 


	START TRANSACTION; 



	SELECT money into balance FROM `players` WHERE `name` = in_name AND `currency` = in_currency LIMIT 1 FOR UPDATE; 



	IF in_obj IS NOT NULL THEN 
    
		SET gameUserNo_from_obj = NULLIF(JSON_UNQUOTE(JSON_EXTRACT(in_obj, '$.gameUserNo')),'null'); 
        
        SET memo_from_obj = NULLIF(JSON_UNQUOTE(JSON_EXTRACT(in_obj, '$.memo')),'null'); 
        
    END IF; 



    IF balance is null THEN 

        IF in_action = 0 THEN  #钱包不存在且上分的话就创建钱包

            INSERT INTO `players` (`name`, `currency`, `money`, `updateDate`) VALUES (in_name, in_currency, in_money, now()); 

            SET updateMoney = in_money; 

            -- 建立订单

            INSERT INTO `players_history` (`orderId`, `name`, `originMoney`, `money`, `currency`, `action`, `type`, `gameUserNo`, `memo`, `createDate`) VALUES (in_orderId, in_name, 0, in_money, in_currency, in_action, in_type, gameUserNo_from_obj , memo_from_obj , now()); 

        ELSE 

           SET errCode = 1001;  #钱包不存在

        END IF; 

	ELSEIF in_action = 1 and balance < in_money THEN #钱包金额不足

        SET errCode = 1002; 

    ELSE

        IF in_action = 1 THEN #钱包下分

            SET updateMoney = balance - in_money; 

        ELSEIF in_action = 0 THEN #钱包上分

            SET updateMoney = balance + in_money; 

        END IF; 



        #更新钱包

        UPDATE `players` SET money = updateMoney,updateDate=now() WHERE `name`= in_name AND `currency` = in_currency; 



        #建立订单

        INSERT INTO `players_history` (`orderId`, `name`, `originMoney`, `money`, `currency`, `action`, `type`, `gameUserNo`, `memo`, `createDate`) VALUES (in_orderId, in_name, balance, in_money, in_currency, in_action, in_type, gameUserNo_from_obj , memo_from_obj, now()); 

	END IF; 



    COMMIT; 



    #回传状态

    SELECT errCode as errCode,updateMoney as money, LAST_INSERT_ID() as id; 



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
DROP PROCEDURE IF EXISTS `updatePlayerWalletAllowNegative`;
CREATE DEFINER=`root`@`%` PROCEDURE `updatePlayerWalletAllowNegative`(IN `in_name` varchar(190), IN `in_money` bigint(20),IN `in_action` tinyint(1), IN `in_type` tinyint(3), IN `in_currency` varchar(20), IN `in_orderId` varchar(190), IN `in_obj` json)
BEGIN
    DECLARE balance bigint(20); 
    DECLARE updateMoney bigint(20); 
    DECLARE errCode smallint(4) DEFAULT 0; 
	DECLARE msg varchar(100); 
    DECLARE gameUserNo_from_obj  varchar(50) DEFAULT NULL; 
    DECLARE memo_from_obj  longtext DEFAULT NULL; 

	DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN #发生异常回滚
        GET CURRENT DIAGNOSTICS CONDITION 1 errCode = MYSQL_ERRNO, msg = MESSAGE_TEXT; 
		SELECT errCode, msg; 
        ROLLBACK; 
        SET errCode = 1100; 
        SELECT errCode; 
        SELECT  msg; 
    END; 

	START TRANSACTION; 
		SELECT money into balance FROM `players` WHERE `name` = in_name AND `currency` = in_currency LIMIT 1 FOR UPDATE; 

		IF in_obj IS NOT NULL THEN 
			SET gameUserNo_from_obj = NULLIF(JSON_UNQUOTE(JSON_EXTRACT(in_obj, '$.gameUserNo')),'null'); 
			SET memo_from_obj = NULLIF(JSON_UNQUOTE(JSON_EXTRACT(in_obj, '$.memo')),'null'); 
		END IF; 

		IF balance is null THEN 
			IF in_action = 0 THEN  #钱包不存在且上分的话就创建钱包
				INSERT INTO `players` (`name`, `currency`, `money`, `updateDate`) VALUES (in_name, in_currency, in_money, now()); 

				SET updateMoney = in_money; 
				INSERT INTO `players_history` (`orderId`, `name`, `originMoney`, `money`, `currency`, `action`, `type`, `gameUserNo`, `memo`, `createDate`) VALUES (in_orderId, in_name, 0, in_money, in_currency, in_action, in_type, gameUserNo_from_obj , memo_from_obj , now()); 
			ELSE 
			   SET errCode = 1101;  #钱包不存在
			END IF; 
		ELSE

			IF in_action = 1 THEN #钱包下分
				SET updateMoney = balance - in_money; 
			ELSEIF in_action = 0 THEN #钱包上分
				SET updateMoney = balance + in_money; 
			END IF; 

			#更新钱包
			UPDATE `players` SET money = updateMoney,updateDate=now() WHERE `name`= in_name AND `currency` = in_currency; 

			#建立订单
			INSERT INTO `players_history` (`orderId`, `name`, `originMoney`, `money`, `currency`, `action`, `type`, `gameUserNo`, `memo`, `createDate`) VALUES (in_orderId, in_name, balance, in_money, in_currency, in_action, in_type, gameUserNo_from_obj , memo_from_obj, now()); 
		END IF; 

    COMMIT; 

    #回传状态
    SELECT errCode as errCode,updateMoney as money, LAST_INSERT_ID() as id; 
END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

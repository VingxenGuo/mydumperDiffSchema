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
DROP PROCEDURE IF EXISTS `updateAgentMoney`;
CREATE DEFINER=`root`@`%` PROCEDURE `updateAgentMoney`(IN  `in_agent` int, IN  `in_money` bigint,IN `in_type` int)
BEGIN

	DECLARE tmp_agent bigint; 

  DECLARE agentCurMoney BIGINT; 

	DECLARE result_code INT DEFAULT 0; -- 定义返回结果并赋初值0

	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION SET result_code=-1; 

	START TRANSACTION; 

	select money,agent into agentCurMoney,tmp_agent from agents where agent=in_agent LIMIT 1 FOR UPDATE; 

  IF tmp_agent is null

	THEN

		ROLLBACK; 

		SELECT 1001 errorcode;#者代理不存在

	ELSE

		#in_type=0 玩家带钱进入大厅，in_type=1 玩家从大厅转出下分 

		IF in_type=0 and agentCurMoney<in_money THEN

			ROLLBACK; 

			SELECT 1002 errorcode;#进入大厅，代理金额不足

		ELSE

			if(in_type=1) then set in_money=in_money*-1; END IF; 

			update agents set money=money-in_money where agent=in_agent; 

			IF result_code = 0 THEN      

				COMMIT; 

				select result_code errorcode

				,agentCurMoney as agentCurMoney; 

			END IF; 

     END IF; 

	END IF; 

	IF result_code = -1 THEN -- 可以根据不同的业务逻辑错误返回不同的result_code，这里只定义了-1和0

		ROLLBACK; 

		SELECT result_code errorcode;#异常回滚

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
DROP PROCEDURE IF EXISTS `updateAgentWallet`;
CREATE DEFINER=`root`@`%` PROCEDURE `updateAgentWallet`(IN `in_channelId` bigint(20), IN `in_money` bigint(20),IN `in_type` tinyint(3),IN `in_orderId` varchar(190), IN `in_currency` varchar(100))
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



	START TRANSACTION; 



	SELECT money into balance FROM `agents` WHERE `channelId` = in_channelId LIMIT 1 FOR UPDATE; 



    IF balance is null THEN  #代理不存在

        SET errCode = 1001; 

	ELSEIF in_type = 0 and balance < in_money THEN #钱包金额不足

        SET errCode = 1002; 

    ELSE

        IF in_type = 0 THEN #钱包下分

            SET updateMoney = balance - in_money; 

        ELSEIF in_type = 1 THEN #钱包上分

            SET updateMoney = balance + in_money; 

        END IF; 



        #更新钱包

        UPDATE `agents` SET money = updateMoney,updateDate=now() WHERE `channelId`= in_channelId; 



        #建立订单

        INSERT INTO `agents_history` (`orderId`, `channelId`, `originMoney`, `money`, `type`,  `createDate`) VALUES (in_orderId, in_channelId, balance, in_money, in_type, now()); 

        INSERT INTO  `game_api`.`orders_sys`(`curMoney`, `money`, `afterMoney`, `status`, `type`,  `agent`, `currency`) VALUES (balance, in_money, updateMoney, 0, in_type, in_channelId, in_currency); 

	END IF; 



    COMMIT; 



    #回传状态

    SELECT errCode as errCode,updateMoney as money; 



END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

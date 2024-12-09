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
CREATE DEFINER=`root`@`%` TRIGGER  `game_api`.`tools_orders` AFTER INSERT ON `game_api`.`orders`

FOR EACH ROW



BEGIN

 DECLARE mode INT; 

 DECLARE type INT; 

 DECLARE json LONGTEXT; 

 

 DECLARE orderID varchar(190); 

 DECLARE channelID INT(11); 

 DECLARE orderTime TIMESTAMP; 

 DECLARE agentOrderType INT; 

 DECLARE playerOrderType INT; 

 DECLARE orderStatus INT; 

 DECLARE agentCurScore BIGINT(20); 

 DECLARE playerCurScore BIGINT(20); 

 DECLARE addScore BIGINT(20); 

 DECLARE agentNewScore BIGINT(20); 

 DECLARE playerNewScore BIGINT(20); 

 DECLARE orderIP varchar(500); 

 DECLARE createUser varchar(150); 

 DECLARE trx_currency varchar(50); 

 DECLARE trx_addScore BIGINT(20); 

 DECLARE errorMsg varchar(200); 

 DECLARE createdate TIMESTAMP; 



 SELECT NEW.status INTO mode; 

 SELECT NEW.type INTO type; 

 SELECT NEW.big_data INTO json; 

 

 SET orderID =  NEW.orderid; /*订单编号*/

 SET channelID =  json->>"$.agent";  /*代理编号*/

 SET orderTime =  NEW.createdate; /*订单时间*/

 SET addScore =  json->>"$.addScore"; /*代理开线币种帐变金额*/

 SET orderIP =  json->>"$.ip"; /*操作ip*/

 SET createUser =  json->>"$.account"; /*操作人*/

 SET trx_currency =  NEW.currency; /*币别*/

 SET trx_addScore =  NEW.money; /*交易之帐变金额*/



/***转账钱包模式:11、單一钱包模式:100 ****/

 IF (mode = 11 OR mode = 100) THEN  

    SET orderStatus = 0; /*订单状态: 0 成功*/

    SET agentCurScore = json->>"$.agentCurMoney"; /*agent帐变前金额*/

    

	IF type = 0 THEN

		SET agentOrderType = 2; /*agent帐变类型*/

        SET playerOrderType = 6; /*player帐变类型*/

		SET agentNewScore = agentCurScore - addScore ; /*agent帐变后金额*/

		SET playerCurScore = IFNULL(json->>"$.accountCurMoney",0); /*player帐变前金额*/

        SET playerNewScore = playerCurScore + trx_addScore ; /*player帐变后金额*/

    ELSE 

		SET agentOrderType = 3; /*agent帐变类型*/

        SET playerOrderType = 7; /*player帐变类型*/

        SET agentNewScore = agentCurScore + addScore ; /*agent帐变后金额*/

		SET playerCurScore = IFNULL(json->>"$.accountCurMoney",trx_addScore); /*player帐变前金额*/

        SET playerNewScore = playerCurScore - trx_addScore ; /*player帐变后金额*/

    END IF; 

     

	INSERT INTO `orders_record`.`agent_orders`

	(OrderID,ChannelID,OrderTime,OrderType,OrderStatus,CurScore,AddScore,NewScore,OrderIP,CreateUser,trx_currency,trx_addScore)values(

	orderID,channelID,orderTime,agentOrderType,orderStatus,agentCurScore,addScore,agentNewScore,orderIP,createUser,trx_currency,trx_addScore); 



    IF (mode = 11) THEN 

		INSERT INTO `orders_record`.`player_orders`

		(OrderID,ChannelID,OrderTime,OrderType,CurScore,AddScore,NewScore,OrderIP,CreateUser,OrderStatus,currency)values(

		orderID,channelID,orderTime,playerOrderType,playerCurScore,trx_addScore,playerNewScore,orderIP,createUser,orderStatus,trx_currency); 

	END IF; 



	REPLACE INTO `KYStatis`.`statis_agent_currency`(ChannelID,currency)values(channelID,trx_currency); 



ELSEIF (mode = 103 OR mode =104 OR mode =105 OR mode =106 OR mode =107 OR mode =108) THEN   /*單一钱包模式*/

	

	SET orderStatus = mode - 100; /*订单状态: orderStatus: 0成功 1处理中 2失败 3通知代理把玩家上分无应答 4通知代理把玩家下分无应答 5通知代理把玩家上分不同意 6通知代理把玩家下分不同意(有错误当不同意) 7内部代理上分钱包卡帐 8内部代理下分钱包卡帐*/

    SET agentCurScore = IFNULL(json->>"$.agentCurMoney",0); /*agent帐变前金额*/

	SET agentNewScore = agentCurScore ; /*agent帐变后金额*/

  

	IF type = 0 THEN

		SET agentOrderType = 2; /*agent帐变类型*/		

    ELSE 

		SET agentOrderType = 3; /*agent帐变类型*/

	END IF; 

     

	INSERT INTO `orders_record`.`agent_orders`

	(OrderID,ChannelID,OrderTime,OrderType,OrderStatus,CurScore,AddScore,NewScore,OrderIP,CreateUser,trx_currency,trx_addScore)values(

	orderID,channelID,orderTime,agentOrderType,orderStatus,agentCurScore,addScore,agentNewScore,orderIP,createUser,trx_currency,trx_addScore); 



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
CREATE DEFINER=`root`@`%` TRIGGER `game_api`.`tools_single_orders` AFTER INSERT ON `single_orders` FOR EACH ROW BEGIN

    DECLARE type INT; 



    DECLARE OrderID VARCHAR(190); 

    DECLARE ChannelID INT(11); 

    DECLARE OrderTime datetime; 

    DECLARE GameNo VARCHAR(50); 

    DECLARE OrderType INT(11); 

    DECLARE OrderAction INT(11); 

    DECLARE CurScore BIGINT(20); 

    DECLARE AddScore BIGINT(20); 

    DECLARE NewScore BIGINT(20); 

    DECLARE OrderIP VARCHAR(255); 

    DECLARE CreateUser VARCHAR(190); 

    DECLARE OrderStatus INT(11); 

    DECLARE ErrorMsg VARCHAR(200); 

    DECLARE RetCode INT(11); 

    DECLARE DealStatus INT(11); 

    DECLARE currency VARCHAR(50); 



    SELECT NEW.type INTO type; 



    SET OrderID = NEW.orderId; 

    SET ChannelID = NEW.channelId; 

    SET OrderTime = New.createdate; 

    SET GameNo = NEW.gameNo; 

    SET OrderAction = NEW.action; 

    SET CurScore = NEW.curScore; 

    SET AddScore = NEW.addScore; 

    SET NewScore = NEW.newScore; 

    SET OrderIP = ''; -- 沒有對應欄位

    SET CreateUser = NEW.account; 

    SET OrderStatus = NEW.status; 

    SET ErrorMsg = NULL; 

    SET RetCode = NEW.retCode; 

    SET DealStatus = NULL; 

    SET currency = NEW.currency; 



    IF type = 0 THEN

        SET OrderType = 14; 

    ELSEIF type = 1 THEN

        SET OrderType = 15; 

    ELSEIF type = 2 THEN

        SET OrderType = 16; 

    ELSE

        SET OrderType = type; 

    END IF; 



    INSERT INTO `orders_record`.`single_orders`

    (OrderID,ChannelID,OrderTime,GameNo,OrderType,OrderAction,CurScore,AddScore,NewScore,OrderIP,CreateUser,OrderStatus,ErrorMsg,RetCode,DealStatus,currency) values

    (OrderID,ChannelID,OrderTime,GameNo,OrderType,OrderAction,CurScore,AddScore,NewScore,OrderIP,CreateUser,OrderStatus,ErrorMsg,RetCode,DealStatus,currency); 

END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

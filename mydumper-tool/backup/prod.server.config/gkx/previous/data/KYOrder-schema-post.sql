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
DROP PROCEDURE IF EXISTS `sp_cashOrderDetail`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_cashOrderDetail`(
    IN pPlayerAccount VARCHAR(200)
    ,IN pGameUserNO VARCHAR(50)
    ,IN isEmptySearchDate INT
    ,IN pAgentId INT
    ,IN pCurrency VARCHAR(50)
    ,IN pBeginDate VARCHAR(30)
    ,IN pEndDate VARCHAR(30)
    ,IN pCreateUser VARCHAR(200)
    ,IN pOrderStatus INT
    ,IN pOrderType VARCHAR(50)
    ,IN pLimit INT
    ,IN pOffset INT
)
proc_label:BEGIN

    DECLARE tWalletPlayerHistorySql LONGTEXT; 
    DECLARE tHTFailedOrderSql LONGTEXT; 
    DECLARE countsql LONGTEXT; 
    DECLARE tSql LONGTEXT; 

    IF IFNULL(LENGTH(pBeginDate),0)<=0 OR IFNULL(LENGTH(pEndDate),0)<=0 THEN

        LEAVE proc_label; 

    END IF; 

    SET tWalletPlayerHistorySql = CONCAT('
    SELECT `order`.id AS id
        , `order`.orderId AS orderNo
        , `order`.gameUserNo AS gameUserNO
        , `order`.createDate AS orderTime
        , `order`.`name` AS playerAccount
        , `order`.`type`
        , `order`.`action`
        , `order`.currency
        , `order`.originMoney AS originScore
        , CASE `order`.`action`
        WHEN 0 THEN `order`.money
        WHEN 1 THEN (-1*`order`.money)
        ELSE 0 END AS addScore
        , (`order`.originMoney + (CASE `order`.`action`
        WHEN 0 THEN `order`.money
        WHEN 1 THEN (-1*`order`.money)
        ELSE 0 END )) AS newScore
    FROM wallet.players_history AS `order`
    '); 

    SET tHTFailedOrderSql = CONCAT('
    SELECT '''' AS orderNo
        , '''' AS gameUserNO
        , player.createTime AS orderTime
        , player.agentId
        , player.account AS playerAccount
        , CASE player.type
            WHEN 0 THEN 5
            WHEN 1 THEN 7
            ELSE -1 END AS type
        , '''' AS action
        , player.currency
        , '''' AS originScore
        , player.addScore AS addScore
        , '''' AS newScore
        , player.ip
        , player.`status`
        , player.createUser
        , agent.NickName AS agentName
    FROM KYOrder.player AS player
    LEFT JOIN KYDB_NEW.agent agent ON player.agentId = agent.id
    WHERE `status` = 1
    AND playersHistoryId IS NULL
'); 

    IF LENGTH(pGameUserNO) > 0 AND isEmptySearchDate = 1 THEN
        SET pBeginDate = ''; 
        SET pEndDate = ''; 

        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' where `order`.`gameUserNo` = ''',pGameUserNO,''' '); 

    ELSEIF  
    IFNULL(LENGTH(pBeginDate),0)>0 OR IFNULL(LENGTH(pEndDate),0)>0 THEN

        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql, ' WHERE `order`.createDate BETWEEN ''',pBeginDate,''' AND ''' ,pEndDate,''' '); 

        SET tHTFailedOrderSql = CONCAT(tHTFailedOrderSql, 'AND createTime BETWEEN ''',pBeginDate,''' AND ''' ,pEndDate,''' '); 

    END IF; 

    IF LENGTH(pGameUserNO) > 0 AND isEmptySearchDate = 0 THEN

        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND `order`.`gameUserNO` = ''',pGameUserNO,''' '); 

        SET tHTFailedOrderSql = CONCAT(tHTFailedOrderSql, ' AND gameUserNO = ''',pGameUserNO,''' '); 

    END IF; 

    IF LENGTH(pCurrency)>0 THEN

        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND `order`.currency = ''',pCurrency,''' '); 

        SET tHTFailedOrderSql = CONCAT(tHTFailedOrderSql,' AND currency = ''',pCurrency,''' '); 

    END IF; 

    IF LENGTH(pOrderType) > 0 THEN

        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND `order`.type IN (',pOrderType,')'); 

    END IF; 

    SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' ORDER BY createDate desc ,id DESC '); 

    SET tWalletPlayerHistorySql = CONCAT('
    SELECT 
        `order`. *
        , player.agent AS agentId
        , apiOrder.OrderIP AS ip
        , apiOrder.`OrderStatus` AS `status`
        , apiOrder.CreateUser AS createUser
        , `agent`.nickName AS agentName
        , `agent`.account AS agentAccount
    FROM (
    ', tWalletPlayerHistorySql ,' ) AS `order`
    INNER JOIN game_api.accounts  AS player ON `order`.`playerAccount` = player.account
    LEFT  JOIN orders_record.player_orders AS apiOrder ON apiOrder.OrderID = `order`.orderNo
    LEFT  JOIN KYDB_NEW.agent   AS agent ON `agent`.id = `player`.agent
    where  `apiOrder`.`OrderTime` BETWEEN ''' ,pBeginDate, ''' AND ''' ,pEndDate, '''
    '); 


    IF pAgentId > 0 THEN

        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' and `player`.agent = ''',pAgentId,''' '); 

        SET tHTFailedOrderSql = CONCAT(tHTFailedOrderSql,' AND agentId = ''',pAgentId,''' '); 

    END IF; 

    SET tSql= tWalletPlayerHistorySql; 

    IF pOrderStatus = -1 AND pOrderType = -1 THEN

        SET tSql = CONCAT(tWalletPlayerHistorySql,' UNION ALL ',tHTFailedOrderSql); 

    END IF; 

    SET tSql = CONCAT('
    SELECT *
    FROM ( ',tSql,' ) AS playerOrder
    WHERE 1=1
    '); 

    IF pOrderStatus > -1 THEN

        SET tSql = CONCAT(tSql,' AND `status` = ''',pOrderStatus,''' '); 

    END IF; 

    IF LENGTH(pCreateUser)>0 THEN

        SET tSql = CONCAT(tSql,' AND createUser = ''',pCreateUser,''' '); 

    END IF; 

    IF LENGTH(pPlayerAccount)>0 THEN

        SET tSql = CONCAT(tSql,' AND playerAccount = ''',pPlayerAccount,''' '); 

    END IF;   

    SET tSql = CONCAT(tSql,' ORDER BY orderTime desc ,id DESC '); 
        
    IF IFNULL(pLimit,0) > 0 AND IFNULL(pOffset,-1)>-1 THEN

        SET tSql = CONCAT(tSql,' LIMIT ',pLimit,' OFFSET ',pOffset,' '); 

    END IF;   

    SET @tSql = tSql; 

    PREPARE stmt FROM @tSql; 

    EXECUTE stmt; 

    DEALLOCATE PREPARE stmt; 

    SET countsql = CONCAT('
    SELECT COUNT(1) AS totalCount
    FROM wallet.players_history AS `order`
    INNER JOIN game_api.accounts AS player ON `order`.`name` = player.account
    LEFT  JOIN orders_record.player_orders AS apiOrder ON apiOrder.OrderID = `order`.orderId
    WHERE `order`.`createDate` BETWEEN ''' ,pBeginDate, ''' AND ''' ,pEndDate, '''
    and `apiOrder`.`OrderTime` BETWEEN ''' ,pBeginDate, ''' AND ''' ,pEndDate, '''
    ' ); 

    IF LENGTH(pGameUserNO) > 0 THEN

        SET countsql = CONCAT(countsql,' AND `order`.`gameUserNO` = ''',pGameUserNO,''' '); 
        
    END IF; 

    IF LENGTH(pCurrency)>0 THEN

        SET countsql = CONCAT(countsql,' AND `order`.currency = ''',pCurrency,''' '); 

    END IF; 

    IF LENGTH(pOrderType) > 0 THEN

        SET countsql = CONCAT(countsql,' AND `order`.type IN ( ',pOrderType,' )'); 

    END IF; 

    IF LENGTH(pCreateUser)>0 THEN

        SET countsql = CONCAT(countsql,' AND createUser = ''',pCreateUser,''' '); 

    END IF; 

    IF LENGTH(pPlayerAccount)>0 THEN

        SET countsql = CONCAT(countsql,' AND `order`.name = ''',pPlayerAccount,''' '); 

    END IF;  

    IF pOrderStatus > -1 THEN

        SET countsql = CONCAT(countsql,' AND `apiOrder`.OrderStatus = ''',pOrderStatus,''' '); 

    END IF; 

    SET @countsql = countsql; 
    
    PREPARE stmt FROM @countsql; 

    EXECUTE stmt; 

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
DROP PROCEDURE IF EXISTS `sp_normalPlayerOrderDetail`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_normalPlayerOrderDetail`(IN pPlayerAccount VARCHAR(200)

,IN pGameUserNO VARCHAR(50)

,IN isEmptySearchDate INT

,IN pAgentId INT

,IN pCurrency VARCHAR(50)

,IN pBeginDate VARCHAR(30)

,IN pEndDate VARCHAR(30)

,IN pCreateUser VARCHAR(200)

,IN pOrderStatus INT

,IN pOrderType VARCHAR(50)

,IN pLimit INT

,IN pOffset INT)
proc_label:BEGIN



    DECLARE tWalletPlayerHistorySql LONGTEXT; 

    DECLARE tHTFailedOrderSql LONGTEXT; 

    DECLARE tSql LONGTEXT; 



    IF IFNULL(LENGTH(pBeginDate),0)<=0 OR IFNULL(LENGTH(pEndDate),0)<=0 THEN

        LEAVE proc_label; 

    END IF; 



    SET tWalletPlayerHistorySql = CONCAT('

SELECT `order`.id AS id

     , `order`.orderId AS orderNo

     , `order`.gameUserNo AS gameUserNO

     , `order`.createDate AS orderTime

     , player.agent AS agentId

     , `order`.`name` AS playerAccount

     , `order`.`type`

     , `order`.`action`

     , `order`.currency

     , `order`.originMoney AS originScore

     , CASE `order`.`action`

       WHEN 0 THEN `order`.money

       WHEN 1 THEN (-1*`order`.money)

       ELSE 0 END AS addScore

     , (`order`.originMoney + (CASE `order`.`action`

       WHEN 0 THEN `order`.money

       WHEN 1 THEN (-1*`order`.money)

       ELSE 0 END )) AS newScore

     , CASE

       WHEN `order`.`type`>=1 && `order`.`type`<=4 THEN apiOrder.OrderIP

       WHEN `order`.`type`>=5 && `order`.`type`<=8 THEN htOrder.ip

       ELSE '''' END AS ip

     , CASE

       WHEN `order`.`type`>=1 && `order`.`type`<=4 THEN apiOrder.`OrderStatus`

       ELSE 0 END AS `status`

     , CASE

       WHEN `order`.`type`>=1 && `order`.`type`<=4 THEN apiOrder.CreateUser

       WHEN `order`.`type`>=5 && `order`.`type`<=8 THEN htOrder.createUser

       WHEN `order`.`type`>=9 && `order`.`type`<=12 THEN `order`.`name`

       ELSE '''' END AS createUser

     , `agent`.NickName AS agentName

     , `agent`.Accounts AS agentAccount

FROM  wallet.players_history           AS `order`

INNER JOIN game_api.accounts           AS player ON `order`.`name` = player.account

LEFT  JOIN orders_record.player_orders AS apiOrder ON apiOrder.OrderID = `order`.orderId

LEFT  JOIN KYOrder.player              AS htOrder FORCE INDEX(idx_playerHistoryId) ON htOrder.playersHistoryId = `order`.id

LEFT  JOIN KYDB_NEW.Sys_ProxyAccount   AS agent ON `agent`.ChannelID = `player`.agent

'); 



    SET tHTFailedOrderSql = CONCAT('

SELECT '''' AS orderNo

      , '''' AS gameUserNO

      , player.createTime AS orderTime

      , player.agentId

      , player.account AS playerAccount

      , CASE player.type

        WHEN 0 THEN 5

        WHEN 1 THEN 7

        ELSE -1 END AS type

      , '''' AS action

      , player.currency

      , '''' AS originScore

      , player.addScore AS addScore

      , '''' AS newScore

      , player.ip

      , player.`status`

      , player.createUser

      , agent.NickName AS agentName

FROM KYOrder.player AS player

LEFT JOIN KYDB_NEW.Sys_ProxyAccount agent ON player.agentId = agent.ChannelID

WHERE `status` = 1

    AND playersHistoryId IS NULL

'); 

    --
    IF LENGTH(pGameUserNO) > 0 AND isEmptySearchDate = 1 THEN
        SET pBeginDate = ''; 
        SET pEndDate = ''; 

        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' where `order`.`gameUserNo` = ''',pGameUserNO,''' '); 

        -- SET tHTFailedOrderSql = CONCAT(tHTFailedOrderSql, ' where gameUserNo = ''',pGameUserNO,''' '); 

    -- END IF; 
    --
    ELSEIF  IFNULL(LENGTH(pBeginDate),0)>0 OR IFNULL(LENGTH(pEndDate),0)>0 THEN

        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql, ' WHERE  `order`.createDate >= ''',pBeginDate,''' AND `order`.createDate <= ''' ,pEndDate,''' '); 

        SET tHTFailedOrderSql = CONCAT(tHTFailedOrderSql, ' WHERE  createTime >= ''',pBeginDate,''' AND createTime <= ''' ,pEndDate,''' '); 

    END IF; 


    IF LENGTH(pPlayerAccount) > 0 THEN

        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND `order`.`name` = ''',pPlayerAccount,''' '); 

        SET tHTFailedOrderSql = CONCAT(tHTFailedOrderSql, ' AND account = ''',pPlayerAccount,''' '); 

    END IF; 



    IF LENGTH(pGameUserNO) > 0 AND isEmptySearchDate = 0 THEN

        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND `order`.`gameUserNO` = ''',pGameUserNO,''' '); 

        SET tHTFailedOrderSql = CONCAT(tHTFailedOrderSql, ' AND gameUserNO = ''',pGameUserNO,''' '); 

    END IF; 



    IF pAgentId > 0 THEN

        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND `player`.agent = ''',pAgentId,''' '); 

        SET tHTFailedOrderSql = CONCAT(tHTFailedOrderSql,' AND agentId = ''',pAgentId,''' '); 

    END IF; 



    IF LENGTH(pCurrency)>0 THEN

        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND `order`.currency = ''',pCurrency,''' '); 

        SET tHTFailedOrderSql = CONCAT(tHTFailedOrderSql,' AND currency = ''',pCurrency,''' '); 

    END IF; 



    IF LENGTH(pOrderType) > 0 THEN

        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND `order`.type IN (',pOrderType,')'); 

    END IF; 



    -- IF pOrderType > -1 THEN

    --  SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND `order`.type = ''',pOrderType,''' '); 

    -- END IF; 



    SET tSql= tWalletPlayerHistorySql; 



    IF pOrderStatus = -1 AND pOrderType = -1 THEN

        SET tSql = CONCAT(tWalletPlayerHistorySql,' UNION ALL ',tHTFailedOrderSql); 

    END IF; 



    SET tSql = CONCAT('

SELECT SQL_CALC_FOUND_ROWS *

FROM ( ',tSql,' ) AS playerOrder

WHERE 1=1

'); 



    IF pOrderStatus > -1 THEN

        SET tSql = CONCAT(tSql,' AND `status` = ''',pOrderStatus,''' '); 

    END IF; 



    IF LENGTH(pCreateUser)>0 THEN

        SET tSql = CONCAT(tSql,' AND createUser = ''',pCreateUser,''' '); 

    END IF; 



    SET tSql = CONCAT(tSql,' ORDER BY orderTime desc ,id DESC '); 



    IF IFNULL(pLimit,0) > 0 AND IFNULL(pOffset,-1)>-1 THEN

        SET tSql = CONCAT(tSql,' LIMIT ',pLimit,' OFFSET ',pOffset,' '); 

    END IF; 

    SET @tSql = tSql; 

    PREPARE stmt FROM @tSql; 

    EXECUTE stmt; 

    DEALLOCATE PREPARE stmt; 

    SELECT FOUND_ROWS() AS totalCount; 

END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

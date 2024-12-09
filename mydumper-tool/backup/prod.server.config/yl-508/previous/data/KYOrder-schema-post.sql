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
    IN pPlayerAccount VARCHAR(200),
    IN pGameUserNO VARCHAR(50),
    IN isEmptySearchDate INT,
    IN pAgentId INT,
    IN pCurrency VARCHAR(50),
    IN pBeginDate VARCHAR(30),
    IN pEndDate VARCHAR(30),
    IN pCreateUser VARCHAR(200),
    IN pOrderStatus INT,
    IN pOrderType VARCHAR(50),
    IN pLimit INT,
    IN pOffset INT
)
BEGIN
    DECLARE tWalletPlayerHistorySql LONGTEXT; 
    DECLARE countsql LONGTEXT; 
    DECLARE tSql LONGTEXT; 

    -- 基本的SQL语句
    SET tWalletPlayerHistorySql = '
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
        WHEN 1 THEN (-1*`order`.money) ELSE 0 END)) AS newScore 
    FROM wallet.players_history AS `order`
    WHERE `order`.createDate BETWEEN ? AND ?'; 

    -- 条件判断拼接WHERE

    IF LENGTH(pGameUserNO) > 0 AND isEmptySearchDate = 0 THEN
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql, ' AND `order`.`gameUserNO` = ?'); 
    ELSE
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql, ' AND @pGameUserNO = ?'); 
    END IF; 


    IF LENGTH(pCurrency) > 0 THEN
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql, ' AND `order`.currency = ?'); 
    ELSE
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql, ' AND @pCurrency = ?'); 
    END IF; 

    IF LENGTH(pOrderType) > 0 THEN
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql, ' AND `order`.type IN (',pOrderType,')'); 
    END IF; 

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
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql, ' AND `player`.agent = ?'); 
    ELSE
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql, ' AND @pAgentId = ?'); 
    END IF; 

    SET tSql= tWalletPlayerHistorySql; 

    -- 附加排序和限制条件
    SET tSql = CONCAT('SELECT * FROM (', tSql, ') AS playerOrder WHERE 1=1'); 

    IF pOrderStatus > -1 THEN
        SET tSql = CONCAT(tSql, ' AND `status` = ?'); 
    ELSE
        SET tSql = CONCAT(tSql, ' AND @pOrderStatus = ?'); 
    END IF; 

    IF LENGTH(pCreateUser) > 0 THEN
        SET tSql = CONCAT(tSql, ' AND createUser = ?'); 
    ELSE
        SET tSql = CONCAT(tSql, ' AND @pCreateUser = ?'); 
    END IF; 

    IF LENGTH(pPlayerAccount) > 0 THEN
        SET tSql = CONCAT(tSql, ' AND playerAccount = ?'); 
    ELSE
        SET tSql = CONCAT(tSql, ' AND @pPlayerAccount = ?'); 
    END IF; 

    IF pLimit > 0 AND pOffset >= 0 THEN
        SET tSql = CONCAT(tSql, ' ORDER BY orderTime DESC, id DESC'); 
        SET tSql = CONCAT(tSql, ' LIMIT ? OFFSET ?'); 
    ELSE
        SET tSql = CONCAT(tSql, ' AND @pLimit = ? AND @pOffset = ?'); 
        SET tSql = CONCAT(tSql, ' ORDER BY orderTime DESC, id DESC'); 
    END IF; 

    SET @pGameUserNO = pGameUserNO; 
    SET @pBeginDate = pBeginDate; 
    SET @pEndDate = pEndDate; 
    SET @pCurrency = pCurrency; 
    SET @pAgentId = pAgentId; 
    SET @pOrderStatus = pOrderStatus; 
    SET @pCreateUser = pCreateUser; 
    SET @pPlayerAccount = pPlayerAccount; 
    SET @pLimit = pLimit; 
    SET @pOffset = pOffset; 
		
    -- 准备和执行查询
    SET @tSql = tSql; 
    PREPARE stmt FROM @tSql; 
    EXECUTE stmt USING @pBeginDate, @pEndDate, @pGameUserNO, @pCurrency, @pAgentId, @pOrderStatus, @pCreateUser, @pPlayerAccount, @pLimit, @pOffset; 
    DEALLOCATE PREPARE stmt; 

    -- 计数查询
    SET countsql = '
    SELECT COUNT(1) AS totalCount 
    FROM wallet.players_history AS `order` 
    INNER JOIN game_api.accounts AS player ON `order`.`name` = player.account 
    LEFT JOIN orders_record.player_orders AS apiOrder ON apiOrder.OrderID = `order`.orderId 
    WHERE `order`.`createDate` BETWEEN ? AND ?
    AND `apiOrder`.`OrderTime` BETWEEN ? AND ?'; 

    IF LENGTH(pGameUserNO) > 0 THEN
        SET countsql = CONCAT(countsql,' AND `order`.`gameUserNO` = ?'); 
    ELSE
        SET countsql = CONCAT(countsql, ' AND @pGameUserNO = ?'); 
    END IF; 

    IF LENGTH(pCurrency)>0 THEN
        SET countsql = CONCAT(countsql,' AND `order`.currency = ?'); 
    ELSE
        SET countsql = CONCAT(countsql, ' AND @pcurrency = ?'); 
    END IF; 

    IF LENGTH(pOrderType) > 0 THEN
        SET countsql = CONCAT(countsql,' AND `order`.type IN ( ',pOrderType,' )'); 
    END IF; 

    IF pOrderStatus > -1 THEN
        SET countsql = CONCAT(countsql,' AND `apiOrder`.OrderStatus = ?'); 
    ELSE
        SET countsql = CONCAT(countsql, ' AND @pOrderStatus = ?'); 
    END IF; 

	IF LENGTH(pCreateUser)>0 THEN
        SET countsql = CONCAT(countsql,' AND createUser = ?'); 
    ELSE
        SET countsql = CONCAT(countsql, ' AND @pCreateUser = ?'); 
    END IF; 

    SET @countsql = countsql; 

    PREPARE count_stmt FROM @countsql; 
    EXECUTE count_stmt USING @pBeginDate, @pEndDate, @pBeginDate, @pEndDate, @pGameUserNO, @pCurrency, @pOrderStatus, @pCreateUser; 
    DEALLOCATE PREPARE count_stmt; 

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
CREATE DEFINER=`root`@`%` PROCEDURE `sp_normalPlayerOrderDetail`(
    IN pPlayerAccount VARCHAR(200),
    IN pGameUserNO VARCHAR(50),
    IN isEmptySearchDate INT,
    IN pAgentId INT,
    IN pCurrency VARCHAR(50),
    IN pBeginDate VARCHAR(30),
    IN pEndDate VARCHAR(30),
    IN pCreateUser VARCHAR(200),
    IN pOrderStatus INT,
    IN pOrderType VARCHAR(50),
    IN pLimit INT,
    IN pOffset INT)
BEGIN

    DECLARE tWalletPlayerHistorySql LONGTEXT; 
    DECLARE tHTFailedOrderSql LONGTEXT; 
    DECLARE tSql LONGTEXT; 
    
    SET tWalletPlayerHistorySql = CONCAT('
        SELECT 
            `order`.id AS id, 
            `order`.orderId AS orderNo, 
            `order`.gameUserNo AS gameUserNO, 
            `order`.createDate AS orderTime, 
            player.agent AS agentId, 
            `order`.`name` AS playerAccount, 
            `order`.`type`, 
            `order`.`action`, 
            `order`.currency, 
            `order`.originMoney AS originScore,             
            CASE `order`.`action`
            WHEN 0 THEN `order`.money
            WHEN 1 THEN (-1*`order`.money)
            ELSE 0 END AS addScore,             
            (`order`.originMoney + (CASE `order`.`action` WHEN 0 THEN `order`.money WHEN 1 THEN (-1*`order`.money) ELSE 0 END )) AS newScore,             
            CASE 
            WHEN `order`.`type`>=1 && `order`.`type`<=4 THEN apiOrder.OrderIP
            WHEN `order`.`type`>=5 && `order`.`type`<=8 THEN htOrder.ip
            ELSE '''' END AS ip,             
            CASE
            WHEN `order`.`type`>=1 && `order`.`type`<=4 THEN apiOrder.`OrderStatus`
            ELSE 0 END AS `status`,             
            CASE
            WHEN `order`.`type`>=1 && `order`.`type`<=4 THEN apiOrder.CreateUser
            WHEN `order`.`type`>=5 && `order`.`type`<=8 THEN htOrder.createUser
            WHEN `order`.`type`>=9 && `order`.`type`<=12 THEN `order`.`name`
            ELSE '''' END AS createUser,             
            `agent`.nickname AS agentName, 
            `agent`.account AS agentAccount
        FROM  wallet.players_history           AS `order`
        INNER JOIN game_api.accounts           AS player ON `order`.`name` = player.account
        LEFT  JOIN orders_record.player_orders AS apiOrder ON apiOrder.OrderID = `order`.orderId
        LEFT  JOIN KYOrder.player              AS htOrder FORCE INDEX(idx_playerHistoryId) ON htOrder.playersHistoryId = `order`.id
        LEFT  JOIN KYDB_NEW.agent   AS agent ON `agent`.id = `player`.agent'); 

    IF LENGTH(pGameUserNO) > 0 AND isEmptySearchDate = 1 THEN
        SET pBeginDate = ''; 
        SET pEndDate = ''; 
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' where `order`.`gameUserNo` = ?'); 
    ELSEIF  IFNULL(LENGTH(pBeginDate),0)>0 OR IFNULL(LENGTH(pEndDate),0)>0 THEN
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql, ' WHERE  `order`.createDate >= ? AND `order`.createDate <= ? '); 
    END IF; 

    IF LENGTH(pPlayerAccount) > 0 THEN
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND `order`.`name` = ?'); 
    ELSE
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND @pPlayerAccount = ?'); 
    END IF; 

    IF LENGTH(pGameUserNO) > 0 AND isEmptySearchDate = 0 THEN
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND `order`.`gameUserNO` = ?'); 
    ELSE
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND @pGameUserNO = ?'); 
    END IF; 

    IF pAgentId > 0 THEN
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND `player`.agent = ?'); 
    ELSE
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND @pAgentId = ?'); 
    END IF; 

    IF LENGTH(pCurrency)>0 THEN
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND `order`.currency = ?'); 
    ELSE
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND @pCurrency = ?'); 
    END IF; 

    IF LENGTH(pOrderType) > 0 THEN
        SET tWalletPlayerHistorySql = CONCAT(tWalletPlayerHistorySql,' AND `order`.type IN (',pOrderType,')'); 
    END IF; 

    SET tSql= tWalletPlayerHistorySql; 

    SET tSql = CONCAT('
        SELECT SQL_CALC_FOUND_ROWS *
        FROM ( ',tSql,' ) AS playerOrder
        WHERE 1=1
        '); 

    IF pOrderStatus > -1 THEN
        SET tSql = CONCAT(tSql,' AND `status` = ?'); 
    ELSE
        SET tSql = CONCAT(tSql,' AND @pOrderStatus = ?'); 
    END IF; 

    IF LENGTH(pCreateUser)>0 THEN
        SET tSql = CONCAT(tSql,' AND createUser = ?'); 
    ELSE
        SET tSql = CONCAT(tSql,' AND @pCreateUser = ?'); 
    END IF; 

    IF IFNULL(pLimit,0) > 0 AND IFNULL(pOffset,-1)>-1 THEN
        SET tSql = CONCAT(tSql,' ORDER BY orderTime desc ,id DESC LIMIT ? OFFSET ?'); 
    ELSE
        SET tSql = CONCAT(tSql,' AND @pLimit = ? AND @pOffset = ?  ORDER BY orderTime desc ,id DESC'); 
    END IF; 

    SET @pGameUserNO = pGameUserNO; 
    SET @pBeginDate = pBeginDate; 
    SET @pEndDate = pEndDate; 
    SET @pPlayerAccount = pPlayerAccount; 
    SET @pAgentId = pAgentId; 
    SET @pCurrency = pCurrency; 
    SET @pOrderStatus = pOrderStatus; 
    SET @pCreateUser = pCreateUser; 
    SET @pLimit = IFNULL(pLimit,0); 
    SET @pOffset = IFNULL(pOffset,-1); 

    SET @tSql = tSql; 

    PREPARE stmt FROM @tSql; 

    IF LENGTH(pGameUserNO) > 0 AND isEmptySearchDate = 1 THEN

        EXECUTE stmt USING @pGameUserNO, @pPlayerAccount, @pGameUserNO, @pAgentId, @pCurrency, @pOrderStatus, @pCreateUser, @pLimit, @pOffset; 

    ELSEIF  IFNULL(LENGTH(pBeginDate),0)>0 OR IFNULL(LENGTH(pEndDate),0)>0 THEN

        EXECUTE stmt USING @pBeginDate, @pEndDate, @pPlayerAccount, @pGameUserNO, @pAgentId, @pCurrency, @pOrderStatus, @pCreateUser, @pLimit, @pOffset; 

    END IF; 

    DEALLOCATE PREPARE stmt; 

    SELECT FOUND_ROWS() AS totalCount; 

END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

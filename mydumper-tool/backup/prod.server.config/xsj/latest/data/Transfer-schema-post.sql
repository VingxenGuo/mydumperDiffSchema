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
DROP PROCEDURE IF EXISTS `ShiftGameApiAccounts`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameApiAccounts`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiAccounts') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.id, old.account, old.agent, old.mstatus, old.mark, old.lineCode, old.lastlogintime, old.createdate, old.updatedate, NULL firstBetTime from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'accounts'; 

	SET v_dist_db = 'game_api'; 
	SET v_dist_table = 'accounts'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

	
	TRUNCATE TABLE `game_api`.`accounts`; 
	ALTER TABLE `game_api`.`accounts` DROP INDEX `index_account`, DROP INDEX `index_createdate`, DROP INDEX `index_createdate_agent`, DROP INDEX `index_agent`, DROP INDEX `agent_mstatus_IDX`; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	ALTER TABLE `game_api`.`accounts` ADD UNIQUE KEY `index_account` (`account`) USING BTREE, ADD KEY `index_createdate` (`createdate`) USING BTREE, ADD KEY `index_createdate_agent` (`createdate`,`agent`) USING BTREE, ADD KEY `index_agent` (`agent`) USING BTREE, ADD KEY `agent_mstatus_IDX` (`agent`,`mstatus`) USING BTREE; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiAccounts') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftGameApiOrders`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameApiOrders`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
	DECLARE v_previous_date VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiOrders') ON DUPLICATE KEY UPDATE `status`= 0; 

    SET v_previous_date = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 3 MONTH), '%Y-%m-%d'); 
	SET v_base_sql = 'select old.id, old.orderid, old.money, old.status, old.type, JSON_SET(old.big_data, \'$.addScore\', old.money), old.createdate, old.updatedate, \'CNY\' currency from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'orders'; 

	SET v_dist_db = 'game_api'; 
	SET v_dist_table = 'orders'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old WHERE createdate >= \'',v_previous_date,'\''); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    
    DROP TRIGGER IF EXISTS `game_api`.`tools_orders`; 

    TRUNCATE TABLE game_api.orders; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiOrders') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftGameApiOrdersGameSys`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameApiOrdersGameSys`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiOrdersGameSys') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.id, old.curMoney, old.money, old.afterMoney, old.status, old.type, old.account, old.createdate, old.updatedate, \'CNY\' currency from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'orders_game_sys'; 

	SET v_dist_db = 'game_api'; 
	SET v_dist_table = 'orders_game_sys'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE game_api.orders_game_sys; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiOrdersGameSys') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftGameApiOrdersSys`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameApiOrdersSys`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiOrdersSys') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.id, old.curMoney, old.money, old.afterMoney, old.status, old.type, old.agent, old.createdate, old.updatedate, \'CNY\' currency from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'orders_sys'; 

	SET v_dist_db = 'game_api'; 
	SET v_dist_table = 'orders_sys'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE game_api.orders_sys; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiOrdersSys') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftGameApiSingleOrders`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameApiSingleOrders`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiSingleOrders') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.id, old.orderId, old.account, old.channelId, old.gameNo, old.curScore, old.addScore, old.newScore, old.status, old.type, old.action, NULL ref_origin_orderId, 0 retCode, \'CNY\' currency, old.createdate, old.updatedate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'single_orders'; 

	SET v_dist_db = 'game_api'; 
	SET v_dist_table = 'single_orders'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE game_api.single_orders; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameApiSingleOrders') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftGameManageRpRole`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameManageRpRole`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameManageRpRole') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.id, old.name, old.json, old.powerlist, old.other, old.isagent, old.ChannelID, old.CreateTime, NULL powergamelist from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'rp_role'; 

	SET v_dist_db = 'game_manage'; 
	SET v_dist_table = 'rp_role'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE game_manage.rp_role; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameManageRpRole') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftGameManageRpUser`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameManageRpUser`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameManageRpUser') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.id, old.UID, old.ChannelID, old.roleid, old.name, old.password, old.Nickname, old.UserStatus, old.CreateUser, old.CreateDate, old.SignIP, old.LastEditUser, old.LastEditDate, old.Mark, old.isDelete, old.LastloginTime, old.Whether, old.IdentityPassword, old.isagent, old.other, old.Forbidden, old.Timezone, old.login2FAKey from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'rp_user'; 

	SET v_dist_db = 'game_manage'; 
	SET v_dist_table = 'rp_user'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE game_manage.rp_user; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameManageRpUser') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftGameStatisticsLoginHall`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftGameStatisticsLoginHall`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameStatisticsLoginHall') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.id, old.account, old.agent, old.ip, old.ipLocal, old.info, old.os, old.browser, old.platform, old.createdate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statistics_login_hall'; 

	SET v_dist_db = 'game_statistics'; 
	SET v_dist_table = 'statistics_login_hall'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE game_statistics.statistics_login_hall; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftGameStatisticsLoginHall') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWAgent`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWAgent`()
BEGIN
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWAgent') ON DUPLICATE KEY UPDATE `status`= 0; 

	
    INSERT INTO KYDB_NEW.agent 
	SELECT
		ChannelID AS id,
		UID AS uid,
		Transfer.getTopUid(ChannelID) AS topUid,
		Accounts AS account,
		roleid AS roleId,
		UserPWD AS userPwd,
		NickName AS nickname,
		UserStatus AS userStatus,
		case MoneyType WHEN 9 THEN 17 WHEN 10 THEN 16 WHEN 11 THEN 13 WHEN 12 THEN 14 WHEN 13 THEN 15 ELSE MoneyType END AS moneyType,
		CASE sbStatus WHEN 1 THEN 2 WHEN 0 THEN 0 END AS walletType,
		ProxyRevenue AS revenue,
		IsDelete AS status,
		ChannelValue AS channelValue,
		CreateUser AS createUser,
		createdate AS createDate,
		LastloginTime AS lastLoginTime,
		AccountingFor AS accountingFor,
		BusinessAccount AS businessAccount,
		CallBackURL AS callBackType,
		Cooperation AS cooperation,
		DemoOutLink AS demoOutUrl,
		DemoLink AS demoUrl,
		Deskey AS aesKey,
		Md5key AS md5Key,
		DisBusinessAccount AS disableBusinessAccount,
		Forbidden AS disableChildAgent,
		DomainBind AS domainBind,
		exRate AS exRate,
		FormalLink AS formalUrl,
		0 AS payType,
		ISinheritwhiteIP AS isInheritWhiteIp,
		0 AS isShowPayPopUps,
		ISPushbutton AS isShowBackLobby,
		feedEnabled AS isShowFeedback,
		0 AS isShowHotGame,
		Disablelinecode AS isShowLinecode,
		0 AS isShowRevenue,
		Winloschart AS isShowWinLosChart,
		LinecodeSet AS linecodeSet,
		Loadimg AS loadImg,
		Logo AS logo,
		logourl AS logoUrl,
		Mark AS mark,
		MatchRange AS matchRange,
		CallBackLink AS offlineBackUrl,
		ProxyURL AS proxyUrl,
		publicId AS publicId,
		SingleOrSystem AS type,
		Timezone AS timeZone,
		WhiteIP AS whiteIp,
		defaultLang AS lang,
		10 AS theme,
		COALESCE(NULLIF(themeList, ''), '') AS themeList,
		rechargeURL AS rechargeUrl,
		rechargeStatus AS rechargeStatus,
		sbUrl AS sbUrl,
		convertMultiple AS convertMultiple,
		gameFrameControl AS gameFrameControl,
		gameFrameTeachControl AS gameFrameTeachControl,
		gameFullScreenControl AS gameFullScreenControl,
		gameMusicControl AS gameMusicControl,
		automatch AS autoMatch,
        1 as productLine,
        0 as gameTakesControl,
		case MoneyType WHEN 9 THEN 17 WHEN 10 THEN 16 WHEN 11 THEN 13 WHEN 12 THEN 14 WHEN 13 THEN 15 ELSE MoneyType END AS deliveryMoneyType
	FROM
		Sys_ProxyAccount
	ON DUPLICATE KEY UPDATE
	    uid = VALUES(uid),
	    topUid = VALUES(topUid),
	    account = VALUES(account),
	    roleId = VALUES(roleId),
	    userPwd = VALUES(userPwd),
	    nickname = VALUES(nickname),
	    userStatus = VALUES(userStatus),
	    moneyType = VALUES(moneyType),
	    walletType = VALUES(walletType),
	    revenue = VALUES(revenue),
	    status = VALUES(status),
	    channelValue = VALUES(channelValue),
	    createUser = VALUES(createUser),
	    createDate = VALUES(createDate),
	    lastLoginTime = VALUES(lastLoginTime),
	    accountingFor = VALUES(accountingFor),
	    businessAccount = VALUES(businessAccount),
	    callBackType = VALUES(callBackType),
	    cooperation = VALUES(cooperation),
	    demoOutUrl = VALUES(demoOutUrl),
	    demoUrl = VALUES(demoUrl),
	    aesKey = VALUES(aesKey),
	    md5Key = VALUES(md5Key),
	    disableBusinessAccount = VALUES(disableBusinessAccount),
	    disableChildAgent = VALUES(disableChildAgent),
	    domainBind = VALUES(domainBind),
	    exRate = VALUES(exRate),
	    formalUrl = VALUES(formalUrl),
	    payType = VALUES(payType),
	    isInheritWhiteIp = VALUES(isInheritWhiteIp),
	    isShowPayPopUps = VALUES(isShowPayPopUps),
	    isShowBackLobby = VALUES(isShowBackLobby),
	    isShowFeedback = VALUES(isShowFeedback),
	    isShowHotGame = VALUES(isShowHotGame),
	    isShowLinecode = VALUES(isShowLinecode),
	    isShowRevenue = VALUES(isShowRevenue),
	    isShowWinLosChart = VALUES(isShowWinLosChart),
	    linecodeSet = VALUES(linecodeSet),
	    loadImg = VALUES(loadImg),
	    logo = VALUES(logo),
	    logoUrl = VALUES(logoUrl),
	    mark = VALUES(mark),
	    matchRange = VALUES(matchRange),
	    offlineBackUrl = VALUES(offlineBackUrl),
	    proxyUrl = VALUES(proxyUrl),
	    publicId = VALUES(publicId),
	    type = VALUES(type),
	    timeZone = VALUES(timeZone),
	    whiteIp = VALUES(whiteIp),
	    lang = VALUES(lang),
	    theme = VALUES(theme),
	    themeList = VALUES(themeList),
	    rechargeUrl = VALUES(rechargeUrl),
	    rechargeStatus = VALUES(rechargeStatus),
	    sbUrl = VALUES(sbUrl),
	    convertMultiple = VALUES(convertMultiple),
	    gameFrameControl = VALUES(gameFrameControl),
	    gameFrameTeachControl = VALUES(gameFrameTeachControl),
	    gameFullScreenControl = VALUES(gameFullScreenControl),
	    gameMusicControl = VALUES(gameMusicControl),
	    autoMatch = VALUES(autoMatch),
	    productLine = VALUES(productLine),
	    gameTakesControl = VALUES(gameTakesControl),
	    deliveryMoneyType = VALUES(deliveryMoneyType); 

	
	INSERT INTO wallet.agents
	(channelId, money)
	SELECT
		agent,
		money
	FROM
		agents
	ON DUPLICATE KEY UPDATE
		money = VALUES(money); 

	
	CALL SP_SplitString(); 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWAgent') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWGameInfoStatus`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWGameInfoStatus`()
BEGIN
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWGameInfoStatus') ON DUPLICATE KEY UPDATE `status`= 0; 
    UPDATE KYDB_NEW.GameInfo SET `GameStatus` = 0; 

    INSERT INTO KYDB_NEW.GameInfo (`GameID`, `GameStatus`)
    SELECT
        GameID,
        GameStatus
    FROM  (
        SELECT
            b.gameID as GameID,
            CASE b.gameState WHEN 2 THEN 1 ELSE b.GameState END AS GameStatus
        FROM
            KYDB_NEW.GameInfo a
        JOIN
            Transfer.abSettingGameInfo b
        ON
            a.GameID = b.gameID
        WHERE
            b.serverID = 1
    ) c
    ON DUPLICATE KEY UPDATE `GameStatus` = VALUES(`GameStatus`); 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWGameInfoStatus') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWGameRoomInfoStatus`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWGameRoomInfoStatus`()
BEGIN
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWGameRoomInfoStatus') ON DUPLICATE KEY UPDATE `status`= 0; 
    UPDATE KYDB_NEW.GameRoomInfo SET `status` = 0; 

    INSERT INTO KYDB_NEW.GameRoomInfo (`ServerID`, `ServerName`, `status`)
    SELECT
        ServerID,
        ServerName,
        RoomStatus
    FROM  (
        SELECT
            b.roomID AS ServerID,
            a.ServerName AS ServerName,
            CASE b.roomState WHEN 2 THEN 1 ELSE b.roomState END AS RoomStatus
        FROM
            KYDB_NEW.GameRoomInfo a
        JOIN
            Transfer.abSettingRoomInfo b
        ON
            a.ServerID = b.roomID
        WHERE
            b.serverID = 1
    ) c
    ON DUPLICATE KEY UPDATE `status` = VALUES(`status`); 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWGameRoomInfoStatus') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWKillRate`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWKillRate`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWKillRate') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.ID, old.ChannelIDLinecode, old.KillRate, old.Type, NULL gameRoomId, old.CreateUser, old.UpdateUser, old.CreateTime, old.UpdateTime from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'Sys_KillRate'; 

	SET v_dist_db = 'KYDB_NEW'; 
	SET v_dist_table = 'Sys_KillRate'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYDB_NEW.Sys_KillRate; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWKillRate') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWProxyGameInfo`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWProxyGameInfo`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWProxyGameInfo') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.GameID, old.ChannelID, old.GameOrderBy, old.GameStatus, old.ShowLabel, old.OutLink from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'Sys_ProxyGameInfo'; 

	SET v_dist_db = 'KYDB_NEW'; 
	SET v_dist_table = 'Sys_ProxyGameInfo'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYDB_NEW.Sys_ProxyGameInfo; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWProxyGameInfo') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWProxyOrderDetails`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWProxyOrderDetails`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWProxyOrderDetails') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.OrderID, old.ChannelID, old.OrderTime, old.OrderType, old.OrderStatus, old.CurScore, old.AddScore, old.NewScore, old.OrderIP, old.CreateUser, old.OrderObject, old.ErrorMsg, NULL AddUser, old.AccountingForOrder from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'Sys_HT_ProxyOrderDetails'; 

	SET v_dist_db = 'KYDB_NEW'; 
	SET v_dist_table = 'Sys_HT_ProxyOrderDetails'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYDB_NEW.Sys_HT_ProxyOrderDetails; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWProxyOrderDetails') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWProxyRoomInfo`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWProxyRoomInfo`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWProxyRoomInfo') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'SELECT * FROM (SELECT a.RoomID,b.KindID,a.ChannelID,IFNULL(a.RoomStatus, 0) FROM Transfer.Sys_ProxyRoomInfo a JOIN KYDB_NEW.GameRoomInfo b ON a.RoomID = b.ServerID)'; 

	SET v_dist_db = 'KYDB_NEW'; 
	SET v_dist_table = 'sys_agent_game_room_info'; 

	SET v_sql = CONCAT(v_base_sql, ' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYDB_NEW.sys_agent_game_room_info; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWProxyRoomInfo') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWServersSet`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWServersSet`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWServersSet') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.SID, old.Serversaddress, old.Demo, old.Status, old.CreateTime, old.CreateUser, old.Ip, old.Type, old.number, old.game, old.Free from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'Sys_ServersSet'; 

	SET v_dist_db = 'KYDB_NEW'; 
	SET v_dist_table = 'Sys_ServersSet'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYDB_NEW.Sys_ServersSet; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
	INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWServersSet') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWUserOrderDetails`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWUserOrderDetails`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWUserOrderDetails') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.OrderID, old.OrderTime, old.ChannelID, old.UserID, old.Accounts, old.OrderType, old.CurScore, old.AddScore, old.NewScore, old.OrderIP, old.CreateUser ,\'CNY\' currency from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'Game_HT_UserOrderDetails'; 

	SET v_dist_db = 'KYDB_NEW'; 
	SET v_dist_table = 'Game_HT_UserOrderDetails'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYDB_NEW.Game_HT_UserOrderDetails; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWUserOrderDetails') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisAgentAccessGame3d`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisAgentAccessGame3d`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisAgentAccessGame3d') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.GameID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, NULL DayNewBetUsers, \'CNY\' currency, 1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'agent_access_game_3d'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'agent_access_game_3d'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.agent_access_game_3d; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisAgentAccessGame3d') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisLoginKeepGameUsers`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisLoginKeepGameUsers`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisLoginKeepGameUsers') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate,old.GameID,old.RegUsers,old.GameLoginUsers,old.PlayGameUsers,old.CR,old.QR,old.HYCR,old.HYQR,old.CellScore,old.Profit,old.Revenue,\'CNY\' currency,1 exchangeRate,old.CreateTime,old.UpdateTime from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_keep_game_users'; 

	SET v_dist_db = 'KYStatisLogin'; 
	SET v_dist_table = 'statis_keep_game_users'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatisLogin.statis_keep_game_users; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisLoginKeepGameUsers') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisProlog`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisProlog`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisProlog') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.logdate, old.proname, old.time from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'prolog'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'prolog'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.prolog; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisProlog') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordAgentHistory`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordAgentHistory`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentHistory') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.ChannelID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_history'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_history'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_record_agent_history; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentHistory') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordAgentLinecode`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordAgentLinecode`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecode') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.LineCode, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_linecode'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_linecode'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_record_agent_linecode; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecode') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordAgentLinecodeEST`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordAgentLinecodeEST`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeEST') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.LineCode, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_linecode_EST'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_linecode_EST'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_record_agent_linecode_EST; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeEST') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordAgentLinecodeGame`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordAgentLinecodeGame`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeGame') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.LineCode, old.GameID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_linecode_game'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_linecode_game'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_record_agent_linecode_game; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeGame') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordAgentLinecodeGameEST`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordAgentLinecodeGameEST`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeGameEST') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.LineCode, old.GameID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_linecode_game_EST'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_linecode_game_EST'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_record_agent_linecode_game_EST; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentLinecodeGameEST') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRecordAgentMonth`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRecordAgentMonth`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentMonth') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, old.ActiveUsers_reguser, \'CNY\' currency, 1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_month'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_month'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_record_agent_month; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRecordAgentMonth') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRoomKd`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRoomKd`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_create_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
	DECLARE v_month VARCHAR(6); 
    DECLARE v_month_counter INT DEFAULT 0; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomKd') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 2 MONTH), '%Y%m'); 

	SET v_month = DATE_FORMAT(NOW(), '%Y%m'); 
	WHILE v_month_counter < 3 DO
		SET v_base_sql = 'select old.StatisDate, old.Type, old.MatchType, old.GameType, old.RoomType, old.KDValidBet, old.KDWin, \'CNY\' currency, 1 exchangeRate, old.KDGames, old.KDUsers, old.KDvalue, NULL TotalUsers_userType, old.TotalUsers, old.CreateDate from '; 

		SET v_src_db = 'Transfer'; 
		SET v_src_table = CONCAT('statis_room_kd_', v_month); 

		SET v_dist_db = 'KYStatis'; 
		SET v_dist_table = CONCAT('statis_room_kd_', v_month); 

		set v_create_sql=CONCAT('
			CREATE TABLE IF NOT EXISTS `',v_dist_db,'`.`',v_dist_table,'` (
				`StatisDate` date NOT NULL COMMENT ''统计日期'',
				`Type` tinyint(2) NOT NULL COMMENT ''1新玩家 2老玩家'',
				`MatchType` tinyint(2) NOT NULL COMMENT ''追放类型 4追杀 5放水'',
				`GameType` varchar(64) NOT NULL COMMENT ''游戏'',
				`RoomType` int(11) NOT NULL COMMENT ''房间'',
				`KDValidBet` varchar(255) DEFAULT NULL COMMENT ''追放玩家投注'',
				`KDWin` varchar(255) DEFAULT NULL COMMENT ''追放金额'',
				`currency` varchar(20) NOT NULL COMMENT ''幣別'',
				`exchangeRate` decimal(20,5) NOT NULL COMMENT ''汇率'',
				`KDGames` int(11) DEFAULT NULL COMMENT ''追放局数'',
				`KDUsers` int(11) DEFAULT NULL COMMENT ''追放人数(不分币别)'',
				`KDvalue` varchar(172) NOT NULL COMMENT ''KDvalue'',
				`TotalUsers_userType` int(11) DEFAULT NULL COMMENT ''房间总老/新玩家投注人数(不分币别)'',
				`TotalUsers` int(11) DEFAULT NULL COMMENT ''房间总投注人数(不分币别)'',
				`CreateDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT ''创建时间'',
				PRIMARY KEY (`StatisDate`,`Type`,`MatchType`,`GameType`,`RoomType`,`KDvalue`,`currency`) USING BTREE
			) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
			'); 


		SET @v_sql = v_create_sql; 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_month_counter = v_month_counter + 1; 
		SET v_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_month_counter MONTH), '%Y%m'); 
	END WHILE; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomKd') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRoomMonitoring`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRoomMonitoring`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomMonitoring') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.createdate, old.roomId, old.validBet, old.revenue, \'CNY\' currency, 1 exchangeRate, old.profit, old.avgOnline, old.maxOnline, old.logCount, old.activeCount, old.gameNum, old.singleTime, old.robotProfit, old.killRobotProfit, old.revRobotProfit, old.dayKillGold, old.dayDiveGold, old.gameTime, old.killGameNum, old.diveGameNum, old.normalValidbet, old.gameId  from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_room_monitoring'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_room_monitoring'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old GROUP BY createdate, roomId, gameId'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_room_monitoring; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomMonitoring') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRoomMonitoringReguser`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRoomMonitoringReguser`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomMonitoringReguser') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.createdate, old.roomId, old.validBet, old.revenue, \'CNY\' currency, 1 exchangeRate, old.profit, old.avgOnline, old.maxOnline, old.logCount, old.activeCount, old.gameNum, old.singleTime, old.robotProfit, old.killRobotProfit, old.revRobotProfit, old.dayKillGold, old.dayDiveGold, old.gameTime, old.killGameNum, old.diveGameNum, old.normalValidbet, old.gameId  from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_room_monitoring_reguser'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_room_monitoring_reguser'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old GROUP BY createdate, roomId, gameId'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_room_monitoring_reguser; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomMonitoringReguser') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRoomRecordtypeData`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRoomRecordtypeData`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_create_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
	DECLARE v_month VARCHAR(6); 
    DECLARE v_month_counter INT DEFAULT 0; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomRecordtypeData') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 2 MONTH), '%Y%m'); 

	SET v_month = DATE_FORMAT(NOW(), '%Y%m'); 
	WHILE v_month_counter < 3 DO
		SET v_base_sql = 'select old.StatisDate, old.KindId, old.ServerId, old.oldSumValid, old.oldSumProfit, old.oldSumGameNum, old.oldSumActiveUser, old.oldNormalValid, old.oldNormalProfit, old.oldNormalGameNum, old.oldNormalActiveUser, old.oldKillValid, old.oldKillProfit, old.oldKillGameNum, old.oldKillActiveUser, old.oldClassKillValid, old.oldClassKillProfit, old.oldClassKillGameNum, old.oldClassKillActiveUser, old.oldRevValid, old.oldRevProfit, old.oldRevGameNum, old.oldRevActiveUser, old.oldClassRevValid, old.oldClassRevProfit, old.oldClassRevGameNum, old.oldClassRevActiveUser, old.oldPtkillValid, old.oldPtkillProfit, old.oldPtkillGameNum, old.oldPtkillActiveUser, old.newSumValid, old.newSumProfit, old.newSumGameNum, old.newSumActiveUser, old.newNormalValid, old.newNormalProfit, old.newNormalGameNum, old.newNormalActiveUser, old.newKillValid, old.newKillProfit, old.newKillGameNum, old.newKillActiveUser, old.newClassKillValid, old.newClassKillProfit, old.newClassKillGameNum, old.newClassKillActiveUser, old.newRevValid, old.newRevProfit, old.newRevGameNum, old.newRevActiveUser, old.newClassRevValid, old.newClassRevProfit, old.newClassRevGameNum, old.newClassRevActiveUser, old.newPtkillValid, old.newPtkillProfit, old.newPtkillGameNum, old.newPtkillActiveUser, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.Updatetime from '; 

		SET v_src_db = 'Transfer'; 
		SET v_src_table = CONCAT('statis_room_recordtype_data_', v_month); 

		SET v_dist_db = 'KYStatis'; 
		SET v_dist_table = CONCAT('statis_room_recordtype_data_', v_month); 

		set v_create_sql=CONCAT('
			CREATE TABLE IF NOT EXISTS `',v_dist_db,'`.`',v_dist_table,'` (
				StatisDate date NOT NULL,
				KindId int(11) NOT NULL DEFAULT ''0'',
				ServerId int(11) NOT NULL DEFAULT ''0'',
				oldSumValid bigint(20) not null default ''0'',
				oldSumProfit bigint(20) not null default ''0'',
				oldSumGameNum bigint(20) not null default ''0'',
				oldSumActiveUser int(11) not null default ''0'',
				oldNormalValid bigint(20) NOT NULL DEFAULT ''0'',
				oldNormalProfit bigint(20) NOT NULL DEFAULT ''0'',
				oldNormalGameNum bigint(20) NOT NULL DEFAULT ''0'',
				oldNormalActiveUser int(11) NOT NULL DEFAULT ''0'',
				oldKillValid bigint(20) NOT NULL DEFAULT ''0'',
				oldKillProfit bigint(20) NOT NULL DEFAULT ''0'',
				oldKillGameNum bigint(20) NOT NULL DEFAULT ''0'',
				oldKillActiveUser int(11) NOT NULL DEFAULT ''0'',
				oldClassKillValid bigint(20) NOT NULL DEFAULT ''0'',
				oldClassKillProfit bigint(20) NOT NULL DEFAULT ''0'',
				oldClassKillGameNum bigint(20) NOT NULL DEFAULT ''0'',
				oldClassKillActiveUser int(11) NOT NULL DEFAULT ''0'',
				oldRevValid bigint(20) NOT NULL DEFAULT ''0'',
				oldRevProfit bigint(20) NOT NULL DEFAULT ''0'',
				oldRevGameNum bigint(20) NOT NULL DEFAULT ''0'',
				oldRevActiveUser int(11) NOT NULL DEFAULT ''0'',
				oldClassRevValid bigint(20) NOT NULL DEFAULT ''0'',
				oldClassRevProfit bigint(20) NOT NULL DEFAULT ''0'',
				oldClassRevGameNum bigint(20) NOT NULL DEFAULT ''0'',
				oldClassRevActiveUser int(11) NOT NULL DEFAULT ''0'',
				oldPtkillValid bigint(20) NOT NULL DEFAULT ''0'',
				oldPtkillProfit bigint(20) NOT NULL DEFAULT ''0'',
				oldPtkillGameNum bigint(20) NOT NULL DEFAULT ''0'',
				oldPtkillActiveUser int(11) NOT NULL DEFAULT ''0'',
				newSumValid bigint(20) not null default ''0'',
				newSumProfit bigint(20) not null default ''0'',
				newSumGameNum bigint(20) not null default ''0'',
				newSumActiveUser int(11) not null default ''0'',
				newNormalValid bigint(20) NOT NULL DEFAULT ''0'',
				newNormalProfit bigint(20) NOT NULL DEFAULT ''0'',
				newNormalGameNum bigint(20) NOT NULL DEFAULT ''0'',
				newNormalActiveUser int(11) NOT NULL DEFAULT ''0'',
				newKillValid bigint(20) NOT NULL DEFAULT ''0'',
				newKillProfit bigint(20) NOT NULL DEFAULT ''0'',
				newKillGameNum bigint(20) NOT NULL DEFAULT ''0'',
				newKillActiveUser int(11) NOT NULL DEFAULT ''0'',
				newClassKillValid bigint(20) NOT NULL DEFAULT ''0'',
				newClassKillProfit bigint(20) NOT NULL DEFAULT ''0'',
				newClassKillGameNum bigint(20) NOT NULL DEFAULT ''0'',
				newClassKillActiveUser int(11) NOT NULL DEFAULT ''0'',
				newRevValid bigint(20) NOT NULL DEFAULT ''0'',
				newRevProfit bigint(20) NOT NULL DEFAULT ''0'',
				newRevGameNum bigint(20) NOT NULL DEFAULT ''0'',
				newRevActiveUser int(11) NOT NULL DEFAULT ''0'',
				newClassRevValid bigint(20) NOT NULL DEFAULT ''0'',
				newClassRevProfit bigint(20) NOT NULL DEFAULT ''0'',
				newClassRevGameNum bigint(20) NOT NULL DEFAULT ''0'',
				newClassRevActiveUser int(11) NOT NULL DEFAULT ''0'',
				newPtkillValid bigint(20) NOT NULL DEFAULT ''0'',
				newPtkillProfit bigint(20) NOT NULL DEFAULT ''0'',
				newPtkillGameNum bigint(20) NOT NULL DEFAULT ''0'',
				newPtkillActiveUser int(11) NOT NULL DEFAULT ''0'',
				currency varchar(20) NOT NULL COMMENT ''幣別'',
				exchangeRate decimal(20,5) NOT NULL COMMENT ''汇率'',
				CreateTime datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
				Updatetime datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
				KEY idx_statisdate (StatisDate,KindId,ServerID,currency) USING BTREE
				) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4; 
				'); 

		SET @v_sql = v_create_sql; 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_month_counter = v_month_counter + 1; 
		SET v_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL v_month_counter MONTH), '%Y%m'); 
	END WHILE; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomRecordtypeData') ON DUPLICATE KEY UPDATE `status`= 1; 


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
DROP PROCEDURE IF EXISTS `ShiftKYStatisRoomRobot`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisRoomRobot`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomRobot') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.createdate, old.ServerId, old.AIID, \'CNY\' currency, 1 exchangeRate, old.DayWin, old.DayLost, old.MonthWin, old.MonthLost, old.Win, old.Lost, old.DayProfit, old.MonthProfit, old.Profit, old.DayWinNum, old.DayLostNum, old.DayHeNum, old.DayTotal, old.MonthWinNum, old.MonthLostNum, old.MonthHeNum, old.MonthTotal, old.WinNum, old.LostNum, old.HeNum, old.TotalNum, old.AllDayProfit, old.AllMonthProfit, old.AllProfit, old.AllDayWinNum, old.AllDayNum, old.AllMonthWinNum, old.AllMonthNum, old.AllTotalWinNum, old.AllTotalNum from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_room_robot'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_room_robot'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_room_robot; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisRoomRobot') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisAgent`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisAgent`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisAgent') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.agent, old.count, old.cretetime, NULL mstatus0, NULL mstatus1, NULL mstatus2, NULL mstatus3 from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_agent'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_agent'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_agent; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisAgent') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisMaxOnline`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisMaxOnline`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisMaxOnline') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.statisdate, old.maxOnline, old.createtime from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_max_online'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_max_online'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statis_max_online; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisMaxOnline') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisRecordAgentAll`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisRecordAgentAll`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentAll') ON DUPLICATE KEY UPDATE `status`= 0; 
	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_all'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_all'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

  	BEGIN
  	  DECLARE CONTINUE HANDLER FOR 1505 BEGIN END; 
  	  ALTER TABLE KYStatis.statis_record_agent_all REMOVE PARTITIONING; 
  	END; 

    TRUNCATE TABLE KYStatis.statis_record_agent_all; 

    PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentAll') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisRecordAgentAllEST`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisRecordAgentAllEST`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentAllEST') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_all_EST'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_all_EST'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

  	BEGIN
  	  DECLARE CONTINUE HANDLER FOR 1505 BEGIN END; 
      ALTER TABLE KYStatis.statis_record_agent_all_EST REMOVE PARTITIONING; 
  	END; 

    TRUNCATE TABLE KYStatis.statis_record_agent_all_EST; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentAllEST') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisRecordAgentGame`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisRecordAgentGame`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentGame') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.GameID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, NULL DayNewBetUsers, \'CNY\' currency, 1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_game'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_game'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

  	BEGIN
  	  DECLARE CONTINUE HANDLER FOR 1505 BEGIN END; 
      ALTER TABLE KYStatis.statis_record_agent_game REMOVE PARTITIONING; 
  	END; 

    TRUNCATE TABLE KYStatis.statis_record_agent_game; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentGame') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisRecordAgentGameEST`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisRecordAgentGameEST`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentGameEST') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelID, old.GameID, old.WinGold, old.LostGold, old.CellScore, old.Revenue, old.WinNum, old.LostNum, old.ActiveUsers, \'CNY\' currency, 1 exchangeRate from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statis_record_agent_game_EST'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statis_record_agent_game_EST'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

  	BEGIN
  	  DECLARE CONTINUE HANDLER FOR 1505 BEGIN END; 
      ALTER TABLE KYStatis.statis_record_agent_game_EST REMOVE PARTITIONING; 
  	END; 

    TRUNCATE TABLE KYStatis.statis_record_agent_game_EST; 

    PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisRecordAgentGameEST') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisStatisusers`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisStatisusers`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisusers') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.StatisDate, old.ChannelId, old.Y_NonLoginUsers, old.M_NonLoginUsers, old.H_NonLoginUsers, old.Y_RegUsers, old.M_RegUsers, old.H_RegUsers, old.Y_PayUsers, old.M_PayUsers, old.H_PayUsers, old.NextRegisterUser, old.NextLoginUser, old.ValidNextRegisterUser, old.ValidNextLoginUser, old.SevenRegisterUser, old.SevenLoginUser, old.ValidSevenRegisterUser, old.ValidSevenLoginUser, old.MonthRegisterUser, old.MonthLoginUser, old.ValidMonthRegisterUser, old.ValidMonthLoginUser, old.DayNewBetUsers, old.dayNewLogin, old.Y_NewLoginUsers from '; 

	SET v_src_db = 'Transfer'; 
	SET v_src_table = 'statisusers'; 

	SET v_dist_db = 'KYStatis'; 
	SET v_dist_table = 'statisusers'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatis.statisusers; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisStatisusers') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersAllGames`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersAllGames`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
	DECLARE v_current_month VARCHAR(6); 
	DECLARE v_last_month VARCHAR(6); 
	DECLARE v_previous_month VARCHAR(6); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersAllGames') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_current_month = DATE_FORMAT(NOW(), '%Y%m'); 
	SET v_last_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 MONTH), '%Y%m'); 
	SET v_previous_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 2 MONTH), '%Y%m'); 

	SET v_base_sql = 'select old.StatisDate, old.Account, old.ChannelID, old.LineCode, 0 AllBet, old.CellScore, old.WinGold, old.LostGold, old.Revenue, old.WinNum, old.LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from '; 

	SET v_src_db = 'Transfer_KYStatisUsers'; 
	SET v_src_table = CONCAT('statis_allgames', v_previous_month, '_users'); 

	SET v_dist_db = 'KYStatisUsers'; 
	SET v_dist_table = CONCAT('statis_allgames', v_previous_month, '_users'); 
	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		call KYStatisUsers.sp_createStatisticsUsersTable(v_dist_table, 0); 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 

	SET v_src_table = CONCAT('statis_allgames', v_last_month, '_users'); 
	SET v_dist_table = CONCAT('statis_allgames', v_last_month, '_users'); 
	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		call KYStatisUsers.sp_createStatisticsUsersTable(v_dist_table, 0); 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 

	SET v_src_table = CONCAT('statis_allgames', v_current_month, '_users'); 
	SET v_dist_table = CONCAT('statis_allgames', v_current_month, '_users'); 
	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		call KYStatisUsers.sp_createStatisticsUsersTable(v_dist_table, 0); 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersAllGames') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersAllUsers`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersAllUsers`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersAllUsers') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_base_sql = 'select old.Account, old.ChannelID, old.LineCode, 0 AllBet, old.CellScore, old.WinGold, old.LostGold, old.Revenue, old.WinNum, old.LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from '; 

	SET v_src_db = 'Transfer_KYStatisUsers'; 
	SET v_src_table = 'statis_all_users'; 

	SET v_dist_db = 'KYStatisUsers'; 
	SET v_dist_table = 'statis_all_users'; 

	set v_sql = concat('select count(*) into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

        TRUNCATE TABLE KYStatisUsers.statis_all_users; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
        INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersAllUsers') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersByGame`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersByGame`()
BEGIN
	DECLARE done INT DEFAULT FALSE; 
	DECLARE GameParameter VARCHAR(255); 
	DECLARE v_current_month VARCHAR(6); 
	DECLARE v_last_month VARCHAR(6); 
	DECLARE v_previous_month VARCHAR(6); 
		
	DECLARE cur CURSOR FOR 
		SELECT gi.GameParameter
		FROM KYDB_NEW.GameInfo gi; 

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersByGame') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_current_month = DATE_FORMAT(NOW(), '%Y%m'); 
	SET v_last_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 MONTH), '%Y%m'); 
	SET v_previous_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 2 MONTH), '%Y%m'); 

	OPEN cur; 

	read_loop: LOOP
		FETCH cur INTO GameParameter; 
		IF done THEN
			LEAVE read_loop; 
		END IF; 

		IF (GameParameter = 'holdem') THEN
			SET GameParameter = 'dzpk'; 
		END IF; 

		call ShiftKYStatisUsersByGame_shift(GameParameter, v_previous_month); 
		call ShiftKYStatisUsersByGame_shift(GameParameter, v_last_month); 
		call ShiftKYStatisUsersByGame_shift(GameParameter, v_current_month); 
	END LOOP; 

	CLOSE cur; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersByGame') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersByGame_shift`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersByGame_shift`(IN `in_GameParameter` VARCHAR(255), IN `in_statismonth` VARCHAR(6))
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

	SET v_src_db = 'Transfer_KYStatisUsers'; 
	SET v_src_table = CONCAT('statis_', in_GameParameter, in_statismonth, '_users'); 

	SET v_dist_db = 'KYStatisUsers'; 
	SET v_dist_table = CONCAT('statis_', in_GameParameter, in_statismonth, '_users'); 

	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		call KYStatisUsers.sp_createStatisticsUsersTable(v_dist_table, 0); 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_sql = CONCAT('select old.StatisDate, old.Account, old.ChannelID, old.LineCode, 0 Allbet, SUM(old.CellScore) CellScore, SUM(old.WinGold) WinGold, SUM(old.LostGold) LostGold, SUM(old.Revenue) Revenue, SUM(old.WinNum) WinNum, SUM(old.LostNum) LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from ', v_src_db,'.', v_dist_table,' old GROUP BY old.StatisDate, old.Account, old.LineCode'); 
		SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersByMonth`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersByMonth`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
	DECLARE v_current_month VARCHAR(6); 
	DECLARE v_last_month VARCHAR(6); 
	DECLARE v_previous_month VARCHAR(6); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersByMonth') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_current_month = DATE_FORMAT(NOW(), '%Y%m'); 
	SET v_last_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 MONTH), '%Y%m'); 
	SET v_previous_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 2 MONTH), '%Y%m'); 

	SET v_base_sql = 'select old.Account, old.ChannelID, old.LineCode, 0 AllBet, old.CellScore, old.WinGold, old.LostGold, old.Revenue, old.WinNum, old.LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from '; 

	SET v_src_db = 'Transfer_KYStatisUsers'; 
	SET v_src_table = CONCAT('statis_month', v_previous_month, '_users'); 

	SET v_dist_db = 'KYStatisUsers'; 
	SET v_dist_table = CONCAT('statis_month', v_previous_month, '_users'); 
	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		call KYStatisUsers.sp_createStatisticsUsersTable(v_dist_table, 1); 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 

	SET v_src_table = CONCAT('statis_month', v_last_month, '_users'); 
	SET v_dist_table = CONCAT('statis_month', v_last_month, '_users'); 
	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		call KYStatisUsers.sp_createStatisticsUsersTable(v_dist_table, 1); 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 

	SET v_src_table = CONCAT('statis_month', v_current_month, '_users'); 
	SET v_dist_table = CONCAT('statis_month', v_current_month, '_users'); 
	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		call KYStatisUsers.sp_createStatisticsUsersTable(v_dist_table, 1); 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersByMonth') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersByRoom`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersByRoom`()
BEGIN
	DECLARE done INT DEFAULT FALSE; 
	DECLARE GameParameter VARCHAR(255); 
	DECLARE v_current_month VARCHAR(6); 
	DECLARE v_last_month VARCHAR(6); 
	DECLARE v_previous_month VARCHAR(6); 

	DECLARE cur CURSOR FOR
		SELECT gi.GameParameter
		FROM KYDB_NEW.GameInfo gi; 

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersByRoom') ON DUPLICATE KEY UPDATE `status`= 0; 
	SET v_current_month = DATE_FORMAT(NOW(), '%Y%m'); 
	SET v_last_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 MONTH), '%Y%m'); 
	SET v_previous_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 2 MONTH), '%Y%m'); 

	OPEN cur; 

	read_loop: LOOP
		FETCH cur INTO GameParameter; 
		IF done THEN
			LEAVE read_loop; 
		END IF; 

		IF (GameParameter = 'holdem') THEN
			SET GameParameter = 'dzpk'; 
		END IF; 

		call ShiftKYStatisUsersByRoom_shift(GameParameter, v_previous_month); 
		call ShiftKYStatisUsersByRoom_shift(GameParameter, v_last_month); 
		call ShiftKYStatisUsersByRoom_shift(GameParameter, v_current_month); 
	END LOOP; 

	CLOSE cur; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersByRoom') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersByRoom_shift`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersByRoom_shift`(IN `in_GameParameter` VARCHAR(255), IN `in_statismonth` VARCHAR(6))
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 


	SET v_src_db = 'Transfer_KYStatisUsers'; 
	SET v_src_table = CONCAT('statis_', in_GameParameter, in_statismonth, '_users_room'); 

	SET v_dist_db = 'KYStatisUsers'; 
	SET v_dist_table = CONCAT('statis_', in_GameParameter, in_statismonth, '_users_room'); 

	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		call KYStatisUsers.sp_createStatisticsUsersTable(v_dist_table, 2); 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


		SET v_sql = CONCAT('select old.StatisDate, old.Account, old.ChannelID, old.ServerID, old.CellScore, old.WinGold, old.LostGold, old.Revenue, old.WinNum, old.LostNum, 0 isNew, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from ', v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersESTAllGames`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersESTAllGames`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
	DECLARE v_current_month VARCHAR(6); 
	DECLARE v_last_month VARCHAR(6); 
	DECLARE v_previous_month VARCHAR(6); 
	
    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
    END; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersESTAllGames') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_current_month = DATE_FORMAT(NOW(), '%Y%m'); 
	SET v_last_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 MONTH), '%Y%m'); 
	SET v_previous_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 2 MONTH), '%Y%m'); 

	SET v_base_sql = 'select old.StatisDate, old.Account, old.ChannelID, old.LineCode, 0 AllBet, old.CellScore, old.WinGold, old.LostGold, old.Revenue, old.WinNum, old.LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from '; 

	SET v_src_db = 'Transfer_KYStatisUsers_EST'; 
	SET v_src_table = CONCAT('statis_allgames', v_previous_month, '_users'); 

	SET v_dist_db = 'KYStatisUsers_EST'; 
	SET v_dist_table = CONCAT('statis_allgames', v_previous_month, '_users'); 
	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		BEGIN
			call KYStatisUsers_EST.sp_createStatisticsUsersTable(v_dist_table, 0); 
		END; 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 

	SET v_src_table = CONCAT('statis_allgames', v_last_month, '_users'); 
	SET v_dist_table = CONCAT('statis_allgames', v_last_month, '_users'); 
	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		BEGIN
			call KYStatisUsers_EST.sp_createStatisticsUsersTable(v_dist_table, 0); 
		END; 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 

	SET v_src_table = CONCAT('statis_allgames', v_current_month, '_users'); 
	SET v_dist_table = CONCAT('statis_allgames', v_current_month, '_users'); 
	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		BEGIN
			call KYStatisUsers_EST.sp_createStatisticsUsersTable(v_dist_table, 0); 
		END; 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 


		SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
	END IF; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersESTAllGames') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersESTByGame`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersESTByGame`()
BEGIN
	DECLARE done INT DEFAULT FALSE; 
	DECLARE GameParameter VARCHAR(255); 
	DECLARE v_current_month VARCHAR(6); 
	DECLARE v_last_month VARCHAR(6); 
	DECLARE v_previous_month VARCHAR(6); 

	DECLARE cur CURSOR FOR
		SELECT gi.GameParameter
		FROM KYDB_NEW.GameInfo gi; 

	DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersESTByGame') ON DUPLICATE KEY UPDATE `status`= 0; 

	SET v_current_month = DATE_FORMAT(NOW(), '%Y%m'); 
	SET v_last_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 1 MONTH), '%Y%m'); 
	SET v_previous_month = DATE_FORMAT(DATE_SUB(NOW(), INTERVAL 2 MONTH), '%Y%m'); 

	OPEN cur; 

	read_loop: LOOP
		FETCH cur INTO GameParameter; 
		IF done THEN
			LEAVE read_loop; 
		END IF; 

		IF (GameParameter = 'holdem') THEN
			SET GameParameter = 'dzpk'; 
		END IF; 

		call ShiftKYStatisUsersESTByGame_shift(GameParameter, v_previous_month); 
		call ShiftKYStatisUsersESTByGame_shift(GameParameter, v_last_month); 
		call ShiftKYStatisUsersESTByGame_shift(GameParameter, v_current_month); 
	END LOOP; 

	CLOSE cur; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersESTByGame') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersESTByGame_shift`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersESTByGame_shift`(IN `in_GameParameter` VARCHAR(255), IN `in_statismonth` VARCHAR(6))
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

    DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
    BEGIN
    END; 

	SET v_src_db = 'Transfer_KYStatisUsers_EST'; 
	SET v_src_table = CONCAT('statis_', in_GameParameter, in_statismonth, '_users'); 

	SET v_dist_db = 'KYStatisUsers_EST'; 
	SET v_dist_table = CONCAT('statis_', in_GameParameter, in_statismonth, '_users'); 

	set v_sql = concat('select count(*)  into @v_exist from information_schema.`TABLES` where TABLE_SCHEMA = \'', v_src_db,'\' AND TABLE_NAME = \'', v_src_table, '\''); 

	set @v_sql = v_sql; 
	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

	IF @v_exist > 0 THEN
		BEGIN
			call KYStatisUsers_EST.sp_createStatisticsUsersTable(v_dist_table, 0); 
		END; 

        
        SET @v_sql = CONCAT('TRUNCATE TABLE ', v_dist_db, '.', v_dist_table); 
		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 

		SET v_sql = CONCAT('select old.StatisDate, old.Account, old.ChannelID, old.LineCode, 0 Allbet, SUM(old.CellScore) CellScore, SUM(old.WinGold) WinGold, SUM(old.LostGold) LostGold, SUM(old.Revenue) Revenue, SUM(old.WinNum) WinNum, SUM(old.LostNum) LostNum, \'CNY\' currency, 1 exchangeRate, old.CreateTime, old.UpdateTime from ', v_src_db,'.', v_dist_table,' old GROUP BY old.StatisDate, old.Account, old.LineCode'); 
		SET v_sql = CONCAT('INSERT IGNORE INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
		SET @v_sql = v_sql; 

		PREPARE stmt FROM @v_sql; 
		EXECUTE stmt; 
		DEALLOCATE PREPARE stmt; 
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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersESTEventLogRecord`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersESTEventLogRecord`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersESTEventLogRecord') ON DUPLICATE KEY UPDATE `status`= 0; 

    SET v_base_sql = 'select old.id, old.sp_name, old.starttime, old.endtime, old.exectime, old.mark, old.createtime from '; 

	SET v_src_db = 'Transfer_KYStatisUsers_EST'; 
	SET v_src_table = 'event_log_record'; 

	SET v_dist_db = 'KYStatisUsers_EST'; 
	SET v_dist_table = 'event_log_record'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatisUsers_EST.event_log_record; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersESTEventLogRecord') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftKYStatisUsersEventLogRecord`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYStatisUsersEventLogRecord`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
	DECLARE v_exist INT; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersEventLogRecord') ON DUPLICATE KEY UPDATE `status`= 0; 

    SET v_base_sql = 'select old.id, old.sp_name, old.starttime, old.endtime, old.exectime, old.mark, old.createtime from '; 

	SET v_src_db = 'Transfer_KYStatisUsers'; 
	SET v_src_table = 'event_log_record'; 

	SET v_dist_db = 'KYStatisUsers'; 
	SET v_dist_table = 'event_log_record'; 

	SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
	SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' ', v_sql); 
	SET @v_sql = v_sql; 

    TRUNCATE TABLE KYStatisUsers.event_log_record; 

	PREPARE stmt FROM @v_sql; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYStatisUsersEventLogRecord') ON DUPLICATE KEY UPDATE `status`= 1; 

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
DROP PROCEDURE IF EXISTS `ShiftOrdersRecordAgentOrders`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftOrdersRecordAgentOrders`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
    DECLARE currentDate DATE; 
    DECLARE startDate DATE; 
    DECLARE endDate DATE; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftOrdersRecordAgentOrders') ON DUPLICATE KEY UPDATE `status`= 0; 

    SET currentDate = CURDATE(); 
    SET startDate = DATE_SUB(currentDate, INTERVAL 3 MONTH); 
    SET endDate = currentDate; 

	SET v_base_sql = 'select old.OrderID, old.ChannelID, old.OrderTime, old.OrderType, old.OrderStatus, old.CurScore, old.AddScore, old.NewScore, old.OrderIP, old.CreateUser, \'CNY\' trx_currency, old.AddScore as trx_addScore, old.ErrorMsg, old.createdate from '; 

	SET v_src_db = 'Transfer_orders_record'; 

	SET v_dist_db = 'orders_record'; 
	SET v_dist_table = 'agent_orders'; 

    TRUNCATE TABLE orders_record.agent_orders; 

    WHILE startDate <= endDate DO
		SET v_src_table = CONCAT('agent_orders',DATE_FORMAT(startDate, '%Y%m%d')); 
		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = v_src_db AND TABLE_NAME = v_src_table) THEN
			SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
			SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' (`OrderID`,`ChannelID`,`OrderTime`,`OrderType`,`OrderStatus`,`CurScore`,`AddScore`,`NewScore`,`OrderIP`,`CreateUser`,`trx_currency`,`trx_addScore`,`ErrorMsg`,`createdate`) ', v_sql); 
			SET @v_sql = v_sql; 

			PREPARE stmt FROM @v_sql; 
			EXECUTE stmt; 
			DEALLOCATE PREPARE stmt; 

		END IF; 
        SET startDate = DATE_ADD(startDate, INTERVAL 1 DAY); 
    END WHILE; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftOrdersRecordAgentOrders') ON DUPLICATE KEY UPDATE `status`= 1; 
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
DROP PROCEDURE IF EXISTS `ShiftOrdersRecordPlayerOrders`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftOrdersRecordPlayerOrders`()
BEGIN
	DECLARE v_sql LONGTEXT; 
	DECLARE v_base_sql LONGTEXT; 
    DECLARE currentDate DATE; 
    DECLARE startDate DATE; 
    DECLARE endDate DATE; 
	DECLARE v_src_db VARCHAR(255); 
	DECLARE v_src_table VARCHAR(255); 
	DECLARE v_dist_db VARCHAR(255); 
	DECLARE v_dist_table VARCHAR(255); 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftOrdersRecordPlayerOrders') ON DUPLICATE KEY UPDATE `status`= 0; 

    SET currentDate = CURDATE(); 
    SET startDate = DATE_SUB(currentDate, INTERVAL 3 MONTH); 
    SET endDate = currentDate; 

	SET v_base_sql = 'select old.OrderID, old.ChannelID, old.OrderTime, old.OrderType, old.CurScore, old.AddScore, old.NewScore, old.OrderIP, old.CreateUser, old.OrderStatus, old.ErrorMsg, old.RetCode, old.DealStatus, \'CNY\' currency, old.createdate from '; 

	SET v_src_db = 'Transfer_orders_record'; 

	SET v_dist_db = 'orders_record'; 
	SET v_dist_table = 'player_orders'; 

    TRUNCATE TABLE orders_record.player_orders; 

    WHILE startDate <= endDate DO
		SET v_src_table = CONCAT('player_orders',DATE_FORMAT(startDate, '%Y%m%d')); 
		IF EXISTS(SELECT * FROM information_schema.TABLES WHERE TABLE_SCHEMA = v_src_db AND TABLE_NAME = v_src_table) THEN
			SET v_sql = CONCAT(v_base_sql, v_src_db,'.', v_src_table,' old'); 
			SET v_sql = CONCAT('INSERT INTO ', v_dist_db,'.', v_dist_table, ' (`OrderID`,`ChannelID`,`OrderTime`,`OrderType`,`CurScore`,`AddScore`,`NewScore`,`OrderIP`,`CreateUser`,`OrderStatus`,`ErrorMsg`,`RetCode`,`DealStatus`,`currency`,`createdate`) ', v_sql); 
			SET @v_sql = v_sql; 

			PREPARE stmt FROM @v_sql; 
			EXECUTE stmt; 
			DEALLOCATE PREPARE stmt; 

		END IF; 
        SET startDate = DATE_ADD(startDate, INTERVAL 1 DAY); 
    END WHILE; 

    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftOrdersRecordPlayerOrders') ON DUPLICATE KEY UPDATE `status`= 1; 
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

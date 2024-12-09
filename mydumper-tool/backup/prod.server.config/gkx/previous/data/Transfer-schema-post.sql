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

	SET v_base_sql = 'select old.id, old.account, old.agent, old.mstatus, old.mark, old.lineCode, old.lastlogintime, old.createdate, old.updatedate, old.firstBetTime from '; 

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
DROP PROCEDURE IF EXISTS `ShiftKYDBNEWAgent`;
CREATE DEFINER=`root`@`%` PROCEDURE `ShiftKYDBNEWAgent`()
BEGIN
    INSERT INTO Transfer.process_record (`sp_name`) VALUES ('ShiftKYDBNEWAgent') ON DUPLICATE KEY UPDATE `status`= 0; 

	
    INSERT INTO KYDB_NEW.agent (id, uid, topUid, account, roleId, userPwd, nickname, userStatus, moneyType, walletType, revenue, status, channelValue, createUser, createDate, lastLoginTime, accountingFor, businessAccount, callBackType, cooperation, demoOutUrl, demoUrl, aesKey, md5Key, disableBusinessAccount, disableChildAgent, domainBind, exRate, formalUrl, payType, isInheritWhiteIp, isShowPayPopUps, isShowBackLobby, isShowFeedback, isShowHotGame, isShowLinecode, isShowRevenue, isShowWinLosChart, linecodeSet, loadImg, logo, logoUrl, mark, matchRange, offlineBackUrl, proxyUrl, publicId, type, timeZone, whiteIp, lang, theme, themeList, rechargeUrl, rechargeStatus, sbUrl, convertMultiple, gameFrameControl, gameFrameTeachControl, gameFullScreenControl, gameMusicControl, autoMatch, productLine, gameTakesControl, jackpotSupport, jackpotNotice, jackpotAllowGrand, insuranceType, jackpotOpenDate, deliveryMoneyType,gameCurrencyControl,gamePlayedListControl,scrollOrientation)
SELECT
    ChannelID AS id,
    UID AS uid,
    Transfer.getTopUid(ChannelID) AS topUid,
    Accounts AS account,
    roleid AS roleId,
    UserPWD AS userPwd,
    NickName AS nickname,
    UserStatus AS userStatus,
    CASE MoneyType
        WHEN 5 THEN 30
        WHEN 7 THEN 36
        WHEN 9 THEN 37
        WHEN 10 THEN 16
        WHEN 11 THEN 13
        WHEN 12 THEN 14
        WHEN 14 THEN 33
        WHEN 15 THEN 29
        WHEN 16 THEN 21
        WHEN 17 THEN 28
        ELSE MoneyType
    END AS moneyType,
    CASE sbStatus
        WHEN 1 THEN 2
        WHEN 0 THEN 0
    END AS walletType,
    ProxyRevenue AS revenue,
    IsDelete AS status,
    ChannelValue AS channelValue,
    CreateUser AS createUser,
    Createdate AS createDate,
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
    WhiteIPInherit AS isInheritWhiteIp,
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
    '1' AS lang,
    CASE defaultSkin
        WHEN '[1]' THEN 4
        WHEN '[2]' THEN 3
        WHEN '[4]' THEN 3
        WHEN '[101]' THEN 3
		WHEN NULL THEN 3
        ELSE 3
    END AS theme,
    Transfer.skinsToThemeList(skins, defaultSkin) AS themeList,
    null AS rechargeUrl,
    null AS rechargeStatus,
    sbUrl AS sbUrl,
    1 AS convertMultiple,
    1 AS gameFrameControl,
    1 AS gameFrameTeachControl,
    1 AS gameFullScreenControl,
    1 AS gameMusicControl,
    automatch AS autoMatch,
    1 as productLine,
    0 as gameTakesControl,
    JackpotSupport as jackpotSupport,
    JackpotNotice as jackpotNotice,
    JackpotAllowGrand as jackpotAllowGrand,
    InsuranceType as insuranceType,
    JackpotOpenDate as jackpotOpenDate,
	CASE MoneyType
        WHEN 5 THEN 30
        WHEN 7 THEN 36
        WHEN 9 THEN 37
        WHEN 10 THEN 16
        WHEN 11 THEN 13
        WHEN 12 THEN 14
        WHEN 14 THEN 33
        WHEN 15 THEN 29
        WHEN 16 THEN 21
        ELSE MoneyType
    END AS deliveryMoneyType,
    1 as gameCurrencyControl,
	1 as gamePlayedListControl,
	0 as scrollOrientation
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
		jackpotSupport = VALUES(jackpotSupport),
		jackpotNotice = VALUES(jackpotNotice),
		jackpotAllowGrand = VALUES(jackpotAllowGrand),
		insuranceType = VALUES(insuranceType),
		jackpotOpenDate = VALUES(jackpotOpenDate),
		deliveryMoneyType = VALUES(deliveryMoneyType),
		gameCurrencyControl= VALUES(gameCurrencyControl),
		gamePlayedListControl= VALUES(gamePlayedListControl),
		scrollOrientation= VALUES(scrollOrientation); 

	
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

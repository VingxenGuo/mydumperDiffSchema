/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE IF NOT EXISTS `agents`(
`agent` int,
`parent` int,
`moneyType` int,
`money` int,
`whiteip` int,
`status` int,
`proxyurl` int,
`desKey` int,
`md5Key` int,
`callbackurl` int,
`lineCodes` int,
`exRate` int,
`publicId` int,
`pumping` int,
`backmain` int,
`oflinebackurl` int,
`feedEnabled` int,
`logourl` int,
`timezone` int,
`isPayPopUps` int,
`isAutoPay` int,
`walletType` int,
`sboStatus` int,
`createdate` int,
`accounts` int,
`nickName` int,
`createUser` int,
`accountingFor` int,
`sportAccountingFor` int,
`lastLoginTime` int,
`cooperation` int,
`businessAccount` int,
`singleOrSystem` int
) ENGINE=MEMORY;

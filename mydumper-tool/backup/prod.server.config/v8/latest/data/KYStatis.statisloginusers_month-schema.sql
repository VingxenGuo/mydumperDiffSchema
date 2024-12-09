/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statisloginusers_month` (
  `Accounts` varchar(190) NOT NULL DEFAULT '',
  `ChannelId` int(10) DEFAULT NULL COMMENT '代理Id',
  PRIMARY KEY (`Accounts`),
  UNIQUE KEY `index_Accounts_ChannelID` (`Accounts`,`ChannelId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

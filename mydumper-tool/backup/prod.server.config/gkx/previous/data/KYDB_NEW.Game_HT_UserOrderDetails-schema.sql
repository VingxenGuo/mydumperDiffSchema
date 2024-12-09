/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Game_HT_UserOrderDetails` (
  `OrderID` bigint(20) NOT NULL DEFAULT '0',
  `OrderTime` datetime DEFAULT NULL,
  `ChannelID` int(10) DEFAULT NULL,
  `UserID` int(10) DEFAULT NULL,
  `Accounts` varchar(190) DEFAULT NULL,
  `OrderType` int(5) DEFAULT NULL,
  `CurScore` bigint(20) DEFAULT NULL,
  `AddScore` bigint(20) DEFAULT NULL,
  `NewScore` bigint(20) DEFAULT NULL,
  `OrderIP` varchar(50) DEFAULT NULL,
  `CreateUser` varchar(50) DEFAULT NULL,
  `currency` varchar(50) NOT NULL COMMENT '币别',
  PRIMARY KEY (`OrderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

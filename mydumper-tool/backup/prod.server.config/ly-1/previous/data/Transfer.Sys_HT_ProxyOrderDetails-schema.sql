/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Sys_HT_ProxyOrderDetails` (
  `OrderID` varchar(50) NOT NULL,
  `ChannelID` int(10) DEFAULT NULL,
  `OrderTime` datetime DEFAULT NULL,
  `OrderType` int(5) DEFAULT NULL,
  `OrderStatus` int(5) DEFAULT NULL,
  `CurScore` bigint(20) DEFAULT NULL,
  `AddScore` bigint(20) DEFAULT NULL,
  `NewScore` bigint(20) DEFAULT NULL,
  `OrderIP` varchar(50) DEFAULT NULL,
  `CreateUser` varchar(50) DEFAULT NULL,
  `OrderObject` varchar(50) DEFAULT NULL,
  `ErrorMsg` varchar(500) DEFAULT NULL,
  `AccountingForOrder` decimal(11,2) DEFAULT NULL,
  PRIMARY KEY (`OrderID`),
  KEY `index_ordertime` (`OrderTime`) USING BTREE,
  KEY `index_ordertime_channelid` (`OrderTime`,`ChannelID`) USING BTREE,
  KEY `index_ordertime_ordertype_createuser` (`OrderTime`,`OrderType`,`CreateUser`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

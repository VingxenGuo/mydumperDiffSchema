/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `single_orders20231220` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `OrderID` varchar(190) DEFAULT NULL,
  `ChannelID` int(11) DEFAULT NULL,
  `OrderTime` datetime DEFAULT NULL,
  `GameNo` varchar(50) DEFAULT NULL,
  `OrderType` int(11) DEFAULT NULL,
  `OrderAction` int(11) DEFAULT NULL,
  `CurScore` bigint(20) DEFAULT NULL,
  `AddScore` bigint(20) DEFAULT NULL,
  `NewScore` bigint(20) DEFAULT NULL,
  `OrderIP` varchar(255) DEFAULT NULL,
  `CreateUser` varchar(190) DEFAULT NULL,
  `OrderStatus` int(11) DEFAULT NULL,
  `ErrorMsg` varchar(200) DEFAULT NULL,
  `RetCode` int(11) DEFAULT '0',
  `DealStatus` int(11) DEFAULT '0',
  `createdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_orderid` (`OrderID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `IpKillManagement` (
  `SID` int(11) NOT NULL AUTO_INCREMENT,
  `Serversaddress` varchar(50) DEFAULT NULL,
  `Demo` varchar(500) DEFAULT NULL,
  `Status` int(11) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL,
  `CreateUser` varchar(50) DEFAULT NULL,
  `Ip` varchar(50) DEFAULT NULL,
  `Type` int(11) DEFAULT NULL,
  `number` int(11) DEFAULT NULL,
  `game` varchar(50) DEFAULT NULL,
  `Account` varchar(20) DEFAULT NULL,
  PRIMARY KEY (`SID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

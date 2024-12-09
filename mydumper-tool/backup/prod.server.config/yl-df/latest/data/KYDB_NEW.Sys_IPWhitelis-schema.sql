/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Sys_IPWhitelis` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `IPAddress` varchar(50) DEFAULT NULL,
  `Mark` varchar(500) DEFAULT NULL,
  `CreateUser` varchar(50) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL,
  `IsDelete` int(11) DEFAULT NULL,
  `ChannelID` int(11) DEFAULT NULL,
  `Isdeveloper` int(11) DEFAULT NULL,
  `AddUser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Game_Bulletin` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `StartTime` datetime DEFAULT NULL,
  `EndTime` datetime DEFAULT NULL,
  `Btype` int(11) DEFAULT NULL,
  `Title` varchar(100) NOT NULL,
  `Conntent` varchar(500) DEFAULT NULL,
  `SendInterval` int(11) DEFAULT NULL,
  `GameID` int(11) DEFAULT NULL,
  `CreateUser` varchar(50) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL,
  `LastEditUser` varchar(50) DEFAULT NULL,
  `LastEditTime` datetime DEFAULT NULL,
  `BulletinStatus` int(11) DEFAULT NULL,
  `AB` varchar(10) DEFAULT NULL,
  `IsDelete` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

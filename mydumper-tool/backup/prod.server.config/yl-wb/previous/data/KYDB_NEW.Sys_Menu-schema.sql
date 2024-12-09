/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Sys_Menu` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `MenuTitle` varchar(50) DEFAULT NULL,
  `MneuTitleEN` varchar(50) DEFAULT NULL,
  `MenuLink` varchar(100) DEFAULT NULL,
  `PID` int(11) DEFAULT NULL,
  `MenuIcon` varchar(100) DEFAULT NULL,
  `Mark` longtext,
  `IsDelete` int(11) DEFAULT '0',
  `Status` bit(1) DEFAULT b'1',
  `Sort` int(11) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

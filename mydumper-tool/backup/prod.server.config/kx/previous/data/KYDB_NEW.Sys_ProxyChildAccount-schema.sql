/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Sys_ProxyChildAccount` (
  `ChildID` int(10) NOT NULL AUTO_INCREMENT,
  `ChannelID` int(10) DEFAULT NULL,
  `Accounts` varchar(50) DEFAULT NULL,
  `UserPWD` varchar(50) DEFAULT NULL,
  `NickName` varchar(50) DEFAULT NULL,
  `UserStatus` int(5) DEFAULT NULL,
  `CreateUser` varchar(50) DEFAULT NULL,
  `CreateDate` datetime DEFAULT NULL,
  `LoginIP` varchar(50) DEFAULT NULL,
  `Mark` varchar(100) DEFAULT NULL,
  `IsDelete` int(5) DEFAULT NULL,
  `LastloginTime` datetime DEFAULT NULL,
  `UID` int(11) DEFAULT '0',
  `Forbidden` int(11) DEFAULT '0',
  `PChannelID` int(11) DEFAULT '0',
  `ISChild` int(11) DEFAULT '0',
  PRIMARY KEY (`ChildID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

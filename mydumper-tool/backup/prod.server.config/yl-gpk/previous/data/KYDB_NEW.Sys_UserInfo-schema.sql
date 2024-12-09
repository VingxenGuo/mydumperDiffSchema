/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Sys_UserInfo` (
  `AccountID` int(11) NOT NULL AUTO_INCREMENT,
  `UID` int(11) DEFAULT NULL,
  `Accounts` varchar(50) NOT NULL,
  `UserPwd` varchar(50) DEFAULT NULL,
  `NickName` varchar(50) NOT NULL,
  `UserStatus` int(11) DEFAULT NULL,
  `CreateUser` varchar(50) DEFAULT NULL,
  `CreateDate` datetime DEFAULT NULL,
  `SignIP` varchar(50) DEFAULT NULL,
  `LastEditUser` varchar(50) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `UserType` int(11) DEFAULT NULL,
  `Mark` varchar(300) DEFAULT NULL,
  `IsDelete` int(11) DEFAULT NULL,
  `LastloginTime` datetime DEFAULT NULL,
  `Whether` int(11) DEFAULT NULL,
  `IdentityPassword` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`AccountID`),
  UNIQUE KEY `index_Accounts` (`Accounts`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

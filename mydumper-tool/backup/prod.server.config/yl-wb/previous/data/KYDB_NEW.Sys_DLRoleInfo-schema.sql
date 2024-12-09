/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Sys_DLRoleInfo` (
  `RoleID` int(11) NOT NULL AUTO_INCREMENT,
  `RoleName` varchar(50) NOT NULL,
  `ChannelID` int(11) DEFAULT '0',
  `RoleMark` varchar(500) DEFAULT NULL,
  `CreateUser` varchar(50) DEFAULT NULL,
  `CreateDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `LastEditUser` varchar(50) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT NULL,
  `IsDelete` int(11) DEFAULT '0',
  PRIMARY KEY (`RoleID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

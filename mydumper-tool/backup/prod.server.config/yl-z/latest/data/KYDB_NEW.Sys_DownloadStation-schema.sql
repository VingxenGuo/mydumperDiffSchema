/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Sys_DownloadStation` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ChineseAPI` varchar(200) DEFAULT NULL COMMENT '中文版API文档',
  `EnglishAPI` varchar(200) DEFAULT NULL COMMENT '英文版API文档',
  `AlllanguagesAPI` varchar(200) DEFAULT NULL COMMENT '各语言API',
  `Lockerdecodedemo` varchar(200) DEFAULT NULL COMMENT '加密解密代码',
  `GameNestDemo` varchar(200) DEFAULT NULL COMMENT '游戏嵌套Demo文档',
  `Artresources` varchar(200) DEFAULT NULL COMMENT '美术资源',
  `CreateUser` varchar(50) DEFAULT NULL,
  `UpdateUser` varchar(50) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL,
  `UpdateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `logoCustomizationData` (
  `aId` int(11) NOT NULL AUTO_INCREMENT,
  `infoId` int(10) unsigned NOT NULL,
  `themeId` tinyint(3) unsigned NOT NULL,
  `screen` tinyint(3) unsigned NOT NULL COMMENT '1:橫屏, 2:豎屏',
  `watermark` tinyint(3) unsigned NOT NULL COMMENT '0:關, 1:開',
  `nickname` varchar(50) DEFAULT NULL,
  `loadingTip` varchar(50) DEFAULT NULL,
  `icon` varchar(100) DEFAULT NULL,
  `loading` varchar(100) DEFAULT NULL,
  `main` varchar(100) DEFAULT NULL,
  `preload` varchar(100) DEFAULT NULL,
  `desk` varchar(100) DEFAULT NULL,
  `user` varchar(50) NOT NULL,
  `updateTime` datetime NOT NULL,
  `createTime` datetime NOT NULL,
  PRIMARY KEY (`aId`),
  KEY `infoId` (`infoId`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4;

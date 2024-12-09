/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `logoCustomizationSwitchLog` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `infoId` int(10) unsigned NOT NULL,
  `state` tinyint(3) unsigned NOT NULL COMMENT '0:關, 1:開',
  `user` varchar(30) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `infoId` (`infoId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

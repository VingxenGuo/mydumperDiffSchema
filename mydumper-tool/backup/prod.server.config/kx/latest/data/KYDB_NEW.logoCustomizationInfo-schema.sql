/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `logoCustomizationInfo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(3) unsigned NOT NULL COMMENT '1:agent, 2:linecode',
  `target` varchar(50) NOT NULL COMMENT '對應type',
  `parentAgentId` int(10) unsigned NOT NULL COMMENT '父代理id',
  `fee` int(10) unsigned NOT NULL COMMENT '月租費',
  `state` tinyint(3) unsigned NOT NULL COMMENT '0:關, 1:開',
  `updateDate` datetime NOT NULL,
  `createDate` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `target` (`target`),
  KEY `parentAgentId` (`parentAgentId`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

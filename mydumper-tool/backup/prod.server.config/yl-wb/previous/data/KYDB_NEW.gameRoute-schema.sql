/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `gameRoute` (
  `rowId` int(11) NOT NULL AUTO_INCREMENT,
  `type` enum('0','1','2') NOT NULL COMMENT '0一般线路 1代理线路',
  `agent` int(11) DEFAULT NULL COMMENT '代理',
  `url` varchar(2000) DEFAULT NULL COMMENT 'domain',
  `ws` text COMMENT 'websocket',
  `id` varchar(100) DEFAULT NULL COMMENT 'id',
  `status` enum('0','1') NOT NULL DEFAULT '0' COMMENT '0停用 1啟用',
  `machineName` enum('blue','green') DEFAULT NULL COMMENT '機器代號',
  `inherit` tinyint(1) unsigned NOT NULL DEFAULT '0' COMMENT '0:無 1:有',
  `inheritAgentId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT '繼承對象的agentId',
  PRIMARY KEY (`rowId`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

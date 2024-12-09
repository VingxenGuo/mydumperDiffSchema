/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `online_game` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `gameId` int(11) DEFAULT NULL COMMENT '游戏id',
  `value` int(255) DEFAULT NULL COMMENT '在线人数',
  `ip` varchar(50) DEFAULT NULL,
  `createtime` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `abId` tinyint(4) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_createtime` (`createtime`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

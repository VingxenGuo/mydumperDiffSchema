/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `gamerecord_fivestars` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `big_data` longtext NOT NULL COMMENT '游戏记录数据',
  `ip` varchar(50) DEFAULT NULL COMMENT '游戏服务器ip',
  `createtime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '创建时间',
  KEY `index_id_createtime` (`id`,`createtime`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

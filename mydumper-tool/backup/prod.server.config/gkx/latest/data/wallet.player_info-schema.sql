/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `player_info` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account` varchar(190) NOT NULL COMMENT '会员账号',
  `agent` int(11) NOT NULL COMMENT '代理商编号',
  `rid` bigint(20) unsigned DEFAULT NULL COMMENT '会员账号b端rid',
  `payload` longtext COMMENT '其他資訊',
  `create_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_account` (`account`) USING HASH,
  KEY `index_rid` (`rid`)
) ENGINE=InnoDB AUTO_INCREMENT=9937 DEFAULT CHARSET=utf8mb4;

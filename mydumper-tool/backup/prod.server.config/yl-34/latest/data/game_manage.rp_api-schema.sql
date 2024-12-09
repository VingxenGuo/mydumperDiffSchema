/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `rp_api` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `rp_power_id` bigint(20) DEFAULT NULL COMMENT '對應rp power ID',
  `action` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL COMMENT 'API路由',
  `method` varchar(32) COLLATE utf8_bin NOT NULL DEFAULT 'GET' COMMENT 'HTTP Method',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_rp_power_id` (`rp_power_id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

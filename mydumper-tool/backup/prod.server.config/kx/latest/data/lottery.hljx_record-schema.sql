/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `hljx_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `issue_no` varchar(190) NOT NULL COMMENT '开奖期号',
  `raw_data` longtext NOT NULL COMMENT '开奖原始记录',
  `ip` varchar(50) DEFAULT NULL COMMENT '開獎服务器ip',
  `draw_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '开奖时间',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_issue_no` (`issue_no`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

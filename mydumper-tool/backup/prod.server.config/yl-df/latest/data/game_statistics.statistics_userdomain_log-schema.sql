/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statistics_userdomain_log` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `agent` int(11) NOT NULL COMMENT '代理编号',
  `account` varchar(190) NOT NULL COMMENT '玩家账号',
  `domain` varchar(190) NOT NULL,
  `ip` varchar(190) NOT NULL,
  `statisDate` date NOT NULL COMMENT '创建日期',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `index_statis_date` (`statisDate`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

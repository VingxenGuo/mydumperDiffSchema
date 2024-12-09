/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `sys_blackListConfig` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `registerDays` int(11) DEFAULT '0' COMMENT '注册天数',
  `scoreProportion` decimal(8,2) DEFAULT '0.00' COMMENT '上下分比',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `createUser` varchar(190) NOT NULL COMMENT '新增者',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `createDate` (`createDate`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

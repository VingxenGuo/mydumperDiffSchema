/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `dayrecord_vvip_users` (
  `StatisDate` date NOT NULL COMMENT '统计日期',
  `account` varchar(190) NOT NULL COMMENT '玩家账号',
  `lastlogintime` timestamp NULL DEFAULT NULL COMMENT '最后登录时间',
  `AccountCreateTime` timestamp NULL DEFAULT NULL COMMENT '会员帐号创建时间',
  `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`StatisDate`,`account`) USING BTREE,
  KEY `index_statisDate` (`StatisDate`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

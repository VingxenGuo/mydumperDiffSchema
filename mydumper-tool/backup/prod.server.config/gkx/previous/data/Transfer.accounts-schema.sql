/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `accounts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account` varchar(190) CHARACTER SET utf8mb4 NOT NULL COMMENT '玩家账号',
  `agent` int(11) DEFAULT NULL,
  `mstatus` int(11) DEFAULT '0' COMMENT '玩家状态 0正常 1封号2黑名单3白名单',
  `mark` varchar(100) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT '备注',
  `lineCode` varchar(200) CHARACTER SET utf8mb4 DEFAULT NULL COMMENT 'lineCode',
  `lastlogintime` timestamp NULL DEFAULT NULL COMMENT '最后登录时间',
  `firstBetTime` timestamp NULL DEFAULT NULL COMMENT '首次下注时间',
  `createdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updatedate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `setKillmoney` int(11) DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_account` (`account`) USING HASH,
  KEY `index_createdate` (`createdate`) USING BTREE,
  KEY `index_createdate_agent` (`createdate`,`agent`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

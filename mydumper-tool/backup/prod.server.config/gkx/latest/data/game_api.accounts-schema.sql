/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `accounts` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account` varchar(190) NOT NULL COMMENT '玩家账号',
  `agent` int(11) DEFAULT NULL,
  `mstatus` int(11) DEFAULT '0' COMMENT '玩家状态 0正常 1封号2黑名单3白名单',
  `mark` varchar(100) DEFAULT NULL COMMENT '备注',
  `lineCode` varchar(200) DEFAULT NULL COMMENT 'lineCode',
  `lastlogintime` timestamp NULL DEFAULT NULL COMMENT '最后登录时间',
  `createdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updatedate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `firstBetTime` timestamp NULL DEFAULT NULL COMMENT '首次下注时间',
  `PTDStatus` tinyint(1) NOT NULL DEFAULT '0' COMMENT '平台放水 0: 关闭 1: 放水',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `index_account` (`account`) USING BTREE,
  KEY `index_createdate` (`createdate`) USING BTREE,
  KEY `index_createdate_agent` (`createdate`,`agent`) USING BTREE,
  KEY `index_agent` (`agent`) USING BTREE,
  KEY `agent_mstatus_IDX` (`agent`,`mstatus`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=11074 DEFAULT CHARSET=utf8mb4;

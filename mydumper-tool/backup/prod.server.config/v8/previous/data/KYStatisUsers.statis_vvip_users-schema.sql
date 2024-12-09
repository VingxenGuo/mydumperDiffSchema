/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_vvip_users` (
  `StatisDate` date NOT NULL,
  `Account` varchar(100) NOT NULL,
  `ChannelID` int(11) DEFAULT NULL,
  `LineCode` varchar(100) NOT NULL DEFAULT '',
  `CellScore` bigint(20) DEFAULT '0' COMMENT '有效投注',
  `WinGold` bigint(20) DEFAULT '0' COMMENT '赢钱',
  `LostGold` bigint(20) DEFAULT '0' COMMENT '输钱',
  `Revenue` bigint(20) DEFAULT '0' COMMENT '抽水',
  `WinNum` int(11) DEFAULT '0' COMMENT '赢钱局数(包含和局)',
  `LostNum` int(11) DEFAULT '0' COMMENT '输钱局数',
  `lastlogintime` timestamp NULL DEFAULT NULL COMMENT '最后登录时间',
  `AccountCreateTime` timestamp NULL DEFAULT NULL COMMENT '会员帐号创建时间',
  `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`StatisDate`,`Account`,`LineCode`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

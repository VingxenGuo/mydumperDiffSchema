/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `finance_dielivery_currency_detail` (
  `statisDate` varchar(7) NOT NULL COMMENT '统计时间',
  `channelId` int(11) NOT NULL DEFAULT '0' COMMENT '代理ID',
  `cellScore` bigint(20) DEFAULT '0' COMMENT '期间有效投注',
  `profit` bigint(20) DEFAULT '0' COMMENT '期间输赢',
  `sumProfit` bigint(20) DEFAULT '0' COMMENT '整条线期间输赢',
  `timeZone` int(11) DEFAULT '0' COMMENT '时区 0：北京时间  1：美东时间',
  `createTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `currency` varchar(50) NOT NULL COMMENT '币别',
  `financeExchangeRate` decimal(20,5) NOT NULL COMMENT '汇率',
  `category` int(11) NOT NULL DEFAULT '0' COMMENT '類別分類 (0 = ALL), (1 = 平台遊戲), (2 = 外部遊戲), (3 = 體育)',
  PRIMARY KEY (`statisDate`,`channelId`,`currency`,`category`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

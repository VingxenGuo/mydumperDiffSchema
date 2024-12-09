/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `finance_dielivery_detail` (
  `StatisDate` date NOT NULL COMMENT '统计时间',
  `ChannelID` int(11) NOT NULL DEFAULT '0' COMMENT '代理ID',
  `ChannelName` varchar(100) DEFAULT NULL COMMENT '代理名称',
  `NickName` varchar(100) DEFAULT NULL COMMENT '代理昵称',
  `AccountingFor` decimal(11,2) DEFAULT '0.00' COMMENT '占成',
  `CellScore` bigint(20) DEFAULT '0' COMMENT '期间有效投注',
  `Profit` bigint(20) DEFAULT '0' COMMENT '期间输赢',
  `SumProfit` bigint(20) DEFAULT '0' COMMENT '整条线期间输赢',
  `TimeZone` int(11) DEFAULT '0' COMMENT '时区 0：北京时间  1：美东时间',
  `CreateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `jpMoney` int(20) DEFAULT '0' COMMENT '当前代理期间总奖金支出',
  `sumJpMoney` int(20) DEFAULT '0' COMMENT '整条代理线期间总奖金支出',
  `category` int(11) NOT NULL DEFAULT '0' COMMENT '類別分類 (0 = ALL), (1 = 平台遊戲), (2 = 外部遊戲), (3 = 體育)',
  PRIMARY KEY (`StatisDate`,`ChannelID`,`category`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

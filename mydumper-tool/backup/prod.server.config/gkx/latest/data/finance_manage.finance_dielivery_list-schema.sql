/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `finance_dielivery_list` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `StatisDate` varchar(7) NOT NULL,
  `ChannelID` int(11) NOT NULL DEFAULT '0' COMMENT '代理ID',
  `ReceiveChannelID` int(11) NOT NULL DEFAULT '0',
  `LevelID` int(11) NOT NULL DEFAULT '0' COMMENT '梯度代理ID',
  `ChannelName` varchar(100) NOT NULL COMMENT '代理名称',
  `NickName` varchar(100) DEFAULT NULL COMMENT '代理昵称',
  `AccountingFor` decimal(11,2) DEFAULT '0.00' COMMENT '占成',
  `CellScore` bigint(20) DEFAULT '0' COMMENT '期间有效投注',
  `Profit` bigint(20) DEFAULT '0' COMMENT '期间输赢',
  `SumProfit` bigint(20) DEFAULT '0' COMMENT '整条线期间输赢',
  `TimeZone` int(11) DEFAULT '0' COMMENT '时区 0：北京时间  1：美东时间',
  `SpecialMoney` bigint(20) DEFAULT '0' COMMENT '赔付金/扣除/优惠',
  `Remark` text COMMENT '原由',
  `Status` int(11) DEFAULT '0' COMMENT '状态 0:未生成  1:生成 2:发送 3:已冲账',
  `CreateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '报表生成时间',
  `CheckTime` datetime DEFAULT NULL COMMENT '报表确认生成时间',
  `SendTime` datetime DEFAULT NULL COMMENT '发送时间',
  `UpdateTime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `ref_deliveryMoneyType` varchar(50) DEFAULT NULL COMMENT '交收币别 备注: 此表皆为CNY 此栏位为参考',
  `ref_deliveryExchangeRate` decimal(20,5) DEFAULT NULL COMMENT '交收汇率 备注: 此表皆为CNY 此栏位为参考',
  `sumJpInsuranceMoney` bigint(20) DEFAULT '0' COMMENT '整条代理线期间奖池保险金',
  `jpInsuranceMoney` bigint(20) DEFAULT '0' COMMENT '当前代理期间奖池保险金',
  `insuranceType` tinyint(1) DEFAULT '0' COMMENT '保险费收款类型 0:先收 1:后收',
  `jackpotOpenDate` datetime DEFAULT NULL COMMENT '奖池开启时间',
  `jpMoney` int(20) DEFAULT '0' COMMENT '当前代理期间总奖金支出',
  `sumJpMoney` int(20) DEFAULT '0' COMMENT '整条代理线期间总奖金支出',
  `category` int(11) NOT NULL DEFAULT '0' COMMENT '類別分類 (0 = ALL), (1 = 平台遊戲), (2 = 外部遊戲), (3 = 體育)',
  PRIMARY KEY (`id`,`category`),
  KEY `index_StatisDate_channelid` (`StatisDate`,`ChannelID`) USING BTREE,
  KEY `index_UpdateTime` (`UpdateTime`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=1150 DEFAULT CHARSET=utf8mb4;

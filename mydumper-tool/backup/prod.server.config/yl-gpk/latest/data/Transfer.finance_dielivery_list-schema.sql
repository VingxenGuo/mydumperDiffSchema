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
  PRIMARY KEY (`id`),
  KEY `index_StatisDate_channelid` (`StatisDate`,`ChannelID`),
  KEY `index_UpdateTime` (`UpdateTime`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

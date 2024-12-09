/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statisusers` (
  `StatisDate` date NOT NULL COMMENT '统计时间',
  `ChannelId` int(10) NOT NULL DEFAULT '0' COMMENT '代理ID',
  `Y_NonLoginUsers` int(10) DEFAULT '0' COMMENT '昨日不重复登录',
  `M_NonLoginUsers` int(10) DEFAULT '0' COMMENT '当月不重复登录',
  `H_NonLoginUsers` int(10) DEFAULT '0' COMMENT '历史不重复登录',
  `Y_RegUsers` int(10) DEFAULT '0' COMMENT '昨日注册',
  `M_RegUsers` int(10) DEFAULT '0' COMMENT '当月注册',
  `H_RegUsers` int(10) DEFAULT '0' COMMENT '历史注册',
  `Y_PayUsers` int(10) NOT NULL DEFAULT '0' COMMENT '昨日带钱进平台的玩家',
  `M_PayUsers` int(10) DEFAULT '0' COMMENT '当月带钱进平台的玩家',
  `H_PayUsers` int(10) DEFAULT '0' COMMENT '历史带钱进平台的玩家',
  `NextRegisterUser` int(10) NOT NULL DEFAULT '0' COMMENT '前天注册玩家',
  `NextLoginUser` int(10) DEFAULT '0' COMMENT '前天注册昨日登录玩家',
  `ValidNextRegisterUser` int(10) DEFAULT '0' COMMENT '前天注册并下注的玩家',
  `ValidNextLoginUser` int(10) DEFAULT '0' COMMENT '前天注册并下注，昨日又登录的玩家',
  `SevenRegisterUser` int(10) DEFAULT '0' COMMENT '七天前注册玩家',
  `SevenLoginUser` int(10) DEFAULT '0' COMMENT '七天前注册昨日登录玩家',
  `ValidSevenRegisterUser` int(10) DEFAULT '0' COMMENT '七天前注册并下注的玩家',
  `ValidSevenLoginUser` int(10) DEFAULT '0' COMMENT '七天前注册并下注，昨日又登录的玩家',
  `MonthRegisterUser` int(10) DEFAULT '0' COMMENT '一个月前注册的玩家',
  `MonthLoginUser` int(10) DEFAULT '0' COMMENT '一个月前注册昨日登录的玩家',
  `ValidMonthRegisterUser` int(10) DEFAULT '0' COMMENT '一个月前注册并下注的玩家',
  `ValidMonthLoginUser` int(10) DEFAULT '0' COMMENT '一个月前注册并下注，昨日又登录的玩家',
  `DayNewBetUsers` int(11) DEFAULT '0' COMMENT '当天注册并且投注人数',
  `dayNewLogin` int(11) DEFAULT '0',
  PRIMARY KEY (`StatisDate`,`ChannelId`),
  KEY `index_statisdate` (`StatisDate`) USING BTREE,
  KEY `index_statisdate_channelid` (`StatisDate`,`ChannelId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

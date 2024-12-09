/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `game_record` (
  `agent` varchar(100) NOT NULL COMMENT '代理',
  `account` varchar(100) NOT NULL COMMENT '代理傳的玩家account',
  `sboAccount` varchar(100) NOT NULL COMMENT '經過sbo轉換的玩家account',
  `productType` int(11) NOT NULL COMMENT '1-Sports 5-Virtual Sports 10-Live Coin',
  `refNo` varchar(100) NOT NULL COMMENT '投注编号',
  `sportsType` varchar(100) DEFAULT NULL COMMENT '下注的体育类型',
  `odds` float DEFAULT NULL COMMENT '下注的赔率',
  `oddsStyle` varchar(1) DEFAULT NULL COMMENT '下注的赔率类别 M-Malay odds, H-HongKong odds, E-Euro odds, I-Indonesia odds',
  `stake` decimal(10,2) DEFAULT NULL COMMENT '玩家的投注金',
  `actualStake` decimal(10,2) DEFAULT NULL COMMENT '玩家的实际投注金。在特别的下注赔率会与注金(stake)不同',
  `currency` varchar(3) DEFAULT NULL COMMENT '币别',
  `status` varchar(10) DEFAULT NULL COMMENT '玩家的注单状态',
  `netTurnoverByActualStake` decimal(10,2) DEFAULT NULL COMMENT '玩家的有效投注额',
  `winlost` decimal(10,2) DEFAULT NULL COMMENT '玩家的注单净赢',
  `turnover` decimal(10,2) DEFAULT NULL COMMENT '玩家的流水',
  `isHalfWonLose` tinyint(1) DEFAULT NULL COMMENT '是否为半场获胜或半场失败',
  `isLive` tinyint(1) DEFAULT NULL COMMENT '是否为现场赛事',
  `maxWinWithoutActualStake` decimal(10,2) DEFAULT NULL COMMENT '注单未清算，将回传当前不包含注金(ActualStake)的最大净赢。 当注单清算时，将回传当前不包含注金(ActualStake)的预估净赢。',
  `ip` varchar(100) DEFAULT NULL COMMENT '玩家下注的ip',
  `sportType` varchar(100) DEFAULT NULL COMMENT '运动类型',
  `isSystemTagRisky` tinyint(1) DEFAULT NULL COMMENT '注单是否被风控检测到',
  `voidReason` varchar(100) DEFAULT NULL COMMENT '注单退款/取消之原因',
  `isCustomerTagRisky` tinyint(1) DEFAULT NULL COMMENT '玩家是否被风控检测到',
  `topDownline` varchar(100) DEFAULT NULL COMMENT '直属下线的用户名/自己的用户名,如果注单是下线的，会显示属于你直属下线的用户名,如果注单是自己的，会显示自己的用户名',
  `orderTime` datetime DEFAULT NULL COMMENT '玩家下注的时间',
  `winLostDate` datetime DEFAULT NULL COMMENT '注单的归帐日。(格式为日期请忽略时间部分"000000")(仅在注单结算后显示)',
  `settleTime` datetime DEFAULT NULL COMMENT '注单最后状态改变的时间',
  `modifyDate` datetime DEFAULT NULL COMMENT '修改日期',
  `createTime` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`productType`,`refNo`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

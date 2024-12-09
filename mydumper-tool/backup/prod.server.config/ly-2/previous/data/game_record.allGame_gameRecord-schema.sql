/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `allGame_gameRecord` (
  `Accounts` varchar(190) NOT NULL COMMENT '代理ID_玩家账号',
  `ServerID` int(11) unsigned NOT NULL COMMENT '服务器ID',
  `RoomType` tinyint(1) unsigned NOT NULL COMMENT '房间类型',
  `KindID` int(11) unsigned NOT NULL COMMENT '游戏ID',
  `TableID` bigint(20) unsigned DEFAULT NULL COMMENT '桌号',
  `ChairID` tinyint(1) unsigned DEFAULT NULL COMMENT '座位号',
  `UserCount` int(11) DEFAULT NULL COMMENT '人数',
  `HandCard` varchar(1000) DEFAULT NULL COMMENT '手牌',
  `CellScore` bigint(20) unsigned DEFAULT NULL COMMENT '有效投注额',
  `AllBet` bigint(20) unsigned DEFAULT NULL COMMENT '总投注',
  `Profit` bigint(20) DEFAULT NULL COMMENT '输赢金额',
  `KillProfit` bigint(20) DEFAULT NULL,
  `DiveProfit` bigint(20) DEFAULT NULL,
  `NormalProfit` bigint(20) DEFAULT NULL,
  `CurScore` bigint(20) DEFAULT NULL COMMENT '玩家身上剩余筹码',
  `TakeScore` bigint(20) DEFAULT NULL COMMENT '玩家携带金额',
  `Revenue` bigint(20) DEFAULT NULL COMMENT '抽水',
  `GameStartTime` timestamp NULL DEFAULT NULL COMMENT '游戏开始时间',
  `GameEndTime` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '游戏结束时间',
  `CardValue` varchar(1000) DEFAULT NULL COMMENT '此局开奖资讯(兼容旧版牌型)',
  `OpValue` bigint(20) unsigned DEFAULT NULL COMMENT '原始数据中的Id OpValue',
  `ChannelID` int(11) unsigned DEFAULT NULL COMMENT '代理ID',
  `GameUserNO` varchar(50) NOT NULL COMMENT '游戏局号',
  `Currency` varchar(50) NOT NULL COMMENT '币别',
  `language` varchar(10) DEFAULT NULL,
  UNIQUE KEY `unique_key` (`GameEndTime`,`GameUserNO`,`Accounts`) USING BTREE,
  KEY `idx_KindId_ServerID_Currency` (`KindID`,`ServerID`,`Currency`) USING BTREE,
  KEY `IDX_ChannelID` (`ChannelID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4
/*!50100 PARTITION BY RANGE ( UNIX_TIMESTAMP(`GameEndTime`))
(PARTITION p_20241127 VALUES LESS THAN (1732636800) ENGINE = InnoDB,
 PARTITION p_20241128 VALUES LESS THAN (1732723200) ENGINE = InnoDB,
 PARTITION p_20241129 VALUES LESS THAN (1732809600) ENGINE = InnoDB,
 PARTITION p_20241130 VALUES LESS THAN (1732896000) ENGINE = InnoDB,
 PARTITION p_20241201 VALUES LESS THAN (1732982400) ENGINE = InnoDB,
 PARTITION p_20241202 VALUES LESS THAN (1733068800) ENGINE = InnoDB,
 PARTITION p_20241203 VALUES LESS THAN (1733155200) ENGINE = InnoDB,
 PARTITION p_20241204 VALUES LESS THAN (1733241600) ENGINE = InnoDB) */;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `GameInfo` (
  `GameID` int(10) NOT NULL,
  `GameName` varchar(50) DEFAULT NULL,
  `GameLogo` varchar(200) DEFAULT NULL,
  `GameType` int(10) DEFAULT NULL,
  `GameStatus` int(5) DEFAULT NULL,
  `GameParameter` varchar(100) DEFAULT NULL,
  `DESKey` varchar(50) DEFAULT NULL,
  `GameURL` varchar(100) DEFAULT NULL,
  `HttpURL` varchar(100) DEFAULT NULL,
  `CreateUser` varchar(50) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL,
  `LastEditUser` varchar(50) DEFAULT NULL,
  `LastEditTime` datetime DEFAULT NULL,
  `IsDelete` int(5) DEFAULT NULL,
  `GameChannelID` varchar(50) DEFAULT NULL,
  `GameIPWhitelis` varchar(500) DEFAULT NULL,
  `Sort` int(5) DEFAULT NULL,
  `ASEKey` varchar(50) DEFAULT NULL,
  `FormalLink` varchar(100) DEFAULT NULL,
  `DemoLink` varchar(100) DEFAULT NULL,
  `DemoOutLink` varchar(100) DEFAULT NULL,
  `Setting` varchar(100) DEFAULT NULL,
  `gType` int(2) DEFAULT '1' COMMENT '1.棋牌2.捕魚3.電子',
  `desensitization` varchar(100) DEFAULT '' COMMENT '脫敏名稱',
  `category` int(11) DEFAULT '0' COMMENT '類別分類 (0 = ALL), (1 = 平台遊戲)',
  `ptkEffect` int(5) NOT NULL DEFAULT '0' COMMENT '后台修改ptk是否生效',
  `setableKillRate` int(5) NOT NULL DEFAULT '1' COMMENT '是否可設置 KillRate',
  PRIMARY KEY (`GameID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

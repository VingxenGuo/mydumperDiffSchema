/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `companyGameInfo` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `companyid` int(11) NOT NULL,
  `GameName` varchar(50) NOT NULL,
  `GameID` int(10) NOT NULL,
  `status` int(11) NOT NULL,
  `agent` varchar(50) DEFAULT NULL,
  `GameParameter` varchar(50) DEFAULT NULL,
  `RegType` int(11) DEFAULT NULL COMMENT '是否支援單一錢包 (是: 0, 否: 1)',
  `GameUrl` varchar(50) DEFAULT NULL COMMENT '鏈接',
  `isShow` int(11) DEFAULT NULL COMMENT '顯示狀態 (顯示: 0, 隱藏: 1)',
  `Sequence` int(11) DEFAULT '2' COMMENT '序號 (統一為2)',
  `langIsopen` int(11) DEFAULT NULL COMMENT '語言狀態 (開啟: 0, 關閉: 1)',
  `HallData` varchar(255) DEFAULT '{[5]=1}' COMMENT '大廳位置 (統一為 {[5]=1})',
  `Vertical` int(11) DEFAULT '2' COMMENT '豎版排序 (統一為2)',
  `HotGame` varchar(255) DEFAULT '{}' COMMENT '熱門遊戲列表 (統一為 {})',
  `External` tinyint(1) DEFAULT '1' COMMENT '是否為外部遊戲 (是: true, 否: false) (統一為 true)',
  `extra` varchar(255) DEFAULT NULL,
  `gameType` int(11) NOT NULL DEFAULT '0',
  `companyGameId` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`GameName`,`companyid`),
  UNIQUE KEY `gameId_UNIQUE` (`GameID`) USING BTREE,
  UNIQUE KEY `id_UNIQUE` (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

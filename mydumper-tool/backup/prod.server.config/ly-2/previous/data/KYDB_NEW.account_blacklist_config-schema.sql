/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `account_blacklist_config` (
  `ID` bigint(20) NOT NULL AUTO_INCREMENT,
  `GameID` int(11) DEFAULT NULL COMMENT '游戏ID',
  `ServerID` int(11) DEFAULT NULL COMMENT '房间ID',
  `ChannelID` int(11) DEFAULT NULL COMMENT '代理ID',
  `KillRate` float NOT NULL COMMENT '总盈利率',
  `GameNumDown` int(11) NOT NULL COMMENT '当天局数下限',
  `GameNumUp` int(11) NOT NULL COMMENT '当天局数上限',
  `Profit` float NOT NULL COMMENT '盈利金额',
  `KillRoomRate` float NOT NULL COMMENT '杀房概率',
  `IsDelete` int(11) NOT NULL COMMENT '是否删除',
  `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

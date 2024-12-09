/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `ActivityAlarm` (
  `Id` int(11) NOT NULL AUTO_INCREMENT,
  `activityID` int(11) NOT NULL COMMENT '活动ID',
  `createTime` datetime DEFAULT NULL COMMENT '创建时间',
  `updateTime` datetime DEFAULT NULL COMMENT '修改时间',
  `rewardType` int(11) DEFAULT NULL COMMENT '监控奖励类型：是1：金币；',
  `outgivingType` int(11) DEFAULT NULL COMMENT '分发类型：1：每日总分发',
  `limit` decimal(11,2) DEFAULT NULL COMMENT '阈值',
  `telGroupID` varchar(20) DEFAULT NULL COMMENT '报警电报群ID',
  `content` varchar(500) DEFAULT NULL COMMENT '报警内容',
  PRIMARY KEY (`Id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

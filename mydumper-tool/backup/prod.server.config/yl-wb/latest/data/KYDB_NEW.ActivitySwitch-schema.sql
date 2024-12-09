/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `ActivitySwitch` (
  `Id` int(11) NOT NULL AUTO_INCREMENT COMMENT '主键',
  `createTime` datetime DEFAULT NULL COMMENT '添加时间',
  `updateTime` datetime DEFAULT NULL COMMENT '修改时间',
  `activityID` int(11) NOT NULL COMMENT '活动ID',
  `ChannelID` int(11) NOT NULL COMMENT '代理ID',
  `childID` varchar(2000) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '需要屏蔽的子ID',
  `status` int(11) DEFAULT NULL COMMENT '状态 0：已更新；1：未更新',
  PRIMARY KEY (`Id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `channel_jump_202410` (
  `StatisDate` date NOT NULL COMMENT '统计日期',
  `firstChannelID` int(11) NOT NULL DEFAULT '0' COMMENT '原始代理',
  `curChannelID` int(11) NOT NULL DEFAULT '0' COMMENT '当前代理',
  `accountDeviceSN` varchar(100) NOT NULL DEFAULT '' COMMENT '普通设备码',
  `Account` varchar(190) NOT NULL DEFAULT '' COMMENT '玩家账号',
  `CreateDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  PRIMARY KEY (`StatisDate`,`firstChannelID`,`curChannelID`,`accountDeviceSN`,`Account`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

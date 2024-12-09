/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `jackpot_log` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `from` int(11) DEFAULT NULL COMMENT '1=巨奖 2=大奖 3=中奖 4=小奖',
  `to` int(11) DEFAULT NULL COMMENT '1=巨奖 2=大奖 3=中奖 4=小奖',
  `fromAfterScore` bigint(20) DEFAULT NULL COMMENT '来源奖池帐变后点数',
  `Score` bigint(20) DEFAULT NULL COMMENT '帐变点数',
  `toAfterScore` bigint(20) DEFAULT NULL COMMENT '目标奖池帐变后点数',
  `type` int(11) DEFAULT NULL COMMENT '1=多福多彩',
  `CreateTime` datetime DEFAULT NULL,
  `CreateUser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

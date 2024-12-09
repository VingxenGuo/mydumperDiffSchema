/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `jackpot_record` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ChannelID` int(11) DEFAULT NULL,
  `Account` varchar(190) DEFAULT NULL,
  `GameID` bigint(20) DEFAULT NULL,
  `RoomID` bigint(20) DEFAULT NULL,
  `CellScore` bigint(20) DEFAULT NULL,
  `jackpotType` int(11) DEFAULT NULL COMMENT '1=多福多彩系列',
  `tier` int(11) DEFAULT NULL COMMENT '1=巨獎 2=大獎 3=中 4=小',
  `pool` bigint(20) DEFAULT NULL,
  `view` bigint(20) DEFAULT NULL,
  `GameUserNO` varchar(50) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `vvip_list_changelog` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `Account` varchar(190) NOT NULL,
  `CellScore` bigint(20) DEFAULT NULL COMMENT '当下总投注',
  `Profit` bigint(20) DEFAULT NULL COMMENT '当下总获胜',
  `ChannelID` int(11) NOT NULL,
  `status` int(11) DEFAULT NULL COMMENT '0 = 手動新增,1 = 手動移除白名單, 2 = 中獎移出, 3 = 系統移出 ',
  `fromAfterScore` bigint(20) DEFAULT NULL COMMENT '帐变前点数',
  `Score` bigint(20) DEFAULT NULL COMMENT '帐变点数',
  `toAfterScore` bigint(20) DEFAULT NULL COMMENT '帐变后点数',
  `CreateTime` datetime DEFAULT NULL,
  `CreateUser` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `dfdc_jackpot_record` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ChannelID` int(11) DEFAULT NULL,
  `Account` varchar(190) DEFAULT NULL,
  `GameID` bigint(20) DEFAULT NULL,
  `RoomID` bigint(20) DEFAULT NULL,
  `trx_cellScore` bigint(20) DEFAULT NULL COMMENT '本次投注金额(玩家币别)',
  `trx_pool` bigint(20) DEFAULT NULL COMMENT '实际水池金额(玩家币别)',
  `trx_view` bigint(20) DEFAULT NULL COMMENT '中奖金额(玩家币别)',
  `trx_currency` varchar(50) DEFAULT NULL COMMENT '玩家币别',
  `jackpotType` int(11) DEFAULT NULL COMMENT '1=多福多彩系列',
  `tier` int(11) DEFAULT NULL COMMENT '1=巨獎 2=大獎 3=中 4=小',
  `pool` bigint(20) DEFAULT NULL COMMENT '实际水池金额(转换成人民币)',
  `view` bigint(20) DEFAULT NULL COMMENT '中奖金额(转换成人民币)',
  `GameUserNO` varchar(50) DEFAULT NULL COMMENT '游戏局号',
  `CreateTime` timestamp NULL DEFAULT NULL,
  KEY `index_ID_CreateTime` (`ID`,`CreateTime`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

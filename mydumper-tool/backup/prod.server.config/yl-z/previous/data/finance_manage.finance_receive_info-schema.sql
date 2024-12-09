/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `finance_receive_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `StatisDate` varchar(10) NOT NULL,
  `ChannelID` int(11) NOT NULL,
  `PreDisReceiveMoney` bigint(20) DEFAULT '0' COMMENT '上月未交收',
  `Rebate` bigint(20) DEFAULT '0' COMMENT '返点',
  `DeliveryMoney` bigint(20) DEFAULT '0' COMMENT '上月交收',
  `ReceiveMoney` bigint(20) DEFAULT '0' COMMENT '本月应收',
  `BeforeReceiveMoney` bigint(20) DEFAULT '0' COMMENT '预收下月',
  `OtherMoney` bigint(20) DEFAULT '0' COMMENT '其他收入',
  `ReceiveDate` date DEFAULT NULL COMMENT '收款时间',
  `CreateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatePerson` varchar(50) DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

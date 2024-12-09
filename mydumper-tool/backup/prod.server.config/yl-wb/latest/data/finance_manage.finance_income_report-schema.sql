/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `finance_income_report` (
  `ChannelID` int(11) NOT NULL,
  `PayMonth` varchar(7) NOT NULL,
  `ReceiveMoney` bigint(20) DEFAULT NULL,
  `BeforeIncomeMoney` bigint(20) DEFAULT NULL,
  `IncomeMoney` bigint(20) DEFAULT NULL,
  `OtherPay` bigint(20) DEFAULT NULL,
  `OtherIncome` bigint(20) DEFAULT NULL,
  `Rebate` bigint(20) DEFAULT NULL,
  `NextIncomeMoney` bigint(20) DEFAULT NULL,
  `LastIncomeMoney` bigint(20) DEFAULT NULL,
  `Unpaid` bigint(20) DEFAULT NULL,
  `Status` int(11) DEFAULT '0' COMMENT '状态  0 未冲账  1已冲账',
  `PrevUnpaid` bigint(20) DEFAULT NULL,
  `UpdateTime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ChannelID`,`PayMonth`) USING BTREE,
  KEY `index_UpdateTime` (`UpdateTime`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `finance_income_info` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `ChannelID` int(11) NOT NULL,
  `IncomeType` int(11) DEFAULT '0' COMMENT '收款类别  0:交收账款,1:预收当月',
  `PayMonth` varchar(7) DEFAULT '0' COMMENT '支付月份',
  `IncomeMoney` bigint(20) DEFAULT '0' COMMENT '入款金额',
  `IncomeDate` date DEFAULT NULL COMMENT '入款日期',
  `Rebate` bigint(20) DEFAULT '0' COMMENT '抵扣返点',
  `ReQuarter` varchar(255) DEFAULT '' COMMENT '返点季度',
  `ReMonth` int(11) DEFAULT '0' COMMENT '抵扣月份',
  `OtherPay` bigint(20) DEFAULT '0' COMMENT '其他扣',
  `OtherPayRemark` varchar(255) DEFAULT NULL COMMENT '其他扣备注',
  `OtherIncome` bigint(20) DEFAULT '0' COMMENT '其他收入',
  `OtherIncomeRemark` varchar(255) DEFAULT NULL COMMENT '其他收入备注',
  `CreateTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `CreatePerson` varchar(50) DEFAULT NULL,
  `Status` int(11) DEFAULT '0' COMMENT '状态 0 默认 1 已冲账',
  `UpdateTime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_ChannelId_payMoney` (`ChannelID`,`PayMonth`) USING BTREE,
  KEY `index_UpdateTime` (`UpdateTime`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

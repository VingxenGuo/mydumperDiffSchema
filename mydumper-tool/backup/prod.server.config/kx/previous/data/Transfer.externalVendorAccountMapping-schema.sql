/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `externalVendorAccountMapping` (
  `agent` int(11) DEFAULT NULL COMMENT '会员所属代理',
  `account` varchar(190) NOT NULL COMMENT '会员帐号',
  `lineCode` varchar(200) DEFAULT '',
  `externalVendorAccount` varchar(40) DEFAULT NULL COMMENT '会员供應商帐号',
  `displayName` varchar(500) DEFAULT NULL COMMENT '会员供應商显示名称',
  `status` int(1) NOT NULL DEFAULT '0' COMMENT '玩家的状态 0: Active 1:Suspend 2: Closed ',
  `userGroup` varchar(2) DEFAULT 'a',
  `createDate` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`account`),
  KEY `index_externalVendorAccount` (`externalVendorAccount`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `rp_currency` (
  `id` bigint(20) NOT NULL,
  `agent` bigint(20) NOT NULL COMMENT '代理编号',
  `currencyName` varchar(50) NOT NULL COMMENT '币别中文',
  `currency` varchar(50) NOT NULL COMMENT '币别',
  `exchangeRate` decimal(20,5) NOT NULL COMMENT '汇率(https://docs.google.com/spreadsheets/d/1C4U6yYA47UgSXF8nQp6DgSKMciSAmwk_/edit#gid=1109246094)',
  `isAgent` tinyint(1) NOT NULL DEFAULT '0' COMMENT '代理是否可以使用该币别',
  `isPlayer` tinyint(1) NOT NULL DEFAULT '0' COMMENT '会员是否可以使用该币别',
  `status` tinyint(1) NOT NULL DEFAULT '0' COMMENT '会员是否可以使用该币别',
  `financeExchangeRate` decimal(20,5) DEFAULT NULL COMMENT '交收汇率',
  `financeLastEditTime` datetime DEFAULT NULL COMMENT '交收汇率最后修改时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `currency` (`currency`) USING BTREE,
  KEY `idx_isPlayer` (`isPlayer`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `trial_currency` (
  `currency` varchar(50) NOT NULL COMMENT '币别',
  `currencyName` varchar(50) NOT NULL COMMENT '币别中文',
  `maxLimit` bigint(20) NOT NULL COMMENT '上分金額上限',
  `eachRecharge` bigint(20) NOT NULL COMMENT '每次上分金額',
  `walletDefault` bigint(20) NOT NULL COMMENT '錢包初始金額',
  `lockSecond` int(11) NOT NULL COMMENT '每次上分鎖定秒數',
  PRIMARY KEY (`currency`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

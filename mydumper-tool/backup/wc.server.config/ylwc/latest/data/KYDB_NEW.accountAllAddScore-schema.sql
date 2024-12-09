/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `accountAllAddScore` (
  `account` varchar(190) NOT NULL COMMENT '会员帐号',
  `currency` varchar(50) NOT NULL COMMENT '币别',
  `addScore` decimal(20,5) DEFAULT '0.00000' COMMENT '总上分',
  `reduceScore` decimal(20,5) DEFAULT '0.00000' COMMENT '总下分',
  `updateDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  UNIQUE KEY `account_currency` (`account`,`currency`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

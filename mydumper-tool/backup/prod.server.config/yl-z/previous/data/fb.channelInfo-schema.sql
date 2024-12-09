/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `channelInfo` (
  `currency` smallint(6) NOT NULL COMMENT '幣種ID see enum: https://doc.newsportspro.com/single_wallet.html#currency',
  `sportCashout` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否為提前結算渠道 0-否 1-是',
  `merchantId` varchar(100) NOT NULL COMMENT '渠道ID',
  `merchantApiSecret` varchar(100) NOT NULL COMMENT '渠道密钥',
  PRIMARY KEY (`currency`,`sportCashout`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

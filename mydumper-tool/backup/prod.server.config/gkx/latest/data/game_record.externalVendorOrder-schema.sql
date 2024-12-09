/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `externalVendorOrder` (
  `orderId` varchar(50) NOT NULL COMMENT '交易單號',
  `orderType` int(11) DEFAULT NULL COMMENT '交易類型([一般錢包] 9:下注 11:結算 12:取消 25: 额外红利奖金; [單一錢包] 19:下注 21:結算 23:取消 26: 额外红利奖金;)',
  `companyId` varchar(100) DEFAULT NULL COMMENT '廠商id',
  `gameId` int(11) DEFAULT NULL COMMENT '遊戲編號',
  `gameNo` varchar(45) DEFAULT NULL COMMENT '遊戲局號',
  `takeScore` int(11) DEFAULT NULL COMMENT '帳變前金額',
  `amount` int(11) DEFAULT NULL COMMENT '帳變金額',
  `currency` varchar(45) NOT NULL COMMENT '币别',
  `createDate` datetime NOT NULL COMMENT '创建时间',
  PRIMARY KEY (`orderId`),
  KEY `index_gameNo_companyId` (`gameNo`,`companyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

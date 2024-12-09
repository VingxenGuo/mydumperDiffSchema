/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `orderRecord` (
  `transactionId` varchar(100) NOT NULL COMMENT '交易流水ID，全服唯一',
  `agent` int(11) NOT NULL COMMENT '会员所属YL代理',
  `account` varchar(190) NOT NULL COMMENT 'YL会员帐号',
  `userId` varchar(100) NOT NULL COMMENT 'FB用戶ID',
  `merchantId` varchar(20) NOT NULL COMMENT '渠道ID',
  `merchantUserId` varchar(100) NOT NULL COMMENT '渠道用戶ID',
  `businessId` varchar(20) NOT NULL COMMENT '業務ID，即訂單ID',
  `transactionType` varchar(3) NOT NULL COMMENT '交易類型OUT 轉出，IN 轉入',
  `transferType` varchar(50) NOT NULL COMMENT '轉賬類型',
  `currencyId` smallint(6) NOT NULL COMMENT '幣種ID see enum: https://doc.newsportspro.com/single_wallet.html#currency',
  `amount` double NOT NULL COMMENT '流水金額',
  `status` tinyint(1) NOT NULL COMMENT '轉賬狀態,0 取消，1成功；當需要取消對應的下單支付交易時，此字段為0，其他都是1',
  `relatedId` varchar(100) DEFAULT NULL COMMENT '三方數據關聯ID，可為空，下單時三方帶的訂單ID,目前只會在下單支付接口返回該字段',
  `orderPayParam` text COMMENT '呼叫B端時的參數',
  `rowCreateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '資料创建时间',
  `takeScore` double DEFAULT NULL COMMENT '下注前金額',
  PRIMARY KEY (`transactionId`),
  KEY `agent` (`agent`),
  KEY `account` (`account`),
  KEY `transferType` (`transferType`),
  KEY `businessId` (`businessId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

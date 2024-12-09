/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `agents` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `parent` int(11) DEFAULT NULL,
  `moneytype` int(11) DEFAULT NULL COMMENT '货币类型',
  `money` bigint(20) DEFAULT '0' COMMENT '代理分数',
  `whiteip` text COMMENT '白名单',
  `status` int(11) DEFAULT '0' COMMENT '代理状态 0正常1封停',
  `proxyurl` varchar(2000) DEFAULT NULL COMMENT '代理跳转地址',
  `agent` bigint(20) DEFAULT NULL COMMENT '代理编号',
  `desKey` varchar(500) NOT NULL COMMENT 'des加密key',
  `md5Key` varchar(500) NOT NULL COMMENT 'md5key',
  `callbackurl` varchar(2000) DEFAULT NULL COMMENT '回调地址',
  `lineCodes` longtext,
  `exRate` int(11) DEFAULT NULL COMMENT '汇率',
  `publicId` int(11) DEFAULT NULL COMMENT '公共匹配队列id',
  `pumping` float DEFAULT NULL COMMENT '抽水',
  `backmain` int(11) DEFAULT '0' COMMENT '是否显示返回大厅按钮(0:显示，1:不显示)',
  `createdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `oflinebackurl` varchar(2000) DEFAULT NULL,
  `feedEnabled` int(11) DEFAULT '0',
  `logourl` varchar(2000) DEFAULT NULL,
  `timeZone` int(11) DEFAULT '8',
  `sbStatus` int(11) DEFAULT '0' COMMENT '单一钱包：0:关闭, 1:开启',
  `sbUrl` varchar(250) DEFAULT NULL COMMENT '单一钱包Url',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_agent` (`agent`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `agent_orders20230224` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `OrderID` varchar(190) DEFAULT NULL COMMENT '订单ID',
  `ChannelID` int(11) DEFAULT NULL COMMENT '代理ID',
  `OrderTime` datetime DEFAULT NULL COMMENT '订单时间',
  `OrderType` int(11) DEFAULT NULL COMMENT '账变类型0后台上分，1后台下分，2玩家上分，3玩家下分',
  `OrderStatus` int(11) DEFAULT NULL COMMENT '订单状态 0成功，1处理中，2失败',
  `CurScore` bigint(20) DEFAULT NULL COMMENT '账变前金额',
  `AddScore` bigint(20) DEFAULT NULL COMMENT '账变金额',
  `NewScore` bigint(20) DEFAULT NULL COMMENT '账变后金额',
  `OrderIP` varchar(500) DEFAULT NULL COMMENT '操作IP',
  `CreateUser` varchar(150) DEFAULT NULL COMMENT '操作账号',
  `ErrorMsg` varchar(200) DEFAULT NULL,
  `createdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_orderid` (`OrderID`),
  KEY `index_ordertime_ordertype` (`OrderTime`,`OrderType`) USING BTREE,
  KEY `index_ordertime_ordertype_createuser` (`OrderTime`,`OrderType`,`CreateUser`) USING BTREE,
  KEY `index_ordertime` (`OrderTime`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

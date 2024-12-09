/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `single_orders20240217` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `OrderID` varchar(190) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '订单ID',
  `ChannelID` int(11) DEFAULT NULL COMMENT '代理ID',
  `OrderTime` datetime DEFAULT NULL COMMENT '订单时间',
  `GameNo` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '局號',
  `OrderType` int(11) DEFAULT NULL COMMENT '账变类型14通知玩家上分15通知玩家下分16取消下注订单',
  `OrderAction` int(11) DEFAULT NULL COMMENT '动作1:游戏赢分, 2:下注超时Rollback, 3:清卡携分, 4:赢分补发, 5:取消百人下注',
  `CurScore` bigint(20) DEFAULT NULL COMMENT '账变前金额',
  `AddScore` bigint(20) DEFAULT NULL COMMENT '账变金额',
  `NewScore` bigint(20) DEFAULT NULL COMMENT '账变后金额',
  `OrderIP` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '操作IP',
  `CreateUser` varchar(190) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '操作账号',
  `OrderStatus` int(11) DEFAULT NULL COMMENT '订单状态 1成功，2异常',
  `ErrorMsg` varchar(200) COLLATE utf8mb4_bin DEFAULT NULL,
  `RetCode` int(11) DEFAULT '0',
  `DealStatus` int(11) DEFAULT '0',
  `createdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_orderid` (`OrderID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

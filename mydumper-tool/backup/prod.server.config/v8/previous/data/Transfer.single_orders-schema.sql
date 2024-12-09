/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `single_orders` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `orderId` varchar(190) NOT NULL COMMENT '订单编号',
  `account` varchar(100) NOT NULL,
  `channelId` int(11) NOT NULL DEFAULT '0',
  `gameNo` varchar(50) DEFAULT NULL COMMENT '局號',
  `curScore` bigint(20) DEFAULT NULL COMMENT '账变前金额',
  `addScore` bigint(20) NOT NULL COMMENT '订单金额变化数量',
  `newScore` bigint(20) DEFAULT NULL COMMENT '账变后金额',
  `status` int(11) NOT NULL COMMENT '订单状态1 是成功，2是失败',
  `type` int(11) DEFAULT NULL COMMENT '订单类型0通知玩家上分1通知玩家下分2取消下注订单',
  `action` int(11) DEFAULT NULL COMMENT '动作1:游戏赢分, 2:下注超时Rollback, 3:清卡携分, 4:赢分补发, 5:取消百人下注',
  `createdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updatedate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `index_orderid` (`orderId`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

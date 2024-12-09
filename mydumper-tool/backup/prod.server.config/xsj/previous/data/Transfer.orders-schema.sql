/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `orders` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `orderid` varchar(190) NOT NULL COMMENT '订单编号',
  `money` bigint(20) NOT NULL COMMENT '订单金额变化数量',
  `status` int(11) NOT NULL COMMENT '订单状态0处理中 1 是成功，2是失败',
  `type` int(11) NOT NULL COMMENT '订单类型0玩家上分1玩家下分',
  `big_data` longtext COMMENT '订单帐变數據',
  `createdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updatedate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  KEY `index_id_createdate` (`id`,`createdate`) USING BTREE,
  KEY `index_orderid_createdate` (`orderid`,`createdate`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

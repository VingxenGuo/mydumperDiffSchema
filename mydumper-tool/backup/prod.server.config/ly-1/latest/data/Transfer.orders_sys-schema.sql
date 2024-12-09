/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `orders_sys` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `curMoney` bigint(20) NOT NULL COMMENT '帐变前金额',
  `money` bigint(20) NOT NULL COMMENT '订单帐变金额',
  `afterMoney` bigint(20) NOT NULL COMMENT '帐变后金额',
  `status` int(11) NOT NULL COMMENT '订单状态0处理中 1 是成功，2是失败',
  `type` int(11) NOT NULL COMMENT '订单类型0代理上分1代理下分',
  `agent` int(11) NOT NULL COMMENT '代理编号',
  `createdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updatedate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_createdate` (`createdate`) USING BTREE,
  KEY `index_createdate_type` (`createdate`,`type`) USING BTREE,
  KEY `index_createdate_type_gaent` (`createdate`,`type`,`agent`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 ROW_FORMAT=COMPACT;

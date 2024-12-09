/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `tracking_single_fail_order` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` varchar(190) NOT NULL COMMENT '订单编号 关联orders_record.single_orders',
  `error_note` longtext COMMENT '错误历程',
  `create_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `index_orderid` (`order_id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=6308 DEFAULT CHARSET=utf8mb4;

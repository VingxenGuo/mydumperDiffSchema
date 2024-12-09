/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `vendor_assigned_time_record_fetch_task` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `vendor_name` varchar(45) DEFAULT NULL,
  `start_date` timestamp NULL DEFAULT NULL,
  `end_date` timestamp NULL DEFAULT NULL,
  `status` char(1) NOT NULL DEFAULT '0' COMMENT '0:未完成拉單1:完成拉單',
  PRIMARY KEY (`id`),
  KEY `idx_status` (`status`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

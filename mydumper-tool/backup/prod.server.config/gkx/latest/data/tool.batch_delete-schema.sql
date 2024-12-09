/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `batch_delete` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `connection_id` int(10) unsigned DEFAULT NULL,
  `exec_table` varchar(64) DEFAULT NULL,
  `where_condition` varchar(256) DEFAULT NULL,
  `chunk_number` int(10) unsigned DEFAULT NULL,
  `delete_rate` float unsigned DEFAULT NULL,
  `total_affected_rows` int(11) DEFAULT NULL,
  `total_delete_rate` float DEFAULT NULL,
  `duration_second` double DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  `finished_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2169 DEFAULT CHARSET=utf8mb4;

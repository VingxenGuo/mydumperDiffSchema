/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `routine_delete_table` (
  `sn` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `exec_database` varchar(64) NOT NULL,
  `exec_table` varchar(128) NOT NULL,
  `routine_type` char(1) NOT NULL COMMENT 'Y: execute at first day of year, M: execute at first day of month, D daily execute',
  `delete_type` varchar(16) NOT NULL COMMENT 'delete_record, drop_table, drop_partition',
  `time_interval` int(10) unsigned NOT NULL,
  `delete_key` varchar(64) DEFAULT NULL COMMENT 'Switch (delete_type) {\n	case ‘delete_record’:\n		#fill the where condition column\n	case ‘drop_table’:\n		#no usage fill null\n	case ‘drop_partition’:\n		#fill the prefix string of partition name\n}',
  `is_enabled` int(10) unsigned NOT NULL,
  `lastest_start_at` datetime DEFAULT NULL,
  `lastest_finish_at` datetime DEFAULT NULL,
  `lastest_duration_second` double DEFAULT NULL,
  `lastest_exec_cmd` varchar(256) DEFAULT NULL,
  `lastest_err_msg` varchar(128) DEFAULT NULL,
  `batch_delete_id` int(10) unsigned DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`sn`),
  KEY `idx-batch_delete_id` (`batch_delete_id`)
) ENGINE=InnoDB AUTO_INCREMENT=377 DEFAULT CHARSET=utf8mb4;

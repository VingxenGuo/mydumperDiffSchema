/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `DetectIndexPartition` (
  `sn` int(11) NOT NULL AUTO_INCREMENT,
  `exec_database` varchar(128) NOT NULL,
  `exec_table` varchar(128) NOT NULL,
  `delete_type` varchar(32) NOT NULL,
  `delete_key` varchar(32) DEFAULT NULL,
  `use_index` varchar(1) DEFAULT NULL COMMENT 'case delete_record use index then suggest it can use drop partition, if not, then it should create index.',
  `use_partition` varchar(1) DEFAULT NULL,
  `partition_name` varchar(64) DEFAULT NULL,
  PRIMARY KEY (`sn`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

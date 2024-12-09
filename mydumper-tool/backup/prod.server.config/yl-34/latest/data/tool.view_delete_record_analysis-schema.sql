/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE IF NOT EXISTS `view_delete_record_analysis`(
`exec_table` int,
`lastest_exec_cmd` int,
`total_affected_rows` int,
`total duration` int,
`delete records duration` int,
`optimize table duration = (total - delete records)` int
) ENGINE=MEMORY;

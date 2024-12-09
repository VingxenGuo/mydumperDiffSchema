/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_agent` (
  `agent` int(11) NOT NULL,
  `count` int(11) DEFAULT '0',
  `cretetime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `mstatus0` int(11) DEFAULT NULL COMMENT 'mstatus為0 統計',
  `mstatus1` int(11) DEFAULT NULL COMMENT 'mstatus為1 統計',
  `mstatus2` int(11) DEFAULT NULL COMMENT 'mstatus為2 統計',
  `mstatus3` int(11) DEFAULT NULL COMMENT 'mstatus為3 統計',
  PRIMARY KEY (`agent`) USING BTREE,
  KEY `index_agent` (`agent`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Sys_cron_partition` (
  `ID` int(10) NOT NULL AUTO_INCREMENT,
  `PartitionDatabase` varchar(30) NOT NULL COMMENT '分區的資料庫名稱',
  `PartitionTable` varchar(50) NOT NULL COMMENT '分區的表格名稱',
  `PartitionType` varchar(20) NOT NULL COMMENT '分區的類型依據',
  `PartitionColumns` varchar(20) NOT NULL COMMENT '分區的欄位名稱依據',
  `PartitionFunction` varchar(20) NOT NULL COMMENT '分區的欄位方法依據',
  `PartitionStatus` int(1) DEFAULT '0' COMMENT '0: 關閉, 1:開啟',
  `CreateTime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=705 DEFAULT CHARSET=utf8mb4;

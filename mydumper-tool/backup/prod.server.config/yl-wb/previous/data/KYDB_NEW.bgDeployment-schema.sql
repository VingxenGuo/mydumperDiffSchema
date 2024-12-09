/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `bgDeployment` (
  `gameServer` varchar(100) NOT NULL COMMENT 'gameServer',
  `outGameServer` varchar(100) NOT NULL,
  `manageGameServer` varchar(100) NOT NULL,
  `type` enum('0','1','2') NOT NULL COMMENT '0暫 1主 2副',
  `machineName` enum('blue','green') NOT NULL COMMENT '機器代號',
  PRIMARY KEY (`gameServer`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

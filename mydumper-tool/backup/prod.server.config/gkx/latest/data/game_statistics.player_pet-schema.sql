/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `player_pet` (
  `rid` bigint(48) NOT NULL,
  `sex` int(11) DEFAULT NULL,
  `name` varchar(255) DEFAULT NULL,
  `icon` varchar(255) DEFAULT NULL,
  `iconBg` int(20) DEFAULT NULL,
  `petType` int(11) DEFAULT NULL,
  `skin1` int(11) DEFAULT NULL,
  `skin2` int(11) DEFAULT NULL,
  `skin3` int(11) DEFAULT NULL,
  `level` int(11) DEFAULT NULL,
  `exp` bigint(20) DEFAULT NULL,
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP,
  `rank` int(11) DEFAULT '0',
  PRIMARY KEY (`rid`) USING BTREE,
  KEY `index_pet_level_petexp` (`level`,`exp`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

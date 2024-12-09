/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_keep_game_users_agent` (
  `StatisDate` date NOT NULL,
  `GameID` int(11) NOT NULL,
  `RegUsers` int(11) DEFAULT NULL,
  `GameLoginUsers` int(11) DEFAULT NULL,
  `PlayGameUsers` int(11) DEFAULT NULL,
  `CR` int(11) DEFAULT NULL,
  `QR` int(11) DEFAULT NULL,
  `HYCR` int(11) DEFAULT NULL,
  `HYQR` int(11) DEFAULT NULL,
  `CellScore` bigint(20) DEFAULT NULL,
  `Profit` bigint(20) DEFAULT NULL,
  `Revenue` bigint(20) DEFAULT NULL,
  `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`StatisDate`,`GameID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

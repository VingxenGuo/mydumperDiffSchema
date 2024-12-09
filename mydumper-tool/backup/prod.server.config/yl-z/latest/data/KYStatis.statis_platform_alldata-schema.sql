/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_platform_alldata` (
  `StatisDate` date NOT NULL,
  `dayBetGames` bigint(20) DEFAULT '0',
  `dayValidBet` bigint(20) DEFAULT '0',
  `dayWinGold` bigint(20) DEFAULT '0',
  `dayLostGold` bigint(20) DEFAULT '0',
  `dayDeductGold` bigint(20) DEFAULT '0',
  `dayNewBetGames` bigint(20) DEFAULT '0',
  `regCount` bigint(20) DEFAULT '0',
  `loginCount` bigint(20) DEFAULT '0',
  `gameCount` bigint(20) DEFAULT '0',
  `roomCount` bigint(20) DEFAULT '0',
  `cpiCount` bigint(20) DEFAULT '0',
  `playGameCount` bigint(20) DEFAULT '0',
  `yxReg` text,
  `CreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `UpdateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`StatisDate`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

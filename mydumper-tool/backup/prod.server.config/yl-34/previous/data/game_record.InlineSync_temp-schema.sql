/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `InlineSync_temp` (
  `big_dataId` bigint(20) NOT NULL DEFAULT '0',
  `GameName` varchar(9) CHARACTER SET utf8mb4 NOT NULL DEFAULT '',
  `GameID` int(11) NOT NULL DEFAULT '0',
  `GameNo` varchar(500) CHARACTER SET utf8 DEFAULT NULL,
  `WinOrderId` varchar(190) CHARACTER SET utf8 DEFAULT NULL,
  `GameEndTime` varchar(8) CHARACTER SET utf8mb4 DEFAULT NULL,
  `RealGameEndTime` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `Account` varchar(100) CHARACTER SET utf8 DEFAULT NULL,
  `WinMoney` float DEFAULT NULL,
  `Revenue` float DEFAULT NULL,
  `Profit` float NOT NULL DEFAULT '0',
  `OrderSyncExist` varchar(1) CHARACTER SET utf8mb4 NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

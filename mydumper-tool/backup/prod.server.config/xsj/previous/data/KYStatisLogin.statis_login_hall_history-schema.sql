/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_login_hall_history` (
  `ChannelID` int(10) NOT NULL,
  `Accounts` varchar(190) DEFAULT NULL,
  UNIQUE KEY `index_ChannelID_Accounts` (`ChannelID`,`Accounts`) USING BTREE,
  KEY `Index_accounts` (`Accounts`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

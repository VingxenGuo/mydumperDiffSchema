/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statistics_checkLogin_deprecation` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `Time` datetime NOT NULL,
  `Agent` int(10) unsigned NOT NULL,
  `AllCount` int(10) unsigned NOT NULL,
  `LoginCount` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

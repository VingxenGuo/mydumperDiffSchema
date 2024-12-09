/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `company` (
  `companyid` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `companyPWD` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT '96e79218965eb72c92a549dd5a330112',
  `companyname` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '暱稱',
  `abbreviation` varchar(45) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '暱稱縮寫',
  `whiteip` varchar(5000) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '白名單',
  `mark` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL COMMENT '備註',
  `updatetime` datetime NOT NULL COMMENT '時間',
  `status` int(11) NOT NULL COMMENT '狀態 0-啟用 1-停用',
  `game_launch_url` varchar(100) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `game_launch_param` varchar(200) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`companyid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

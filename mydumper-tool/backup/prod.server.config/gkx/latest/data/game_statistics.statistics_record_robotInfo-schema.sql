/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statistics_record_robotInfo` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `dayFTime` timestamp NULL DEFAULT NULL,
  `createtime` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `allData` longtext COMMENT '机器人统计',
  `aiData` longtext COMMENT '每种机器人统计',
  `games` longtext COMMENT '游戏机器人统计',
  `rooms` longtext COMMENT '房间机器人统计',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `index_dayFTime` (`dayFTime`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=279 DEFAULT CHARSET=utf8mb4;

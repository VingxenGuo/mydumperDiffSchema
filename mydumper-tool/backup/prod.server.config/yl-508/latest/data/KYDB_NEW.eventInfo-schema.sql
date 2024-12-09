/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `eventInfo` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `typeSpecification` blob,
  `param` blob NOT NULL,
  `startTime` datetime NOT NULL,
  `endTime` datetime NOT NULL,
  `repeat` tinyint(3) unsigned NOT NULL,
  `marquee` tinyint(3) unsigned NOT NULL,
  `marqueeTimeInterval` int(10) unsigned NOT NULL,
  `marqueeChipLimit` int(10) unsigned NOT NULL,
  `leaderboard` tinyint(3) unsigned NOT NULL,
  `leaderboardFakeDataSwitch` tinyint(3) unsigned NOT NULL,
  `skin` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(3) unsigned NOT NULL,
  `createTime` datetime NOT NULL,
  `updateTime` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

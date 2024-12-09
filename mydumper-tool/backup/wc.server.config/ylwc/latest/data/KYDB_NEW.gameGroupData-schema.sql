/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `gameGroupData` (
  `infoId` int(10) unsigned NOT NULL COMMENT '對應 gameGroupInfo 的 id',
  `gameId` int(10) unsigned NOT NULL COMMENT '不包含的 gameId',
  PRIMARY KEY (`infoId`,`gameId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

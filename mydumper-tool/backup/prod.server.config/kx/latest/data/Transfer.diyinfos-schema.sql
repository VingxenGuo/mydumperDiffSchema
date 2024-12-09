/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `diyinfos` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `code` varchar(190) NOT NULL COMMENT 'type=1为代理id   type=0为下线id',
  `parent` varchar(10) NOT NULL,
  `CreateDate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00' COMMENT '添加时间',
  `status` tinyint(4) NOT NULL DEFAULT '0',
  `CloseDate` timestamp NOT NULL DEFAULT '0000-00-00 00:00:00',
  `fee` int(11) NOT NULL DEFAULT '0',
  `info` text NOT NULL,
  `type` tinyint(4) NOT NULL DEFAULT '0' COMMENT '0-LineCode 1-Agent',
  `UploadDate` longtext COMMENT 'logo上傳時間',
  PRIMARY KEY (`id`),
  UNIQUE KEY `index_lineCode` (`code`) USING HASH
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

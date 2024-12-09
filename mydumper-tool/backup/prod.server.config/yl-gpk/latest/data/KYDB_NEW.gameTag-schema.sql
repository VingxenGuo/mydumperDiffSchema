/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `gameTag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `name` varchar(190) NOT NULL COMMENT '主標籤名稱',
  `languageId` bigint(20) NOT NULL COMMENT '所屬語言 關聯 KYDB_NEW.Sys_Language.id',
  `sort` bigint(20) NOT NULL COMMENT '排序',
  `subTagStatus` tinyint(1) NOT NULL COMMENT '子標籤開關 0: 關, 1: 開',
  `updateTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_languageId_sort` (`languageId`,`sort`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

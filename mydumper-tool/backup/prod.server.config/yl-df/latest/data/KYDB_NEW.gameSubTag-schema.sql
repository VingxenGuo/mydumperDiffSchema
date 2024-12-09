/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `gameSubTag` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `tagId` bigint(20) NOT NULL COMMENT '主標籤id 關聯 KYDB_NEW.gameTag.id',
  `companyId` bigint(20) NOT NULL COMMENT '廠商 id 關聯 KYDB_NEW.company.compantid (1 為內部品牌)',
  `name` varchar(190) NOT NULL COMMENT '子標籤名稱(廠商名稱)',
  `sort` bigint(20) NOT NULL COMMENT '排序',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_tagId_companyId` (`tagId`,`companyId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

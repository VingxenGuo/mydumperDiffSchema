/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Sys_ConfigAddress` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `Behindaddress` varchar(300) DEFAULT NULL COMMENT '后台地址',
  `Portaddress` varchar(300) DEFAULT NULL COMMENT '接口地址',
  `Pullinterface` varchar(300) DEFAULT NULL COMMENT '拉单接口',
  `CreateUser` varchar(50) DEFAULT NULL,
  `CreateDate` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `UpdateDate` datetime DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4;

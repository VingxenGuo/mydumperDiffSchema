/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `rp_hide` (
  `action` varchar(50) NOT NULL,
  `field` varchar(50) NOT NULL,
  `type` tinyint(1) NOT NULL COMMENT '0: 管理員, 1: 代理, 2: 全部',
  PRIMARY KEY (`action`,`field`,`type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

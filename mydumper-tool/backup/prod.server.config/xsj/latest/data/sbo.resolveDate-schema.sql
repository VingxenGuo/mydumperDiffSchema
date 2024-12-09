/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `resolveDate` (
  `resolveDate` date NOT NULL COMMENT '需重跑统计时间',
  `createDate` date NOT NULL COMMENT '资料创建时间',
  `updateDate` date DEFAULT NULL COMMENT '资料更新时间',
  PRIMARY KEY (`resolveDate`,`createDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

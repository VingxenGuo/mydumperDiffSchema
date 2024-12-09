/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `restatic` (
  `restaticDate` date NOT NULL COMMENT '要重新統計的日期',
  `agent` int(11) NOT NULL COMMENT '要重新統計的代理',
  `createDate` date NOT NULL COMMENT '資料創建日期',
  `isRun` int(11) NOT NULL COMMENT '是否已重新統計 0:未統計 1:已統計',
  PRIMARY KEY (`restaticDate`,`agent`,`createDate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

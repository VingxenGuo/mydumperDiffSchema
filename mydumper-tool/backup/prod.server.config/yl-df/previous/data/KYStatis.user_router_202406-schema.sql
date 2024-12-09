/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `user_router_202406` (
  `StatisDate` date NOT NULL COMMENT '统计日期',
  `Account` varchar(190) NOT NULL COMMENT '用户账号',
  `ChannelID` int(11) NOT NULL COMMENT '代理',
  `Source` varchar(64) NOT NULL COMMENT '源游戏',
  `Target` varchar(64) NOT NULL COMMENT '目标游戏',
  `PlayGameSort` int(11) NOT NULL COMMENT '访问顺序',
  `Type` tinyint(2) NOT NULL COMMENT '类型 1 新用户 2 活跃用户',
  `CreateDate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建日期',
  PRIMARY KEY (`StatisDate`,`Account`,`PlayGameSort`,`Type`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

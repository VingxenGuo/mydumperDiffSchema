/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statistics_feedback` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gameid` int(11) NOT NULL COMMENT '游戏id',
  `account` varchar(190) NOT NULL COMMENT '玩家账号',
  `content` text NOT NULL COMMENT '内容',
  `ip` varchar(255) DEFAULT NULL COMMENT '玩家ip',
  `os` varchar(50) DEFAULT NULL COMMENT '系统版本',
  `browser` varchar(80) DEFAULT NULL COMMENT '浏览器型号',
  `creatdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

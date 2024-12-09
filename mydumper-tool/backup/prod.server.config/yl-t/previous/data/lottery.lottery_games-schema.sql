/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `lottery_games` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `uid` varchar(50) NOT NULL COMMENT '彩票中心的游戏哈希ID',
  `name` varchar(100) NOT NULL COMMENT '游戏名称',
  `abbr` varchar(20) NOT NULL COMMENT '游戏名称缩写 对应记录表',
  `type` tinyint(4) NOT NULL COMMENT '游戏类型',
  `created_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `uk_game_uid` (`uid`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

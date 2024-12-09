/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Sys_GameInfo` (
  `game_id` int(11) NOT NULL COMMENT '游戏ID',
  `is_support_single_wallet` tinyint(1) NOT NULL DEFAULT '0' COMMENT '是否支援单一钱包',
  PRIMARY KEY (`game_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin COMMENT='由开发商来控制游戏相关设定';

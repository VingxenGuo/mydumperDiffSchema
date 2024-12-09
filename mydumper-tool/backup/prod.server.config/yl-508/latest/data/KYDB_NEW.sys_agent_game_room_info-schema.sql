/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `sys_agent_game_room_info` (
  `roomId` int(11) NOT NULL COMMENT '房间id',
  `gameId` int(11) NOT NULL COMMENT '游戏id',
  `agent` int(11) NOT NULL COMMENT '代理id',
  `status` int(11) NOT NULL DEFAULT '0' COMMENT '房间状态',
  PRIMARY KEY (`roomId`,`gameId`,`agent`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

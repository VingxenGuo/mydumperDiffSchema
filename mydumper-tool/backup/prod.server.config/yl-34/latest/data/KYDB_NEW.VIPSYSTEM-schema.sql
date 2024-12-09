/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `VIPSYSTEM` (
  `ID` mediumint(9) NOT NULL AUTO_INCREMENT COMMENT '唯一ID',
  `types` int(11) NOT NULL COMMENT '0-后台编辑暂存 1-欲更新正式暂存 2-正式环境',
  `nickname` varchar(20) COLLATE utf8mb4_bin DEFAULT NULL COMMENT '昵称',
  `betrange` int(11) NOT NULL COMMENT '投注區間',
  `dn_ws_id` varchar(1000) COLLATE utf8mb4_bin NOT NULL COMMENT '域名, websocket, id',
  PRIMARY KEY (`ID`,`types`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

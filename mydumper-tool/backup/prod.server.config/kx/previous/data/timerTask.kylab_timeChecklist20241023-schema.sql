/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `kylab_timeChecklist20241023` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `start_time` datetime DEFAULT NULL COMMENT '拉單開始時間',
  `end_time` datetime DEFAULT NULL COMMENT '拉單結束時間 也是執行拉單的時間',
  `done` int(11) DEFAULT NULL COMMENT '1:完成',
  `create_time` datetime DEFAULT NULL COMMENT '完成時間',
  `update_time` datetime DEFAULT NULL COMMENT '重跑時間',
  PRIMARY KEY (`id`),
  UNIQUE KEY `end_time_UNIQUE` (`end_time`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

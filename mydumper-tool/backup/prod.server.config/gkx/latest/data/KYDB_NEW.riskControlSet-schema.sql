/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `riskControlSet` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `type` tinyint(2) unsigned NOT NULL COMMENT '1: 後台, 2: 平台, 3: 遊戲, 4: 代理, 5: 玩家',
  `track` tinyint(2) unsigned NOT NULL COMMENT '1: 密碼驗證, 2: 盈利率, 3: 盈利, 4: 日投注額, 5: 上分/下分',
  `statistics` tinyint(2) unsigned NOT NULL DEFAULT '0' COMMENT '1: 當日, 2: 昨日, 3: 當月',
  `frequency` int(11) unsigned NOT NULL COMMENT '檢查秒數',
  `min` int(11) DEFAULT NULL COMMENT '最小值',
  `max` int(11) DEFAULT NULL COMMENT '最大值',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

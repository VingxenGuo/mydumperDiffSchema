/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statistics_login_hall` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account` varchar(190) NOT NULL COMMENT '玩家账号',
  `agent` int(11) NOT NULL COMMENT '代理编号',
  `ip` varchar(255) NOT NULL COMMENT '登陆ip',
  `ipLocal` varchar(200) DEFAULT NULL COMMENT 'ip所在地',
  `info` varchar(500) DEFAULT NULL COMMENT '玩家设备信息(原始数据)',
  `os` varchar(50) DEFAULT NULL COMMENT '系统版本',
  `browser` varchar(80) DEFAULT NULL COMMENT '浏览器型号',
  `platform` int(2) DEFAULT NULL COMMENT '设备平台0:pc,1:mobile',
  `createdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  KEY `index_createdate` (`createdate`) USING BTREE,
  KEY `index_createdate_agent` (`createdate`,`agent`) USING BTREE,
  KEY `index_id_createdate` (`id`,`createdate`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4
/*!50100 PARTITION BY RANGE ( UNIX_TIMESTAMP(`createdate`))
(PARTITION p_202410 VALUES LESS THAN (1727712000) ENGINE = InnoDB,
 PARTITION p_202411 VALUES LESS THAN (1730390400) ENGINE = InnoDB,
 PARTITION p_202412 VALUES LESS THAN (1732982400) ENGINE = InnoDB,
 PARTITION p_202501 VALUES LESS THAN (1735660800) ENGINE = InnoDB,
 PARTITION p_202502 VALUES LESS THAN (1738339200) ENGINE = InnoDB) */;

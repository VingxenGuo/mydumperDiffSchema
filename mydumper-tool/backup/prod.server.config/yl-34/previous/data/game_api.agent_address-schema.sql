/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `agent_address` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agent` int(20) unsigned zerofill DEFAULT NULL COMMENT '代理编号 null:  通用地址；not null ：专用地址;',
  `address` varchar(255) DEFAULT '' COMMENT '地址',
  `type` int(5) NOT NULL COMMENT '0:为ws地址 1:url地址 ;2:漏斗地址',
  `status` int(5) DEFAULT '1' COMMENT '0:废弃 1：可用',
  `priority` int(5) DEFAULT '5' COMMENT '优先级： max:5 ； min：1；',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='a}';

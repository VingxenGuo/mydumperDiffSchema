/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `special_agent_manage` (
  `channelId` int(11) NOT NULL,
  `nickName` varchar(100) DEFAULT NULL,
  `type` int(11) DEFAULT '0' COMMENT '0 美东代理，1 迁移的代理',
  `createtime` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`channelId`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

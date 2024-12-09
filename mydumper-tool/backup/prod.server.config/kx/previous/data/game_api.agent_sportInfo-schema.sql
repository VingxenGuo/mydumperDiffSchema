/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `agent_sportInfo` (
  `channelID` varchar(100) NOT NULL COMMENT '代理编号',
  `sboAgentName` varchar(20) DEFAULT NULL COMMENT '代理SBO帐号',
  `UID` varchar(100) NOT NULL COMMENT '上级代理',
  `min` int(11) NOT NULL COMMENT '该代理底下玩家的预设单笔注单最低限额',
  `max` int(11) NOT NULL COMMENT '该代理底下玩家的预设单笔注单最高限额',
  `maxPerMatch` int(11) NOT NULL COMMENT '该代理底下玩家的预设单场比赛最高限额',
  `casinoTableLimit` int(11) NOT NULL COMMENT '该代理底下玩家的预设真人赌场限额设定 1： 低 2：中 3：高 4：VIP',
  PRIMARY KEY (`channelID`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

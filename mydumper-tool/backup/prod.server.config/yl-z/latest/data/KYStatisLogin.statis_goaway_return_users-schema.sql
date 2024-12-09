/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_goaway_return_users` (
  `statisdate` date NOT NULL,
  `channelid` int(11) NOT NULL DEFAULT '0' COMMENT '流失或回归天数',
  `seven_go_away` int(11) DEFAULT '0' COMMENT '7天流失',
  `fifteen_go_away` int(11) DEFAULT '0' COMMENT '15日流失',
  `thirty_go_away` int(11) DEFAULT '0' COMMENT '30日流失',
  `seven_return` int(11) DEFAULT '0' COMMENT '7日回归',
  `fifteen_return` int(11) DEFAULT '0' COMMENT '15日回归',
  `thirty_return` int(11) DEFAULT '0' COMMENT '30日回归',
  `createdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`statisdate`,`channelid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

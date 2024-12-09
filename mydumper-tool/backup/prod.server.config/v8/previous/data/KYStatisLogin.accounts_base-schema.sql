/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `accounts_base` (
  `accounts` varchar(190) NOT NULL,
  `channelid` int(11) NOT NULL,
  `lastlogintime` date NOT NULL COMMENT '最后登陆时间',
  `createdate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `updatedate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`lastlogintime`,`accounts`) USING BTREE,
  UNIQUE KEY `index_account` (`accounts`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

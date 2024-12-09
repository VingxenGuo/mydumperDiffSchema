/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_keep_login_users_202501` (
  `statisdate` date NOT NULL COMMENT '统计日期',
  `statis_reg_day` int(11) NOT NULL COMMENT '第N天留存点',
  `channelid` int(11) NOT NULL COMMENT '代理编号',
  `keep_login_users` int(11) DEFAULT NULL COMMENT '留存人数',
  `regdate` date DEFAULT NULL COMMENT '注册时间(天)',
  `regusers` int(11) DEFAULT NULL COMMENT '注册当天的注册人数',
  PRIMARY KEY (`statisdate`,`statis_reg_day`,`channelid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

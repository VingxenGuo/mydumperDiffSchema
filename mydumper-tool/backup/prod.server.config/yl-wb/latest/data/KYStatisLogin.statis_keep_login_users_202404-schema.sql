/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statis_keep_login_users_202404` (
  `statisdate` date NOT NULL COMMENT 'iy',
  `statis_reg_day` int(11) NOT NULL COMMENT 'Nѯds',
  `channelid` int(11) NOT NULL COMMENT 'NzCA',
  `keep_login_users` int(11) DEFAULT NULL COMMENT 'dsH',
  `regdate` date DEFAULT NULL COMMENT '`䃺}()',
  `regusers` int(11) DEFAULT NULL COMMENT '`Ѫ`H',
  PRIMARY KEY (`statisdate`,`statis_reg_day`,`channelid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

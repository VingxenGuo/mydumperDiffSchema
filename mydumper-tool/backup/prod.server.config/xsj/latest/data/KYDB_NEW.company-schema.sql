/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `company` (
  `companyid` varchar(100) NOT NULL,
  `companyPWD` varchar(255) DEFAULT '96e79218965eb72c92a549dd5a330112',
  `companyname` varchar(200) DEFAULT NULL COMMENT '暱稱',
  `abbreviation` varchar(45) DEFAULT NULL COMMENT '暱稱縮寫',
  `whiteip` varchar(5000) DEFAULT NULL COMMENT '白名單',
  `mark` varchar(100) DEFAULT NULL COMMENT '備註',
  `updatetime` datetime NOT NULL COMMENT '時間',
  `status` int(11) NOT NULL COMMENT '狀態 0-啟用 1-停用',
  `game_launch_url` varchar(100) DEFAULT NULL,
  `game_launch_param` varchar(200) DEFAULT NULL,
  `type` int(11) NOT NULL DEFAULT '0' COMMENT '廠商類型 0:未歸類 1:透过bridge 2.直接对我方',
  PRIMARY KEY (`companyid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

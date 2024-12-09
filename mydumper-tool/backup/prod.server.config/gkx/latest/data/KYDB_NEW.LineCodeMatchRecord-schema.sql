/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `LineCodeMatchRecord` (
  `LID` int(11) NOT NULL AUTO_INCREMENT,
  `LineCode` varchar(50) DEFAULT NULL,
  `ChannelID` int(11) DEFAULT NULL,
  `lineCodes` varchar(600) DEFAULT NULL,
  `MatchFlag` varchar(500) DEFAULT NULL,
  `Games` varchar(500) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL,
  `CreateUser` varchar(50) DEFAULT NULL,
  `ISAllGame` int(11) DEFAULT NULL,
  `ISLineCode` int(11) DEFAULT NULL,
  `Mark` varchar(100) DEFAULT NULL,
  `UpdateTime` datetime DEFAULT NULL,
  PRIMARY KEY (`LID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE IF NOT EXISTS `View_BulletinLanguage`(
`ID` int,
`StartTime` int,
`EndTime` int,
`Btype` int,
`Title` int,
`Conntent` int,
`SendInterval` int,
`GameID` int,
`CreateUser` int,
`CreateTime` int,
`LastEditUser` int,
`LastEditTime` int,
`BulletinStatus` int,
`AB` int,
`IsDelete` int,
`Language` int,
`LanAB` int,
`GameName` int
) ENGINE=MEMORY;

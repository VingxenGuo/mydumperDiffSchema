/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE IF NOT EXISTS `View_Sys_Menu`(
`ID` int,
`MenuTitle` int,
`MneuTitleEN` int,
`PID` int,
`PMenuTitle` int,
`MenuLink` int,
`MenuIcon` int,
`Mark` int,
`Status` int,
`IsDelete` int,
`Sort` int
) ENGINE=MEMORY;

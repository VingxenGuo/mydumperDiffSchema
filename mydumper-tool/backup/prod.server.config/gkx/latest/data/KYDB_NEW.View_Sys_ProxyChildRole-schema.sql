/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE IF NOT EXISTS `View_Sys_ProxyChildRole`(
`Accounts` int,
`UserAccount` int,
`ChildID` int,
`ChannelID` int,
`UserPWD` int,
`NickName` int,
`UserStatus` int,
`CreateUser` int,
`LoginIP` int,
`Mark` int,
`IsDelete` int,
`LastloginTime` int,
`ProxyAccounts` int,
`UID` int,
`Forbidden` int,
`PChannelID` int,
`ISChild` int,
`CreateDate` int
) ENGINE=MEMORY;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE IF NOT EXISTS `View_UserInfo`(
`AccountID` int,
`UID` int,
`Accounts` int,
`UserPwd` int,
`NickName` int,
`UserStatus` int,
`CreateUser` int,
`CreateDate` int,
`SignIP` int,
`LastEditUser` int,
`LastEditDate` int,
`UserType` int,
`Mark` int,
`IsDelete` int,
`LastloginTime` int,
`Whether` int,
`IdentityPassword` int,
`UserAccount` int
) ENGINE=MEMORY;

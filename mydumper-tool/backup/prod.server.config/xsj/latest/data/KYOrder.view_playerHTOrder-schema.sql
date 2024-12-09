/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE IF NOT EXISTS `view_playerHTOrder`(
`orderId` int,
`orderNo` int,
`agentId` int,
`agentNickName` int,
`agentAccount` int,
`playerId` int,
`playerAccount` int,
`orderTime` int,
`currency` int,
`originScore` int,
`addScore` int,
`newScore` int,
`type` int,
`status` int,
`ip` int,
`createUser` int
) ENGINE=MEMORY;

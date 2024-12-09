/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `reduceScoreBlack` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `agentId` int(11) NOT NULL COMMENT '代理id',
  `account` varchar(190) NOT NULL COMMENT '会员帐号',
  `status` int(11) NOT NULL COMMENT '1: 黑名單, 2: 白名單',
  `mark` longtext COMMENT '原因',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `createUser` varchar(190) NOT NULL COMMENT '新增者',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `account_UNIQUE` (`account`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

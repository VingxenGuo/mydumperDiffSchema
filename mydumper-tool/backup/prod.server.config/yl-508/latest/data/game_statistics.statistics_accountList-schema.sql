/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `statistics_accountList` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `accountListReg` longtext COMMENT '注册账号列表',
  `accountListLogin` longtext COMMENT '登陆账号列表',
  `accountListGame` longtext COMMENT '登陆游戏账号列表',
  `accountListRoom` longtext COMMENT '登陆房间账号列表',
  `accountListCPI` longtext COMMENT '上分账号列表',
  `accountListPlayGame` longtext COMMENT '玩游戏账号列表',
  `yxReg` longtext COMMENT '有效注册比例列表',
  `createdate` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

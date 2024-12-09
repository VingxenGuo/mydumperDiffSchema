/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `rp_user` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `UID` int(11) DEFAULT NULL,
  `ChannelID` int(11) DEFAULT '0',
  `roleid` bigint(20) NOT NULL COMMENT '角色id',
  `name` varchar(255) NOT NULL COMMENT '用户名',
  `password` varchar(255) NOT NULL COMMENT '密码',
  `NickName` varchar(50) DEFAULT NULL,
  `UserStatus` int(11) DEFAULT '0',
  `CreateUser` varchar(50) DEFAULT NULL,
  `CreateDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `SignIP` varchar(50) DEFAULT NULL,
  `LastEditUser` varchar(50) DEFAULT NULL,
  `LastEditDate` datetime DEFAULT CURRENT_TIMESTAMP,
  `Mark` varchar(300) DEFAULT NULL,
  `IsDelete` int(11) DEFAULT '0',
  `LastloginTime` datetime DEFAULT NULL,
  `Whether` int(11) DEFAULT '0',
  `IdentityPassword` varchar(255) DEFAULT NULL COMMENT '身份密码',
  `isagent` int(11) DEFAULT '0' COMMENT '是否设置为代理商  0代理商  1开发商',
  `other` varchar(255) DEFAULT NULL,
  `Forbidden` int(11) DEFAULT '0',
  `Timezone` int(11) DEFAULT '0' COMMENT '0:北京时间(GTM+8),1:美东时间(GTM-4)',
  `login2FAKey` varchar(100) DEFAULT NULL,
  `isInitPwd` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `name` (`name`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `rp_power` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `pid` bigint(20) NOT NULL COMMENT '权限所在的模块',
  `name` varchar(255) NOT NULL COMMENT '权限名称',
  `code` varchar(255) NOT NULL COMMENT '权限唯一编码',
  `action` varchar(255) NOT NULL COMMENT '权限对应的接口',
  `mark` varchar(255) DEFAULT NULL,
  `sort` int(11) NOT NULL DEFAULT '0' COMMENT '排序',
  `icon` varchar(50) NOT NULL COMMENT '菜单图标',
  `status` bit(1) NOT NULL DEFAULT b'1' COMMENT '状态',
  `isagent` int(2) NOT NULL DEFAULT '0' COMMENT '是否代理商后台菜单',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8;

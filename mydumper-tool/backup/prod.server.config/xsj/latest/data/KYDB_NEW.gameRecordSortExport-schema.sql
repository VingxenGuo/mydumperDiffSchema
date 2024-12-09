/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `gameRecordSortExport` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `fileName` varchar(300) NOT NULL COMMENT '档案名称',
  `param` text NOT NULL COMMENT '请求参数',
  `language` varchar(10) DEFAULT NULL COMMENT '语系',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '1 = 等待处理中, 2 = 处理中, 3 = 完成, 4 = 失败',
  `createDate` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `endDate` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '更新結束时间',
  `createUser` varchar(50) DEFAULT NULL COMMENT '创建者',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='开发商-玩家盈利监控-导出纪录';

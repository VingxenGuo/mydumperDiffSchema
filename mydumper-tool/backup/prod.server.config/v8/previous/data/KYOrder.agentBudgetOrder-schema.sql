/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `agentBudgetOrder` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `agentId` int(11) NOT NULL COMMENT '代理ID',
  `agentAccount` varchar(190) NOT NULL COMMENT '代理账号',
  `agentOrderId` varchar(50) DEFAULT '' COMMENT '后台上下分订单号',
  `orderType` tinyint(1) NOT NULL DEFAULT '0' COMMENT '0 = 待审核, 1 = 允许, 2 = 拒绝',
  `score` varchar(11) NOT NULL DEFAULT '0' COMMENT '代理预算申请',
  `trxCurrency` varchar(10) NOT NULL DEFAULT '0' COMMENT '申请审核币别',
  `remark` text NOT NULL COMMENT '备注',
  `status` tinyint(1) NOT NULL DEFAULT '1' COMMENT '0 = 隐藏, 1 = 开启',
  `createTime` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `updateTime` timestamp NULL DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP COMMENT '最后更新时间',
  `createUser` varchar(50) DEFAULT NULL COMMENT '创建者',
  `updateUser` varchar(50) DEFAULT NULL COMMENT '最后修改者',
  PRIMARY KEY (`id`),
  KEY `IDX_channelId` (`agentId`) USING BTREE,
  KEY `IDX_orderId` (`agentOrderId`) USING BTREE
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4 COMMENT='代理申请审核充值请求记录';

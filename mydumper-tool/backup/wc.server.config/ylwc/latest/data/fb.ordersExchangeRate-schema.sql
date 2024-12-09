/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `ordersExchangeRate` (
  `id` varchar(100) NOT NULL COMMENT '訂單號',
  `ownCurrency` bigint(20) DEFAULT '1' COMMENT 'game_manage.rp_currency的 id',
  `stakeAmount` varchar(20) DEFAULT NULL COMMENT '投注額(本金)',
  `settleAmount` varchar(20) DEFAULT NULL COMMENT '結算派獎金額',
  `maxWinAmount` varchar(20) DEFAULT NULL COMMENT '最大可贏金額',
  `loseAmount` varchar(20) DEFAULT NULL COMMENT '最大賠付金額',
  `cashOutTotalStake` varchar(20) DEFAULT NULL COMMENT '提前結算總本金',
  `cashOutPayoutStake` varchar(20) DEFAULT NULL COMMENT '提前結算總派獎額',
  `unitStake` varchar(20) DEFAULT NULL COMMENT '每單金額(混合串關時用到)',
  `maxStake` varchar(20) DEFAULT NULL COMMENT '最大投注額',
  `validSettleStakeAmount` varchar(20) DEFAULT NULL COMMENT '有效已結算投注額',
  `validSettleAmount` varchar(20) DEFAULT NULL COMMENT '有效返還額',
  `cashOutCancelStake` varchar(20) DEFAULT NULL COMMENT '提前結算取消總額',
  `version` tinyint(4) NOT NULL COMMENT '數據變更標記，升序，根據大小可判斷是否是最新的數據',
  `rowCreateTime` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '資料创建时间',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

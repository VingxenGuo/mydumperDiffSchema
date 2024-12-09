/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `jackpot_payout_record` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `order_id` varchar(190) NOT NULL COMMENT '訂單ID',
  `agent` int(11) NOT NULL COMMENT '代理ID',
  `order_time` datetime DEFAULT NULL COMMENT '訂單時間',
  `order_type` int(11) NOT NULL COMMENT '賬變類型',
  `cur_score` bigint(20) DEFAULT NULL COMMENT '賬變前金額',
  `add_score` bigint(20) NOT NULL COMMENT '賬變金額',
  `new_score` bigint(20) DEFAULT NULL COMMENT '賬變後金額',
  `order_ip` varchar(50) NOT NULL COMMENT '操作IP',
  `create_user` varchar(50) NOT NULL COMMENT '操作帳號',
  `order_status` int(11) NOT NULL COMMENT '訂單狀態:0成功,1處理中,2異常',
  `error_msg` varchar(200) DEFAULT NULL COMMENT '錯誤訊息',
  `ref_game_user_no` varchar(50) DEFAULT NULL COMMENT '關聯遊戲紀錄GameUserNo',
  `game_user_no` varchar(50) DEFAULT NULL COMMENT '派獎遊戲紀錄GameUserNo',
  `payout_user` varchar(50) DEFAULT NULL COMMENT '派獎者(自動或派獎帳號)',
  `pool_tier` int(11) NOT NULL COMMENT '獎金池Tier',
  `create_date` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '創建時間',
  `auditor` varchar(50) DEFAULT NULL COMMENT '审核员',
  `audit_date` timestamp NULL DEFAULT NULL COMMENT '审核时间',
  `refGameID` int(10) NOT NULL COMMENT '关联游戏ID',
  `refRoomID` int(10) NOT NULL COMMENT '关联游戏房间ID',
  `refGameBet` bigint(20) DEFAULT NULL COMMENT '关联游戏中奖投注',
  `poolActualAmount` bigint(20) DEFAULT NULL COMMENT '当时实际奖池',
  `poolFrontAmount` bigint(20) DEFAULT NULL COMMENT '当时实际前端奖池',
  `trx_currency` varchar(50) DEFAULT NULL COMMENT '关联游戏中奖投注币别',
  PRIMARY KEY (`id`),
  KEY `index_agent_time` (`agent`,`audit_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

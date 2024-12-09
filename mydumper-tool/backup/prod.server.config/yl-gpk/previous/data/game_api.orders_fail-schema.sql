/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `orders_fail` (
  `proxy_url` varchar(200) NOT NULL COMMENT '代理下分api的url',
  `agents` varchar(200) NOT NULL COMMENT '代理編號',
  `account` varchar(200) NOT NULL COMMENT '會員帳號',
  `order_id` varchar(100) NOT NULL COMMENT '下分的訂單編號',
  `money` varchar(35) DEFAULT NULL COMMENT '下分金額',
  `to_mail` varchar(200) NOT NULL COMMENT '通知代理的e-mail',
  `subject` varchar(200) NOT NULL COMMENT '信件主旨',
  `msg_text` varchar(1000) NOT NULL COMMENT '信件內容',
  `mail_url` varchar(1000) NOT NULL COMMENT '信件轉發器的url',
  `status` varchar(3) NOT NULL COMMENT '訂單狀態0:會員下分成功,1:會員下分失敗需寄信2:會員下分失敗且已寄信',
  `create_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '訂單失敗時間',
  `update_time` timestamp NULL DEFAULT CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`order_id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

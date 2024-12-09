/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `bgDepolyment_sync_log` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `level` varchar(50) DEFAULT NULL COMMENT '紀錄危急等級(info/warn/error)',
  `server` varchar(50) DEFAULT NULL COMMENT '發送紀錄伺服器(blue/green)',
  `serverIp` varchar(50) DEFAULT NULL COMMENT '發送紀錄伺服器IP',
  `isMain` int(11) DEFAULT '0' COMMENT '發送紀錄伺服器主副狀態(0:unknown;1:主;2副)',
  `action` int(11) DEFAULT NULL COMMENT '操作(1:藍綠互連成功;2:藍綠中斷互連)',
  `message` text COMMENT '操作資訊',
  `exception` varchar(500) DEFAULT NULL COMMENT '例外錯誤資訊',
  `execTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '伺服器收到請求時間',
  `createTime` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '紀錄創建時間',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4;

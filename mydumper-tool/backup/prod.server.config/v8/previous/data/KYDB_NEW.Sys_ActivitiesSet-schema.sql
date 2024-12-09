/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `Sys_ActivitiesSet` (
  `ID` int(11) NOT NULL AUTO_INCREMENT,
  `ActivityType` varchar(50) DEFAULT NULL,
  `Winningrate` varchar(20) DEFAULT NULL COMMENT '活动中奖率',
  `Totalbonus` varchar(20) DEFAULT NULL COMMENT '活动总资金',
  `Singipupper` varchar(20) DEFAULT NULL COMMENT '单IP奖励上限',
  `Moneyreturnrate` varchar(20) DEFAULT NULL COMMENT '返奖率',
  `BeginDate` varchar(20) DEFAULT NULL COMMENT '活动开启日期',
  `EndDate` varchar(20) DEFAULT NULL COMMENT '活动结束日期',
  `BeginTime` varchar(20) DEFAULT NULL COMMENT '活动开启时间',
  `EndTime` varchar(20) DEFAULT NULL COMMENT '活动结束时间',
  `Status` int(11) DEFAULT '0' COMMENT '状态',
  `ForntPerMaxPrize` varchar(20) DEFAULT NULL COMMENT '单次派奖上线',
  `DropoutGames` varchar(255) DEFAULT NULL COMMENT '不参与的游戏ID',
  `Joinchannelid` varchar(5000) DEFAULT NULL,
  `Dropoutlinecode` varchar(500) DEFAULT NULL COMMENT '不参与的linecode',
  `FrontWinningrate` varchar(20) DEFAULT NULL COMMENT '前端显示的中奖率',
  `Totalmoney` varchar(50) DEFAULT NULL COMMENT '前端显示的总金额',
  `NoticeTime` varchar(50) DEFAULT NULL COMMENT '前端活动预告时间',
  `CreateUser` varchar(50) DEFAULT NULL,
  `CreateTime` datetime DEFAULT NULL,
  `LastEditUser` varchar(50) DEFAULT NULL,
  `LastEditTime` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB  DEFAULT CHARSET=utf8mb4;

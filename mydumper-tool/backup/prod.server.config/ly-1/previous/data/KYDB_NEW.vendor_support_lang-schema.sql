/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
CREATE TABLE `vendor_support_lang` (
  `vendor_id` varchar(100) NOT NULL COMMENT '外接厂商id    對應 KYDB_NEW.company',
  `vendor_abbreviation` varchar(20) NOT NULL COMMENT '外接厂商支援之语系名称',
  `language_id` int(11) NOT NULL COMMENT '語系id 對應 kydb_new.Sys_Language',
  PRIMARY KEY (`language_id`,`vendor_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

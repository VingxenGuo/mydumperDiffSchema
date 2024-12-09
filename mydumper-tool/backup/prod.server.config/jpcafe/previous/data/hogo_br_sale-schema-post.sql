/*!40101 SET NAMES binary*/;
/*!40014 SET FOREIGN_KEY_CHECKS=0*/;
/*!40101 SET SQL_MODE='NO_AUTO_VALUE_ON_ZERO,NO_ENGINE_SUBSTITUTION'*/;
/*!40103 SET TIME_ZONE='+00:00' */;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP PROCEDURE IF EXISTS `sp_cron_partition`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_cron_partition`()
BEGIN
                DECLARE v_sql LONGTEXT; 
                DECLARE v_nextDate varchar(12);	
                DECLARE v_nextPartitionAbbr varchar(20); 
                DECLARE v_nextPartitionDateFormat varchar(20); 
                DECLARE v_nextIntervalForDay INT; 
                DECLARE v_accumulator INT; 
                
                DECLARE v_starttime TIMESTAMP(3); 
                DECLARE v_endtime TIMESTAMP(3); 
            
                DECLARE cursorPartitionDatabase varchar(30); 
                DECLARE cursorPartitionTable varchar(50); 
                DECLARE cursorPartitionType varchar(20); 
                DECLARE cursorPartitionColumns varchar(20); 
                DECLARE cursorPartitionFunction varchar(30); 
                
                DECLARE done BOOLEAN DEFAULT 0; 
                
                DECLARE cronPartition CURSOR FOR select PartitionDatabase, PartitionTable, PartitionType, PartitionColumns, PartitionFunction from hogo_br_sale.sys_cron_partition where PartitionStatus = 1; 
                DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1; 
                
                set v_starttime = CURRENT_TIMESTAMP(3); 
                
                OPEN cronPartition; 
                    partitionLoop: LOOP
                        FETCH cronPartition INTO cursorPartitionDatabase, cursorPartitionTable, cursorPartitionType, cursorPartitionColumns, cursorPartitionFunction; 
                        
                        IF done THEN
                            LEAVE partitionLoop; 
                        END IF; 
                                
                        set v_sql = '';														
                        
                        IF cursorPartitionType = 'month' THEN
                            set v_nextDate = DATE_FORMAT(DATE_ADD(NOW(), interval 1 MONTH), '%Y%m');				
                            set v_nextPartitionAbbr = concat('p_', v_nextDate); 
                            set @v_nextDate = DATE_FORMAT(DATE_ADD(NOW(), interval 2 MONTH), '%Y%m'); 
                            set @v_nextPartitionAbbr = concat('p_', @v_nextDate);		
                            IF cursorPartitionFunction = 'UNIX_TIMESTAMP' THEN
                                set v_nextPartitionDateFormat = concat(DATE_FORMAT(DATE_ADD(NOW(), interval 1 MONTH), '%Y-%m'),'-01 00:00:00');				
                                set @v_nextPartitionDateFormat = concat(DATE_FORMAT(DATE_ADD(NOW(), interval 2 MONTH), '%Y-%m'),'-01 00:00:00');				
                            ELSEIF cursorPartitionFunction = 'to_days' THEN
                                set v_nextPartitionDateFormat = concat(DATE_FORMAT(DATE_ADD(NOW(), interval 1 MONTH), '%Y-%m'),'-01');				
                                set @v_nextPartitionDateFormat = concat(DATE_FORMAT(DATE_ADD(NOW(), interval 2 MONTH), '%Y-%m'),'-01');		
                            END IF; 
                            
                            IF EXISTS( SELECT PARTITION_NAME FROM information_schema.`PARTITIONS` WHERE table_name = cursorPartitionTable and partition_name IS NULL) THEN					
                                set v_sql = concat( 'ALTER TABLE ', cursorPartitionDatabase, '.', cursorPartitionTable, ' PARTITION BY RANGE ( ', cursorPartitionFunction, '(`', cursorPartitionColumns, '`)) ( PARTITION ', v_nextPartitionAbbr, ' VALUES LESS THAN (', cursorPartitionFunction, '(''', v_nextPartitionDateFormat, ''')))' );						
                                
                                set @v_sql = v_sql; 
                                PREPARE stmt from @v_sql; 
                                execute stmt; 
                                DEALLOCATE PREPARE stmt; 
                            END IF; 
                            
                            IF NOT EXISTS( SELECT * FROM information_schema.`PARTITIONS` WHERE table_name = cursorPartitionTable and partition_name = @v_nextPartitionAbbr) THEN    																
                                set v_sql = concat( 'ALTER TABLE ', cursorPartitionDatabase, '.', cursorPartitionTable , ' ADD PARTITION ( PARTITION ', @v_nextPartitionAbbr , ' VALUES LESS THAN (', cursorPartitionFunction, '(''', @v_nextPartitionDateFormat, ''')))' );									
                                
                                set @v_sql = v_sql;					
                                PREPARE stmt from @v_sql; 
                                execute stmt; 
                                DEALLOCATE PREPARE stmt; 
                            END IF;								
                        END IF;	
                        
                        IF cursorPartitionType = 'day' THEN
                            set v_accumulator = 0; 
                            set v_nextIntervalForDay = 2; 
                            while v_accumulator <= v_nextIntervalForDay DO
                                set v_nextDate = DATE_FORMAT(DATE_ADD(NOW(), interval v_accumulator + 1 DAY), '%Y%m%d'); 
                                select v_nextDate; 
                                set v_nextPartitionAbbr = concat('p_', v_nextDate); 
                                IF cursorPartitionFunction = 'UNIX_TIMESTAMP' THEN
                                    set v_nextPartitionDateFormat = concat(DATE_FORMAT(DATE_ADD(NOW(), interval v_accumulator + 1 DAY), '%Y-%m-%d'),' 00:00:00'); 
                                ELSEIF cursorPartitionFunction = 'to_days' THEN
                                    set v_nextPartitionDateFormat = DATE_FORMAT(DATE_ADD(NOW(), interval v_accumulator + 1 DAY), '%Y-%m-%d'); 
                                END IF; 
                                
                                IF EXISTS( SELECT PARTITION_NAME FROM information_schema.`PARTITIONS` WHERE table_name = cursorPartitionTable and partition_name IS NULL) THEN					
                                    set v_sql = concat( 'ALTER TABLE ', cursorPartitionDatabase, '.', cursorPartitionTable, ' PARTITION BY RANGE ( ', cursorPartitionFunction, '(`', cursorPartitionColumns, '`)) ( PARTITION ', v_nextPartitionAbbr, ' VALUES LESS THAN (', cursorPartitionFunction, '(''', v_nextPartitionDateFormat, ''')))' );									
                                    
                                    set @v_sql = v_sql; 
                                    PREPARE stmt from @v_sql; 
                                    execute stmt; 
                                    DEALLOCATE PREPARE stmt; 
                                END IF; 
                                
                                IF NOT EXISTS( SELECT * FROM information_schema.`PARTITIONS` WHERE table_name = cursorPartitionTable and partition_name = v_nextPartitionAbbr) THEN    											
                                    set v_sql = concat( 'ALTER TABLE ', cursorPartitionDatabase, '.', cursorPartitionTable , ' ADD PARTITION ( PARTITION ', v_nextPartitionAbbr , ' VALUES LESS THAN (', cursorPartitionFunction, '(''', v_nextPartitionDateFormat, ''')))' );									
                                    
                                    set @v_sql = v_sql;					
                                    PREPARE stmt from @v_sql; 
                                    execute stmt; 
                                    DEALLOCATE PREPARE stmt; 
                                END IF;	
                                set v_accumulator = v_accumulator + 1; 
                            end while; 
                        END IF;								
                        END LOOP partitionLoop; 
                CLOSE cronPartition; 
                
                set v_endtime = CURRENT_TIMESTAMP(); 
                insert into hogo_br_sale.sys_prolog values(NOW(),'hogo_br_sale.sp_cron_partition',TIMESTAMPDIFF(SECOND,v_starttime,v_endtime), ''); 
                
            END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP PROCEDURE IF EXISTS `sp_partition_monthly_archive`;
CREATE DEFINER=`nodejs`@`10.21.0.%` PROCEDURE `sp_partition_monthly_archive`(
	IN `table_name_param` VARCHAR(255),
	IN `month_param` VARCHAR(7)
)
BEGIN
    DECLARE v_starttime TIMESTAMP(3); 
    DECLARE v_endtime TIMESTAMP(3); 
    DECLARE target_partition_name VARCHAR(255); 
    DECLARE target_table_name VARCHAR(255); 
    DECLARE target_date DATE; 
    DECLARE db_name VARCHAR(255); 
    DECLARE tbl_name VARCHAR(255); 
    DECLARE table_name VARCHAR(255); 
    DECLARE stmt VARCHAR(1000); 

    set v_starttime = CURRENT_TIMESTAMP(); 

    -- 設置錶名，如果未提供則使用默認錶名 'wallet_ledgers'
    SET table_name = IFNULL(table_name_param, 'wallet_ledgers'); 

        -- 解析數據庫名和錶名
    IF LOCATE('.', table_name) > 0 THEN
        SET db_name = SUBSTRING_INDEX(table_name, '.', 1); 
        SET tbl_name = SUBSTRING_INDEX(table_name, '.', -1); 
    ELSE
        SET db_name = DATABASE();  -- 使用當前默認數據庫
        SET tbl_name = table_name; 
    END IF; 


    -- 設置 target_date，根據是否傳入參數決定使用的月份
    IF month_param IS NOT NULL AND month_param != '' THEN
        SET target_date = STR_TO_DATE(CONCAT(month_param, '-01'), '%Y-%m-%d'); 
    ELSE
        -- 預設舊分區的名稱（超過三個月前的分區）
        SET target_date = DATE_SUB(CURDATE(), INTERVAL 4 MONTH); 
    END IF; 

    -- 目標partition名稱需加一個月 因partition是以結束月份來當名稱
    SET target_partition_name = CONCAT('p_', DATE_FORMAT(DATE_ADD(target_date, INTERVAL 1 MONTH), '%Y%m')); 

    -- 檢查舊分區是否存在
    IF EXISTS (
        SELECT 1 FROM information_schema.partitions
        WHERE TABLE_NAME = table_name 
          AND partition_name = target_partition_name
    ) THEN
        -- 設置目標歸檔錶的名稱
        SET target_table_name = CONCAT(db_name, '.', tbl_name, '_', DATE_FORMAT(target_date, '%Y%m')); 

        -- 創建歸檔錶
        SET @create_table_sql = CONCAT(
            'CREATE TABLE IF NOT EXISTS ', target_table_name, 
            ' LIKE ', db_name, '.', tbl_name, ';'
        ); 
        PREPARE stmt FROM @create_table_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 

        -- 將舊分區數據移動到歸檔錶
        SET @move_data_sql = CONCAT(
            'INSERT INTO ', target_table_name, 
            ' SELECT * FROM ', db_name, '.', tbl_name, ' PARTITION(', target_partition_name, ');'
        ); 
        PREPARE stmt FROM @move_data_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 

        -- 刪除舊分區
        SET @drop_partition_sql = CONCAT(
            'ALTER TABLE ', db_name, '.', tbl_name, ' DROP PARTITION ', target_partition_name, ';'
        ); 
        PREPARE stmt FROM @drop_partition_sql; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 
    END IF; 

    SET v_endtime = CURRENT_TIMESTAMP(); 
    INSERT INTO hogo_br_sale.sys_prolog VALUES (NOW(),'hogo_br_sale.sp_partition_monthly_archive', TIMESTAMPDIFF(SECOND,v_starttime,v_endtime), target_table_name); 
END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP PROCEDURE IF EXISTS `sp_statis_brokerage`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statis_brokerage`(IN `statisDate` DATE)
BEGIN
        
        DECLARE v_starttime TIMESTAMP(3); 
        DECLARE v_endtime TIMESTAMP(3); 
    
        DECLARE v_startdt TIMESTAMP(3); 
        DECLARE v_enddt TIMESTAMP(3); 
    
        
        IF statisDate IS NULL THEN
            SET statisDate = DATE(CURDATE() - INTERVAL 1 DAY); 
        END IF; 
        
        SET v_starttime = CURRENT_TIMESTAMP(3); 
        
    
        SET v_enddt = CONCAT(statisDate, ' 23:59:59.999'); 
        SET v_startdt = CONCAT(statisDate, ' 00:00:00'); 

        
        SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`brokerage_date`(record_date, user_id, symbol, brokerage, created_at, updated_at) 
        select DATE_FORMAT(''', statisDate,''', ''%Y-%m-%d'') as record_date, 
            a.user_id as user_id,
            a.symbol as symbol,
            sum(a.bmoney) as brokerage,
            now(),
            now()
        from `hogo_br_sale`.`brokerage` a
        where a.created_at >= ''',v_startdt,''' and a.created_at <= ''',v_enddt,'''
        group by record_date, a.user_id, a.symbol'); 


        PREPARE stmt FROM @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 

        
        set v_endtime = CURRENT_TIMESTAMP(); 
        insert into hogo_br_sale.sys_prolog values(NOW(),'hogo_br_sale.sp_statis_brokerage',TIMESTAMPDIFF(SECOND,v_starttime,v_endtime), statisDate); 
    END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP PROCEDURE IF EXISTS `sp_statis_daily_report_all`;
CREATE DEFINER=`nodejs`@`10.21.0.%` PROCEDURE `sp_statis_daily_report_all`(IN statisDate DATE)
BEGIN
    DECLARE v_starttime TIMESTAMP(3); 
    DECLARE v_endtime TIMESTAMP(3);                    
    
    DECLARE v_startdt TIMESTAMP(3); 
    DECLARE v_enddt TIMESTAMP(3); 
            
    -- 如果 updateTime 参数为 NULL，则使用当前时间
    IF statisDate IS NULL THEN
        SET statisDate = DATE(CURDATE() - INTERVAL 1 DAY); 
    END IF; 
                
    SET v_starttime = CURRENT_TIMESTAMP(3); 
            
    -- 取得统计前一天时间范围
    SET v_enddt = CONCAT(statisDate, ' 23:59:59'); 
    SET v_startdt = CONCAT(statisDate, ' 00:00:00'); 
    
    SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`daily_report_all`(time, channel_id, symbol, paymoney, payfees, peypeople) 
        SELECT DATE_FORMAT(''', statisDate,''', ''%Y-%m-%d'') as time, c.channel_id as channel_id, 
            b.symbol as symbol,
            sum(a.payout) as paymoney,
            sum(a.fee) as payfees,
            count(distinct c.id) as peypeople
        from hogo_br_sale.topups a 
        left join hogo_br_sale.wallets b on a.wallet_id = b.id 
        left join hogo_br_sale.users c on b.user_id = c.id 
        where a.paid_at >= ''',v_startdt,''' and a.paid_at <= ''',v_enddt,'''
        and a.status = 2 and b.position = ''CASH'' group by c.channel_id, b.symbol
        ON DUPLICATE KEY UPDATE paymoney = VALUES(paymoney), payfees = VALUES(payfees), peypeople = VALUES(peypeople);'); 
                
    
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt; 
                
    
    SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`daily_report_all`(time, channel_id, symbol, reflectmoney, reflectsalary, reflectreward, reflectfees, reflectnum) 
        SELECT DATE_FORMAT(''',statisDate,''', ''%Y-%m-%d'') as time, c.channel_id, 
            b.symbol as symbol,
            SUM(payout) AS reflectmoney,
            SUM(IF(b.position = ''SALARY'', payout, 0)) AS reflectsalary,
            SUM(IF(b.position = ''COMMISSION'', payout, 0)) AS reflectreward,
            SUM(a.fee) AS reflectfees,
            COUNT(DISTINCT c.id) AS reflectnum
        from hogo_br_sale.withdrawals a 
        left join hogo_br_sale.wallets b on a.wallet_id = b.id 
        left join hogo_br_sale.users c on b.user_id = c.id 
        where a.verified_at >= ''',v_startdt,''' and a.verified_at <= ''',v_enddt,''' 
        and a.status = 4 group by c.channel_id, b.symbol
        ON DUPLICATE KEY UPDATE reflectmoney = VALUES(reflectmoney), reflectsalary = VALUES(reflectsalary), reflectreward = VALUES(reflectreward), reflectfees = VALUES(reflectfees), reflectnum = VALUES(reflectnum);'); 
               
    
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt; 
                    
    
    SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`daily_report_all`(time, channel_id, symbol, newusermoney, newuserpeople) 
        SELECT DATE_FORMAT(''',statisDate,''', ''%Y-%m-%d'') as time, c.channel_id, 
            b.symbol as symbol,
            sum(a.payout) as newusermoney,
            count(DISTINCT c.id) as newuserpeople
        from hogo_br_sale.topups a 
        left join hogo_br_sale.wallets b on a.wallet_id = b.id 
        left join hogo_br_sale.users c on b.user_id = c.id 
        where paid_at >= ''',v_startdt,''' and paid_at <= ''',v_enddt,''' 
        and c.created_at >= ''',v_startdt,''' and c.created_at <= ''',v_enddt,'''
        and a.status = 2 group by c.channel_id, b.symbol
        ON DUPLICATE KEY UPDATE newusermoney = VALUES(newusermoney), newuserpeople = VALUES(newuserpeople);'); 
                
    
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt; 
                    
    
    SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`daily_report_all`(time, channel_id, symbol, newuser) 
        SELECT DATE_FORMAT(''',statisDate,''', ''%Y-%m-%d'') as time, 
        a.channel_id as channel_id,
        b.symbol as symbol, 
        count(a.id) as newuser 
        from hogo_br_sale.users a
        left join channels b on a.channel_id = b.id 
        where a.created_at >= ''',v_startdt,''' and a.created_at <= ''',v_enddt,'''
        group by a.channel_id, b.symbol
        ON DUPLICATE KEY UPDATE newuser = VALUES(newuser);'); 
                
    
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt; 
                    
    
    SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`daily_report_all`(time, channel_id, symbol, activeuser) 
        SELECT DATE_FORMAT(''',statisDate,''', ''%Y-%m-%d'') as time, 
        a.channel_id as channel_id,
        a.currency as symbol, 
        count(DISTINCT a.username) as activeuser 
        from hogo_br_play.vp_order a
        left join hogo_br_sale.users b on CONVERT(a.username USING utf8mb4) = CONVERT(b.username USING utf8mb4)
        left join hogo_br_sale.channels c on CONVERT(b.channel_id USING utf8mb4) = CONVERT(c.id USING utf8mb4)
        left join hogo_br_sale.wallets d on CONVERT(d.user_id USING utf8mb4) = CONVERT(a.wallet_id USING utf8mb4)
        WHERE
        CONVERT(a.channel_id USING utf8mb4) = CONVERT(c.id USING utf8mb4)
        AND CONVERT(b.channel_id USING utf8mb4) = CONVERT(a.channel_id USING utf8mb4)
        AND a.created_at >= ''',v_startdt,''' and a.created_at <= ''',v_enddt,''' 
        group by a.channel_id, a.currency
        ON DUPLICATE KEY UPDATE activeuser = VALUES(activeuser);'); 
    
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt;	
            
    
    SET @v_sqlselect = CONCAT('UPDATE `hogo_br_sale`.`daily_report_all` SET profit = paymoney - reflectmoney
        where time >= ''',v_startdt,''' and time <= ''',v_enddt,''';'); 
                
    
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt;	
    
    
    SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`daily_report_all`(time, channel_id, symbol, repaypeople) 
        SELECT DATE_FORMAT(''',statisDate,''', ''%Y-%m-%d'') as time, c.channel_id,
        b.symbol as symbol,
        COUNT(DISTINCT b.user_id) as repaypeople
        FROM hogo_br_sale.topups a
        left join hogo_br_sale.wallets b on a.wallet_id = b.id 
        left join hogo_br_sale.users c on b.user_id = c.id 
        WHERE DATE(paid_at) = ''',v_startdt,''' AND b.user_id IN (
            SELECT user_id
                FROM hogo_br_sale.topups a
                left join hogo_br_sale.wallets b on a.wallet_id = b.id 
                WHERE DATE(paid_at) = DATE(''',v_startdt,''' - INTERVAL 1 DAY)
                and a.status = 2 and b.position = ''CASH''
            ) and a.status = 2 and b.position = ''CASH''
        group by c.channel_id, b.symbol
        ON DUPLICATE KEY UPDATE repaypeople = VALUES(repaypeople);'); 

    
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt;	
                
    
    SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`daily_report_all`(time, channel_id, symbol, yesterdaypaypeople) 
        SELECT DATE_FORMAT(''',statisDate,''', ''%Y-%m-%d'') AS time,
            c.channel_id,  b.symbol as symbol,
            count(DISTINCT c.id)  AS yesterday_paypeople
        FROM hogo_br_sale.topups a
        left join hogo_br_sale.wallets b on a.wallet_id = b.id 
        left join hogo_br_sale.users c on b.user_id = c.id 
        WHERE DATE(paid_at) = DATE(''',v_startdt,''' - INTERVAL 1 DAY)
        GROUP BY c.channel_id, b.symbol
        ON DUPLICATE KEY UPDATE yesterdaypaypeople = VALUES(yesterdaypaypeople);'); 
            
    
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt;	

    SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`daily_report_all`(time, channel_id, symbol, wallet_channel_gain) 
        SELECT DATE_FORMAT(''',statisDate,''', ''%Y-%m-%d'') AS time,
            b.channel_id,  b.symbol as symbol,
            SUM(
                (
                    SELECT IFNULL(SUM(score), 0) FROM hogo_br_sale.channel_wallet_ledgers
                    WHERE created_at >= ''',v_startdt,''' and created_at <= ''',v_enddt,''' 
                    AND type = 1 
                    AND wallet_serial = a.wallet_serial
                )-(
                    SELECT IFNULL(SUM(score), 0) FROM hogo_br_sale.channel_wallet_ledgers 
                    WHERE created_at >= ''',v_startdt,''' and created_at <= ''',v_enddt,''' 
                    AND type =2
                    AND wallet_serial = a.wallet_serial
                )
            ) AS wallet_channel_gain
        FROM hogo_br_sale.channel_wallet_ledgers a
        LEFT JOIN hogo_br_sale.channel_wallets b on a.wallet_serial = b.serial 
        LEFT JOIN hogo_br_sale.channels c on c.id = b.channel_id 
        WHERE a.created_at >= ''',v_startdt,''' and a.created_at <= ''',v_enddt,''' 
        GROUP BY b.channel_id, b.symbol
        ON DUPLICATE KEY UPDATE wallet_channel_gain = VALUES(wallet_channel_gain);'); 
            
    
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt;	


    SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`daily_report_all`(time, channel_id, symbol, wallet_paymoney, wallet_paypeople) 
        SELECT DATE_FORMAT(''',statisDate,''', ''%Y-%m-%d'') AS time,
            c.channel_id, b.symbol as symbol,
            SUM(a.gain + a.loss) AS wallet_paymoney,
            count(DISTINCT c.id) AS wallet_paypeople
        FROM hogo_br_sale.wallet_ledgers a
        left join hogo_br_sale.wallets b on a.wallet_id = b.id 
        left join hogo_br_sale.users c on b.user_id = c.id 
         WHERE a.created_at >= ''',v_startdt,''' and a.created_at <= ''',v_enddt,''' 
        AND type_id = 2
        GROUP BY c.channel_id, b.symbol
        ON DUPLICATE KEY UPDATE wallet_paymoney = VALUES(wallet_paymoney), wallet_paypeople = VALUES(wallet_paypeople);'); 
            
    
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt;	

    SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`daily_report_all`(time, channel_id, symbol, wallet_reflectsalary, wallet_reflectnum) 
        SELECT DATE_FORMAT(''',statisDate,''', ''%Y-%m-%d'') AS time,
            c.channel_id,  
            b.symbol as symbol,
            SUM(a.gain + a.loss) AS wallet_reflectsalary,
            count(DISTINCT c.id) AS wallet_reflectnum
        FROM hogo_br_sale.wallet_ledgers a
        left join hogo_br_sale.wallets b on a.wallet_id = b.id 
        left join hogo_br_sale.users c on b.user_id = c.id 
        WHERE a.created_at >= ''',v_startdt,''' and a.created_at <= ''',v_enddt,''' 
        AND type_id = 3
        GROUP BY c.channel_id, b.symbol
        ON DUPLICATE KEY UPDATE wallet_reflectsalary = VALUES(wallet_reflectsalary), wallet_reflectnum = VALUES(wallet_reflectnum);'); 
            
    
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt;	

    SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`daily_report_all`(time, channel_id, symbol, wallet_user_profit) 
        SELECT DATE_FORMAT(''',statisDate,''', ''%Y-%m-%d'') AS time,
            c.channel_id,  
            b.symbol as symbol,
            SUM(a.gain - a.loss) AS wallet_user_profit
        FROM hogo_br_sale.wallet_ledgers a
        left join hogo_br_sale.wallets b on a.wallet_id = b.id 
        left join hogo_br_sale.users c on b.user_id = c.id 
        WHERE a.created_at >= ''',v_startdt,''' and a.created_at <= ''',v_enddt,''' 
        AND type_id IN ("1002","1003","1005")
        GROUP BY c.channel_id, b.symbol
        ON DUPLICATE KEY UPDATE wallet_user_profit = VALUES(wallet_user_profit);'); 
            
    
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt;	

    SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`daily_report_all`(time, channel_id, symbol, wallet_user_loss) 
        SELECT DATE_FORMAT(''',statisDate,''', ''%Y-%m-%d'') AS time,
            c.channel_id,  
            b.symbol as symbol,
            SUM(a.loss) AS wallet_user_loss
        FROM hogo_br_sale.wallet_ledgers a
        left join hogo_br_sale.wallets b on a.wallet_id = b.id 
        left join hogo_br_sale.users c on b.user_id = c.id 
        WHERE a.created_at >= ''',v_startdt,''' and a.created_at <= ''',v_enddt,''' 
        AND type_id IN ("1002")
        GROUP BY c.channel_id, b.symbol
        ON DUPLICATE KEY UPDATE wallet_user_loss = VALUES(wallet_user_loss);'); 
            
    
    PREPARE stmt FROM @v_sqlselect; 
    EXECUTE stmt; 
    DEALLOCATE PREPARE stmt;	
            
    -- log sp name and time
    set v_endtime = CURRENT_TIMESTAMP(); 
        insert into `hogo_br_sale`.`sys_prolog` values(NOW(),'hogo_br_sale.sp_statis_daily_report_all',TIMESTAMPDIFF(SECOND,v_starttime,v_endtime), statisDate); 
    END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP PROCEDURE IF EXISTS `sp_statis_daily_report_user`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statis_daily_report_user`(IN `statisDate` DATE)
BEGIN
        DECLARE v_starttime TIMESTAMP(3); 
        DECLARE v_endtime TIMESTAMP(3); 

        DECLARE v_startdt TIMESTAMP(3); 
        DECLARE v_enddt TIMESTAMP(3); 

        
        IF statisDate IS NULL THEN
            SET statisDate = DATE(CURDATE() - INTERVAL 1 DAY); 
        END IF; 

        SET v_starttime = CURRENT_TIMESTAMP(3); 

        
    SET v_enddt = CONCAT(statisDate, ' 23:59:59.999999'); 
    SET v_startdt = CONCAT(statisDate, ' 00:00:00'); 
          
    

    SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`daily_report_user`(time, user_id, symbol, topup, withdrawal, sys_cashier, token_purchase, token_receive,
        roulette, roulette_reward, sys_cashier_bonus, commission_withdraw, commission_redemption, sys_cashier_salary, promotion_chest,
        invitation_chest, bonus_topup_initial, bonus_topup_fever)
        select DATE_FORMAT(''',statisDate,''', ''%Y-%m-%d'') as time, 
                      b.user_id as user_id, 
            c.symbol as symbol,
                        SUM(IF(a.type = ''topup'', gain * e.rate , 0)) AS topup,
                        SUM(IF(a.type = ''withdrawal'', loss * e.rate , 0)) AS withdrawal,
                        SUM(IF(a.type = ''system-cashier'', (gain-loss) * e.rate , 0)) AS sys_cashier,
                        SUM(IF(a.type = ''token-purchase'', gain * e.rate , 0)) AS token_purchase,
                        SUM(IF(a.type = ''token-receive'', gain , 0)) AS token_receive,
                        SUM(IF(a.type = ''roulette'', loss , 0)) AS roulette,
                        SUM(IF(a.type = ''roulette-reward'', gain * e.rate , 0)) AS roulette_reward,
                        SUM(IF(a.type = ''system-cashier-bonus'', (gain-loss) * e.rate , 0)) AS sys_cashier_bonus,
                        SUM(IF(a.type = ''withdrawal-invite-commission'', loss * e.rate , 0)) AS commission_withdraw,
                        SUM(IF(a.type = ''redemption-invite-commission'', loss * e.rate , 0)) AS commission_redemption,
                        SUM(IF(a.type = ''system-cashier-salary'', (gain-loss) * e.rate , 0)) AS sys_cashier_salary,
                        SUM(IF(a.type = ''promotion-chest'', gain * e.rate , 0)) AS promotion_chest,
                        SUM(IF(a.type = ''invitation-chest'', gain * e.rate , 0)) AS invitation_chest,
                        SUM(IF(a.type = ''initial-topup-bonus'', gain * e.rate , 0)) AS bonus_topup_initial,
                        SUM(IF(a.type = ''topup-fever-bonus'', gain * e.rate , 0)) AS bonus_topup_fever
        from hogo_br_sale.wallet_ledgers a 
        left join hogo_br_sale.wallets b on a.wallet_id = b.id 
                left join hogo_br_sale.users u on b.user_id = u.id
                left join hogo_br_sale.channels c on u.channel_id = c.id
                left join exchange_rates e on c.symbol = e.quote and b.symbol = e.base
        where a.created_at >= ''',v_startdt,''' and a.created_at <= ''',v_enddt,'''
        group by b.user_id;'); 

        
        PREPARE stmt FROM @v_sqlselect; 
        EXECUTE stmt; 
        DEALLOCATE PREPARE stmt; 

        
        set v_endtime = CURRENT_TIMESTAMP(); 
            insert into `hogo_br_sale`.`sys_prolog` values(NOW(),'hogo_br_sale.sp_statis_daily_report_user',TIMESTAMPDIFF(SECOND,v_starttime,v_endtime), statisDate); 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP PROCEDURE IF EXISTS `sp_statis_relybet`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statis_relybet`(IN `statisTime` DATETIME)
BEGIN

	DECLARE v_starttime TIMESTAMP(3); 
	DECLARE v_endtime TIMESTAMP(3); 

	DECLARE v_startdt TIMESTAMP(3); 
	DECLARE v_enddt TIMESTAMP(3); 

    
    IF statisTime IS NULL THEN
        SET statisTime = NOW(); 
    END IF; 


	set v_starttime = CURRENT_TIMESTAMP(3); 

    
    set v_enddt = FROM_UNIXTIME(FLOOR(UNIX_TIMESTAMP(statisTime) / 300) * 300); 
    set v_startdt = DATE_SUB(v_enddt, INTERVAL 5 MINUTE); 

    
    SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`rely_bet` (statis_date, game_id, user_id, wallet_id, gateway_id, channel_id, sum_consume, sum_reward, sum_num)
    SELECT DATE_FORMAT(''',v_startdt,''' , ''%Y-%m-%d''), game_id, user_id, wallet_id, gateway_id, channel_id, sum(consume), sum(reward),
    SUM(CASE WHEN type = 1 AND state = 1 THEN 1 ELSE 0 END) FROM `hogo_br_play`.`playlist_bet_temp`
    WHERE time >= ''',v_startdt,''' and time < ''',v_enddt,''' GROUP BY channel_id, user_id, wallet_id, gateway_id, game_id
    ON DUPLICATE KEY UPDATE sum_consume = sum_consume + VALUES(sum_consume), sum_reward = sum_reward + VALUES(sum_reward),sum_num = sum_num + VALUES(sum_num);'); 

    
    PREPARE stmt FROM @v_sqlselect; 
	EXECUTE stmt; 
	DEALLOCATE PREPARE stmt; 

    
    

    
    
	
	

    
    set v_endtime = CURRENT_TIMESTAMP(); 
	insert into hogo_br_sale.sys_prolog values(NOW(),'hogo_br_sale.sp_statis_relybet',TIMESTAMPDIFF(SECOND,v_starttime,v_endtime), CONCAT(v_startdt, ' - ', v_enddt)); 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP PROCEDURE IF EXISTS `sp_statis_vipaward`;
CREATE DEFINER=`root`@`%` PROCEDURE `sp_statis_vipaward`(IN `statisDate` DATE)
BEGIN
            DECLARE v_starttime TIMESTAMP(3); 
            DECLARE v_endtime TIMESTAMP(3); 
            
            DECLARE v_startdt TIMESTAMP(3); 
            DECLARE v_enddt TIMESTAMP(3); 
            
            
            IF statisDate IS NULL THEN
                SET statisDate = DATE(CURDATE() - INTERVAL 1 DAY); 
            END IF; 
                
            SET v_starttime = CURRENT_TIMESTAMP(3); 
            

            SET v_enddt = CONCAT(statisDate, ' 23:59:59.999'); 
            SET v_startdt = CONCAT(statisDate, ' 00:00:00'); 

            
            SET @v_sqlselect = CONCAT('INSERT INTO `hogo_br_sale`.`user_vip_award_date`(user_id, symbol, acc_level, vip_award_rate, total_consume, vip_award, record_date, created_at, updated_at)
            select 
                user_id as user_id, 
                symbol as symbol,
                max(acc_level) as acc_level,
                max(vip_award_rate) as vip_award_rate,
                sum(consume) as total_consume,
                sum(vip_award) as vip_award,
                DATE_FORMAT(''', statisDate,''', ''%Y-%m-%d'') as record_date, 
                now(),
                now()
            from `hogo_br_sale`.`user_vip_award`
            where created_at >= ''',v_startdt,''' and created_at <= ''',v_enddt,'''
            group by record_date, user_id, symbol'); 


            PREPARE stmt FROM @v_sqlselect; 
            EXECUTE stmt; 
            DEALLOCATE PREPARE stmt; 

            
            set v_endtime = CURRENT_TIMESTAMP(); 
            insert into hogo_br_sale.sys_prolog values(NOW(),'hogo_br_sale.sp_statis_vipaward',TIMESTAMPDIFF(SECOND,v_starttime,v_endtime), statisDate); 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_general_ci;
DROP EVENT IF EXISTS `event_call_sp_cron_partition`;
CREATE DEFINER=`nodejs`@`10.21.0.%` EVENT `event_call_sp_cron_partition` ON SCHEDULE EVERY 30 DAY STARTS '2024-12-15 06:00:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL hogo_br_sale.sp_cron_partition();
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP EVENT IF EXISTS `event_call_sp_statis_brokerage`;
CREATE DEFINER=`root`@`%` EVENT `event_call_sp_statis_brokerage` ON SCHEDULE EVERY 1 DAY STARTS '2023-08-01 00:05:00' ON COMPLETION PRESERVE DISABLE DO CALL hogo_br_sale.sp_statis_brokerage(NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP EVENT IF EXISTS `event_call_sp_statis_daily_report_all`;
CREATE DEFINER=`root`@`%` EVENT `event_call_sp_statis_daily_report_all` ON SCHEDULE EVERY 1 DAY STARTS '2023-08-01 00:15:00' ON COMPLETION PRESERVE ENABLE DO CALL `hogo_br_sale`.`sp_statis_daily_report_all`(NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP EVENT IF EXISTS `event_call_sp_statis_daily_report_user`;
CREATE DEFINER=`root`@`%` EVENT `event_call_sp_statis_daily_report_user` ON SCHEDULE EVERY 1 DAY STARTS '2023-08-01 00:25:00' ON COMPLETION PRESERVE ENABLE DO CALL `hogo_br_sale`.`sp_statis_daily_report_user`(NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP EVENT IF EXISTS `event_call_sp_statis_relybet`;
CREATE DEFINER=`root`@`%` EVENT `event_call_sp_statis_relybet` ON SCHEDULE EVERY 5 MINUTE STARTS '2023-08-01 00:00:30' ON COMPLETION PRESERVE DISABLE DO CALL hogo_br_sale.sp_statis_relybet(NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP EVENT IF EXISTS `event_call_sp_statis_vipaward`;
CREATE DEFINER=`root`@`%` EVENT `event_call_sp_statis_vipaward` ON SCHEDULE EVERY 1 DAY STARTS '2023-08-01 00:15:00' ON COMPLETION PRESERVE DISABLE DO CALL hogo_br_sale.sp_statis_vipaward(NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP EVENT IF EXISTS `event_monthly_archive_bridge_order`;
CREATE DEFINER=`root`@`%` EVENT `event_monthly_archive_bridge_order` ON SCHEDULE EVERY 1 MONTH STARTS '2024-10-01 00:10:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL sp_partition_monthly_archive('hogo_br_play.bridge_order', NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP EVENT IF EXISTS `event_monthly_archive_playlist_all`;
CREATE DEFINER=`root`@`%` EVENT `event_monthly_archive_playlist_all` ON SCHEDULE EVERY 1 MONTH STARTS '2024-10-01 00:15:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL sp_partition_monthly_archive('hogo_br_play.playlist_all', NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP EVENT IF EXISTS `event_monthly_archive_vp_order`;
CREATE DEFINER=`root`@`%` EVENT `event_monthly_archive_vp_order` ON SCHEDULE EVERY 1 MONTH STARTS '2024-10-01 00:20:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL sp_partition_monthly_archive('hogo_br_play.vp_order', NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP EVENT IF EXISTS `event_monthly_archive_wallet_ledgers`;
CREATE DEFINER=`root`@`%` EVENT `event_monthly_archive_wallet_ledgers` ON SCHEDULE EVERY 1 MONTH STARTS '2024-10-01 00:05:00' ON COMPLETION NOT PRESERVE ENABLE DO CALL sp_partition_monthly_archive('wallet_ledgers', NULL);
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb4;
SET character_set_results = utf8mb4;
SET collation_connection = utf8mb4_0900_ai_ci;
DROP EVENT IF EXISTS `wallet_ledgers_daily_partition_and_move_outdated`;
CREATE DEFINER=`root`@`%` EVENT `wallet_ledgers_daily_partition_and_move_outdated` ON SCHEDULE EVERY 1 DAY STARTS '2023-12-07 23:55:00' ON COMPLETION NOT PRESERVE DISABLE DO BEGIN
                DECLARE next_partition_name VARCHAR(255); 
                DECLARE next_partition_value BIGINT; 
                DECLARE old_partition_name VARCHAR(255); 
                DECLARE target_table_name VARCHAR(255); 

                
                SET next_partition_name =
                    CONCAT('p', DATE_FORMAT(
                        CURDATE() + INTERVAL 2 DAY, '%Y%m%d')
                ); 
                SET next_partition_value =
                    10000 * YEAR(CURDATE() + INTERVAL 2 DAY) +
                    100 * MONTH(CURDATE() + INTERVAL 2 DAY) +
                    DAY(CURDATE() + INTERVAL 2 DAY); 

                
                SET @alter_sql = CONCAT('ALTER TABLE wallet_ledgers
                    ADD PARTITION (PARTITION ', next_partition_name,
                        ' VALUES LESS THAN (', next_partition_value, ')
                    ); 
                '); 
                PREPARE stmt FROM @alter_sql; 
                EXECUTE stmt; 

                
                SET old_partition_name =
                    CONCAT('p',
                        DATE_FORMAT(
                            DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y%m%d'
                        )
                    ); 

                
                IF EXISTS (SELECT 1 FROM information_schema.partitions
                    WHERE TABLE_NAME='wallet_ledgers'
                        AND partition_name = old_partition_name) THEN
                    
                    SET target_table_name =
                        CONCAT('wallet_ledgers_',
                            DATE_FORMAT(
                                DATE_SUB(CURDATE(), INTERVAL 1 MONTH), '%Y%m'
                            )
                        ); 

                    
                    SET @create_table_sql = CONCAT(
                        'CREATE TABLE IF NOT EXISTS ',
                            target_table_name, ' LIKE wallet_ledgers;'
                        ); 
                    PREPARE stmt FROM @create_table_sql; 
                    EXECUTE stmt; 

                    
                    SET @move_data_sql = CONCAT(
                        'INSERT INTO ', target_table_name,
                        ' SELECT * FROM wallet_ledgers
                        PARTITION(', old_partition_name, ');'
                    ); 
                    PREPARE stmt FROM @move_data_sql; 
                    EXECUTE stmt; 

                    
                    SET @drop_partition_sql = CONCAT(
                        'ALTER TABLE wallet_ledgers
                        DROP PARTITION ', old_partition_name, ';'
                    ); 
                    PREPARE stmt FROM @drop_partition_sql; 
                    EXECUTE stmt; 
                END IF; 

                DEALLOCATE PREPARE stmt; 
            END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

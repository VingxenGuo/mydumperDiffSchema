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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `insert_channel_wallet_statistic_after_wallet_insert` AFTER INSERT ON `channel_wallets` FOR EACH ROW BEGIN  
                INSERT INTO channel_wallet_statistics (wallet_serial) VALUES (NEW.serial); 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `update_channel_wallet_statistic_after_wallet_update` AFTER UPDATE ON `channel_wallets` FOR EACH ROW BEGIN
                DECLARE flow BIGINT; 

                IF NEW.balance > OLD.balance THEN
                    SET flow = NEW.balance - OLD.balance; 
                    
                    INSERT INTO channel_wallet_statistics (wallet_serial, inflow)
                    VALUES (NEW.serial, flow)
                    ON DUPLICATE KEY UPDATE
                        inflow = inflow + flow; 
                END IF; 

                IF NEW.balance < OLD.balance THEN
                    SET flow = OLD.balance - NEW.balance; 

                    INSERT INTO channel_wallet_statistics (wallet_serial, outflow)
                    VALUES (NEW.serial, flow)
                    ON DUPLICATE KEY UPDATE
                        outflow = outflow + flow; 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `prevent_channel_cycles_before_insert` BEFORE INSERT ON `channels` FOR EACH ROW BEGIN
                DECLARE current_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE loop_detected TINYINT DEFAULT 0; 

                IF NEW.id = NEW.parent_id THEN
                    SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'A channel cannot be its own parent.'; 
                END IF; 

                SET current_parent_id = NEW.parent_id; 

                WHILE current_parent_id IS NOT NULL AND loop_detected = 0 DO
                    IF current_parent_id = NEW.id THEN
                        SET loop_detected = 1; 
                    ELSE
                        SELECT parent_id INTO current_parent_id
                        FROM channels
                        WHERE id = current_parent_id; 
                    END IF; 
                END WHILE; 

                IF loop_detected = 1 THEN
                    SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'A cycle was detected in the hierarchy'; 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `assign_channel_root_id_before_insert` BEFORE INSERT ON `channels` FOR EACH ROW BEGIN
                DECLARE current_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE current_root_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 

                -- If the current item doesn't have a parent, it's the root
                IF NEW.parent_id = '00000000000000000000000000000000' THEN
                    SET NEW.root_id = NEW.id; 
                ELSE
                    -- Assign root_id from parent
                    SELECT root_id INTO current_root_id
                    FROM channels
                    WHERE id = NEW.parent_id; 

                    -- If parent has no root_id, take its id as root_id
                    IF current_root_id IS NULL THEN
                        SET NEW.root_id = NEW.parent_id; 
                    ELSE
                        SET NEW.root_id = current_root_id; 
                    END IF; 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `update_channel_edge_after_insert` AFTER INSERT ON `channels` FOR EACH ROW BEGIN
                DECLARE current_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE parent_level_depth INT DEFAULT 0; 

                SET current_parent_id = NEW.parent_id; 

                
                IF current_parent_id IS NULL THEN
                    SET parent_level_depth = 0; 
                ELSE
                    SELECT IFNULL(depth, 0) INTO parent_level_depth
                    FROM channel_edges
                    WHERE channel_id = current_parent_id; 
                END IF; 

                INSERT INTO channel_edges
                    (channel_id, count, depth)
                VALUES (NEW.id, 0, parent_level_depth + 1)
                ON DUPLICATE KEY UPDATE
                    depth = parent_level_depth + 1; 

                WHILE current_parent_id IS NOT NULL DO
                    INSERT INTO channel_edges
                        (channel_id, count, depth)
                    VALUES (current_parent_id, 1, parent_level_depth)
                    ON DUPLICATE KEY UPDATE
                        count = IFNULL(count, 0) + 1; 

                    SELECT parent_id INTO current_parent_id
                    FROM channels
                    WHERE id = current_parent_id; 

                    SELECT IFNULL(depth, 0) INTO parent_level_depth
                    FROM channel_edges
                    WHERE channel_id = current_parent_id; 
                END WHILE; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `prevent_channel_cycles_before_update` BEFORE UPDATE ON `channels` FOR EACH ROW BEGIN
                DECLARE current_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE loop_detected TINYINT DEFAULT 0; 

                IF NEW.id = NEW.parent_id THEN
                    SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'A channel cannot be its own parent.'; 
                END IF; 

                SET current_parent_id = NEW.parent_id; 

                WHILE current_parent_id IS NOT NULL AND loop_detected = 0 DO
                    IF current_parent_id = NEW.id THEN
                        SET loop_detected = 1; 
                    ELSE
                        SELECT parent_id INTO current_parent_id
                        FROM channels
                        WHERE id = current_parent_id; 
                    END IF; 
                END WHILE; 

                IF loop_detected = 1 THEN
                    SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'A cycle was detected in the hierarchy'; 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `assign_channel_root_id_before_update` BEFORE UPDATE ON `channels` FOR EACH ROW BEGIN
                DECLARE current_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE current_root_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 

                -- If the current item doesn't have a parent after update, it's the root
                IF NEW.parent_id = '00000000000000000000000000000000' THEN
                    SET NEW.root_id = NEW.id; 
                ELSE
                    -- Assign root_id from parent
                    SELECT root_id INTO current_root_id
                    FROM channels
                    WHERE id = NEW.parent_id; 

                    -- If parent has no root_id, take its id as root_id
                    IF current_root_id IS NULL THEN
                        SET NEW.root_id = NEW.parent_id; 
                    ELSE
                        SET NEW.root_id = current_root_id; 
                    END IF; 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `update_channel_edge_after_update` AFTER UPDATE ON `channels` FOR EACH ROW BEGIN
                DECLARE old_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE new_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE old_level_depth INT DEFAULT 0; 
                DECLARE new_level_depth INT DEFAULT 0; 

                IF OLD.parent_id != NEW.parent_id THEN

                    
                    SET old_parent_id = OLD.parent_id; 
                    SELECT IFNULL(depth, -1) INTO old_level_depth
                        FROM channel_edges WHERE channel_id = OLD.id; 
                    WHILE old_parent_id IS NOT NULL DO
                        UPDATE channel_edges
                        SET
                            count = count - 1,
                            depth = old_level_depth
                        WHERE channel_id = old_parent_id; 

                        
                        
                        
                        SELECT parent_id INTO old_parent_id
                        FROM channels
                        WHERE id = old_parent_id; 
                        SELECT IFNULL(depth, -1) INTO old_level_depth
                        FROM channel_edges
                        WHERE channel_id = old_parent_id; 
                    END WHILE; 

                    
                    SET new_parent_id = NEW.parent_id; 
                    SELECT IFNULL(depth, -1) INTO new_level_depth
                        FROM channel_edges WHERE channel_id = NEW.id; 
                    WHILE new_parent_id IS NOT NULL DO
                        INSERT INTO channel_edges
                            (channel_id, count, depth)
                        VALUES (new_parent_id, 1, new_level_depth + 1)
                        ON DUPLICATE KEY UPDATE
                            count = count + 1,
                            depth = new_level_depth + 1; 

                        
                        SELECT parent_id INTO new_parent_id
                        FROM channels
                        WHERE id = new_parent_id; 
                        SELECT IFNULL(depth, -1) INTO new_level_depth
                        FROM channel_edges
                        WHERE channel_id = new_parent_id; 
                    END WHILE; 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `update_channel_edge_after_delete` BEFORE DELETE ON `channels` FOR EACH ROW BEGIN
                DECLARE current_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE node_edge_count INT DEFAULT 0; 

                
                SELECT count INTO node_edge_count
                FROM channel_edges WHERE channel_id = OLD.id; 

                SET current_parent_id = OLD.parent_id; 

                WHILE current_parent_id IS NOT NULL DO
                    
                    UPDATE channel_edges
                    SET
                        count = count - (node_edge_count + 1)
                    WHERE channel_id = current_parent_id; 

                    
                    SELECT parent_id INTO current_parent_id
                    FROM channels
                    WHERE id = current_parent_id; 
                END WHILE; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `assign_referral_root_id_before_insert` BEFORE INSERT ON `referrals` FOR EACH ROW BEGIN
                DECLARE current_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE current_root_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 

                
                IF NEW.parent_id IS NULL THEN
                    SET NEW.root_id = NEW.id; 
                ELSE
                    
                    SELECT root_id INTO current_root_id
                    FROM referrals
                    WHERE id = NEW.parent_id; 

                    
                    IF current_root_id IS NULL THEN
                        SET NEW.root_id = NEW.parent_id; 
                    ELSE
                        SET NEW.root_id = current_root_id; 
                    END IF; 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `prevent_referral_cycles_before_insert` BEFORE INSERT ON `referrals` FOR EACH ROW BEGIN
                DECLARE current_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE loop_detected TINYINT DEFAULT 0; 

                IF NEW.id = NEW.parent_id THEN
                    SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'A referral cannot be its own parent.'; 
                END IF; 

                SET current_parent_id = NEW.parent_id; 

                WHILE current_parent_id IS NOT NULL AND loop_detected = 0 DO
                    IF current_parent_id = NEW.id THEN
                        SET loop_detected = 1; 
                    ELSE
                        SELECT parent_id INTO current_parent_id
                        FROM referrals
                        WHERE id = current_parent_id; 
                    END IF; 
                END WHILE; 

                IF loop_detected = 1 THEN
                    SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'A cycle was detected in the hierarchy'; 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `update_referral_edge_after_insert` AFTER INSERT ON `referrals` FOR EACH ROW BEGIN
                DECLARE current_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE parent_level_depth INT DEFAULT 0; 

                SET current_parent_id = NEW.parent_id; 

                
                IF current_parent_id IS NULL THEN
                    SET parent_level_depth = 0; 
                ELSE
                    SELECT IFNULL(depth, 0) INTO parent_level_depth
                    FROM referral_edges
                    WHERE referral_id = current_parent_id; 
                END IF; 

                INSERT INTO referral_edges
                    (referral_id, count, depth)
                VALUES (NEW.id, 0, parent_level_depth + 1)
                ON DUPLICATE KEY UPDATE
                    depth = parent_level_depth + 1; 

                WHILE current_parent_id IS NOT NULL DO
                    INSERT INTO referral_edges
                        (referral_id, count, depth)
                    VALUES (current_parent_id, 1, parent_level_depth)
                    ON DUPLICATE KEY UPDATE
                        count = IFNULL(count, 0) + 1; 

                    SELECT parent_id INTO current_parent_id
                    FROM referrals
                    WHERE id = current_parent_id; 

                    SELECT IFNULL(depth, 0) INTO parent_level_depth
                    FROM referral_edges
                    WHERE referral_id = current_parent_id; 
                END WHILE; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `assign_referral_root_id_before_update` BEFORE UPDATE ON `referrals` FOR EACH ROW BEGIN
                DECLARE current_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE current_root_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 

                
                IF NEW.parent_id IS NULL THEN
                    SET NEW.root_id = NEW.id; 
                ELSE
                    
                    SELECT root_id INTO current_root_id
                    FROM referrals
                    WHERE id = NEW.parent_id; 

                    
                    IF current_root_id IS NULL THEN
                        SET NEW.root_id = NEW.parent_id; 
                    ELSE
                        SET NEW.root_id = current_root_id; 
                    END IF; 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `prevent_referral_cycles_before_update` BEFORE UPDATE ON `referrals` FOR EACH ROW BEGIN
                DECLARE current_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE loop_detected TINYINT DEFAULT 0; 

                IF NEW.id = NEW.parent_id THEN
                    SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'A referral cannot be its own parent.'; 
                END IF; 

                SET current_parent_id = NEW.parent_id; 

                WHILE current_parent_id IS NOT NULL AND loop_detected = 0 DO
                    IF current_parent_id = NEW.id THEN
                        SET loop_detected = 1; 
                    ELSE
                        SELECT parent_id INTO current_parent_id
                        FROM referrals
                        WHERE id = current_parent_id; 
                    END IF; 
                END WHILE; 

                IF loop_detected = 1 THEN
                    SIGNAL SQLSTATE '45000'
                    SET MESSAGE_TEXT = 'A cycle was detected in the hierarchy'; 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `update_referral_edge_after_update` AFTER UPDATE ON `referrals` FOR EACH ROW BEGIN
                DECLARE old_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE new_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE old_level_depth INT DEFAULT 0; 
                DECLARE new_level_depth INT DEFAULT 0; 

                IF OLD.parent_id != NEW.parent_id THEN

                    
                    SET old_parent_id = OLD.parent_id; 
                    SELECT IFNULL(depth, -1) INTO old_level_depth
                        FROM referral_edges WHERE referral_id = OLD.id; 
                    WHILE old_parent_id IS NOT NULL DO
                        UPDATE referral_edges
                        SET
                            count = count - 1,
                            depth = old_level_depth
                        WHERE referral_id = old_parent_id; 

                        
                        
                        
                        SELECT parent_id INTO old_parent_id
                        FROM referrals
                        WHERE id = old_parent_id; 
                        SELECT IFNULL(depth, -1) INTO old_level_depth
                        FROM referral_edges
                        WHERE referral_id = old_parent_id; 
                    END WHILE; 

                    
                    SET new_parent_id = NEW.parent_id; 
                    SELECT IFNULL(depth, -1) INTO new_level_depth
                        FROM referral_edges WHERE referral_id = NEW.id; 
                    WHILE new_parent_id IS NOT NULL DO
                        INSERT INTO referral_edges
                            (referral_id, count, depth)
                        VALUES (new_parent_id, 1, new_level_depth + 1)
                        ON DUPLICATE KEY UPDATE
                            count = count + 1,
                            depth = new_level_depth + 1; 

                        
                        SELECT parent_id INTO new_parent_id
                        FROM referrals
                        WHERE id = new_parent_id; 
                        SELECT IFNULL(depth, -1) INTO new_level_depth
                        FROM referral_edges
                        WHERE referral_id = new_parent_id; 
                    END WHILE; 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `update_referral_edge_after_delete` BEFORE DELETE ON `referrals` FOR EACH ROW BEGIN
                DECLARE current_parent_id CHAR(36)
                    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci; 
                DECLARE node_edge_count INT DEFAULT 0; 

                
                SELECT count INTO node_edge_count
                FROM referral_edges WHERE referral_id = OLD.id; 

                SET current_parent_id = OLD.parent_id; 

                WHILE current_parent_id IS NOT NULL DO
                    
                    UPDATE referral_edges
                    SET
                        count = count - (node_edge_count + 1)
                    WHERE referral_id = current_parent_id; 

                    
                    SELECT parent_id INTO current_parent_id
                    FROM referrals
                    WHERE id = current_parent_id; 
                END WHILE; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `upsert_wallet_statistic_after_topup_complete_insert` AFTER INSERT ON `topups` FOR EACH ROW BEGIN
                
                IF NEW.status = 2 THEN
                    
                    INSERT INTO wallet_statistics (wallet_id,
                        topups,
                        topup,
                        topup_payout,
                        topup_fee,
                        topup_at)
                    VALUES (NEW.wallet_id,
                        1,
                        NEW.amount,
                        NEW.payout,
                        NEW.fee,
                        NOW())
                    ON DUPLICATE KEY UPDATE
                        topups = topups + 1,
                        topup = topup + NEW.amount,
                        topup_fee = topup_fee + NEW.fee,
                        topup_payout = topup_payout + NEW.payout,
                        topup_at = NOW(); 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `upsert_wallet_statistic_after_topup_complete_update` AFTER UPDATE ON `topups` FOR EACH ROW BEGIN
                
                IF NEW.status = 2 THEN
                    
                    INSERT INTO wallet_statistics (wallet_id,
                        topups,
                        topup,
                        topup_payout,
                        topup_fee,
                        topup_at)
                    VALUES (NEW.wallet_id,
                        1,
                        NEW.amount,
                        NEW.payout,
                        NEW.fee,
                        NOW())
                    ON DUPLICATE KEY UPDATE
                        topups = topups + 1,
                        topup = topup + NEW.amount,
                        topup_fee = topup_fee + NEW.fee,
                        topup_payout = topup_payout + NEW.payout,
                        topup_at = NOW(); 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `insert_wallet_statistic_after_wallet_insert` AFTER INSERT ON `wallets` FOR EACH ROW BEGIN
                
                INSERT INTO wallet_statistics (wallet_id) VALUES (NEW.id); 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `update_wallet_statistic_after_wallet_update` AFTER UPDATE ON `wallets` FOR EACH ROW BEGIN
                DECLARE flow BIGINT; 

                
                IF NEW.balance > OLD.balance THEN
                    
                    SET flow = NEW.balance - OLD.balance; 
                    
                    INSERT INTO wallet_statistics (wallet_id, inflow)
                    VALUES (NEW.id, flow)
                    ON DUPLICATE KEY UPDATE
                        inflow = inflow + flow; 
                END IF; 

                
                IF NEW.balance < OLD.balance THEN
                    
                    SET flow = OLD.balance - NEW.balance; 

                    
                    INSERT INTO wallet_statistics (wallet_id, outflow)
                    VALUES (NEW.id, flow)
                    ON DUPLICATE KEY UPDATE
                        outflow = outflow + flow; 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `upsert_wallet_statistic_after_withdrawal_complete_insert` AFTER INSERT ON `withdrawals` FOR EACH ROW BEGIN
                
                IF NEW.status = 4 THEN
                    
                    INSERT INTO wallet_statistics (wallet_id,
                        withdrawals,
                        withdrawal,
                        withdrawal_payout,
                        withdrawal_fee,
                        withdraw_at)
                    VALUES (NEW.wallet_id,
                        1,
                        NEW.amount,
                        NEW.payout,
                        New.fee,
                        NOW())
                    ON DUPLICATE KEY UPDATE
                        withdrawals = withdrawals + 1,
                        withdrawal = withdrawal + NEW.amount,
                        withdrawal_fee = withdrawal_fee + NEW.fee,
                        withdrawal_payout = withdrawal_payout + NEW.payout,
                        withdraw_at = NOW(); 
                END IF; 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `upsert_wallet_statistic_after_withdrawal_complete_update` AFTER UPDATE ON `withdrawals` FOR EACH ROW BEGIN
                
                IF NEW.status = 4 THEN
                    
                    INSERT INTO wallet_statistics (wallet_id,
                        withdrawals,
                        withdrawal,
                        withdrawal_payout,
                        withdrawal_fee,
                        withdraw_at)
                    VALUES (NEW.wallet_id,
                        1,
                        NEW.amount,
                        NEW.payout,
                        NEW.fee,
                        NOW())
                    ON DUPLICATE KEY UPDATE
                        withdrawals = withdrawals + 1,
                        withdrawal = withdrawal + NEW.amount,
                        withdrawal_fee = withdrawal_fee + NEW.fee,
                        withdrawal_payout = withdrawal_payout + NEW.payout,
                        withdraw_at = NOW(); 
                END IF; 
            END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

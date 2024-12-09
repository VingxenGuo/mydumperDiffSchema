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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1000` AFTER INSERT ON `playlist_1000` FOR EACH ROW BEGIN
            
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
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
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1000` AFTER UPDATE ON `playlist_1000` FOR EACH ROW BEGIN
            
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1001` AFTER INSERT ON `playlist_1001` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1001` AFTER UPDATE ON `playlist_1001` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1002` AFTER INSERT ON `playlist_1002` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1002` AFTER UPDATE ON `playlist_1002` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1003` AFTER INSERT ON `playlist_1003` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1003` AFTER UPDATE ON `playlist_1003` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1004` AFTER INSERT ON `playlist_1004` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1004` AFTER UPDATE ON `playlist_1004` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1005` AFTER INSERT ON `playlist_1005` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1005` AFTER UPDATE ON `playlist_1005` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1006` AFTER INSERT ON `playlist_1006` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1006` AFTER UPDATE ON `playlist_1006` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1007` AFTER INSERT ON `playlist_1007` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1007` AFTER UPDATE ON `playlist_1007` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1008` AFTER INSERT ON `playlist_1008` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1008` AFTER UPDATE ON `playlist_1008` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1009` AFTER INSERT ON `playlist_1009` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1009` AFTER UPDATE ON `playlist_1009` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1010` AFTER INSERT ON `playlist_1010` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1010` AFTER UPDATE ON `playlist_1010` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1011` AFTER INSERT ON `playlist_1011` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1011` AFTER UPDATE ON `playlist_1011` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1012` AFTER INSERT ON `playlist_1012` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1012` AFTER UPDATE ON `playlist_1012` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1013` AFTER INSERT ON `playlist_1013` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1013` AFTER UPDATE ON `playlist_1013` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1014` AFTER INSERT ON `playlist_1014` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1014` AFTER UPDATE ON `playlist_1014` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1015` AFTER INSERT ON `playlist_1015` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1015` AFTER UPDATE ON `playlist_1015` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1016` AFTER INSERT ON `playlist_1016` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1016` AFTER UPDATE ON `playlist_1016` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1017` AFTER INSERT ON `playlist_1017` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1017` AFTER UPDATE ON `playlist_1017` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1018` AFTER INSERT ON `playlist_1018` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1018` AFTER UPDATE ON `playlist_1018` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1019` AFTER INSERT ON `playlist_1019` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1019` AFTER UPDATE ON `playlist_1019` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1020` AFTER INSERT ON `playlist_1020` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1020` AFTER UPDATE ON `playlist_1020` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1021` AFTER INSERT ON `playlist_1021` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1021` AFTER UPDATE ON `playlist_1021` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1022` AFTER INSERT ON `playlist_1022` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1022` AFTER UPDATE ON `playlist_1022` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1023` AFTER INSERT ON `playlist_1023` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1023` AFTER UPDATE ON `playlist_1023` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1024` AFTER INSERT ON `playlist_1024` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1024` AFTER UPDATE ON `playlist_1024` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1025` AFTER INSERT ON `playlist_1025` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1025` AFTER UPDATE ON `playlist_1025` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1026` AFTER INSERT ON `playlist_1026` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1026` AFTER UPDATE ON `playlist_1026` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1027` AFTER INSERT ON `playlist_1027` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1027` AFTER UPDATE ON `playlist_1027` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1028` AFTER INSERT ON `playlist_1028` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1028` AFTER UPDATE ON `playlist_1028` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1029` AFTER INSERT ON `playlist_1029` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1029` AFTER UPDATE ON `playlist_1029` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1030` AFTER INSERT ON `playlist_1030` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1030` AFTER UPDATE ON `playlist_1030` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1031` AFTER INSERT ON `playlist_1031` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1031` AFTER UPDATE ON `playlist_1031` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1032` AFTER INSERT ON `playlist_1032` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1032` AFTER UPDATE ON `playlist_1032` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1033` AFTER INSERT ON `playlist_1033` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1033` AFTER UPDATE ON `playlist_1033` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1034` AFTER INSERT ON `playlist_1034` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1034` AFTER UPDATE ON `playlist_1034` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1035` AFTER INSERT ON `playlist_1035` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1035` AFTER UPDATE ON `playlist_1035` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1036` AFTER INSERT ON `playlist_1036` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1036` AFTER UPDATE ON `playlist_1036` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1037` AFTER INSERT ON `playlist_1037` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1037` AFTER UPDATE ON `playlist_1037` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_insert_playlist_1038` AFTER INSERT ON `playlist_1038` FOR EACH ROW BEGIN
            -- 遊戲注單與遊戲獎勵單建立時存到temp
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, NEW.consume, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 OR new.type = 2 OR new.type = 3 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, NEW.consume, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;
SET @PREV_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT;
SET @PREV_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS;
SET @PREV_COLLATION_CONNECTION=@@COLLATION_CONNECTION;
SET character_set_client = utf8mb3;
SET character_set_results = utf8mb3;
SET collation_connection = utf8mb3_unicode_ci;
CREATE DEFINER=`nodejs`@`10.21.0.%` TRIGGER `after_update_playlist_1038` AFTER UPDATE ON `playlist_1038` FOR EACH ROW BEGIN
            -- 遊戲注單結算時存到temp
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_play.playlist_bet_temp (game_id, user_id, wallet_id, gateway_id, channel_id, consume, reward, game_code, time, oid, type, state)
                VALUES (NEW.game_id, NEW.user_id, NEW.wallet_id, NEW.gateway_id, NEW.channel_id, 0, NEW.reward, NEW.game_code, NEW.time, NEW.oid, NEW.type, NEW.state); 
            END IF; 

            -- 存紀錄到wallet_ledgers
            IF NEW.type = 1 THEN
                INSERT INTO hogo_br_sale.wallet_ledgers (id, wallet_id, gateway_id, order_id, gain, loss, balance_before, balance_remain, type, created_at, updated_at)
                VALUES (REPLACE(UUID(), '-', ''), NEW.wallet_id, NEW.gateway_id, NEW.id, NEW.reward, 0, NEW.cmoney, NEW.smoney, NEW.game_code, CURRENT_TIMESTAMP(6), CURRENT_TIMESTAMP(6)); 
            END IF; 
        END;
SET character_set_client = @PREV_CHARACTER_SET_CLIENT;
SET character_set_results = @PREV_CHARACTER_SET_RESULTS;
SET collation_connection = @PREV_COLLATION_CONNECTION;

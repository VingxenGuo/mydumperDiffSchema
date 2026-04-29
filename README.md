# Mydumper Diff Schema

這是一個用於定時備份 MySQL 資料庫結構（Schema）並進行差異比對的工具組。主要包含兩個功能模組：

1. **mydumper-tool**: 負責定時傾印資料庫結構，並與上一次的備份進行比對。
2. **diff-wc-prod-tool**: 負責比對不同環境（例如 WC 環境與 Prod 環境）之間的結構差異。

## 目錄結構

- `mydumper-tool/`: 包含結構傾印腳本與郵件通知功能。
- `diff-wc-prod-tool/`: 包含跨環境結構比對腳本。
- `backup/`: 存放備份資料與比對結果（由腳本自動產生）。

## 功能說明

### 1. 結構傾印與歷史比對 (mydumper-tool)

使用 `dumper.sh` 腳本來執行。它會：
- 根據設定檔連線至資料庫。
- 使用 `mydumper` 傾印目前的資料庫結構。
- 將本次傾印結果與上一次（`previous`）的結果進行 `diff`。
- 將比對結果打包成 `.tar.gz` 並發送郵件通知。

**執行方式示例:**
```bash
bash ./mydumper-tool/dumper.sh prod.server.config
```

### 2. 跨環境結構比對 (diff-wc-prod-tool)

使用 `diff-wc-prod.sh` 腳本。它會：
- 讀取 `diff-wc-prod.config` 中的路徑設定。
- 比對指定環境中「最新（latest）」的結構傾印檔。
- 產生差異報告並透過郵件發送。

**執行方式示例:**
```bash
bash ./diff-wc-prod-tool/diff-wc-prod.sh
```

## 定時執行設定 (Crontab)

為了達成自動化監控，請將以下設定加入 `crontab`。

使用 `crontab -e` 編輯設定：

```cron
# 每週日 UTC+8 6:00 執行 Prod 環境的結構備份與歷史比對
0 6 * * 0 /bin/bash {PROJECT_PATH}/mydumper-tool/dumper.sh prod.server.config > {PROJECT_PATH}/mydumper-tool/diff_prod.log

# 每週一 UTC+8 6:00 執行 WC 與 Prod 環境間的結構差異比對
0 6 * * 1 /bin/bash {PROJECT_PATH}/diff-wc-prod-tool/diff-wc-prod.sh > {PROJECT_PATH}/diff-wc-prod-tool/diff_wc_prod.log
```

> [!NOTE]
> 請確保路徑 `{PROJECT_PATH}` 與您實際存放專案的路徑一致。

## 設定與需求

- **Mydumper**: 系統需安裝 `mydumper` 工具。
- **Python 3**: 用於執行 `sendmail.py` 發送郵件。
- **設定檔**:
  - `mydumper-tool/*.server.config`: 設定資料庫連線資訊（CSV 格式）。
  - `mydumper-tool/sendmail.config`: 設定郵件發送資訊（SMTP, 收件者等）。
  - `diff-wc-prod-tool/diff-wc-prod.config`: 設定要比對的目錄路徑。
  - `mydumper-tool/omit_file.txt`: 設定傾印時要忽略的檔案或表格。

## 郵件通知

腳本執行完畢後，會自動調用 `sendmail.py`。請務必在 `sendmail.config` 中正確設定您的 SMTP 伺服器與授權密碼（如 Gmail 的應用程式密碼）。

# Step 1 — Set up the database

Goal: get the Maven Fuzzy Factory data into a local MySQL server and confirm it
loaded correctly.

## 1a. MySQL

Homebrew MySQL, installed and started with:

```bash
brew install mysql
brew services start mysql
echo 'export PATH="/opt/homebrew/opt/mysql/bin:$PATH"' >> ~/.zshrc && source ~/.zshrc
```

`brew services start` runs MySQL now and on every login. Homebrew's MySQL has a
`root` user with **no password**, reachable only from this machine — fine for a
local learning database, so no `-p` flag is needed below.

> If a system-wide MySQL from Oracle's `.dmg` installer is also present it will
> fight for port 3306. Remove it (`sudo launchctl bootout system
> /Library/LaunchDaemons/com.oracle.oss.mysql.mysqld.plist`, then delete
> `/usr/local/mysql*`, its `.prefPane`, and `pkgutil --forget com.mysql.*`).

## 1c. Download the dataset

```bash
cd ~/Desktop/data-analytics-portfolio/projects/05-marketing-funnel/data/raw
curl -L -o create_mavenfuzzyfactory.zip \
  https://raw.githubusercontent.com/MrIdrisAbdulrahman/Maven_Fuzzy_Factory_Project_1/main/create_mavenfuzzyfactory.zip
unzip create_mavenfuzzyfactory.zip
```

This gives you `create_mavenfuzzyfactory.sql` (~110 MB, 1.7M lines): a MySQL
dump of the schema plus all the data. `data/raw/` is gitignored, so this never
gets committed.

## 1d. Inspect before loading

See [`docs/inspecting-sql-scripts.md`](../../../docs/inspecting-sql-scripts.md) for
the method. Verdict for this file: **safe** — only `CREATE SCHEMA`, 6
`CREATE TABLE`, 6 bulk `INSERT`, and session `SET` statements.

Two quirks in this dump that break a naive `mysql < file`:

1. **`SET global time_zone = '-5:00';`** (line 5). This forces a fixed UTC
   offset so the `TIMESTAMP` values all parse. Without it, MySQL interprets
   each timestamp in the machine's local zone, and a value like
   `2012-03-25 01:00:54` is rejected — that clock time never existed in the
   UK (British Summer Time began that morning: 01:00 jumped to 02:00). We set
   this per-**session** instead of globally.
2. **Each `INSERT` is one enormous statement** — `website_pageviews` is a
   single 60 MB line. The `mysql` client's default `max_allowed_packet` is
   16 MB, so it silently refuses to send them and you get empty tables.

## 1e. Load it

```bash
mysql -u root -e "DROP DATABASE IF EXISTS mavenfuzzyfactory;"   # in case a half-load left a shell

sed 's/^SET global time_zone/-- &/' create_mavenfuzzyfactory.sql \
  | mysql -u root --max_allowed_packet=1G --init-command="SET time_zone='+00:00'"
```

- `sed 's/^SET global time_zone/-- &/'` comments out the global time-zone line
  as it streams past (`&` = the matched text). The file on disk is untouched.
- `--max_allowed_packet=1G` — let the client send the 60 MB `INSERT`s.
- `--init-command="SET time_zone='+00:00'"` — run this on connect, before the
  dump: a **session** fixed offset, no DST, so every timestamp is valid. Nothing
  server-wide changes.

Loads in ~10 seconds. Row counts: 472,871 sessions / 1,188,124 pageviews /
32,313 orders / 40,025 order items / 1,731 refunds / 4 products.

## 1f. Create a project user (good habit — don't analyse as root)

```bash
mysql -u root <<'SQL'
CREATE USER IF NOT EXISTS 'analyst'@'localhost' IDENTIFIED BY 'analyst';
GRANT SELECT ON mavenfuzzyfactory.* TO 'analyst'@'localhost';
FLUSH PRIVILEGES;
SQL
```

`GRANT SELECT` only: the analyst account can read every table but cannot change
the data. That is exactly the access a real analyst gets.

## 1g. Verify

```bash
mysql -u analyst -panalyst mavenfuzzyfactory -e "
SHOW TABLES;
SELECT 'website_sessions' AS tbl, COUNT(*) AS n, MIN(created_at) AS first_at, MAX(created_at) AS last_at FROM website_sessions
UNION ALL SELECT 'website_pageviews', COUNT(*), MIN(created_at), MAX(created_at) FROM website_pageviews
UNION ALL SELECT 'orders', COUNT(*), MIN(created_at), MAX(created_at) FROM orders
UNION ALL SELECT 'order_items', COUNT(*), MIN(created_at), MAX(created_at) FROM order_items
UNION ALL SELECT 'order_item_refunds', COUNT(*), MIN(created_at), MAX(created_at) FROM order_item_refunds
UNION ALL SELECT 'products', COUNT(*), MIN(created_at), MAX(created_at) FROM products;
"
```

Expected ballpark: ~470k sessions, ~1.19M pageviews, ~32k orders, spanning
2012-03 to 2015-03. (`mysql` prints a warning about the password on the command
line — expected and harmless for a local box.)

## 1h. Store the connection string

```bash
cd ~/Desktop/data-analytics-portfolio
cp .env.example .env
```

Then add this line to `.env`:

```
MFF_DB_URL=mysql+pymysql://analyst:analyst@localhost:3306/mavenfuzzyfactory
```

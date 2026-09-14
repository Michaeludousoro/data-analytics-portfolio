# How to inspect a `.sql` script before you run it

A `.sql` file is not data — it is a list of commands your database will execute
with your privileges. A downloaded dump is usually harmless (schema + data), but
"usually" is not "always", and running one blind is the SQL equivalent of
`curl | bash`. This is also a question interviewers ask about data governance.

You do **not** read a 30 MB dump line by line. You *characterise* it: find out
what kinds of statements it contains, confirm they are all expected, and
spot-check a few. Five minutes, mostly `grep`.

## 1. Shape and endpoints

```bash
ls -lh file.sql              # how big
wc -l file.sql               # how many lines
head -n 40 file.sql          # what does it do first
tail -n 20 file.sql          # ...and last
```

You are looking for: does it target a **named new database**, or could it touch
existing ones? A clean dump starts with something like
`CREATE DATABASE x; USE x;` and ends with a few `SET` statements re-enabling
constraint checks.

## 2. What statement types are inside

```bash
grep -oiE '^\s*(CREATE|INSERT|DROP|ALTER|UPDATE|DELETE|GRANT|REVOKE|SET|USE|LOCK|UNLOCK|REPLACE|TRUNCATE|CALL)\b' file.sql \
  | tr '[:lower:]' '[:upper:]' | sort | uniq -c | sort -rn
```

Expected for a data dump: thousands of `INSERT`, a handful of `CREATE`,
`DROP TABLE IF EXISTS` (recreating its own tables — fine), `SET`, `USE`, maybe
`LOCK/UNLOCK TABLES`. Anything else earns a closer look.

## 3. The red flags — grep for each explicitly

```bash
grep -niE 'LOAD_FILE|INTO OUTFILE|INTO DUMPFILE|LOAD DATA|INFILE' file.sql   # file read/write
grep -niE 'sys_exec|sys_eval|UDF|SONAME|INSTALL PLUGIN|INSTALL COMPONENT'    # OS command execution
grep -niE 'CREATE (DEFINER=.*)?(PROCEDURE|FUNCTION|TRIGGER|EVENT)' file.sql  # code that runs later
grep -niE 'GRANT |CREATE USER|SET PASSWORD|ALTER USER|IDENTIFIED BY'         # privilege changes
grep -niE 'DROP (DATABASE|SCHEMA)|DROP USER'                                 # destructive to other things
grep -niE 'SET +GLOBAL|@@ *global|SUPER|FILE ON' file.sql                    # server-wide changes
```

For a plain Maven-style dump every one of these should return **nothing**.
If one matches, read those specific lines and decide whether it is legitimate
(e.g. a dump legitimately creates its own stored procedures) or not.

## 4. Confirm the bulk is what you expect

```bash
grep -oiE 'INSERT INTO `?[a-z_]+`?' file.sql | sort | uniq -c   # rows go into which tables?
grep -icE '^\s*INSERT' file.sql                                 # how many INSERT statements
```

The table names must match the ones the dataset is documented to have — no
extras.

## 5. Safer ways to run it

- **Review in an editor** with syntax highlighting for anything under a few MB.
- **Load into a throwaway database first** (`CREATE DATABASE scratch; USE scratch;`
  then the dump) and inspect, before pointing your real work at it.
- **Run as a least-privilege user** where possible, so even a malicious statement
  can't exceed that user's rights.
- Keep the raw file; never edit it by hand. Reproducibility beats tidiness.

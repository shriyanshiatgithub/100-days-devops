# 100 Days of DevOps — Day 17

## Task: PostgreSQL — Create Database, User and Grant Privileges

| Field      | Value                        |
|------------|------------------------------|
| Platform   | KodeKloud                    |
| Category   | Linux / PostgreSQL / Database |
| Difficulty | Easy-Medium                  |
| Status     | ✅ Solved                    |

---

## Problem Statement

PostgreSQL was already installed on the database server (stdb01)
but not enabled on boot. The task was to enable the service,
then create a new database, a new user with a password, and
grant that user full privileges on the database.

---

## Concepts Learned

PostgreSQL passwords in SQL must be wrapped in single quotes.
Using double quotes or no quotes causes a syntax error this
is different from most other contexts in Linux where quotes
are optional.


To exit the psql shell use `\q` not `/q`. psql uses backslash
commands, not forward slash.

`sudo -u postgres psql` switches to the postgres system user
and opens the psql shell. The "Permission denied" warning about
the home directory is harmless and can be ignored.

---

## Solution

```bash
# Step 1 — SSH into database server
ssh peter@stdb01

# Step 2 — Enable PostgreSQL on boot
sudo systemctl enable postgresql

# Step 3 — Verify service is running
sudo systemctl status postgresql

# Step 4 — Open psql as postgres superuser
sudo -u postgres psql
```

```sql
-- Step 5 — Create the database
CREATE DATABASE kodekloud_db8;

-- Step 6 — Create the user with password (single quotes required)
CREATE USER kodekloud_top WITH PASSWORD 'dCV3szSGNA';

-- Step 7 — Grant full privileges on the database to the user
GRANT ALL PRIVILEGES ON DATABASE kodekloud_db8 TO kodekloud_top;

-- Step 8 — Exit psql
\q
```

---

## Gotcha

Two syntax errors hit during this task:

First, the password was written without single quotes:
```sql
CREATE USER kodekloud_top WITH PASSWORD dCV3szSGNA;
-- ERROR: syntax error at or near "dCV3szSGNA"
```
Fix: always wrap passwords in single quotes.

Second, the GRANT syntax was wrong:
```sql
GRANT ALL PRIVILEGES TO USER kodekloud_top ON kodekloud_db8;
-- ERROR: syntax error at or near "TO"
```
Fix: the correct order is ON DATABASE first, then TO user.

---

## Key Takeaway

PostgreSQL SQL syntax is strict about quote types and keyword
order. Passwords always need single quotes.These are small things that cause
real errors if you get them wrong.

---

*Part of my #100DaysOfDevOps challenge*

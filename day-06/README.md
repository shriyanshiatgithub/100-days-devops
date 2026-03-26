# 100 Days of DevOps — Day 6

## Task: Install Cronie and Configure Cron Job on All App Servers

**Platform:** KodeKloud
**Category:** Linux / Automation
**Difficulty:** Medium
**Status:** ✅ Solved

---

## 📋 Problem Statement

The Nautilus sysadmin team needed a cron job deployed across all
3 app servers in Stratos DC to test scheduled automation.
Tasks:
- Install cronie package on stapp01, stapp02, stapp03
- Start and enable crond service
- Add cron job for root: */5 * * * * echo hello > /tmp/cron_text

---

## 💡 Concepts Learned

- **cronie** is the cron daemon package on RHEL/CentOS systems
- Cron syntax: `*/5 * * * *` = every 5 minutes
  - Fields: minute · hour · day · month · weekday
  - `*/5` = every 5th minute (0, 5, 10, 15...)
- Critical distinction:
  - `crontab -e` → edits cron for the currently logged-in user
  - `sudo crontab -e` → edits cron for the root user
  - The job runs as whoever owns that crontab
- `sudo crontab -l` lists root's scheduled jobs
- Always enable AND start the service — enable alone doesn't
  start it immediately, only on next boot

---

## 🛠️ Solution

```bash
# Repeat on each server: stapp01, stapp02, stapp03

# Step 1 — Install cronie
sudo yum install cronie -y

# Step 2 — Enable and start crond service
sudo systemctl enable crond
sudo systemctl start crond

# Step 3 — Verify service is running
sudo systemctl status crond

# Step 4 — Add cron job for ROOT user (sudo = root's crontab)
sudo crontab -e
# Add this line:
# */5 * * * * echo hello > /tmp/cron_text

# Step 5 — Verify cron job was added under root
sudo crontab -l
```

### Expected output (sudo crontab -l):
```
*/5 * * * * echo hello > /tmp/cron_text
```

---

## ⚠️ Key Distinction

`crontab -e` vs `sudo crontab -e` are NOT the same:

| Command          | Edits crontab of | Job runs as |
|------------------|-----------------|-------------|
| crontab -e       | current user    | current user|
| sudo crontab -e  | root            | root        |

This task required the job to run as root — so sudo was essential,
not optional.

---

## 🔑 Key Takeaway

Every cron job runs as a specific user. Using the wrong crontab
means the job either fails silently (no permissions) or runs
with unintended privileges. Always be explicit about which
user's crontab you are editing.

---

*Part of my #100DaysOfDevOps challenge*

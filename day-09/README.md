# 100 Days of DevOps — Day 9

## Task: Debug and Fix a Failing MariaDB Service

**Platform:** KodeKloud
**Category:** Linux / Database / Troubleshooting
**Difficulty:** Medium-Hard
**Status:** ✅ Solved

---

## 📋 Problem Statement

MariaDB was installed on stdb01 but the service was inactive
and failing to start. Task: diagnose the root cause, fix it,
start the service, and enable it on boot.

---

## 💡 Debugging Process — Step by Step

### Step 1 — Check service status
```bash
systemctl status mariadb
# Result: inactive (dead) — not enough info
```

### Step 2 — Try to start and observe the failure
```bash
systemctl start mariadb
# Result: failed (exit-code) — still vague
```

### Step 3 — Read the actual logs
```bash
cat /var/log/mariadb/mariadb.log
```
Found the real error:
```
[ERROR] Can't create/write to file '/run/mariadb/mariadb.pid'
(Errcode: 13 "Permission denied")
```

### Step 4 — Inspect the directory permissions
```bash
ls -ld /run/mariadb/
# drwxr-xr-x 2 root mysql
```
Owner was root. MariaDB runs as mysql user.
mysql could not write to a root-owned directory.

### Step 5 — Fix ownership
```bash
chown -R mysql:mysql /run/mariadb/
```

### Step 6 — Start and enable the service
```bash
systemctl start mariadb
systemctl enable mariadb
systemctl status mariadb  # active (running) ✅
```

---

## ⚠️ Key Distinction

`disabled` ≠ `failed`

| State    | Meaning                        |
|----------|--------------------------------|
| inactive | not running                    |
| failed   | tried to start and crashed     |
| disabled | won't auto-start on boot       |

The service was disabled AND failing — two separate issues.
Fix the failure first, then enable for boot.

---

## 🔑 Key Takeaway

**Always read logs before assuming the root cause.**
`systemctl status` shows the symptom.
The log file shows the actual error.

When you see "Permission denied" on a service — think:
→ Who owns the directory?
→ Which user does the service run as?
→ Does that user have write access?

Also: `/run` is a tmpfs — it resets on reboot. So even after
fixing permissions, if the directory is recreated by systemd
without correct ownership, the issue can return after reboot.
The proper long-term fix is a systemd tmpfiles.d config.

---

*Part of my #100DaysOfDevOps challenge*

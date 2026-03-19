# 🚀 100 Days of DevOps — Day 1

## Task: Create a Non-Interactive Shell User

**Platform:** KodeKloud
**Category:** Linux / Shell
**Difficulty:** Medium
**Status:** ✅ Solved

---

## 📋 Problem Statement

At xFusionCorp Industries, the backup agent tool requires a system user
with a non-interactive shell. Task: create user `mark` with a
non-interactive shell on App Server 2.

---

## 💡 Concepts Learned

- **Non-interactive shell** (`/sbin/nologin` or `/bin/false`) prevents
  a user from logging in interactively while still allowing system/
  daemon processes to run as that user
- Used for service accounts, backup agents, and system daemons
- Security best practice: limit attack surface by restricting shell access

---

## 🛠️ Solution

```bash
# SSH into App Server 2
ssh steve@stapp02

# Create user with non-interactive shell
sudo useradd -s /sbin/nologin mark

# Verify the user was created correctly
grep "mark" /etc/passwd
```

### Expected output:
```
mark:x:1002:1002::/home/mark:/sbin/nologin
```

---

## 🔑 Key Takeaway

Non-interactive shells are a Linux security fundamental — every
production system uses them for service accounts. Understanding
this is essential for any DevOps/SRE role.

---
*Part of my #100DaysOfDevOps challenge*


# 100 Days of DevOps — Day 2

## Task: Create a Temporary User with Expiry Date

**Platform:** KodeKloud
**Category:** Linux / Shell
**Difficulty:** Easy-Medium
**Status:** ✅ Solved

---

## 📋 Problem Statement

A developer named `ravi` needs temporary access to App Server 1
in the Stratos Datacenter for the Nautilus project.
Task: create the user with an expiry date of 2026-12-07.

---

## 💡 Concepts Learned

- **User expiry** (`-e` flag) sets an account expiration date after
  which the user cannot log in — account still exists but is disabled
- Date format must be `YYYY-MM-DD` for the `-e` flag
- `-m` flag creates the home directory automatically
- Real-world use case: contractors, temporary staff, project-based access
- Security principle: least privilege + time-bound access

---

## 🛠️ Solution

```bash
# SSH into App Server 1
ssh tony@stapp01

# Create user with expiry date
sudo useradd -m -e 2026-12-07 ravi

# Verify expiry date was set correctly
sudo chage -l ravi
```

### Expected output (chage -l ravi):
```
Login:                          ravi
Account expires:                Dec 07, 2026
```

---

## 🔑 Key Takeaway

Time-bound user accounts are a production security standard.
Every cloud platform supports temporary access patterns. Understanding the Linux
foundation behind it matters.

---

*Part of my #100DaysOfDevOps challenge*

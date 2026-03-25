# 100 Days of DevOps — Day 5

## Task: Install SELinux Packages and Permanently Disable SELinux

**Platform:** KodeKloud
**Category:** Linux / Security
**Difficulty:** Medium
**Status:** ✅ Solved

---

## 📋 Problem Statement

As part of a security audit rollout at xFusionCorp Industries,
SELinux packages needed to be installed on App Server 2, then
SELinux permanently disabled ahead of a planned maintenance reboot.
Current runtime status was irrelevant — only the post-reboot
state mattered.

---

## 💡 Concepts Learned

- SELinux (Security-Enhanced Linux) adds mandatory access control
  on top of standard Linux permissions
- Two ways to disable SELinux:
  - Runtime: `setenforce 0` — temporary, lost on reboot
  - Permanent: edit `/etc/selinux/config` → set SELINUX=disabled
- The config file is what survives a reboot — runtime changes don't
- `dnf install -y` for installing multiple packages in one command
- Always verify config changes with `cat` or `grep` after editing

---

## 🛠️ Solution

```bash
# SSH into App Server 2
ssh steve@stapp02

# Step 1 — Install required SELinux packages
sudo dnf install -y selinux-policy-targeted \
  policycoreutils \
  policycoreutils-python-utils

# Step 2 — Permanently disable SELinux
sudo nano /etc/selinux/config
# Change: SELINUX=enforcing → SELINUX=disabled

# Step 3 — Verify the change
cat /etc/selinux/config | grep SELINUX
```

### Expected output:
```
SELINUX=disabled
SELINUXTYPE=targeted
```

---

## ⚠️ Key Distinction

`setenforce 0` disables SELinux immediately but temporarily.
Editing `/etc/selinux/config` makes it permanent across reboots.
The task specifically required the post-reboot state — so only
the config file edit mattered here.

---

## 🔑 Key Takeaway

Understanding the difference between runtime state and persistent
config is critical in production. Many outages happen because
engineers apply temporary fixes thinking they are permanent.
Always verify what survives a reboot.

---

*Part of my #100DaysOfDevOps challenge*

# 100 Days of DevOps — Day 4

## Task: Grant Executable Permissions to a Script for All Users

**Platform:** KodeKloud
**Category:** Linux / File Permissions
**Difficulty:** Easy-Medium
**Status:** ✅ Solved

---

## 📋 Problem Statement

A bash script xfusioncorp.sh was distributed to App Server 1
but lacked executable permissions. Task: grant execute permissions
to all users on the server.

---

## 💡 Concepts Learned

- Linux file permissions: read (r), write (w), execute (x)
- `chmod +x` only works if you own the file — need sudo otherwise
- `chmod a+rx` — grants read + execute to ALL users (owner, group, others)
- `a` = all, `r` = read, `x` = execute
- `ls -lh` to verify permissions in human-readable format
- Permission string breakdown: `-r-xr-xr-x`
  - owner: r-x, group: r-x, others: r-x

---

## 🛠️ Solution

```bash
# SSH into App Server 1
ssh tony@stapp01

# First attempt failed — need sudo
chmod +x /tmp/xfusioncorp.sh
# chmod: changing permissions of '/tmp/xfusioncorp.sh': Operation not permitted

# Correct approach — use sudo
sudo chmod a+rx /tmp/xfusioncorp.sh

# Verify permissions
ls -lh /tmp/xfusioncorp.sh
```

### Expected output:
```
-r-xr-xr-x 1 root root 40 Mar 24 05:32 /tmp/xfusioncorp.sh
```

---

## ⚠️ Gotcha

`chmod +x` sets execute only for the owner by default.
The task required ALL users to execute it — so `a+rx` was needed,
not just `+x`. Always read the requirement carefully.

---

## 🔑 Key Takeaway

Linux file permissions are foundational to every DevOps and
security role. Misconfigured permissions are one of the most
common causes of script failures in production pipelines.

---

*Part of my #100DaysOfDevOps challenge*

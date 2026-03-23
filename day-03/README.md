# 100 Days of DevOps — Day 3

## Task: Disable Direct Root SSH Login Across All App Servers

**Platform:** KodeKloud
**Category:** Linux / Security
**Difficulty:** Medium
**Status:** ✅ Solved

---

## 📋 Problem Statement

Following a security audit at xFusionCorp Industries, direct root
SSH login must be disabled on all 3 app servers in the Stratos
Datacenter (stapp01, stapp02, stapp03).

---

## 💡 Concepts Learned

- **PermitRootLogin** directive in `/etc/ssh/sshd_config` controls
  whether root can SSH directly into a server
- Setting it to `no` forces all users to log in as a named user
  and escalate with `sudo` — full audit trail
- `sed -i` for in-place file editing without opening a text editor
- Always restart `sshd` after config changes for them to take effect
- Real-world: this is a CIS Benchmark requirement and a standard
  hardening step on every production Linux server

---

## 🛠️ Solution

```bash
# Repeat on each server: stapp01 (tony), stapp02 (steve), stapp03 (banner)

# SSH into server
ssh tony@stapp01

# Disable root login using sed
sudo sed -i 's/^PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config

# Verify the change
sudo grep PermitRootLogin /etc/ssh/sshd_config

# Restart SSH service to apply changes
sudo systemctl restart sshd

# Exit and repeat for stapp02 and stapp03
exit
```

### Expected output after grep:
```
#PermitRootLogin prohibit-password
PermitRootLogin no
```

---

## 🔑 Key Takeaway

Disabling root SSH is one of the first steps in any server
hardening checklist. Combined with key-based auth and fail2ban,
it dramatically reduces the attack surface of any Linux server.

---


*Part of my #100DaysOfDevOps challenge*

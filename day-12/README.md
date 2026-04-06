# 100 Days of DevOps — Day 12

## Task: Fix Apache Not Starting Due to Port Conflict and iptables Block

**Platform:** KodeKloud
**Category:** Linux / Networking / Troubleshooting
**Difficulty:** Medium-Hard
**Status:** ✅ Solved

---

## 📋 Problem Statement

Apache (httpd) was configured to run on port 3002 on App Server 1
but was failing to start. Even after fixing the startup issue,
the port was not reachable from outside the server. Two separate
problems to solve.

---

## 💡 Debugging Process

### Problem 1 — Port already in use

```bash
systemctl status httpd
# (98) Address already in use: could not bind to address [::]:3002
```

Found what was occupying port 3002:
```bash
sudo ss -tulnp | grep 3002
# sendmail was listening on 127.0.0.1:3002
```

Killed the conflicting process:
```bash
sudo kill -9 15229
```

Started and enabled httpd:
```bash
sudo systemctl start httpd
sudo systemctl enable httpd
```

### Problem 2 — Port blocked by iptables

Even after httpd was running, telnet from jump host failed:
```bash
telnet stapp01 3002
# No route to host
```

Checked iptables rules:
```bash
sudo iptables -L INPUT -n --line-numbers
# Rule 5: REJECT all — this was blocking all traffic
# Port 3002 had no ACCEPT rule before the REJECT
```

Inserted ACCEPT rule for port 3002 before the REJECT:
```bash
sudo iptables -I INPUT 5 -p tcp --dport 3002 -j ACCEPT
```

Verified the final rule order:
```
1  ACCEPT  (established connections)
2  ACCEPT  (icmp)
3  ACCEPT  (loopback)
4  ACCEPT  (tcp port 22 - SSH)
5  ACCEPT  (tcp port 3002 - httpd) ← inserted here
6  REJECT  all                     ← must come after
```

---

## ⚠️ Key Distinctions

**Port conflict vs firewall block — two different problems:**
- Port conflict: service can't start because another process
  owns that port → find it with ss, kill it
- Firewall block: service is running fine but traffic can't
  reach it → fix iptables rule order

**iptables rule order matters:**
Rules are evaluated top to bottom. ACCEPT for port 3002 must
come BEFORE the REJECT all rule. Use `-I` (insert) with a
position number, not `-A` (append) which adds to the end
after the REJECT.

---

## 🔑 Key Takeaway

When a port is "unreachable" there are two completely separate
layers to check: the application layer (is the service running
and bound to the port?) and the network layer (does the firewall
allow traffic through?). Always check both before concluding
anything.
---

*Part of my #100DaysOfDevOps challenge*

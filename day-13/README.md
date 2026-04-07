# 100 Days of DevOps — Day 13

## Task: Harden Apache with iptables — Allow Only Load Balancer on Port 8088

**Platform:** KodeKloud
**Category:** Linux / Networking / Security
**Difficulty:** Medium-Hard
**Status:** ✅ Solved

---

## 📋 Problem Statement

Apache is running on port 8088 across all 3 app servers but the
port is open to everyone. Security requirement: only the Load
Balancer (stlb01) should be able to reach port 8088. Rules must
persist after reboot.

---

## 💡 Concepts Learned

iptables reads rules top to bottom. First match wins. This means
rule ORDER is everything. If a REJECT or DROP rule appears before
your ACCEPT rule, your ACCEPT never gets evaluated.

iptables rules live in memory by default. They disappear on
reboot. To persist them, save to /etc/sysconfig/iptables using
iptables-save, and enable the iptables service.

On EL9 systems, iptables-services and iptables are separate
packages. Installing only one breaks the service.

---

## 🛠️ Solution

```bash
# Step 1 — Get Load Balancer IP
ssh loki@stlb01
hostname -i
# 10.244.234.219

# Step 2 — On each app server (stapp01/02/03)
sudo yum install -y iptables iptables-services
sudo systemctl enable iptables
sudo systemctl start iptables

# Step 3 — Flush existing rules (important — avoid conflicts)
sudo iptables -F

# Step 4 — Add rules in correct order
sudo iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
sudo iptables -A INPUT -i lo -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT
sudo iptables -A INPUT -p tcp -s 10.244.234.219 --dport 8088 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 8088 -j DROP

# Step 5 — Save rules persistently
sudo iptables-save | sudo tee /etc/sysconfig/iptables

# Step 6 — Verify
sudo iptables -L -n
```

### Expected rule output:
```
ACCEPT  all   RELATED,ESTABLISHED
ACCEPT  all   lo (localhost)
ACCEPT  tcp   dpt:22 (SSH)
ACCEPT  tcp   10.244.234.219 → dpt:8088 (LBR allowed)
DROP    tcp   dpt:8088 (everyone else blocked)
```

---

## ⚠️ Gotchas

The server had pre-existing iptables rules including a REJECT all
rule that appeared BEFORE the port 8088 rules. This would have
blocked even the Load Balancer. Had to flush all rules with
iptables -F and rebuild them in the correct order.

Also, `service iptables save` doesn't work on EL9 — use
`iptables-save | tee /etc/sysconfig/iptables` instead.

---

## 🔑 Key Takeaway

iptables rule order is not a preference, it is the logic.
A DROP rule before an ACCEPT means the ACCEPT never runs.
---

*Part of my #100DaysOfDevOps challenge*

# 📅 Day 14/100 – Apache Service Unavailability (Port Conflict Debugging)

**Task:** Fix Apache Service on Multiple App Servers  
**Platform:** KodeKloud  
**Category:** Linux / Networking / Troubleshooting  
**Difficulty:** Medium  
**Status:** ✅ Solved  

---

## 📋 Problem Statement
The monitoring system reported that **Apache service was unavailable** on one of the app servers in the Stratos Datacenter.

We needed to:
- Identify the faulty app server  
- Fix Apache service  
- Ensure Apache is running on **port 6300** on all app servers  
- Verify accessibility from jump host  

---

## 💡 Concepts Learned

### Apache Service Troubleshooting
- Use `systemctl status httpd` to identify service failures  
- Logs often point directly to root cause

- Error: `Address already in use` means another process is using the port  
- Apache fails to start if it cannot bind to the required port  

### Network Debugging
- `telnet` helps quickly identify connectivity issues  
- “Connection refused” usually means service is down  

### Process & Port Inspection
- `ss -tulnp` shows active ports and associated processes  
- Helps identify which service is blocking required port  

---

## 🔍 Investigation

### From Jump Host:

```bash
telnet stapp01 6300
telnet stapp02 6300
telnet stapp03 6300
🧠 Observations:
stapp01 → ❌ Connection refused
stapp02 → ✅ Connected
stapp03 → ✅ Connected

👉 Faulty server identified: stapp01

🛠️ Solution
# Step 1 — SSH into faulty server
ssh tony@stapp01

# Step 2 — Check Apache status
sudo systemctl status httpd

# Step 3 — Identify port conflict
sudo ss -tulnp | grep 6300

# Step 4 — Kill process using port 6300
sudo kill -9 <PID>

# Step 5 — Start Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Step 6 — Verify service
sudo systemctl status httpd

# Step 7 — Test locally
curl http://localhost:6300

# Step 8 — Final test from jump host
curl http://stapp01:6300
##🔑 Key Takeaway

Apache service failures are often caused by port conflicts. Always check if the required port is already in use before restarting services. Tools like ss and telnet make debugging faster and more reliable in real-world scenarios.

*Part of my #100DaysOfDevOps challenge 🚀*

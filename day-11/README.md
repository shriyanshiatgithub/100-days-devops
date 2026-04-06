# 100 Days of DevOps — Day 11

## Task: Deploy a WAR Application on Tomcat with Custom Port

**Platform:** KodeKloud
**Category:** Linux / Java / Application Deployment
**Difficulty:** Medium
**Status:** ✅ Solved

---

## 📋 Problem Statement

Deploy a ROOT.war application on App Server 1 using Tomcat.
Java 11 was required. Tomcat needed to be configured to run
on a custom port (5002) instead of the default 8080.

---

## 💡 Concepts Learned

**WAR files (Web Application Archive)**
- A WAR file is a packaged Java web application
- Tomcat deploys it automatically when placed in /var/lib/tomcat/webapps/
- Naming it ROOT.war makes it the default root application

**Tomcat port configuration**
- Default port is 8080
- Changed in /etc/tomcat/server.xml
- Look for the Connector element and update the port attribute:
```xml

```

**Deployment flow**
```
WAR file → /var/lib/tomcat/webapps/ROOT.war
         → Tomcat auto-deploys on start
         → accessible at http://stapp01:5002
```

---

## 🛠️ Solution

```bash
# Step 1 — Copy WAR file from jump host to app server
scp /tmp/ROOT.war tony@stapp01:/tmp/

# Step 2 — SSH into App Server 1
ssh tony@stapp01

# Step 3 — Install Java and Tomcat
sudo dnf install -y java-11-openjdk
sudo dnf install -y tomcat

# Step 4 — Configure custom port in server.xml
sudo nano /etc/tomcat/server.xml
# Change port="8080" to port="5002"

# Step 5 — Deploy the WAR file
sudo cp /tmp/ROOT.war /var/lib/tomcat/webapps/ROOT.war

# Step 6 — Start and enable Tomcat
sudo systemctl start tomcat
sudo systemctl enable tomcat

# Step 7 — Verify
sudo systemctl status tomcat
curl http://stapp01:5002
```

---

## 🔑 Key Takeaway

Tomcat auto-deploys any WAR file placed in the webapps directory.
ROOT.war specifically maps to the root URL path (/).
Port configuration lives in server.xml — always edit this file
when running multiple services on the same server to avoid
port conflicts.

---

*Part of my #100DaysOfDevOps challenge*

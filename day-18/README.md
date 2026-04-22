# 100 Days of DevOps — Day 18

## Task: Host Two Static Websites on Apache with Custom Port

| Field      | Value                          |
|------------|--------------------------------|
| Platform   | KodeKloud                      |
| Category   | Linux / Apache / Web Hosting   |
| Difficulty | Medium                         |
| Status     | ✅ Solved                      |

---

## Problem Statement

Set up two static websites on App Server 2 using Apache (httpd).
The sites (ecommerce and demo) were available as backups on the
jump host and needed to be served on port 8086 at:
- http://localhost:8086/ecommerce/
- http://localhost:8086/demo/

---

## Concepts Learned

Apache serves files from /var/www/html/ by default. Subdirectories
under this path are automatically accessible as URL paths, so
placing files in /var/www/html/ecommerce/ makes them available
at /ecommerce/ with no extra configuration needed.

The default Apache port is 80. To change it, update the Listen
directive in /etc/httpd/conf/httpd.conf and also update the
VirtualHost port if one is defined.

File permissions on web directories must allow the Apache process
to read them. chmod -R 755 is the standard for static content —
owner can read/write/execute, everyone else can read and execute.

scp -r copies directories recursively from one host to another.
Always use -r when copying folders.

---

## Solution

```bash
# Step 1 — Copy website files from jump host to app server
scp -r /home/thor/ecommerce steve@stapp02:/tmp/
scp -r /home/thor/demo steve@stapp02:/tmp/

# Step 2 — SSH into App Server 2
ssh steve@stapp02

# Step 3 — Install Apache
sudo yum install -y httpd

# Step 4 — Change Apache port to 8086
sudo nano /etc/httpd/conf/httpd.conf
# Change: Listen 80 → Listen 8086
# Change:  →  if present

# Step 5 — Copy website files to Apache web root
sudo cp -r /tmp/ecommerce /var/www/html/ecommerce
sudo cp -r /tmp/demo /var/www/html/demo

# Step 6 — Set correct permissions
sudo chmod -R 755 /var/www/html/ecommerce
sudo chmod -R 755 /var/www/html/demo

# Step 7 — Start and enable Apache
sudo systemctl start httpd
sudo systemctl enable httpd

# Step 8 — Verify both sites are accessible
curl http://localhost:8086/ecommerce/
curl http://localhost:8086/demo/
```

### Expected Apache status output:
```
Active: active (running)
Status: "Started, listening on: port 8086"
```

---

## Gotcha

The port change requires updating two places in httpd.conf —
the `Listen` directive at the top and the ``
tag if it exists. Missing either one causes Apache to still
listen on port 80 or fail to start.

Also, files copied to /tmp/ are not served by Apache. They must
be moved to /var/www/html/ explicitly. Permissions must also be
set after copying — Apache cannot serve files it cannot read.

---

## Key Takeaway

Apache subdirectory hosting requires no extra VirtualHost config.
Files placed under /var/www/html/sitename/ are immediately
accessible at /sitename/ once permissions are correct and the
service is running on the right port. 

---

*Part of my #100DaysOfDevOps challenge*

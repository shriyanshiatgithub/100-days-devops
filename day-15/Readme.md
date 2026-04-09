# 100 Days of DevOps — Day 15

## Task: Deploy Nginx with SSL/TLS on App Server 3

**Platform:** KodeKloud
**Category:** Linux / Nginx / SSL
**Difficulty:** Medium
**Status:** ✅ Solved

---

## 📋 Problem Statement

Configure Nginx with HTTPS on stapp03 in Stratos DC as part of
application pre-requisite setup. SSL certificate and key were
pre-provided in /tmp.

---

## 💡 Concepts Learned

SSL certificate storage conventions on RHEL/CentOS:
- Certificates → /etc/pki/tls/certs/
- Private keys  → /etc/pki/tls/private/

These are not arbitrary paths. System tools and services expect
certs and keys here by convention. Placing them elsewhere works
but breaks the convention every sysadmin expects.

HTTP/2 is enabled by simply adding `http2` to the listen
directive — no separate module needed in modern Nginx.


---

## 🛠️ Solution

```bash
# Step 1 — Install Nginx
sudo dnf install -y nginx

# Step 2 — Move SSL cert and key to correct locations
sudo mv /tmp/nautilus.crt /etc/pki/tls/certs/nautilus.crt
sudo mv /tmp/nautilus.key /etc/pki/tls/private/nautilus.key

# Step 3 — Edit /etc/nginx/nginx.conf
# Add server block inside http { }
```

```nginx
server {
    listen       443 ssl http2;
    listen       [::]:443 ssl http2;
    server_name  stapp03;
    root         /usr/share/nginx/html;

    ssl_certificate     "/etc/pki/tls/certs/nautilus.crt";
    ssl_certificate_key "/etc/pki/tls/private/nautilus.key";
    ssl_session_cache   shared:SSL:1m;
    ssl_session_timeout 10m;
    ssl_ciphers         PROFILE=SYSTEM;
    ssl_prefer_server_ciphers on;

    error_page 404 /404.html;
    error_page 500 502 503 504 /50x.html;
}
```

```bash
# Step 4 — Create index page
echo "Welcome!" | sudo tee /usr/share/nginx/html/index.html

# Step 5 — Test config before starting
sudo nginx -t

# Step 6 — Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Step 7 — Verify from jump host
curl -Ik https://stapp03/
```

### Expected output:
```
HTTP/2 200
server: nginx/1.20.1
content-type: text/html
content-length: 9
```

content-length: 9 confirms "Welcome!\n" (8 chars + newline)
was served correctly over HTTPS.

---

## ⚠️ Gotcha

A missing closing `}` in the http block causes Nginx to fail
at startup with a configuration error. Always run nginx -t
first — it catches syntax errors before they take down the
service.


---

*Part of my #100DaysOfDevOps challenge*

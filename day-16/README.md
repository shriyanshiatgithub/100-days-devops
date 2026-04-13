# 100 Days of DevOps — Day 16

## Task: Configure Nginx Load Balancer with Multiple App Servers

| Field      | Value                        |
|------------|------------------------------|
| Platform   | KodeKloud                    |
| Category   | Linux / Nginx / Load Balancing |
| Difficulty | Medium                       |
| Status     | ✅ Solved                    |

---

## Problem Statement

Due to increasing traffic, the application needed a high
availability setup using a load balancer. The task was to
configure Nginx on the LBR server (stlb01) to distribute
traffic across stapp01, stapp02, and stapp03. Apache was
already running on all backend servers on port 6400 and
that configuration was not to be modified.

---

## Concepts Learned

Nginx uses an `upstream` block inside the `http` context to
define a group of backend servers and distribute traffic
between them.

By default, Nginx uses round-robin load balancing — requests
are forwarded to each backend server one by one in order.

The backend port in the upstream block must match the actual
port the backend service is listening on. Assuming port 80
when the service runs on 6400 will silently fail.

---

## Solution

```bash
# Step 1 — Start and enable Nginx on LBR server
sudo systemctl start nginx
sudo systemctl enable nginx

# Step 2 — Verify Nginx is running
sudo systemctl status nginx
```

```bash
# Step 3 — Verify Apache is running on all backend servers
# Repeat on stapp01, stapp02, stapp03
sudo systemctl status httpd
sudo systemctl enable httpd
```

```bash
# Step 4 — Edit Nginx configuration on stlb01
sudo vi /etc/nginx/nginx.conf
```

```nginx
http {

    upstream backend {
        server stapp01:6400;
        server stapp02:6400;
        server stapp03:6400;
    }

    server {
        listen 80;

        location / {
            proxy_pass http://backend;
        }
    }
}
```

```bash
# Step 5 — Test configuration syntax
sudo nginx -t

# Step 6 — Restart Nginx to apply changes
sudo systemctl restart nginx

# Step 7 — Verify load balancer is responding
curl http://stlb01:80
```

---

## Gotcha

Nginx was running and returning its default error page even
after configuration. The issue was the upstream block was
pointing to the default port 80 on the backend servers, but
Apache was actually running on port 6400. Once the upstream
block was updated with the correct port, requests forwarded
correctly.


---

## Key Takeaway

The load balancer configuration must exactly match the backend
service setup.

---

*Part of my #100DaysOfDevOps challenge*

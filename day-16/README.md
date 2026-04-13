100 Days of DevOps — Day 16
Task: Configure Nginx Load Balancer with Multiple App Servers

Platform: KodeKloud
Category: Linux / Nginx / Load Balancing
Difficulty: Medium
Status: ✅ Solved

📋 Problem Statement

Due to increasing traffic, the team decided to deploy the
application on a high availability setup using a load balancer.

My task was to configure Nginx on the LBR server (stlb01)
to distribute traffic across all backend app servers
(stapp01, stapp02, stapp03).

Important condition: Apache was already running on port 6400
on all app servers, and I was not supposed to change it.

💡 Concepts Learned

Nginx uses the upstream block to define backend servers
and proxy_pass to forward incoming requests.

By default, Nginx follows round-robin load balancing, so
traffic automatically gets distributed across servers.

🛠️ Solution
# Step 1 — Start and enable Nginx on LBR server
sudo systemctl start nginx
sudo systemctl enable nginx

# Step 2 — Verify Nginx is running
sudo systemctl status nginx
# Step 3 — Ensure Apache is running on all backend servers

# stapp01
sudo systemctl status httpd
sudo systemctl enable httpd

# stapp02
sudo systemctl status httpd
sudo systemctl enable httpd

# stapp03
sudo systemctl status httpd
sudo systemctl enable httpd
# Step 4 — Edit Nginx configuration
sudo vi /etc/nginx/nginx.conf
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
# Step 5 — Test configuration
sudo nginx -t

# Step 6 — Restart Nginx
sudo systemctl restart nginx

# Step 7 — Verify
curl http://stlb01:80
Expected output:
Welcome to xFusionCorp Industries!
⚠️ Gotcha

Initially, Nginx was running fine but I kept getting the
default error page:

nginx error! The page you are looking for is temporarily unavailable

This was confusing because:

Nginx service was active
Apache was also running

The actual issue was port mismatch.

Nginx was listening on port 80, but backend Apache servers
were running on port 6400, and the problem statement clearly
mentioned not to change it.

Once I updated the upstream block to use port 6400,
it started working.


🔑 Key Takeaway

Always verify the actual port on which backend services are running.

Load balancer configuration must match backend setup exactly.

Part of my #100DaysOfDevOps challenge

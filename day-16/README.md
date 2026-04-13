# 100 Days of DevOps — Day 16

Task: Configure Nginx Load Balancer with Multiple App Servers

Platform: KodeKloud
Category: Linux / Nginx / Load Balancing
Difficulty: Medium
Status: ✅ Solved

📋 Problem Statement

Traffic was increasing on one of the applications, so the team
decided to move to a high availability setup using a load
balancer.

My task was to configure Nginx on the LBR server (stlb01) and
route traffic to all backend app servers (stapp01, stapp02,
stapp03).

Important constraint: Apache was already running on all app
servers on port 6400, and I was not supposed to change it.

💡 Concepts Learned

Nginx uses an upstream block to define backend servers and
proxy_pass to forward requests.

By default, it follows round-robin load balancing — distributing
requests across all servers automatically.


🛠️ Solution
# Step 1 — Start and enable Nginx on LBR server
sudo systemctl start nginx
sudo systemctl enable nginx

# Step 2 — Verify Nginx is running
sudo systemctl status nginx
# Step 3 — Ensure Apache is running on all backend servers

# stapp01 / stapp02 / stapp03
sudo systemctl status httpd
sudo systemctl enable httpd
# Step 4 — Edit Nginx config
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
# Step 5 — Test and restart
sudo nginx -t
sudo systemctl restart nginx

# Step 6 — Verify
curl http://stlb01:80
Final Output:
Welcome to xFusionCorp Industries!
⚠️ Gotcha (Where I Got Stuck)

This one confused me for a while.

Initially, I kept getting the default Nginx error page:

nginx error! The page you are looking for is temporarily unavailable

What I missed was:

Nginx listens on port 80
But Apache backend was running on port 6400

I initially thought everything works on port 80 by default,
but the problem statement clearly said do not change Apache port.

So the fix was:
👉 Point Nginx upstream to port 6400, not 80

🔑 Key Takeaway

Never assume default ports in real environments.

Always verify:

Which port backend is actually running on
What the problem statement restricts you from changing

Load balancer should adapt to backend — not the other way around.

Part of my #100DaysOfDevOps challenge

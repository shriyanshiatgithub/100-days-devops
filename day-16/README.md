100 Days of DevOps — Day 16
Task: Configure Nginx Load Balancer with Multiple App Servers
Field	Value
Platform	KodeKloud
Category	Linux / Nginx / Load Balancing
Difficulty	Medium
Status	✅ Solved
Problem Statement

Due to increasing traffic, the application needed to be moved
to a high availability setup using a load balancer.

The task was to configure Nginx on the LBR server (stlb01)
to distribute traffic across multiple backend app servers
(stapp01, stapp02, stapp03).

Apache was already running on all backend servers on port 6400,
and the requirement was to not modify this configuration.

Concepts Learned

Nginx uses an upstream block inside the http context to define
multiple backend servers and distribute traffic between them.

By default, Nginx uses round-robin load balancing, which means
requests are sent to each server one by one.

It is important to match the backend port correctly instead of
assuming default ports like 80.

Solution
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
Gotcha

Even though Nginx was running, it initially returned the default
error page:

nginx error! The page you are looking for is temporarily unavailable

This caused confusion because both Nginx and Apache services
were active.

The issue was that Nginx was not correctly pointing to the
backend servers on the right port. Apache was running on port
6400, but without configuring that in the upstream block,
Nginx could not forward the request.

There was also a brief delay due to failed SSH login attempts,
which made debugging slightly confusing.

Key Takeaway

Always verify the actual port on which backend services are
running before configuring a load balancer.

Do not assume default ports. The load balancer configuration
must align exactly with the backend service setup.

Part of my #100DaysOfDevOps challenge

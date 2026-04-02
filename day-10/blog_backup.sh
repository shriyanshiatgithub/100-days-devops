#!/bin/bash
zip -r /backup/xfusioncorp_blog.zip /var/www/html/blog
scp /backup/xfusioncorp_blog.zip natasha@ststor01:/backup/

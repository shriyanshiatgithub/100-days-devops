# 100 Days of DevOps — Day 10

## Task: Write a Bash Backup Script with Passwordless SCP

**Platform:** KodeKloud
**Category:** Linux / Bash Scripting / SSH
**Difficulty:** Medium-Hard
**Status:** ✅ Solved

---

## Problem

App Server 2 hosts a static blog at /var/www/html/blog.
Need a script that zips it, saves to /backup locally,
and copies it to Nautilus Storage Server automatically
without any password prompt.

---

## What I did

First installed zip since it wasn't on the server, then
set up passwordless SSH from steve@stapp02 to natasha@ststor01
using ssh-keygen and ssh-copy-id (same pattern as Day 7).

Then wrote the script at /scripts/blog_backup.sh:

Made it executable:
```bash
chmod +x /scripts/blog_backup.sh
```

Ran it and verified:
```
adding: var/www/html/blog/ (stored 0%)
adding: var/www/html/blog/index.html (stored 0%)
xfusioncorp_blog.zip   100%  588   1.1MB/s   00:00
```

---

## What I learned

The no-sudo rule in the script forced me to think about
who actually runs it. The script runs as steve, so steve
needs SSH keys set up to ststor01, not root.

The key insight: passwordless SCP inside a script = SSH key
setup beforehand as the user who will run the script.
Always think about execution context.

---

*Part of my #100DaysOfDevOps challenge*

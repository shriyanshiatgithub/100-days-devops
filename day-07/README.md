# 100 Days of DevOps — Day 7

## Task: Set Up Passwordless SSH from Jump Host to All App Servers

**Platform:** KodeKloud
**Category:** Linux / SSH Security
**Difficulty:** Medium
**Status:** ✅ Solved (failed first attempt, fixed and passed)

---

## 📋 Problem Statement

Scripts on the jump host run on regular intervals and SSH into
all 3 app servers automatically. thor (jump host user) needed
passwordless SSH access to tony@stapp01, steve@stapp02,
and banner@stapp03.

---

## 💡 Concepts Learned

- SSH key-based auth eliminates password prompts — essential
  for automation scripts and CI/CD pipelines
- `ssh-keygen` generates a public/private RSA key pair
- `ssh-copy-id` appends the public key to the remote server's
  `~/.ssh/authorized_keys`
- The private key stays on the source machine — never shared
- Key distinction:
  - `crontab -e` runs as current user — same idea applies here
  - Keys generated as root go to /root/.ssh/
  - Keys generated as thor go to /home/thor/.ssh/
  - Always generate keys as the user who needs the access

---

## 🛠️ Solution

```bash
# Stay as thor — do NOT sudo su
ssh-keygen -t rsa -b 2048
# Default path: /home/thor/.ssh/id_rsa
# Leave passphrase empty for automation

# Copy public key to all 3 servers
ssh-copy-id tony@stapp01
ssh-copy-id steve@stapp02
ssh-copy-id banner@stapp03

# Verify passwordless login works
ssh tony@stapp01
ssh steve@stapp02
ssh banner@stapp03
```

---

## ⚠️ Why My First Attempt Failed

I ran `sudo su` before `ssh-keygen` — so keys were generated
for root (/root/.ssh/) not for thor (/home/thor/.ssh/).

The task checker ran `ssh tony@stapp01` as thor — who had no
keys set up. Task failed.

Fix: run everything as thor from the start. No sudo su needed.

Always ask: WHICH user needs the passwordless access?
Generate the keys as that exact user.

---

## 🔑 Key Takeaway

Passwordless SSH is the foundation of infrastructure automation.
Ansible, Kubernetes node communication, CI/CD pipelines, and
monitoring agents all rely on this exact mechanism.
Always generate SSH keys as the user who will be doing the SSHing.

---

*Part of my #100DaysOfDevOps challenge*

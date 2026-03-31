# 100 Days of DevOps — Day 8

## Task: Install Ansible 4.10.0 Globally on Jump Host via pip3

**Platform:** KodeKloud
**Category:** Ansible / Configuration Management
**Difficulty:** Medium
**Status:** ✅ Solved

---

## 📋 Problem Statement

The Nautilus DevOps team chose Ansible for configuration management.
Jump host is the Ansible controller. Task: install ansible==4.10.0
via pip3 so the binary is available globally to ALL users.

---

## 💡 Concepts Learned

**1. Ansible Architecture**
- Controller node (jump-host) → where Ansible is installed
- Managed nodes (stapp01/02/03) → Ansible NOT required here
- Communication happens over SSH — that's it

**2. pip3 install behavior**
- `pip3 install ansible`       → installs in ~/.local/ (user only)
- `sudo pip3 install ansible`  → installs in /usr/local/ (global)
- This single difference determines who can run ansible

**3. Linux PATH priority**
```
~/.local/bin      ← checked FIRST (highest priority)
/usr/local/bin    ← global install lands here
/usr/bin
```
Even after a global install, if a user-space binary exists in
~/.local/bin it takes priority. Always verify with `which ansible`

**4. Cleanup before reinstalling**
Must remove BOTH:
- ansible package
- ansible-core package
- leftover binaries in ~/.local/bin/ansible*
Otherwise path conflicts cause the wrong binary to be used

---

## 🛠️ Solution

```bash
# Step 1 — Install globally using sudo pip3
sudo python3 -m pip install ansible==4.10.0

# Step 2 — Remove any user-space leftover binaries
pip3 uninstall ansible-core -y
rm -f ~/.local/bin/ansible*
hash -r   # clear shell's binary cache

# Step 3 — Verify global installation
which ansible        # should show /usr/local/bin/ansible
ansible --version    # should show ansible core 2.11.12
```

### Expected output:
```
/usr/local/bin/ansible

ansible [core 2.11.12]
  executable location = /usr/local/bin/ansible
```

---

## ⚠️ Gotcha

After sudo pip3 install, `which ansible` still showed
~/.local/bin/ansible — the user-space version took priority.
Had to remove ~/.local/bin/ansible* and run `hash -r` to
clear the shell cache before the global binary took effect.

Also checked ansible on stapp01 — which was wrong.
Ansible only needs to be on the controller (jump host),
never on the managed nodes.

---

## 🔑 Key Takeaway

`pip3 install` vs `sudo pip3 install` is not just a permissions
difference — it determines the install location and therefore
which users can access the binary. In any multi-user or
automation context, always think about WHERE the binary lands,
not just whether the install succeeded.

---

*Part of my #100DaysOfDevOps challenge*

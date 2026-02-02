# Day 5 : SSH key login (WSL -> VM)

## Goal
- Login to VM without typing password.

## Steps (client: WSL)
- ssh-keygen -t ed25519 -C "wsl-to-vm"
- ssh-copy-id bbluebean@<VM_IP>
- ssh bbluebean@<VM_IP>

#3 Notes
- Server stores public keys at ~/.ssh/authorized_keys

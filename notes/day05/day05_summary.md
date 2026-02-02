# Day 5 : SSH + scp + tar

## SSH key login (WSL -> VM)
- ssh-copy-id bbluebean@<VM_IP>
- ssh bbluebean@<VM_IP>  # no password

## scp transfer
- local -> remote: scp FILE USER@HOST:PATH
- remote -> local: scp USER@HOST:FILE PATH
- directory: scp -r DIR USER@HOST:PATH

## VM workspace
- Use ~/Test/dayXX/playground for VM practice files.
- Keep VM copies in private_labs/ (do not commit).

## tar backup on VM
- tar -czf backup_YYYYMMDD.tar.gz day05/playground
- tar -tzf backup.tar.gz

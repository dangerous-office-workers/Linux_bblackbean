# Day 5: scp file transfer (WSL <-> VM)

## Syntax
- local -> remote: scp FILE USER@HOST:PATH
- remote -> local: scp USER@HOST:FILE PATH
- directories: scp -r DIR USER@HOST:PATH

## Tips
- :~ means remote home directory
- use SSH keys to avoid password prompts

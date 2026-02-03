# Day 4: user/group ownership

## Commands
- whoami: current user
- id: uid/gid + groups
- groups: group names
- ls -l: shows owner and group
- chgrp GROUP FILE: change group owner
- chown USER FILE / chown USER:GROUP FILE: change owner (and group)
- umask: default permission mask for new files

## umask and default permissions
- default file base: 666 (rw-rw-rw-)
- default dir base : 777 (rwxrwxrwx)
- with umask 022:
  - file: 666 - 022 = 644
  - dir : 777 - 022 = 755
- wiht umask 077:
  - file: 600
  - dir : 700

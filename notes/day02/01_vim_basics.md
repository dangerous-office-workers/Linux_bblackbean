# DAY 02-01 Vim Basics

## Goals
- mode (normal/insert/command) 익히기
- 저장/종료, 검색, 복붙, 되돌리기

## Practice text
hi linux
hi vim
today is day2
today is day2
## Survival commands
- :q!    quit without saving
- :wq    save and quit
- ZZ     save and quit (normal mode)
- :w!    force write (may still fail without permission)
- :%s/old/new/g    replace in whole file
- :%s/old/new/gc   replace with confirmation
- :set number / :set nonumber

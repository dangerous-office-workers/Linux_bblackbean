# Day 7 - permissions basics

## 권한 읽기
- ls -l : 권한/소유자/그룹 확인
- 권한 9글자 : user/group/other 각각 rwx

## chmod
- 문자 모드: chmod u+x file (u/g/o/a, +/-, r/w/x)
- 숫자 모드: r=4, w=2, x=1 (예: 640, 755)

## 디렉토리 권한 핵심
- 디렉토리 x 없으면 cd/접근 불가
- r: 목록 보기, w: 생성/삭제, x:접근/통과

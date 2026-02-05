# Day 9 - 그룹 공유 폴더(setgid) + umask로 협업 권한 만들기(VM)

## 목표
- 공유 폴더에서 팀원(다른 사용자)도 파일을 생성/수정할 수 있게 설정한다.

## 구성 요소
### 1) 그룹
- 공유 그룹 생성: `sudo groupadd -f labshare`
- 사용자 그룹 추가: `sudo usermod -aG labshare <user>`
  - `-a`(append) 없으면 기존 그룹이 날아갈 수 있음(중요)

### 2) 공유 폴더
- 폴더 생성: `/srv/labshare`
- 소유자/그룹: `root:labshare`
- 권한: `2770`
  - `770` : user/group은 rwx, other는 접근 차단
  - 앞의 `2` : setgid (디렉토리에서 매우 중요)
- 확인: `ls -ld /srv/labshare` -> `drwxrws---` 처럼 `s`가 보이면 setgid 적용

## setgid가 하는 일(디렉토리에서)
- 그 폴더 안에서 새로 만든 파일/디렉토리는 **그룹을 자동으로 상속**(labshare)

## umask가 하는 일(기본 권한에 영향)
- 새 파일 기본 최대: 666, 새 디렉토리 기본 최대: 777
- umask는 "기본 권한에서 빼는 값"
- 협업에 유리한 값: `0002`
  - 파일: 666 - 002 = 664 (-rw-rw-r--)
  - 디렉토리: 777 - 002 = 775 (drwxrwxr-x)
- 협업에 불리한 값: `0022`
  - 파일: 666 - 022 = 644 (-rw-r--r--) -> 그룹원이 수정 못함

## 실습에서 확인한 것
- umask=0002 상태에서 만든 파일은 `-rw-rw-r--`로 생성됨
- 다른 사용자(labuser)가 같은 그룹(labshare)로 파일 수정 가능

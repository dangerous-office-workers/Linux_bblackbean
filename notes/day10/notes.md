# Day 10 - Sticky bit(/tmp) + ACL(GETFACL/SETFACL) (VM)

## 1) Sticky bit
### 왜 필요한가?
- 공용 폴더는 누구나 만들 수 있어야 함(예: /tmp).
- 하지만 777만 주면 남의 파일도 삭제/이름 변경이 가능해져 위험함.
- Sticky bit를 걸면 **공용 폴더에서 "자기 파일만 삭제/이름변경"** 가능해짐.

### 확인/설정
- 확인: `ls -ld /tmp` -> 권한 끝에 `t`가 보이면 sticky bit 적용
  - 예: `drwxrwxrwt ... /tmp`
- 설정: `chmod 1777 <dir>`
  - `1` = sticky bit, `777` = 누구나 접근/쓰기 가능

### 실습 포인트
- sticky bit 없는 0777 폴더에서는 다른 사용자가 만든 파일이 삭제될 수 있음
- sticky bit(1777)를 적용하면 남의 파일 삭제가 `Permission denied`로 막힘

## 2) ACL (Access Control List)
### chmod의 한계
- chmod는 권한을 3덩어리(user/group/other)로만 관리.
- "특정 사용자 1명에게만 예외 권한" 같은 상황에 부족할 수 있음.

### getfacl / setfacl
- 조회: `getfacl FILE`
- 추가/수정: `setfacl -m u:<user>:<perm> FILE`
  - 예: `setfacl -m u:labuser:r secret.txt` (labuser에게 읽기만 허용)
- 원복(ACL 제거): `setfacl -b FILE`

### 주의사항(경로 권한)
- 파일에 ACL을 줘도, 그 파일까지 가는 상위 디렉토리들에 `x`(통과) 권한이 없으면 접근 불가.
- 실습은 /srv 같은 공용 경로에서 하면 ACL 효과를 깔끔하게 확인 가능

## 3) 실습 결과 요약
- /tmp는 `drwxrwxrwt`로 sticky bit가 걸려 있어 공용 폴더를 안전하게 운영한다.
- ACL로 특정 사용자(labuser)에게만 파일 읽기 권한을 예외로 부여할 수 있다.

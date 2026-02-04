# Day 8 - 텍스트 처리/파이프라인 기초 (로그 분석)

## 핵심 개념
- `|` (파이프): 앞 명령의 출력(stdout)을 뒤 명령의 입력(stdin)으로 전달
- `>` : 파일 덮어쓰기 저장
- `>>` : 파일 이어붙이기 저장
- 로그 분석은 보통 "필터링 -> 필요한 토큰 추출 -> 집계" 흐름으로 진행


## 자주 쓰는 기본 명령
- `wc -l FILE` : 줄 수(라인 수) 세기
- `head -n N FILE` : 앞 N줄 보기
- `tail -n N File` : 뒤 N줄 보기
- `grep "PATTERN" FILE` : 패턴이 포함된 줄만 필터링
- `grep -oE 'REGEX'` : 매칭된 부분만 출력(-o), 확장 정규식(-E)


## 집계 공식
- 정렬 후 중복 개수 세기
  - `... | sort | uniq -c | sort -nr`
- `uniq`는 "연속된 중복"만 세므로 보통 `sort`를 먼저 사용


## app.log 분석

### 1) ERROR 줄만 추출 / 개수
- `grep "ERROR" app.log`
- `grep "ERROR" app.log | wc -l`
- 저장: `grep "ERROR" app.log > -1_errors_only.txt`

### 2) ERROR status 집계(공백이 들쭉날쭉해도 안전한 방식)
- `grep "ERROR" app.log | grep -oE 'status=[0-9]+' | sort | uniq -c | sort -nr`

> 주의: `cut -d' ' -fN` 방식은 로그에 공백이 여러 칸이면 필드 번호가 흔들릴 수 있음.
> 이런 경우 필요한 토큰을 `grep -oE`로 뽑는 방식이 더 안정적이다.

### 3) ERROR path 집계
- `grep "ERROR" app.log | grep -oE 'path=[^ ]+' | sort | uniq -c | sort -nr`

### 4) 레벨(INFO/WARN/ERROR) 비율 집계
- `grep -oE '\b(INFO|WARN|ERROR)\b' app.log | sort | uniq -c | sort -nr`

### 5) status + path 같이 보기(awk 맛보기)
- `grep "ERROR" app.log | awk '{
    status=""; path="";
    for(i=1;i<=NF;i++){
      if($i ~ /^status=/) status=$i;
      if($i ~ /^path=/) path=$i;
    }
    if(status != "" && path != "") print status, path;
  }' | sort | uniq -c | sort -nr`

## 스크립트
- `scripts/day08/analyze_log.sh` : 로그파일을 입력받아 레벨/ERROR status/ERROR path 등을 한 번에 출력


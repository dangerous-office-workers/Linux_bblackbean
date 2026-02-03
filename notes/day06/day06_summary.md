# Day 6 - tar/백업 실습 + 간단 백업 스크립트 + cron 맛보기

## 1) tar 개념 (백업 관점)

`tar`는 여러 파일/폴더를 **하나의 아카이브 파일로 묶는 도구**이다.

- `.tar` : 묶기만 함(압축 X)
- `.tar.gz` : gzip 압축(자주 씀)
- `.tar.xz` : xz 압축(압축률 좋을 수 있으나 느릴 수 있음)

### 자주 쓰는 옵션
- `-c` : create (아카이브 생성)
- `-x` : extract (아카이브 풀기)
- `-t` : list (목록 보기)
- `-f` : file (아카이브 파일 지정) -> **거의 항상 같이 사용**
- `-v` : verbose (진행 과정 출력)
- `-C DIR` : 해당 DIR로 이동한 것처럼 기준 디렉토리를 바꿔 작업
- `-z` : gzip 압축 사용 (`.gz`)
- `-J` : xz 압축 사용 (`.xz`)
- `--exclude='패턴'` : 특정 파일/폴더 제외

> 자주 쓰는 형태 : `tar -czf 결과.tar.gz 대상폴더`


## 2) 실습
```bash
mkdir -p labs/day06
cd labs/day06

mkdir -p sample/{docs,logs}
echo "hello" > sample/docs/a.txt
echo "today=$(date)" > sample/docs/today.txt
for i in 1 2 3; do echo "log-$i $(date)" > sample/logs/app-$i.log; done

# tar 생성(압축x)
tar -cvf sample.tar sample
ls -lh sample.tar

# tar 목록 확인
tar -tvf sample.tar | head

# tar 풀기
# 원본과 섞이지 않게 restore/ 에 풀기
mkdir -p restore
tar -xvf sample.tar -C restore

# gzip / xz 압축 비교
tar -czvf sample.tar.gz sample
tar =cJvf sample.tar.xz sample
ls -lh sample.tar.gz sample.tar.xz

# 제외(exclude) 옵션
tar -czvf sample-no-logs.tar.gz --exclude='sample/logs' sample
tar -tvf sample-no-logs.tar.gz | grep logs || echo "logs 폴더 제외 확인 ok"
```

## 백업 스크립트(scripts/day06/backup-home.sh)
- tar.gz로 백업 생성
- 제외 패턴 적용(.git, build 산출물 등)
- 타임스탬프 포함 파일명
- 백업 무결성(간단) 체크
- 오래된 백업 자동 삭제(예:7일)
- 로그 남기기

- `tar -C "$SRC_DIR" .` 형태를 쓰면 경로가 깔끔하게 백업된다.
- 크론에서 실행할 것을 고려해, 절대경로+로그 리다이렉션을 습관화한다.
```bash
# 실행
chmod +x scripts/day06/backup-home.sh
/home/bblackbean/Linux_bblackbean/scripts/backup-home.sh

# 결과 확인
ls -lh /home/bblackbean/backups | tail
tail -n 30 /home/bblackbean/backups/backup.log

# 복구
mkdir -p ~/restore_test
LATEST="$(ls -t ~/backups/backup_*.tar.gz | head -n 1)"
tar -xzvf "$LATEST" -C ~/restore_test
```

## cron
`cron`은 정해진 시간에 명령어를 자동 실행하는 서비스이다.
`crontab`은 사용자별 예약 작업 목록이다.
```bash
# 기본 확인
which cron
crontab -e
```

### cron 문법
```
분 시 일 월 요일  실행할_명령어
```
- `*/5 * * * *` : 매 5분마다
- `0 9 * * 1` : 매주 월요일 09:00
- `30 9 * * 1` : 매주 월요일 09:30
- `0 18 * * *` : 매일 18:00

date를 1분마다 로그로 남김 (테스트 완료 후에는 반드시 삭제)
```bash
* * * * * date >> /home/bblackbean/backups/cron_test.log 2>&1

# 확인
tail -n 5 ~/backups/cron_test.log
```

#!/usr/bin/env bash
set -euo pipefail

# === 설정 ===
# 백업할 대상 디렉토리
SRC_DIR="${HOME}/Linux_bblackbean"  # 예시: 레포 자체를 백업
# 백업 파일을 저장할 위치
DEST_DIR="${HOME}/backups"
# 몇 일 치 백업을 남길지
RETENTION_DAYS=7

# 제외할 패턴
# - 레포일 경우 .git, 빌드 산출물, 캐시 등을 빼는 게 좋음
EXCLUDES=(
    "--exclude=.git"
    "--exclude=private_labs"
    "--exclude=**/build"
    "--exclude=**/.gradle"
    "--exclude=**/node_modules"
)

# === 실행 로직 ===
mkdir -p "$DEST_DIR"

TS="$(date +'%Y%m%d_%H%M%S')"
HOST="$(hostname | tr ' ' '_')"
ARCHIVE_NAME="backup_${HOST}_${TS}.tar.gz"
ARCHIVE_PATH="${DEST_DIR}/${ARCHIVE_NAME}"
LOG_PATH="${DEST_DIR}/backup.log"

echo "=== [$(date)] 백업 시작 ===" | tee -a "$LOG_PATH"
echo "- SRC_DIR : $SRC_DIR" | tee -a "$LOG_PATH"
echo "- DEST    : $ARCHIVE_PATH" | tee -a "$LOG_PATH"


# -C "$SRC_DIR"  : SRC_DIR로 들어간 것처럼 기준을 바꿔서
# .              : 현재 디렉토리 전체를 아카이브에 담는다(경로 깔끔)
tar -czf "$ARCHIVE_PATH" \
  -C "$SRC_DIR" \
  "${EXCLUDES[@]}" \
  . 2>>"$LOG_PATH"

# 무결성 확인 : tar 목록 보기 성공하면 기본 검증 통과
tar -tzf "$ARCHIVE_PATH" >/dev/null

# 백업 파일 해시 기록(원하면 복구 시 비교 가능)
sha256sum "$ARCHIVE_PATH" | tee -a "$LOG_PATH" >/dev/null

echo "- 백업 완료: $(ls -lh "$ARCHIVE_PATH" | awk '{print $5, $9}')" | tee -a "$LOG_PATH"

# 오래된 백업 삭제(RETENTION_DAYS 이전 파일)
echo "- 오래된 백업 정리(${RETENTION_DAYS}일 초과...)" | tee -a "$LOG_PATH"
find "$DEST_DIR" -type f -name 'backup_*.tar.gz' -mtime +"$RETENTION_DAYS" -print -delete | tee -a "$LOG_PATH"

echo "=== [$(date)] 백업 종료 ===" | tee -a "$LOG_PATH"

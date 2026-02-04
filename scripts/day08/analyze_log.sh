#!/usr/bin/env bash
set -euo pipefail

# 사용법:
#   ./analyze_log.sh [로그파일]
# 예:
#   ./analyze_log.sh labs/day08/app.log
LOG_FILE="${1:-labs/day08/app.log}"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "에러: 로그 파일이 없습니다: $LOG_FILE" >&2
  exit 1
fi

echo "== 대상 로그 =="
echo "$LOG_FILE"
echo

echo "== 레벨(INFO/WARN/ERROR) 개수 =="
grep -oE '\b(INFO|WARN|ERROR)\b' "$LOG_FILE" | sort | uniq -c | sort -nr
echo

echo "== ERROR path 집계 =="
grep "ERROR" "$LOG_FILE" | grep -oE 'path=[^ ]+' | sort | uniq -c | sort -nr
echo

echo "== ERROR status + path 집계 =="
grep "ERROR" "$LOG_FILE" | awk '{
  status=""; path="";
  for (i = 1; i <= NF; i++) {
    if ($i ~ /^status=/) status=$i;
    if ($i ~ /^path=/) path=$i;
  }
  if(status != "" & path != "") print status, path
}' | sort | uniq -c | sort -nr

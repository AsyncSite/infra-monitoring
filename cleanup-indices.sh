#!/bin/bash
# 기존 인덱스 삭제 스크립트 - 필드 타입 충돌 해결용

echo "Deleting existing Elasticsearch indices to resolve field type conflicts..."

# Filebeat 기본 인덱스 삭제
curl -X DELETE "localhost:9200/filebeat-*" 2>/dev/null
echo "Deleted filebeat-* indices"

# AsyncSite 서비스별 인덱스 삭제 (있다면)
curl -X DELETE "localhost:9200/asyncsite-*" 2>/dev/null
echo "Deleted asyncsite-* indices"

# 인덱스 목록 확인
echo -e "\nRemaining indices:"
curl -s "localhost:9200/_cat/indices?v" | grep -E "(filebeat|asyncsite)" || echo "No filebeat or asyncsite indices found"

echo -e "\nCleanup complete!"
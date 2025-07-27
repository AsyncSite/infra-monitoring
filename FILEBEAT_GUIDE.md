# Filebeat 설정 가이드

## 파일 구조 설명

### Filebeat 설정 파일
- **`filebeat-local.yml`**: 로컬 개발 환경용 (파일 기반 로그 수집)
- **`filebeat-server.yml`**: 서버 환경용 (Docker 컨테이너 로그 직접 수집)

### Docker Compose 파일
- **`docker-compose.filebeat.yml`**: 기본 Filebeat 컨테이너 설정 (공통)
- **`docker-compose.filebeat.local.yml`**: 로컬 환경 오버라이드
- **`docker-compose.filebeat.server.yml`**: 서버 환경 오버라이드

## 사용 방법

### 로컬 환경 (macOS)
```bash
# 로그 디렉터리 생성
mkdir -p ~/asyncsite-logs

# Filebeat 실행
docker-compose -f docker-compose.filebeat.yml -f docker-compose.filebeat.local.yml up -d
```

### 서버 환경 (Linux)
```bash
# Filebeat 실행 (Docker 로그 자동 수집)
docker-compose -f docker-compose.filebeat.yml -f docker-compose.filebeat.server.yml up -d
```

## 환경별 차이점

| 구분 | 로컬 환경 | 서버 환경 |
|------|-----------|-----------|
| 로그 수집 방식 | 파일 기반 | Docker 컨테이너 로그 직접 수집 |
| 로그 위치 | `~/asyncsite-logs/*/application.log` | `/var/lib/docker/containers/*/*.log` |
| 설정 파일 | `filebeat-local.yml` | `filebeat-server.yml` |
| 필터링 | 없음 (모든 로그 파일) | `asyncsite-*` 컨테이너만 |

## 트러블슈팅

### 서버에서 권한 오류 발생 시
```bash
# filebeat 설정 파일 권한 확인
ls -la filebeat-server.yml
sudo chown root:root filebeat-server.yml
sudo chmod 644 filebeat-server.yml
```

### 로그가 수집되지 않을 때
1. Filebeat 로그 확인: `docker logs asyncsite-filebeat-agent`
2. 로그 파일/컨테이너 존재 확인
3. Logstash 연결 상태 확인
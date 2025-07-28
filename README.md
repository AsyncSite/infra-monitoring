# infra-monitoring

## 개요
AsyncSite 프로젝트의 중앙화된 로그 수집 및 모니터링을 위한 ELK Stack 구성입니다.

## 구성 요소
- **Elasticsearch**: 로그 데이터 저장소
- **Logstash**: 로그 처리 및 변환 파이프라인
- **Kibana**: 로그 시각화 대시보드
- **Filebeat**: 로그 수집 에이전트

## 특징
- JSON 형식 로그 자동 파싱
- **서비스별 인덱스 분리**: `asyncsite-{service}-{date}` 형태로 자동 생성
- 상관관계 ID(corrId)를 통한 요청 추적
- 로그 레벨별 태그 지정
- Kibana 인덱스 패턴 자동 설정

## 시작하기

### 1. ELK Stack 실행
```bash
docker-compose up -d
```

### 2. Filebeat 실행

Filebeat는 환경에 따라 다른 설정을 사용합니다. 자세한 내용은 [FILEBEAT_GUIDE.md](./FILEBEAT_GUIDE.md)를 참조하세요.

#### 로컬 개발 환경 (macOS)
```bash
# 로그 디렉토리 생성 (최초 1회)
mkdir -p ~/asyncsite-logs/{user-service,gateway,eureka-server,study-service,game-service,noti-service}

# Filebeat 실행
docker-compose -f docker-compose.filebeat.yml -f docker-compose.filebeat.local.yml up -d
```

#### 서버 환경 (Production/Staging)
```bash
# Filebeat 실행
docker-compose -f docker-compose.filebeat.yml -f docker-compose.filebeat.server.yml up -d

# Kibana 인덱스 패턴 자동 설정 (최초 1회)
docker-compose -f docker-compose.server.yml up kibana-setup
```

## 로그 수집 방식

### 서버 환경 - Docker 컨테이너 로그 직접 수집
```
# Docker 컨테이너 로그 위치
/var/lib/docker/containers/
├── {container-id}/
│   └── {container-id}-json.log
└── ...

# Filebeat가 Docker 메타데이터를 통해 자동으로 서비스 식별
# asyncsite-* 컨테이너만 필터링하여 수집
```

### 로컬 환경 - 파일 기반 로그 수집
```
~/asyncsite-logs/
├── user-service/
│   └── application.log
├── game-service/
│   └── application.log
└── ...
```

## Kibana 사용법
1. 브라우저에서 http://localhost:5601 접속
2. 왼쪽 메뉴에서 Discover 클릭
3. 인덱스 패턴 선택:
   - `asyncsite-*`: 전체 서비스 로그
   - `asyncsite-user-service-*`: 특정 서비스 로그
4. 시간 범위 설정 후 로그 조회

### 유용한 필터
- 특정 서비스: `service: "user-service"`
- 에러 로그: `level: "ERROR"`
- 상관관계 추적: `correlation_id: "특정ID"`

### 인덱스 패턴 확인
```bash
# 생성된 인덱스 목록 조회
curl -s 'localhost:9200/_cat/indices?v' | grep asyncsite
```

## 개발 팁
- Logstash 파이프라인 디버깅: `logstash.conf`의 stdout 출력 주석 해제
- 로그 필드 확인: Kibana의 Discover에서 JSON 탭 확인
- 서버 환경에서 특정 컨테이너 로그만 보기: `container.name: "asyncsite-user-service"`
- Docker 로그 실시간 확인: `docker logs -f {container-name}`
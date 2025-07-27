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
- 서비스별 로그 필터링
- 상관관계 ID(corrId)를 통한 요청 추적
- 로그 레벨별 태그 지정

## 시작하기

### 1. ELK Stack 실행
```bash
docker-compose up -d
```

### 2. Filebeat 실행

#### 서버 환경 (Production/Staging)
```bash
docker-compose -f docker-compose.filebeat.yml up -d
```

#### 로컬 개발 환경 (macOS)
```bash
# 로그 디렉터리 생성
mkdir -p ~/asyncsite-logs

# 로컬 환경용 설정으로 실행
docker-compose -f docker-compose.filebeat.yml -f docker-compose.filebeat.local.yml up -d
```

## 로그 디렉터리 구조
```
# 서버 환경
/var/log/containers/
├── user-service/
│   └── application.log
├── game-service/
│   └── application.log
└── ...

# 로컬 환경
~/asyncsite-logs/
├── user-service/
│   └── application.log
├── game-service/
│   └── application.log
└── ...
```

## Kibana 사용법
1. 브라우저에서 http://localhost:5601 접속
2. Stack Management → Index Patterns → Create index pattern
3. Index pattern: `filebeat-*`
4. Time field: `@timestamp`
5. Discover 메뉴에서 로그 조회

### 유용한 필터
- 특정 서비스: `service: "user-service"`
- 에러 로그: `level: "ERROR"`
- 상관관계 추적: `correlation_id: "특정ID"`

## 개발 팁
- Logstash 파이프라인 디버깅: `logstash.conf`의 stdout 출력 주석 해제
- 로그 필드 확인: Kibana의 Discover에서 JSON 탭 확인
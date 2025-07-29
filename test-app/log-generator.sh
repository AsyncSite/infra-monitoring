#!/bin/bash

# AsyncSite 서비스와 동일한 JSON 로그 생성
while true; do
    TIMESTAMP=$(date -u +"%Y-%m-%dT%H:%M:%S.%3NZ")
    CORR_ID=$(uuidgen | tr '[:upper:]' '[:lower:]')
    
    # SERVICE_NAME 환경변수가 있으면 사용, 없으면 기본값
    SERVICE=${SERVICE_NAME:-"user-service"}
    
    # AsyncSite 서비스와 동일한 JSON 로그 형식
    echo "{\"@timestamp\":\"$TIMESTAMP\",\"@version\":\"1\",\"message\":\"Test log from mock service\",\"logger_name\":\"com.asyncsite.${SERVICE}.test\",\"thread_name\":\"http-nio-8081-exec-1\",\"level\":\"INFO\",\"level_value\":20000,\"corrId\":\"$CORR_ID\",\"service\":\"$SERVICE\",\"environment\":\"docker\"}"
    
    sleep 1
done
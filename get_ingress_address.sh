#!/bin/bash

# kubectl 명령어 실행하여 ingress 목록을 가져오고 ADDRESS 값을 추출
ADDRESS=$(kubectl get ingress -A -o wide | awk '/istio-system/ {print $5}')

# 출력 값을 JSON 형식으로 반환
echo "{ \"address\": \"$ADDRESS\" }"


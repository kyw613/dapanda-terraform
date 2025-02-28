apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: dpd-eks-ingress
  namespace: istio-system
  annotations:
    alb.ingress.kubernetes.io/scheme: internet-facing
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}, {"HTTPS": 443}]'
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:ap-northeast-2:571698711201:certificate/fd0fcb7b-f2d7-4d4e-928d-2724d1f5d5d8
    alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
    alb.ingress.kubernetes.io/target-type: instance
    alb.ingress.kubernetes.io/subnets: "${public_subnet_2a_id},${public_subnet_2c_id}"
spec:
  ingressClassName: alb
  rules:
  - host: awscloudschool.online
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: istio-ingressgateway
            port:
              number: 80


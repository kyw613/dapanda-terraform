resource "aws_route53_record" "alb_a_record" {
  zone_id = "Z08256762BWQZIDT588AT"
  name    = "awscloudschool.online"
  type    = "A"

  alias {
    name                   = data.external.ingress_address.result.address
    zone_id                = "Z08256762BWQZIDT588AT"
    evaluate_target_health = true
  }

  depends_on = [kubectl_manifest.istio_ingress_alb]
}


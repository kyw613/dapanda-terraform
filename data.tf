data "aws_eks_cluster_auth" "default" {
  name = aws_eks_cluster.main.id
}

data "aws_caller_identity" "current" {}

data "aws_ssm_parameter" "eks" {
  name = format("/aws/service/eks/optimized-ami/%s/amazon-linux-2/recommended/image_id", var.k8s_version)
}

#data "kubernetes_ingress" "alb_ingress" {
#  metadata {
#    name      = "dpd-eks-ingress"
#    namespace = "istio-system"
#  }
#}

#output "alb_dns_name" {
#  value = one(data.kubernetes_ingress.alb_ingress.status[0].load_balancer.ingress[*].hostname)
#}

#data "external" "ingress_address" {
#  program = ["bash", "${path.module}/get_ingress_address.sh"]
#}


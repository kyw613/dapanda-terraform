
resource "helm_release" "istio_base" {
  name             = "istio-base"
  chart            = "base"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  namespace        = "istio-system"
  create_namespace = true

  version = "1.22.2"

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.main,
    kubernetes_config_map.aws-auth,
    helm_release.alb_ingress_controller
  ]
}


resource "helm_release" "istiod" {
  name             = "istio"
  chart            = "istiod"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  namespace        = "istio-system"
  create_namespace = true

  version = "1.22.2"

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.main,
    kubernetes_config_map.aws-auth,
    helm_release.istio_base
  ]
}

resource "helm_release" "istio_ingress" {
  name             = "istio-ingressgateway"
  chart            = "gateway"
  repository       = "https://istio-release.storage.googleapis.com/charts"
  namespace        = "istio-system"
  create_namespace = true

  version = "1.22.2"

  set {
    name  = "service.type"
    value = "NodePort"
  }


  set {
    name  = "service.ports[0].name"
    value = "status-port"
  }

  set {
    name  = "service.ports[0].port"
    value = 15021
  }

  set {
    name  = "service.ports[0].targetPort"
    value = 15021
  }

  set {
    name  = "service.ports[0].nodePort"
    value = 30021
  }

  set {
    name  = "service.ports[0].protocol"
    value = "TCP"
  }


  set {
    name  = "service.ports[1].name"
    value = "http2"
  }

  set {
    name  = "service.ports[1].port"
    value = 80
  }

  set {
    name  = "service.ports[1].targetPort"
    value = 80
  }

  set {
    name  = "service.ports[1].nodePort"
    value = 30080
  }

  set {
    name  = "service.ports[1].protocol"
    value = "TCP"
  }


  set {
    name  = "service.ports[2].name"
    value = "https"
  }

  set {
    name  = "service.ports[2].port"
    value = 443
  }

  set {
    name  = "service.ports[2].targetPort"
    value = 443
  }

  set {
    name  = "service.ports[2].nodePort"
    value = 30443
  }

  set {
    name  = "service.ports[2].protocol"
    value = "TCP"
  }

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.main,
    kubernetes_config_map.aws-auth,
    helm_release.istio_base,
    helm_release.istiod
  ]
}

resource "kubectl_manifest" "istio_gateway" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: dpd-istio-gw
  namespace: istio-system
spec:
  selector:
    istio: ingressgateway
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - "*"
YAML

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.main,
    kubernetes_config_map.aws-auth,
    helm_release.istio_base,
    helm_release.istiod
  ]
}

resource "kubectl_manifest" "istio_virtual_service" {
  yaml_body = <<YAML
apiVersion: networking.istio.io/v1alpha3
kind: VirtualService
metadata:
  name: dpd-istio-vs
  namespace: istio-system
spec:
  hosts:
  - "*"
  gateways:
  - dpd-istio-gw
  http:
  - match:
    - uri:
        prefix: "/"
    route:
    - destination:
        host: "dpd-fe-svc.dpd-fe-ns.svc.cluster.local"
        port:
          number: 3000
YAML

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.main,
    kubernetes_config_map.aws-auth,
    helm_release.istio_base,
    helm_release.istiod
  ]
}

resource "kubectl_manifest" "istio_var" {
  yaml_body = templatefile("istio_virtual_service.yaml.tpl", {
    public_subnet_2a_id = aws_subnet.public_subnet_2a.id
    public_subnet_2c_id = aws_subnet.public_subnet_2c.id
  })

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.main,
    kubernetes_config_map.aws-auth,
    helm_release.istio_base,
    helm_release.istiod,
  ]
}

resource "kubectl_manifest" "istio_ingress_alb" {
  yaml_body = templatefile("istio_virtual_service.yaml.tpl", {
    public_subnet_2a_id = aws_subnet.public_subnet_2a.id,
    public_subnet_2c_id = aws_subnet.public_subnet_2c.id
  })

  depends_on = [
    aws_eks_cluster.main,
    aws_eks_node_group.main,
    kubernetes_config_map.aws-auth,
    helm_release.istio_base,
    helm_release.istiod,
    kubectl_manifest.istio_var
  ]
}


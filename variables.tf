#########################
###  GENERAL CONFIGS  ###
#########################

variable "cluster_name" {
  description = "The name of the Amazon EKS cluster. This is a unique identifier for your EKS cluster within the AWS region."
  default     = "dpd-eks"
}

variable "aws_region" {
  description = "AWS region where the EKS cluster will be deployed. This should be set to the region where you want your Kubernetes resources to reside."
  default     = "ap-northeast-2"
}

variable "k8s_version" {
  description = "The version of Kubernetes to use for the EKS cluster. This version should be compatible with the AWS EKS service and other infrastructure components."
  default     = "1.29"
}

#########################
### CAPACITY CONFIGS  ###
#########################

variable "nodes_instances_sizes" {
  description = "A list of EC2 instance types to use for the EKS worker nodes. These instance types should balance between cost, performance, and resource requirements for your workload."
  default = [
    "t3.large"
  ]
}

variable "auto_scale_options" {
  description = "Configuration for the EKS cluster auto-scaling. It includes the minimum (min), maximum (max), and desired (desired) number of worker nodes."
  default = {
    min     = 2
    max     = 6
    desired = 2
  }
}

variable "cluster_autoscaler_toggle" {
  type        = bool
  description = "Enable or disable the Cluster Autoscaler installation. When true, Cluster Autoscaler is installed to automatically adjust the number of nodes in the cluster."
  default     = false
}


#########################
### KARPENTER CONFIGS ###
#########################

variable "karpenter_toggle" {
  type        = bool
  description = "Determines whether Karpenter is enabled for the EKS cluster. Karpenter is an open-source auto-scaler for Kubernetes clusters."
  default     = true
}

variable "karpenter_instance_family" {
  type        = list(any)
  description = "Defines a list of EC2 instance families to be considered by Karpenter for node provisioning. Instance families like 'c6' and 'c5' offer different compute capabilities."
  default = [
    "t3"
  ]
}

variable "karpenter_instance_sizes" {
  type        = list(any)
  description = "Specifies a list of instance sizes within the chosen instance families to allow diversity in the provisioned nodes by Karpenter."
  default = [
    "large"
  ]
}

variable "karpenter_capacity_type" {
  type        = list(any)
  description = "Defines the capacity types for provisioning instances in the cluster, such as 'spot' or 'on_demand', offering cost-saving options or consistent availability respectively."
  default = [
    "spot"
  ]
}

variable "karpenter_availability_zones" {
  type        = list(any)
  description = "A list of AWS availability zones where Karpenter should launch nodes. These zones should be in the same region as the EKS cluster."
  default = [
    "ap-northeast-2a",
    "ap-northeast-2c"
  ]
}

#########################
###  INGRESS CONFIGS  ###
#########################

variable "alb_ingress_internal" {
  type        = bool
  description = "Indicates whether the Application Load Balancer (ALB) for the EKS cluster should be internal, restricting access to within the AWS network."
  default     = false
}

variable "alb_ingress_type" {
  type        = string
  description = "Specifies the type of ingress to be used, such as 'application', determining how the ALB handles incoming traffic to the EKS cluster."
  default     = "application"
}

variable "alb_ingress_enable_termination_protection" {
  type        = bool
  description = "Determines if termination protection is enabled for the Application Load Balancer, preventing accidental deletion."
  default     = false
}

variable "enable_cross_zone_load_balancing" {
  type        = bool
  description = "Controls whether cross-zone load balancing is enabled for the Application Load Balancer, allowing even traffic distribution across all zones."
  default     = false
}

variable "alb_idle_timeout" {
  type        = number
  description = "The time in seconds that the connection is allowed to be idle. The default is 60 seconds."
  default     = 60
}

variable "alb_drop_invalid_header_fields" {
  type        = bool
  description = "Indicates whether to drop invalid header fields."
  default     = false
}

variable "alb_enable_http2" {
  type        = bool
  description = "Enables HTTP/2 support on the Application Load Balancer."
  default     = true
}


#########################
###  ISTIO CONFIGS    ###
#########################

variable "istio_ingress_min_pods" {
  type        = number
  description = "The minimum number of pods to maintain for the Istio ingress gateway. This ensures basic availability and load handling."
  default     = 1
}

variable "istio_ingress_max_pods" {
  type        = number
  description = "The maximum number of pods to scale up for the Istio ingress gateway. This limits the resources used and manages the scaling behavior."
  default     = 5
}


#########################
###  GENERAL TOGGLES  ###
#########################

variable "descheduler_toggle" {
  type        = bool
  description = "Controls the installation of the Descheduler, a tool to balance and optimize the distribution of Pods across the cluster for improved efficiency."
  default     = false
}

variable "chaos_mesh_toggle" {
  type        = bool
  description = "Determines whether to install Chaos Mesh, a cloud-native Chaos Engineering platform that orchestrates chaos experiments on Kubernetes environments."
  default     = false
}

variable "node_termination_handler_toggle" {
  type        = bool
  description = "Enables the AWS Node Termination Handler, which ensures that Kubernetes workloads are gracefully handled during EC2 instance terminations or disruptions."
  default     = true
}

variable "argo_rollouts_toggle" {
  type        = bool
  description = "Enables the installation of Argo Rollouts, providing advanced deployment strategies like Canary and Blue-Green deployments in Kubernetes."
  default     = true
}

variable "keda_toggle" {
  type        = bool
  description = "Activates the installation of KEDA (Kubernetes Event-Driven Autoscaling), which adds event-driven scaling capabilities to Kubernetes workloads."
  default     = true
}

#########################
###   ADDONS CONFIGS  ###
#########################

variable "addon_cni_version" {
  type        = string
  description = "Specifies the version of the AWS VPC CNI (Container Network Interface) plugin to use, which manages the network interfaces for pod networking."
  default     = "v1.14.1-eksbuild.1"
}

variable "addon_coredns_version" {
  type        = string
  description = "Defines the version of CoreDNS to use, a DNS server/forwarder that is integral to internal Kubernetes DNS resolution."
  default     = "v1.11.1-eksbuild.4"
}

variable "addon_kubeproxy_version" {
  type        = string
  description = "Sets the version of Kubeproxy to be used, which handles Kubernetes network services like forwarding the requests to correct containers."
  default     = "v1.29.0-eksbuild.1"
}

variable "addon_csi_version" {
  type        = string
  description = "Indicates the version of the Container Storage Interface (CSI) driver to use for managing storage volumes in Kubernetes."
  default     = "v1.26.1-eksbuild.1"
}

variable "default_tags" {
  type        = map(string)
  description = "A map of default tags to apply to all resources. These tags can help with identifying and organizing resources within the AWS environment."
  default = {
    Environment = "prod"
    Foo         = "Bar"
    Ping        = "Pong"
  }
}

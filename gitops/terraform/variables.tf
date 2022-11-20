variable "project" {
  type        = string
  description = "Project nme"
  default = "k8s_vanek"
}
variable "location" {
  type        = string
  description = "Resources location in Azure"
  default = "West Europe"
}
variable "kubernetes_version" {
  type        = string
  description = "Kubernetes version"
  default = "1.24.6"
}
variable "vm_size" {
  type = string
  default = "Standard_D2as_v4"
}
variable "enable_auto_scaling" {
  type = bool
  default = false
}
variable "dns_prefix" {
  type = string
  default = "k8s-vanek"
}
variable "node_count" {
  type = number
  default = 2
}
variable "environment" {
  type = map(any)
  default = {
    dev = {
      address_space  = "172.31.0.0/16"
      instance_count = 1
      vm_size        = "Standard_D2as_v4"
    }
  }
}
variable "tenant_id" {
  type    = string
  default = "39a3b01c-a3ef-495b-a5ad-b1d0ee62025e"
}
variable "client_id" {
  type    = string
}
variable "client_secret" {
  type    = string
}
variable "subscription_id" {
  type    = string
}
variable "ms_academy_admin_id" {
  type    = string
  default = "eac5a5f9-a7ae-40bc-ad05-5415830d2bcc"
}
variable "ms_academy_developer_id" {
  type    = string
  default = "b1b3ceca-46b8-4ab8-b5c5-3129992efa0a"
}
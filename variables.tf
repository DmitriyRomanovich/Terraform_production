#####    Credentials

variable "client_id" {
  default = ""
}
variable "subscription_id" {
  default = ""
}
variable "tenant_id" {
  default = ""
}
variable "client_secret" {
  default = ""
}

variable "storage_account_name" {
  default = "prodtstate32422"
}

variable "storage_access_key" {
  default = ""
}

variable "build_number" {
  default = ""
}

variable "valueChecksum" {
  default = ""
}

variable "stateChecksum" {
  default = ""
}


variable "cluster_name" {
  default = "glow-prod-aks"
}

variable "resource_group_name" {
  default = "PROD-PRS-GlowAKS"
}

variable "pod_namespace" {
  description = "Pod namespace. Use in cert, configmaps, ingress_config, pgbouncer modules"
  default     = "production"
  type        = string
}

#######   Variables for Pgbouncer
variable "db_ip" {
  default = ""
}
variable "db_port" {
  default = ""
}

variable "db_user" {
  default = ""
}
variable "db_password" {
  default = ""
}


#######   Names of certificates
variable "calc" {
  description = "Cert name of calc"
  default     = "calc"
  type        = string
}

variable "glowapi" {
  description = "Cert name of glowapi"
  default     = "glowapi"
  type        = string
}

variable "loanapi" {
  description = "Cert name of loanapi"
  default     = "loanapi"
  type        = string
}

variable "paymentui" {
  description = "Cert name of paymentui"
  default     = "paymentui"
  type        = string
}

variable "loanui" {
  description = "Cert name of loanui"
  default     = "loanui"
  type        = string
}

variable "glowui" {
  description = "Cert name of glowui"
  default     = "glowui"
  type        = string
}

variable "demo_back" {
  description = "Cert name of demo-back"
  default     = "demo-back"
  type        = string
}

variable "demo_ui" {
  description = "Cert name of demo-ui"
  default     = "demo-ui"
  type        = string
}

variable "env_domain" {
  description = "Env for domain url"
  default     = "prod"
  type        = string
}

variable "inauth_enable" {
  description = "INAUTH variable"
  type        = string
}

variable "inauth_domain" {
  description = "INAUTH variable"
  type        = string
}

variable "inauth_apikey" {
  description = "INAUTH variable"
  type        = string
}
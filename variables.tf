variable "region" {
  description = "Región principal (ca-central-1 para la prueba)"
  type        = string
}

variable "cf_region" {
  description = "Región para ACM/CloudFront (us-east-1) / bc cf no es compatible con otra"
  type        = string
}

variable "account_id" {
  description = "ID de la cuenta AWS"
  type        = string
}

variable "project" {
  description = "promarketig"
  type        = string
}

variable "operation" {
  description = "casino-online"
  type        = string
}

variable "root_domain" { type = string }
variable "app_domain" { type = string }
variable "api_domain" { type = string }
variable "assets_domain" { type = string }

variable "instance_type" {
  description = "Tipo de instancia para EC2/Bastion"
  type        = string
  default     = "t3.micro"
}

variable "db_instance" {
  description = "Clase de instancia para RDS"
  type        = string
  default     = "db.t3.micro"
}

variable "acm_cert_arn_regional" {
  description = "ARN del certificado ACM en ca-central-1 para el ALB"
  type        = string
  default     = ""
}

variable "acm_cert_arn_cf" {
  description = "ARN del certificado ACM en us-east-1 para CloudFront"
  type        = string
  default     = ""
}

variable "redis_node_type" {
  description = "Tamaño del nodo de Redis"
  type        = string
  default     = "cache.t3.micro"
}



variable "num" {
  description = "Número secuencial para nombres (01, 02, ...)"
  type        = number
  default     = 1
}


variable "redis_auth_token" {
  description = "Auth token para Redis (solo si transit_encryption_enabled=true)"
  type        = string
  sensitive   = true
}

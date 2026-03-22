variable "domain_name" {
  description = "Primary domain name for the portfolio"
  type        = string
  default     = "gotetibhaskar.com"
}

variable "www_domain_name" {
  description = "WWW subdomain"
  type        = string
  default     = "www.gotetibhaskar.com"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "production"
}

variable "project" {
  description = "Project name for tagging"
  type        = string
  default     = "portfolio"
}

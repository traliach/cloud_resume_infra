variable "aws_region" {
  description = "Primary AWS region for all resources except ACM"
  type        = string
  default     = "us-east-1"
}

variable "domain_name" {
  description = "Root domain name (e.g. achille.tech)"
  type        = string
  default     = "achille.tech"
}

variable "resume_subdomain" {
  description = "Full subdomain for the resume site"
  type        = string
  default     = "resume.achille.tech"
}

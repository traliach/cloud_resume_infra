variable "aws_region" {
  description = "Primary AWS region for all resources except ACM"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix for shared infrastructure resources"
  type        = string
  default     = "cloud-resume"
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

variable "alert_email" {
  description = "Email address that receives Lambda alarm notifications"
  type        = string
  sensitive   = true
  nullable    = false

  validation {
    condition     = can(regex("^[^\\s@]+@[^\\s@]+\\.[^\\s@]+$", var.alert_email))
    error_message = "alert_email must be a valid email address."
  }
}

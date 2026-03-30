resource "aws_acm_certificate" "resume" {
  provider          = aws.us_east_1
  domain_name       = var.resume_subdomain
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# NOTE: DNS is managed by Vercel — validation records must be added manually.
# After running `terraform apply`, run `terraform output acm_validation_records`
# and add the CNAME record shown in Vercel's DNS dashboard.
# Terraform will wait here until ACM sees the record and issues the certificate.
resource "aws_acm_certificate_validation" "resume" {
  provider        = aws.us_east_1
  certificate_arn = aws_acm_certificate.resume.arn
}

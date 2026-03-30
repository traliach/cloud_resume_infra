output "cloudfront_url" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.resume.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID — used for cache invalidation in CI/CD"
  value       = aws_cloudfront_distribution.resume.id
}

output "s3_bucket_name" {
  description = "S3 bucket name — used for deploy upload in CI/CD"
  value       = aws_s3_bucket.resume.bucket
}

output "api_endpoint" {
  description = "Visitor counter API endpoint"
  value       = "${aws_apigatewayv2_stage.visitor_counter.invoke_url}/count"
}

output "acm_validation_records" {
  description = "Add these CNAME records in Vercel DNS to validate the ACM certificate"
  value = {
    for dvo in aws_acm_certificate.resume.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
}

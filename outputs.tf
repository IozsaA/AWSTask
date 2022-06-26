output "s3_bucket_arn" {
    value = aws_s3_bucket.buck.arn
}

output "s3_bucket_id" {
    value = aws_s3_bucket.buck.id
}

output "s3_bucket_domain_name" {
    value = aws_s3_bucket.buck.bucket_domain_name
}

output "s3_bucket_region" {
    value = aws_s3_bucket.buck.region
}

output "s3_hosted_zone_id" {
    value = aws_s3_bucket.buck.hosted_zone_id
}

output "s3_bucket_website_endpoint" {
    value = aws_s3_bucket.buck.website_endpoint
}

output "s3_bucket_website_domain" {
    value = aws_s3_bucket.buck.website_domain
}
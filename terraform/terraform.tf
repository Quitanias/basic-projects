# Simple S3 bucket to test AWS provider against LocalStack
resource "aws_s3_bucket" "test_bucket" {
  bucket = "tf-localstack-test-bucket"
}

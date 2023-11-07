resource "aws_s3_bucket" "statefiles" {
  bucket = "assign-tf-statefiles"
  tags = {
    "Name" = "assign-tf-statefiles"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "statefiles" {
  bucket = aws_s3_bucket.statefiles.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_versioning" "statefiles" {
  bucket = aws_s3_bucket.statefiles.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "statefiles" {
  bucket                  = aws_s3_bucket.statefiles.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_ownership_controls" "statefiles" {
  bucket = aws_s3_bucket.statefiles.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
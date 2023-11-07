resource "aws_s3_bucket" "kinesis_config_s3" {
  bucket = "assign-kinesis-config"
  tags = {
    "Name" = "assign-kinesis-config"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "kinesis_config_s3" {
  bucket = aws_s3_bucket.kinesis_config_s3.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_object" "kinesis_config_object" {
  key                    = "appsettings.json"
  bucket                 = aws_s3_bucket.kinesis_config_s3.id
  source                 = "${path.module}/files/kinsesis_agent_config.json"
}


resource "aws_s3_bucket_public_access_block" "kinesis_config_s3" {
  bucket                  = aws_s3_bucket.kinesis_config_s3.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_ownership_controls" "kinesis_config_s3" {
  bucket = aws_s3_bucket.kinesis_config_s3.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
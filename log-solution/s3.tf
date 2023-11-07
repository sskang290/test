resource "aws_s3_bucket" "logbucket" {
  bucket = "assign-logbucket"
  tags = {
    "Name" = "assign-logbucket"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "logbucket" {
  bucket = aws_s3_bucket.logbucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.s3_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
#resource "aws_s3_bucket_versioning" "logbucket" {
#  bucket = aws_s3_bucket.logbucket.id
#  versioning_configuration {
#    status = "Enabled"
#  }
#}

resource "aws_s3_bucket_public_access_block" "logbucket" {
  bucket                  = aws_s3_bucket.logbucket.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

resource "aws_s3_bucket_ownership_controls" "logbucket" {
  bucket = aws_s3_bucket.logbucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}


resource "aws_kms_key" "s3_kms_key" {
  enable_key_rotation     = true
  description             = "log bucket kms key"
  deletion_window_in_days = 30

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Id": "key-default-1",
    "Statement": [
        {
            "Sid": "Enable IAM User Permissions",
            "Effect": "Allow",
            "Principal": {
                "AWS": "arn:aws:iam::${data.aws_caller_identity.current.id}:root"
            },
            "Action": "kms:*",
            "Resource": "*"
        },
        {
            "Sid": "Allow use of the key",
            "Effect": "Allow",
            "Principal": {
                "AWS": [
                    "arn:aws:iam::${data.aws_caller_identity.current.id}:user/testassign",
                    "arn:aws:iam::${data.aws_caller_identity.current.id}:role/aws-sandbox-2021-with-power-access",
                    "arn:aws:iam::${data.aws_caller_identity.current.id}:role/eventlog-firehose-role",
                    "arn:aws:iam::${data.aws_caller_identity.current.id}:role/aws-reserved/sso.amazonaws.com/eu-west-1/AWSReservedSSO_with-power-access_2b29fa234cbf871e",
                    "arn:aws:iam::${data.aws_caller_identity.current.id}:role/ec2-app1-role"
                ]
            },
            "Action": [
                "kms:Encrypt",
                "kms:Decrypt",
                "kms:ReEncrypt*",
                "kms:GenerateDataKey*",
                "kms:DescribeKey"
            ],
            "Resource": "*"
        }
    ]
}
EOF
  tags = {
    "Name" = "logbucket-kms-key"
  }

}




resource "aws_s3_bucket_policy" "logbucket_policy" {
  bucket = aws_s3_bucket.logbucket.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "logBucketPolicy",
    "Statement" : [
      {
        "Sid" : "AllowCI",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : ["arn:aws:iam::${data.aws_caller_identity.current.id}:user/testassign", "arn:aws:iam::${data.aws_caller_identity.current.id}:role/aws-reserved/sso.amazonaws.com/eu-west-1/AWSReservedSSO_with-power-access_2b29fa234cbf871e", "arn:aws:iam::${data.aws_caller_identity.current.id}:role/aws-sandbox-2021-with-power-access", "arn:aws:iam::${data.aws_caller_identity.current.id}:role/eventlog-firehose-role"]
        },
        "Action" : [
          "s3:AbortMultipartUpload",
          "s3:GetBucketLocation",
          "s3:GetObject",
          "s3:ListBucket",
          "s3:ListBucketMultipartUploads",
          "s3:PutObject"
        ],
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.logbucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.logbucket.id}/*"
        ]
      },
    {
        "Sid" : "AllowSSLRequestsOnly",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::${aws_s3_bucket.logbucket.id}",
          "arn:aws:s3:::${aws_s3_bucket.logbucket.id}/*"
        ],
        "Condition" : {
          "Bool" : {
            "aws:SecureTransport" : "false"
          }
        }
      }
    ]
  })
}

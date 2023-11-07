resource "aws_kinesis_firehose_delivery_stream" "win_eventlog_stream" {
  destination    = "extended_s3"
  destination_id = "destinationId-000000000001"
  name           = local.env.firehose.name
  extended_s3_configuration {
    bucket_arn          = aws_s3_bucket.logbucket.arn
    buffering_interval  = local.env.firehose.buffering_interval
    buffering_size      = local.env.firehose.buffering_size
    compression_format  = "UNCOMPRESSED"
    error_output_prefix = null
    kms_key_arn         = null
    prefix              = null
    role_arn            = aws_iam_role.eventlog_firehose_role.arn
    s3_backup_mode      = "Disabled"
    cloudwatch_logging_options {
      enabled         = true
      log_group_name  = "/aws/kinesisfirehose/${local.env.firehose.name}"
      log_stream_name = "DestinationDelivery"
    }
    processing_configuration {
      enabled = false
    }
  }
  server_side_encryption {
    enabled  = true
    key_arn  = aws_kms_key.s3_kms_key.arn
    key_type = "CUSTOMER_MANAGED_CMK"
  }

  tags = {
    "Name" = "eventlog_win_firehose_datastream",
  }
}

data "aws_iam_policy_document" "firehose_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["firehose.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "eventlog_firehose_role" {
  name               = "eventlog-firehose-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.firehose_assume_role.json
}


resource "aws_iam_role_policy" "firehose_access_to_s3" {
  name = "log-firehose-access-to-S3"
  role = aws_iam_role.eventlog_firehose_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
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
        "Sid" : "",
        "Effect" : "Allow",
        "Action" : [
          "logs:PutLogEvents"
        ],
        "Resource" : [
          "arn:aws:logs:ap-southeast-1:${data.aws_caller_identity.current.id}:log-group:/aws/kinesisfirehose/${local.env.firehose.name}:log-stream:*"
        ]
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "kms:Decrypt",
          "kms:GenerateDataKey"
        ],
        "Resource" : [
          "arn:aws:kms:ap-southeast-1:${data.aws_caller_identity.current.id}:key/${aws_kms_key.s3_kms_key.arn}"
        ],
        "Condition" : {
          "StringEquals" : {
            "kms:ViaService" : "s3.ap-southeast-1.amazonaws.com"
          },
          "StringLike" : {
            "kms:EncryptionContext:aws:s3:arn" : "arn:aws:s3:::${aws_s3_bucket.logbucket.id}/*"
          }
        }
      },

    ]
    }
  )
}
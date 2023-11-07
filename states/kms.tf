resource "aws_kms_key" "s3_kms_key" {
  enable_key_rotation     = true
  description             = "State file kms key"
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
                "AWS": [
                  "arn:aws:iam::${data.aws_caller_identity.current.id}:root"
                ]
            },
            "Action": "kms:*",
            "Resource": "*"
        }
    ]
}
EOF
  tags = {
    "Name" = "statefiles-s3-kms-key"
  }

}


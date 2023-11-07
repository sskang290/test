resource "aws_s3_bucket_policy" "state_access_policy" {
  bucket = aws_s3_bucket.statefiles.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "StateBucketPolicy",
    "Statement" : [
      {
        "Sid" : "AllowCI",
        "Effect" : "Allow",
        "Principal" : {
          "AWS" : "arn:aws:iam::${data.aws_caller_identity.current.id}:user/testassign" #locked to user/role that is used to create TF deployments. 
        },
        "Action" : [
          "s3:Get*",
          "s3:List*",
          "s3:Put*"
        ],
        "Resource" : [
          "arn:aws:s3:::assign-tf-statefiles",
          "arn:aws:s3:::assign-tf-statefiles/*"
        ]
      },
      {
        "Sid" : "Denyeveryonelese",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::assign-tf-statefiles",
          "arn:aws:s3:::assign-tf-statefiles/*"
        ],
        "Condition" : {
          "StringNotEquals" : {
            "aws:PrincipalArn" : [
              "arn:aws:iam::${data.aws_caller_identity.current.id}:user/testassign"
            ]
          }
        }
      },
      {
        "Sid" : "AllowSSLRequestsOnly",
        "Effect" : "Deny",
        "Principal" : "*",
        "Action" : "s3:*",
        "Resource" : [
          "arn:aws:s3:::assign-tf-statefiles",
          "arn:aws:s3:::assign-tf-statefiles/*"
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

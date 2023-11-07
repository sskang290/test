module "ec2_app1_asg" {
  source            = "./modules/asg"
  security_groups   = [aws_security_group.ec2_app1_sg.id]
  asg_subnets       = data.aws_subnets.ec2_subnets.ids
  min_count         = local.env.ec2.app1_server.min_count
  max_count         = local.env.ec2.app1_server.max_count
  desired_count     = local.env.ec2.app1_server.desired_count
  instance_type     = local.env.ec2.app1_server.size
  instance_profile  = aws_iam_instance_profile.ec2_app1_profile.name
  ssh_key_name      = data.aws_key_pair.cloud_infra.key_name
  ami               = "ami-02e9cad243378eee2" #for now I have hard coded it but this can be retrieved dynamically using data sources
  public_ip         = true
  userdata_filepath = "${path.module}/files/initscript"
}

resource "aws_security_group" "ec2_app1_sg" {
  name        = "ec2-app1-sg"
  description = "security group for app1 ec2"
  vpc_id      = data.aws_vpc.cloud_infra_vpc.id

  ingress {
    description = "allow RDP"
    from_port   = 3389
    protocol    = "tcp"
    to_port     = 3389
    cidr_blocks = ["18.141.107.44/32"]
    #security_groups = [aws_security_group.app1_lb_sg.id]
  }

  egress {
    description = "allow traffic from ec2 to outbound"
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
    #security_groups = [aws_security_group.ec2_app1_sg]
  }

  timeouts {
    delete = "5m"
  }

  tags = {
    "Name" = "ec2-app1-sg",
  }
}

resource "aws_iam_instance_profile" "ec2_app1_profile" {
  name = "ec2-app1-profile"
  role = aws_iam_role.ec2_app1_role.name
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "ec2_app1_role" {
  name               = "ec2-app1-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}


resource "aws_iam_role_policy" "firehose_access_for_ec2" {
  name = "firehose-access-for-ec2-profile"
  role = aws_iam_role.ec2_app1_role.id

  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Action" : [
          "kinesis:PutRecord",
          "kinesis:PutRecords",
          "firehose:PutRecord",
          "firehose:PutRecordBatch"
        ],
        "Effect" : "Allow",
        "Resource" : "arn:aws:firehose:ap-southeast-1:${data.aws_caller_identity.current.id}:deliverystream/${local.env.firehose.name}"
      },
      {
        "Sid" : "EC2MetadataAccess",
        "Effect" : "Allow",
        "Action" : [
          "ec2:DescribeInstances",
          "ec2:DescribeInstanceAttribute",
          "ec2:DescribeInstanceTypes",
          "ec2:DescribeInstanceStatus",
          "ec2:DescribeTags"
        ],
        "Resource" : "*"
      },
      {
        "Sid" : "S3Access",
        "Effect" : "Allow",
        "Action" : [
          "s3:*",
        ],
        "Resource" : [
           "arn:aws:s3:::${aws_s3_bucket.kinesis_config_s3.id}",
          "arn:aws:s3:::${aws_s3_bucket.kinesis_config_s3.id}/*"
        ]
      }
    ]
  })
}


#### below is another way we can create EC2s 
/*
module "ec2_app1" {
  source = "./modules/ec2"

  count     = local.env.ec2.app1_server.count
  subnet_id = "subnet-0b25ab40e3187a21b"

  instance_size = local.env.ec2.app1_server.size
  instance_ami  = "ami-036d8cf6cf7a08f64" #for now I have hard coded it but this can be retrieved dynamically using data sources
}

module "ec2_app2" {
  source = "./modules/ec2"

  count     = local.env.ec2.app2_server.count
  subnet_id = "subnet-0b25ab40e3187a21b"

  instance_size = local.env.ec2.app2_server.size
  instance_ami  = "ami-036d8cf6cf7a08f64" #for now I have hard coded it but this can be retrieved dynamically using data sources
}
*/
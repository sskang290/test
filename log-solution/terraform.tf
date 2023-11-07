terraform {

  required_version = "~> 1.6.2"

  backend "s3" {
    region         = "ap-southeast-1"
    bucket         = "assign-tf-statefiles"
    key            = "cloud-infra.tfstate"
    encrypt        = "true"
    dynamodb_table = "cloud-infra"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "= 5.23.1"
    }
  }

}

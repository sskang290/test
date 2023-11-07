terraform {

  required_version = "= 1.6.2"

  ## backend can only be enabled after the creating s3 resource. Once s3 is created enable the backend and run "terraform init -reconfigure"
  backend "s3" {
    region         = "ap-southeast-1"
    bucket         = "assign-tf-statefiles"
    key            = "assignment-states.tfstate"
    encrypt        = "true"
    dynamodb_table = "assign-tf-states"
  }

  required_providers {

    aws = {
      source  = "hashicorp/aws"
      version = "= 5.23.1"
    }
  }

}

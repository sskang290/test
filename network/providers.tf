#### Provider Configuration

provider "aws" {
  region = "ap-southeast-1"
  #  shared_credentials_files = ["~/.aws/credentials"]
  profile                 = local.common.terraform_profile
  skip_metadata_api_check = true

  default_tags {
    tags = {
      "Contact"        = local.common.contact,
      "CostCenter"     = local.env.costcenter,
      "DeploymentName" = local.env.deploymentname,
      "DeploymentRepo" = local.common.deploymentrepo
    }
  }
}

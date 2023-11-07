#### Get var based off workspace(environment)
locals {
  common = merge(
    yamldecode(file("env/common.yaml")),
    { "environment" = terraform.workspace }
  )
  env = yamldecode(file("env/${terraform.workspace}.yaml"))
}


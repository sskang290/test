variable "infra_env" {
  type        = string
  description = "infrastructure environment"
  default     = "CI"
}


variable "instance_size" {
  type        = string
  description = "ec2 size"
  default     = "t2.micro"
}

variable "instance_ami" {
  type        = string
  description = "AMI to use"
}

variable "instance_root_device_size" {
  type        = number
  description = "Root disk size in GB"
  default     = 40
}

variable "create_eip" {
  type        = bool
  description = "EIP creation for EC2"
  default     = false
}

variable "subnet_id" {
  type        = string
  description = "subnet id in which ec2 is to be created"
}
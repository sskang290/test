variable "ami" {
  type        = string
  description = "AMI id for ec2"
}


variable "instance_type" {
  type        = string
  description = "EC2 instance size"
}

variable "security_groups" {
  type        = list(string)
  description = "Security groups for EC2"
}

variable "ssh_key_name" {
  type        = string
  description = "Name of the EC2 key pair"
}


variable "asg_subnets" {
  type        = list(string)
  description = "list of private subnet ID's for ASG to place instances"
}

variable "min_count" {
  type        = number
  description = "minimum count of ec2"
}

variable "max_count" {
  type        = number
  description = "maximum count of ec2"
}

variable "desired_count" {
  type        = number
  description = "required count of ec2"
}

variable "instance_profile" {
  type        = string
  description = "instance profile to be assigned to ec2"
}

#variable "alb_target_group_arn" {
#  type        = string
#  description = "arn of target group of alb that should be assigned to the ASG"
#}

variable "public_ip" {
  type = bool
  default = false
  description = "se true to assign public ip address"
  
}

variable "userdata_filepath" {
  type        = string
  description = "path to userdata file"
}
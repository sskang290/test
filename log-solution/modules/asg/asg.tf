resource "aws_autoscaling_group" "cloud_infra_asg" {
  launch_template {
    name    = aws_launch_template.cloud_infra_lt.name
    version = aws_launch_template.cloud_infra_lt.latest_version
  }

  name                = "asg-cloud-infra-${terraform.workspace}-${aws_launch_template.cloud_infra_lt.latest_version}"
  vpc_zone_identifier = var.asg_subnets

  min_size             = var.min_count
  max_size             = var.max_count
  desired_capacity     = var.desired_count
  termination_policies = ["OldestInstance"]

  health_check_type         = "ELB"
  health_check_grace_period = 90

  lifecycle {
    create_before_destroy = true
  }
}

#resource "aws_autoscaling_attachment" "asg_attachment" {
#
#  autoscaling_group_name = aws_autoscaling_group.cloud_infra_asg.name
#  lb_target_group_arn    = var.alb_target_group_arn
#}
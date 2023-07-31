data "aws_subnets" "autoscale_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default.id]
  }
  filter {
    name   = "availability-zone"
    values = ["ap-northeast-2a", "ap-northeast-2c"]
  }

}


# 오토스케일링 그룹
resource "aws_autoscaling_group" "ec2_autoscaling_group" {
  name                      = "ec2_autoscaling_group"
  launch_configuration      = aws_launch_configuration.ec2_autoscaling_group.name
  min_size                  = 2
  max_size                  = 4
  desired_capacity          = 2
  vpc_zone_identifier = data.aws_subnets.autoscale_subnets.ids  

  tag {
    key                 = "Env"
    value               = "Prod"
    propagate_at_launch = true
  }
  tag {
    key                 = "TEST"
    value               = "ec2_autoscaling_group"
    propagate_at_launch = true
  }

  # 추가 설정 (옵션)
  # target_group_arns         = ["your-target-group-arns"]
  # health_check_type         = "ELB"
  # health_check_grace_period = 300
  # ...
}

# 탄력성 정책 설정
resource "aws_autoscaling_policy" "ec2_autoscaling_policy" {
  name                   = "ec2_autoscaling_policy"
  policy_type            = "SimpleScaling"
  autoscaling_group_name = aws_autoscaling_group.ec2_autoscaling_group.name
  
  # 조정 정책 설정
  adjustment_type        = "ChangeInCapacity"
  scaling_adjustment     = 1
}

# 알람 설정
resource "aws_cloudwatch_metric_alarm" "ec2_cpu_alarm" {
  alarm_name          = "ec2_cpu_alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = 120
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This metric monitors CPU utilization"
  alarm_actions       = [aws_autoscaling_policy.ec2_autoscaling_policy.arn]
}

# Launch Configuration
resource "aws_launch_configuration" "ec2_autoscaling_group" {
  name                 = "ec2_autoscaling_group_lc"
  image_id             = "ami-0c9c942bd7bf113a2"
  instance_type        = "t2.nano"
  iam_instance_profile = aws_iam_instance_profile.SSMInstanceProfile.name
  security_groups      = [aws_security_group.OpenSG_443.id]
}


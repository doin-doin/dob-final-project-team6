# 로드 밸런서 생성
resource "aws_lb" "auto_lb" {
  name               = "auto-lb"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.autoscale_subnets.ids  
  tags = {
    "Name" = "auto_loadbalancer",
    "TEST" = "auto_loadbalancer",
    "Env"  = "Prod",
    "Type" = "alb",
    "Owner"= "DevOps",
    "Privacy" = "Y"
  }
}

# 로드 밸런서 타겟 그룹 생성
resource "aws_lb_target_group" "auto_lb_target_group" {
  name        = "auto-lb-target-group"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_default_vpc.default.id
  target_type = "instance"
}

# 로드 밸런서와 오토스케일링 그룹 연결
resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.ec2_autoscaling_group.name
  lb_target_group_arn   = aws_lb_target_group.auto_lb_target_group.arn
}

  # 로드 밸런서 리스너
resource "aws_alb_listener" "auto_lb-listner" {
  load_balancer_arn = aws_lb.auto_lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.auto_lb_target_group.arn
  }
}
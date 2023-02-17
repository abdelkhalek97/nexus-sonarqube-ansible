# Target Group
####################################################
resource "aws_lb_target_group" "NLB_tg" {
  name     = var.target_name
  port     = var.target_port
  protocol = var.target_protocol
  vpc_id   = var.vpcid

  health_check {
    enabled  = true
    protocol = var.health_protocol
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_alb_target_group_attachment" "tgattachment1" {
  target_group_arn = aws_lb_target_group.NLB_tg.arn
  target_id        = var.ec2ids[0]
  port             = var.attach_target_port_1

  depends_on = [
    aws_lb_target_group.NLB_tg
  ]

}
resource "aws_alb_target_group_attachment" "tgattachment2" {
  target_group_arn = aws_lb_target_group.NLB_tg.arn
  target_id        = var.ec2ids[1]
  port             = var.attach_target_port_2

  depends_on = [
    aws_lb_target_group.NLB_tg
  ]

}
# Load Balancer
####################################################
resource "aws_lb" "app_lb" {
  name               = var.name
  internal           = var.lb_internal
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = var.subnets
}

# Listener
####################################################

resource "aws_lb_listener" "this" {
  load_balancer_arn = aws_lb.app_lb.arn

  protocol = var.listener_protocol
  port     = var.listener_port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.NLB_tg.arn
  }
}
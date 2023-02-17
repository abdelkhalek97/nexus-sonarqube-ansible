output "Load_Balancer_DNS" {

  value = aws_lb.app_lb.dns_name

}

output "Targetgroup_arn" {
  value       = aws_lb_target_group.NLB_tg.arn
  description = "target group arn"
}

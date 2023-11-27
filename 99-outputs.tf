#Log the load balancer app URL
output "app_url" {
  value = aws_lb.ecs_alb.dns_name
}

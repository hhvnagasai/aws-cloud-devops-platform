output "alb_id" {
  description = "ID of the Application Load Balancer"
  value       = aws_lb.this.id
}

output "alb_arn" {
  description = "ARN of the Application Load Balancer"
  value       = aws_lb.this.arn
}

output "alb_dns_name" {
  description = "DNS name of the Application Load Balancer"
  value       = aws_lb.this.dns_name
}
output "target_group_arns" {
  description = "ARNs of the ALB target groups."

  value = {
    for name, target_group in aws_lb_target_group.this :
    name => target_group.arn
  }
}

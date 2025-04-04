output "alb_dns_name" {
  description = "The DNS name of the load balancer"
  value       = aws_lb.this[0].dns_name
}

output "alb_arn" {
  description = "The ARN of the load balancer"
  value       = aws_lb.this[0].arn
}

output "listener_arns" {
  description = "List of listener ARNs"
  value       = [for l in aws_lb_listener.this : l.arn]
}

output "target_group_arns" {
  description = "List of all target group ARNs"
  value       = try(local.target_group_arns, [])
}

output "dns_name" {
  value = aws_lb.this[0].dns_name
}

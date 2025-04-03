output "instance_id" {
  description = "The ID of the EC2 instance."
  value       = aws_instance.this[0].id
}

output "public_ip" {
  description = "The public IP of the EC2 instance."
  value       = aws_instance.this[0].public_ip
}

output "private_ip" {
  description = "The private IP of the EC2 instance."
  value       = aws_instance.this[0].private_ip
}

output "arn" {
  description = "The ARN of the EC2 instance."
  value       = aws_instance.this[0].arn
}

output "private_dns" {
  description = "The private DNS name of the EC2 instance."
  value       = aws_instance.this[0].private_dns
}

output "iam_instance_profile" {
  description = "The name of the IAM instance profile attached to the EC2 instance."
  value       = aws_instance.this[0].iam_instance_profile
}

output "ami_id" {
  description = "The AMI ID used for the EC2 instance."
  value       = aws_instance.this[0].ami
}

output "instance_type" {
  description = "The instance type of the EC2 instance."
  value       = aws_instance.this[0].instance_type
}

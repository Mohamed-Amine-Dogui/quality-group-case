output "aws_lambda_function_name" {
  description = "Lambda function name from my_lambda module"
  value       = module.my_lambda.aws_lambda_function_name
}

output "aws_lambda_function_arn" {
  description = "Lambda function ARN from my_lambda module"
  value       = module.my_lambda.aws_lambda_function_arn
}

output "source_terraform_state_bucket" {
  description = "source_terraform_state_bucket"
  value       = module.source_terraform_state_bucket.s3_bucket
}

output "target_terraform_state_bucket" {
  description = "target_terraform_state_bucket"
  value       = module.target_terraform_state_bucket.s3_bucket
}
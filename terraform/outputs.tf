output "aws_lambda_function_name" {
  description = "Lambda function name from my_lambda module"
  value       = module.my_lambda.aws_lambda_function_name
}

output "aws_lambda_function_arn" {
  description = "Lambda function ARN from my_lambda module"
  value       = module.my_lambda.aws_lambda_function_arn
}

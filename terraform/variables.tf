########################################################################################################################
###  Project generic vars
########################################################################################################################
variable "stage" {
  description = "Specify to which stage this resource belong"
  default     = "dev"
}

variable "aws_region" {
  description = "Default Region"
  default     = "eu-central-1"
}

variable "project" {
  description = "Specify to which project this resource belongs"
  default     = "esn"
}

variable "project_id" {
  description = "project ID for billing"
  default     = "esn"
}

variable "git_repository" {
  description = "The current GIT repository used to keep track of the origin of resources in AWS"
  default     = "https://github.com/Mohamed-Amine-Dogui/quality-group-case"
}

variable "default_lambda_handler" {
  description = "The name of the function handler inside main.py file"
  default     = "lambda_handler"
}

variable "my-lambda_unique_function_name" {
  description = "The name of the function "
  default     = "my_lambda"
}

variable "vpc_id" {
  description = "ID of default vpc"
  default     = "vpc-0e8471e886fad17c5"
}

variable "subnet_1a_id" {
  description = "The id of the subnet  "
  default     = "subnet-04580d1a8986b23d4"
}

variable "subnet_1b_id" {
  description = "The id of the subnet  "
  default     = "subnet-032f05d2bf79cae47"
}

variable "subnet_1c_id" {
  description = "The id of the subnet  "
  default     = "subnet-02bfc67ae6cbaf5c2"
}






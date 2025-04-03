variable "enable" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "name" {
  description = "Name tag for the EC2 instance"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC to launch the instance in."
  type        = string
}

variable "subnet_id" {
  description = "The subnet ID to launch the instance in."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "security_group_ids" {
  description = "List of security group IDs to associate with the instance"
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "user_data" {
  description = "User data script to run at instance launch"
  type        = string
  default     = ""
}

variable "project" {
  description = "Project identifier"
  type        = string
}

variable "stage" {
  description = "Deployment stage (e.g., dev, prd)"
  type        = string
}

variable "git_repository" {
  description = "Git repo for tagging purposes"
  type        = string
}

variable "resource_group" {
  description = "Resource group name, e.g. 'ec2'"
  type        = string
  default     = "ec2"
}

variable "additional_tags" {
  description = "Additional tags to merge"
  type        = map(string)
  default     = {}
}

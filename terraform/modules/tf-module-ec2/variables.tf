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
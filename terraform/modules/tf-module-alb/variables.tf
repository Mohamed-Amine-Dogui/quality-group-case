
variable "enable" {
  type        = bool
  default     = true
  description = "Set to false to prevent the module from creating any resources"
}

variable "name" {
  description = "Name to assign to the ALB"
  type        = string
}

variable "vpc_id" {
  description = "VPC where the ALB will be created"
  type        = string
}

variable "subnet_ids" {
  description = "Subnets (typically public) for the ALB"
  type        = list(string)
}

variable "security_group_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
  default     = []
}

variable "listeners" {
  description = "List of listeners with port, protocol, and target group key"
  type = list(object({
    port               = number
    protocol           = string
    target_group_index = number
  }))
}

variable "target_groups" {
  description = "List of target group configurations"
  type = list(object({
    name_prefix        = string
    port               = number
    protocol           = string
    target_type        = string
    health_check_path  = string
    vpc_id             = string
  }))
}

variable "tags" {
  description = "Tags to assign to resources"
  type        = map(string)
  default     = {}
}


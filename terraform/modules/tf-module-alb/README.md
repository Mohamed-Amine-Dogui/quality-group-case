## ALB Module for AWS

### Current Usage

> [IMPORTANT] This module supports multi-environment deployment (`dev`, `int`, `prd`) and integrates tagging best practices for governance and cost management.
This version leverages the `stage` variable to manage resources across multiple environments and supports optional activation via the `enable` toggle.

The ALB can be configured with multiple listeners and target groups. It supports routing traffic to EC2, Lambda, or IP-based targets, and allows dynamic listener/target group mapping.

---

### Features

- Create **Application Load Balancer** (ALB) in a specified VPC
- Support for multiple **listeners** (HTTP/HTTPS/Custom Ports)
- Attach multiple **target groups** with custom settings
- Support **health checks** per target group
- Optional tagging with project/stage metadata
- Conditional resource creation using `enable`
- Flexible backend type: EC2, Lambda, or IP

---

### Example Usage

```hcl
module "alb" {
  source  = "./modules/tf-module-alb"
  enable  = true
  name    = "app-alb"
  vpc_id  = var.vpc_id
  subnets = var.public_subnets
  security_group_ids = [aws_security_group.alb_sg.id]

  listeners = [
    {
      port            = 80
      protocol        = "HTTP"
      default_action  = {
        type             = "forward"
        target_group_key = "web_tg"
      }
    },
    {
      port            = 443
      protocol        = "HTTPS"
      certificate_arn = var.acm_certificate_arn
      default_action  = {
        type             = "forward"
        target_group_key = "web_tg"
      }
    }
  ]

  target_groups = [
    {
      key                = "web_tg"
      target_type        = "instance"
      port               = 80
      protocol           = "HTTP"
      health_check_path  = "/"
      target_ids         = [module.ec2.instance_id]
    }
  ]

  tags = {
    Project     = var.project
    Stage       = var.stage
    Environment = var.stage
  }
}
```

---

### Inputs

| Name              | Description                                                       | Type             | Default  | Required |
|-------------------|-------------------------------------------------------------------|------------------|----------|:--------:|
| enable            | Toggle to enable/disable resource creation                        | `bool`           | `true`   | no       |
| name              | Name of the ALB                                                  | `string`         | n/a      | yes      |
| vpc_id            | VPC ID in which to create the ALB                                | `string`         | n/a      | yes      |
| subnet_ids        | List of subnet IDs for ALB                                       | `list(string)`   | n/a      | yes      |
| security_groups   | List of security group IDs for ALB                               | `list(string)`   | `[]`     | no       |
| listeners         | List of listeners with `port` and `protocol`                     | `list(object)`   | n/a      | yes      |
| target_groups     | List of target groups and their settings                         | `list(object)`   | `[]`     | no       |
| tags              | Tags to attach to ALB and resources                              | `map(string)`    | `{}`     | no       |

---

### Outputs

| Name          | Description                          |
|---------------|--------------------------------------|
| alb_arn       | ARN of the ALB                       |
| alb_dns_name  | DNS name to access the ALB           |
| alb_name      | Name of the ALB                      |
| listener_arns | List of listener ARNs                |
| tg_arns       | Map of target group names to ARNs    |

---

### Notes
- The ALB must be placed in public subnets to be accessible from the internet.
- Health check paths are customizable per target group.
- Listener rules and advanced routing are extendable if needed.
- Supports integration with EC2, Lambda, or IP-based targets via `target_type`.

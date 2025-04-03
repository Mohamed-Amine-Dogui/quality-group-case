Here's the updated `README.md` for your **ALB module**, now including the `name` variable to customize the ALB name:

---

## ALB Module for AWS

### Current Usage

> [IMPORTANT] This module supports multi-environment deployment (`dev`, `int`, `prd`) and integrates tagging best practices for governance and cost control.

This module provisions an **Application Load Balancer** with support for **multiple listeners** and **multiple target groups**, customizable **health checks**, and compatibility with **EC2**, **Lambda**, and other target types.

The module uses `stage`, `project`, and `tags` to organize deployments and can be toggled on/off with the `enable` flag. It also allows assigning a custom name to the ALB using the `name` variable.

---

### Features

- Creates an Application Load Balancer (ALB)
- Supports **multiple listeners** on different ports (e.g. 80, 443)
- Supports **multiple target groups** (EC2, Lambda, or IP)
- Customizable **health check paths**
- Assign a custom ALB name
- Fully tagged resources using `tags` map
- Outputs ALB DNS, ARNs, and related identifiers
- Controlled deployment with the `enable` toggle

---

### Example Usage

```hcl
module "alb" {
  source  = "./modules/tf-module-alb"
  enable  = true
  name    = "web-alb"
  vpc_id  = var.vpc_id
  subnet_ids = [var.subnet_1a_id, var.subnet_1b_id, var.subnet_1c_id]
  security_group_ids = [aws_security_group.alb_sg.id]

  listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    },
    {
      port               = 443
      protocol           = "HTTPS"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      name_prefix       = "web"
      port              = 80
      protocol          = "HTTP"
      target_type       = "instance"
      health_check_path = "/"
      vpc_id            = var.vpc_id
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

| Name                | Description                                                    | Type            | Default     | Required |
|---------------------|----------------------------------------------------------------|------------------|-------------|:--------:|
| enable              | Toggle to enable/disable ALB creation                          | `bool`           | `true`      | no       |
| name                | Name to assign to the ALB                                      | `string`         | n/a         | yes      |
| vpc_id              | VPC ID to deploy the ALB into                                  | `string`         | n/a         | yes      |
| subnet_ids          | List of subnets (must be public) for ALB                       | `list(string)`   | n/a         | yes      |
| security_group_ids  | Security Groups to associate with the ALB                      | `list(string)`   | `[]`        | no       |
| listeners           | List of listener objects with `port`, `protocol`, `target_group_index` | `list(object)` | n/a | yes      |
| target_groups       | List of target group objects                                   | `list(object)`   | n/a         | yes      |
| tags                | Tags to apply to all resources                                 | `map(string)`    | `{}`        | no       |

---

### Outputs

| Name               | Description                                |
|--------------------|--------------------------------------------|
| alb_arn            | ARN of the created ALB                     |
| alb_dns_name       | DNS name of the ALB                        |
| target_group_arns  | List of target group ARNs                  |
| listener_arns      | List of ALB listener ARNs                  |

---

### Notes

- For **HTTPS**, a valid `certificate_arn` is required. Currently, the module assumes certificate configuration is handled outside.
- This module supports EC2 (`instance`), Lambda (`lambda`), and IP-based (`ip`) targets.
- Health check path defaults to `/` but can be overridden per target group.
- You can extend this module with listener rules for advanced routing logic.

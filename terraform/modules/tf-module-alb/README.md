## ALB Module for AWS

### Current Usage

> [IMPORTANT] This module supports multi-environment deployments (`dev`, `int`, `prd`) and integrates centralized labeling using the `tf-module-label` to ensure consistent resource naming and tagging across environments.

This module provisions an **Application Load Balancer (ALB)** with support for **multiple listeners** and **target groups**, customizable **health checks**, and support for **EC2**, **Lambda**, or **IP** targets. It uses the `tf-module-label` internally to generate consistent names and tags.

---

### Features

- Creates an Application Load Balancer (ALB)
- Supports **multiple listeners** (HTTP, HTTPS, etc.)
- Supports **multiple target groups** (instance, lambda, ip)
- Configurable **health check paths**
- Automatic resource name and tag generation via `tf-module-label`
- Conditional creation using the `enable` flag
- Outputs ALB DNS, ARNs, and related identifiers

---

### Example Usage

```hcl
module "alb" {
  source  = "./modules/tf-module-alb"
  enable  = true
  name    = "web"
  vpc_id  = var.vpc_id
  subnet_ids         = [var.subnet_1a_id, var.subnet_1b_id]
  security_group_ids = [aws_security_group.alb_sg.id]

  listeners = [
    {
      port               = 80
      protocol           = "HTTP"
      target_group_index = 0
    }
  ]

  target_groups = [
    {
      port              = 80
      protocol          = "HTTP"
      target_type       = "instance"
      health_check_path = "/"
      vpc_id            = var.vpc_id
    }
  ]

  project         = var.project
  stage           = var.stage
  resource_group  = "alb"
  git_repository  = var.git_repository
  additional_tags = {
    Owner = "douggui.med.amine@gmail.com"
  }
}
```

---

### Inputs

| Name                | Description                                                           | Type             | Default     | Required |
|---------------------|------------------------------------------------------------------------|------------------|-------------|:--------:|
| enable              | Toggle to enable/disable ALB creation                                 | `bool`           | `true`      | no       |
| name                | Base name to use for naming resources via `tf-module-label`           | `string`         | n/a         | yes      |
| vpc_id              | VPC ID where the ALB will be created                                  | `string`         | n/a         | yes      |
| subnet_ids          | List of subnets to associate with the ALB                             | `list(string)`   | n/a         | yes      |
| security_group_ids  | List of security group IDs for the ALB                                | `list(string)`   | `[]`        | no       |
| listeners           | List of listener configs (port, protocol, target group index)         | `list(object)`   | `[]`        | yes      |
| target_groups       | List of target group configs (port, protocol, target_type, etc.)      | `list(object)`   | `[]`        | yes      |
| stage               | Deployment stage/environment (e.g., dev, prd)                         | `string`         | n/a         | yes      |
| project             | Project name or code                                                  | `string`         | n/a         | yes      |
| resource_group      | Logical group name used in label generation (e.g. `alb`)              | `string`         | n/a         | yes      |
| git_repository      | Git repository reference used in tag metadata                         | `string`         | n/a         | yes      |
| additional_tags     | Optional map of additional tags to apply                              | `map(string)`    | `{}`        | no       |

---

### Outputs

| Name               | Description                         |
|--------------------|-------------------------------------|
| alb_arn            | ARN of the Application Load Balancer |
| alb_dns_name       | DNS name of the ALB                 |
| target_group_arns  | List of ARNs for the target groups  |
| listener_arns      | List of ARNs for the listeners      |

---
### Notes

- For **HTTPS**, a valid `certificate_arn` is required. Currently, the module assumes certificate configuration is handled outside.
- This module supports EC2 (`instance`), Lambda (`lambda`), and IP-based (`ip`) targets.
- Health check path defaults to `/` but can be overridden per target group.
- You can extend this module with listener rules for advanced routing logic.

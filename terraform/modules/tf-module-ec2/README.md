Perfekt, ich habe das gespeichert. Hier ist dein aktualisiertes `README.md` für das **EC2 Modul**, basierend auf der neuen Struktur mit `tf-module-label`:

---

## EC2 Module for AWS

### Current Usage

> [IMPORTANT] This module supports multi-environment deployment (`dev`, `int`, `prd`) and integrates a shared `tf-module-label` to standardize naming and tagging across resources.

This version leverages the `stage` variable to manage resources across multiple environments, and uses `tf-module-label` internally for consistent resource IDs and tags. It also supports optional activation via the `enable` toggle.

The EC2 instance is launched into a user-provided VPC/Subnet with optional custom tags and SSM Session Manager login support (no SSH key required).

---

### Features

- Launch Amazon Linux 2 EC2 Instance
- Support for `t2.micro` (or custom type)
- Install and run NGINX via `user_data`
- Attach 8GB EBS root volume
- IAM role/profile for Session Manager (SSM) login
- Integrated naming and tagging via `tf-module-label`
- Conditional resource creation using `enable`

---

### Example Usage

```hcl
module "ec2" {
  source             = "./modules/tf-module-ec2"
  enable             = true
  name               = "webserver-1"
  vpc_id             = var.vpc_id
  subnet_id          = var.subnet_id
  instance_type      = "t2.micro"
  security_group_ids = [aws_security_group.web_sg.id]

  user_data = <<-EOF
    #!/bin/bash
    yum update -y
    amazon-linux-extras install nginx1 -y
    systemctl enable nginx
    systemctl start nginx

    INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
    VPC_ID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$(curl -s http://169.254.169.254/latest/meta-data/mac)/vpc-id)
    SUBNET_ID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$(curl -s http://169.254.169.254/latest/meta-data/mac)/subnet-id)
    PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)

    echo "<h1>EC2 Instance Info</h1>" > /usr/share/nginx/html/index.html
    echo "<p><strong>Instance ID:</strong> $INSTANCE_ID</p>" >> /usr/share/nginx/html/index.html
    echo "<p><strong>VPC ID:</strong> $VPC_ID</p>" >> /usr/share/nginx/html/index.html
    echo "<p><strong>Subnet ID:</strong> $SUBNET_ID</p>" >> /usr/share/nginx/html/index.html
    echo "<p><strong>Public IP:</strong> $PUBLIC_IP</p>" >> /usr/share/nginx/html/index.html
  EOF

  project         = var.project
  stage           = var.stage
  resource_group  = "ec2"
  git_repository  = var.git_repository
  additional_tags = {
    Owner  = "douggui.med.amine@gmail.com"
    Module = "tf-module-ec2"
  }
}
```

---

### Inputs

| Name                | Description                                              | Type           | Default     | Required |
|---------------------|----------------------------------------------------------|----------------|-------------|:--------:|
| enable              | Toggle to enable/disable resource creation               | `bool`         | `true`      | no       |
| name                | Base name for the EC2 instance                           | `string`       | n/a         | yes      |
| vpc_id              | VPC ID for the EC2 instance                              | `string`       | n/a         | yes      |
| subnet_id           | Subnet ID for the EC2 instance                           | `string`       | n/a         | yes      |
| instance_type       | EC2 instance type (e.g., t2.micro)                       | `string`       | `"t2.micro"`| no       |
| security_group_ids  | List of Security Group IDs                               | `list(string)` | `[]`        | no       |
| user_data           | User data script to run on instance launch               | `string`       | `""`        | no       |
| tags                | Deprecated – use `additional_tags`                       | `map(string)`  | `{}`        | no       |
| project             | Project name or code                                     | `string`       | n/a         | yes      |
| stage               | Deployment environment (e.g., dev, prd)                  | `string`       | n/a         | yes      |
| resource_group      | Logical group of resource (e.g., ec2)                    | `string`       | n/a         | yes      |
| git_repository      | Git repo reference (for audit traceability)             | `string`       | n/a         | yes      |
| additional_tags     | Custom tags to merge                                     | `map(string)`  | `{}`        | no       |

---

### Outputs

| Name                | Description                                |
|---------------------|--------------------------------------------|
| instance_id         | ID of the EC2 instance                     |
| public_ip           | Public IP address                          |
| private_ip          | Private IP address                         |
| arn                 | ARN of the EC2 instance                    |
| private_dns         | Private DNS of the EC2 instance            |
| iam_instance_profile| IAM Instance Profile name                  |
| ami_id              | ID of the AMI used                         |
| instance_type       | EC2 instance type                          |


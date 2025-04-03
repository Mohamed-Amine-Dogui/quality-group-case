## EC2 Module for AWS

### Current Usage

> [IMPORTANT] This module supports multi-environment deployment (`dev`, `int`, `prd`) and integrates tagging best practices for governance and cost management.
This version leverages the `stage` variable to manage resources across multiple environments and supports optional activation via the `enable` toggle.
The EC2 instance is launched into a user-provided VPC/Subnet with optional custom tagging and SSM Session Manager login support (no SSH key required).

---

### Features

- Launch Amazon Linux 2 EC2 Instance
- Support for `t2.micro` (or custom type)
- Install and run NGINX via `user_data`
- Attach 8GB EBS root volume
- IAM role/profile for Session Manager (SSM) login
- Optional tagging with project/stage metadata
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
  user_data          = <<-EOF
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

  tags = {
    Project     = var.project
    Stage       = var.stage
    Environment = var.stage
  }
}
```

---

### Inputs

| Name                | Description                                              | Type          | Default     | Required |
|---------------------|----------------------------------------------------------|---------------|-------------|:--------:|
| enable              | Toggle to enable/disable resource creation               | `bool`        | `true`      | no       |
| vpc_id              | VPC ID for the EC2 instance                              | `string`      | n/a         | yes      |
| subnet_id           | Subnet ID for the EC2 instance                           | `string`      | n/a         | yes      |
| instance_type       | EC2 instance type (e.g., t2.micro)                       | `string`      | `t2.micro`  | no       |
| security_group_ids  | List of Security Group IDs                               | `list(string)`| `[]`        | no       |
| tags                | Tags to attach to the instance and IAM resources         | `map(string)` | `{}`        | no       |
| name                | Name tag for the EC2 instance                            | `string`      | n/a         | yes      |
| user_data           | User data script to execute on instance launch           | `string`      | `""`        | no       |

---

### Outputs

| Name         | Description                         |
|--------------|-------------------------------------|
| instance_id  | EC2 instance ID                     |
| public_ip    | Public IP address of instance       |
| private_ip   | Private IP address of instance      |
| instance_arn | ARN of the EC2 instance             |
| instance_name| Name tag of the EC2 instance        |

---

### Notes
- No SSH key is required. You can connect using **SSM Session Manager**.
- Make sure SSM Agent is active and `AmazonSSMManagedInstanceCore` is attached.
- The AMI used is the latest Amazon Linux 2 (x86_64).

module "label" {
  source          = "../tf-module-label"
  project         = var.project
  stage           = var.stage
  name            = var.name
  resource_group  = var.resource_group
  git_repository  = var.git_repository
  additional_tags = var.additional_tags
  resources       = ["ssm-role", "ssm-profile", "ec2"]
}


resource "aws_instance" "this" {
  count                  = var.enable ? 1 : 0
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.security_group_ids
  iam_instance_profile = aws_iam_instance_profile.ssm_profile[0].name

  user_data = var.user_data

  root_block_device {
    volume_type = "gp2"
    volume_size = 8
    delete_on_termination = true
  }

  tags = merge(
    module.label.resource["ec2"].tags,
    {
      Name = var.name
    }
  )
}

resource "aws_iam_role" "ssm_role" {
  count = var.enable ? 1 : 0
  name  = module.label.resource["ssm-role"].id

assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })

  tags  = module.label.resource["ssm-role"].tags
}

resource "aws_iam_role_policy_attachment" "ssm_attach" {
  count      = var.enable ? 1 : 0
  role       = aws_iam_role.ssm_role[0].name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_instance_profile" "ssm_profile" {
  count = var.enable ? 1 : 0
  name  = module.label.resource["ssm-profile"].id
  role  = aws_iam_role.ssm_role[0].name
}

# Data to get latest Amazon Linux 2 AMI
data "aws_ami" "amazon_linux" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["137112412989"] # Amazon official
}
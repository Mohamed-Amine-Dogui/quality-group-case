#module "ec2-1a" {
#  source             = "./modules/tf-module-ec2"
#  enable             = true
#  name               = "web-1a"
#  vpc_id             = var.vpc_id
#  subnet_id          = var.subnet_1a_id
#  instance_type      = "t2.micro"
#  security_group_ids = [aws_security_group.web_sg.id]
#  user_data          = <<-EOF
#                            #!/bin/bash
#                            yum update -y
#                            amazon-linux-extras install nginx1 -y
#                            systemctl enable nginx
#                            systemctl start nginx
#
#                            INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
#                            VPC_ID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$(curl -s http://169.254.169.254/latest/meta-data/mac)/vpc-id)
#                            SUBNET_ID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$(curl -s http://169.254.169.254/latest/meta-data/mac)/subnet-id)
#                            PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
#
#                            echo "<h1>EC2 Instance Info</h1>" > /usr/share/nginx/html/index.html
#                            echo "<p><strong>Instance ID:</strong> $INSTANCE_ID</p>" >> /usr/share/nginx/html/index.html
#                            echo "<p><strong>VPC ID:</strong> $VPC_ID</p>" >> /usr/share/nginx/html/index.html
#                            echo "<p><strong>Subnet ID:</strong> $SUBNET_ID</p>" >> /usr/share/nginx/html/index.html
#                            echo "<p><strong>Public IP:</strong> $PUBLIC_IP</p>" >> /usr/share/nginx/html/index.html
#                            EOF
#
#  project        = var.project
#  stage          = var.stage
#  resource_group = "ec2"
#  git_repository = var.git_repository
#  additional_tags = {
#    Owner  = "douggui.med.amine@gmail.com"
#    Module = "tf-module-ec2"
#  }
#}
#
#module "ec2-1b" {
#  source             = "./modules/tf-module-ec2"
#  enable             = true
#  name               = "web-1b"
#  vpc_id             = var.vpc_id
#  subnet_id          = var.subnet_1b_id
#  instance_type      = "t2.micro"
#  security_group_ids = [aws_security_group.web_sg.id]
#  user_data          = <<-EOF
#                            #!/bin/bash
#                            yum update -y
#                            amazon-linux-extras install nginx1 -y
#                            systemctl enable nginx
#                            systemctl start nginx
#
#                            INSTANCE_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
#                            VPC_ID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$(curl -s http://169.254.169.254/latest/meta-data/mac)/vpc-id)
#                            SUBNET_ID=$(curl -s http://169.254.169.254/latest/meta-data/network/interfaces/macs/$(curl -s http://169.254.169.254/latest/meta-data/mac)/subnet-id)
#                            PUBLIC_IP=$(curl -s http://169.254.169.254/latest/meta-data/public-ipv4)
#
#                            echo "<h1>EC2 Instance Info</h1>" > /usr/share/nginx/html/index.html
#                            echo "<p><strong>Instance ID:</strong> $INSTANCE_ID</p>" >> /usr/share/nginx/html/index.html
#                            echo "<p><strong>VPC ID:</strong> $VPC_ID</p>" >> /usr/share/nginx/html/index.html
#                            echo "<p><strong>Subnet ID:</strong> $SUBNET_ID</p>" >> /usr/share/nginx/html/index.html
#                            echo "<p><strong>Public IP:</strong> $PUBLIC_IP</p>" >> /usr/share/nginx/html/index.html
#                            EOF
#  project            = var.project
#  stage              = var.stage
#  resource_group     = "ec2"
#  git_repository     = var.git_repository
#  additional_tags = {
#    Owner  = "douggui.med.amine@gmail.com"
#    Module = "tf-module-ec2"
#  }
#}
#
#resource "aws_lb_target_group_attachment" "ec2_1a_attachment" {
#  target_group_arn = module.alb.target_group_arns[0]
#  target_id        = module.ec2-1a.instance_id
#  port             = 80
#}
#
#resource "aws_lb_target_group_attachment" "ec2_1b_attachment" {
#  target_group_arn = module.alb.target_group_arns[0]
#  target_id        = module.ec2-1b.instance_id
#  port             = 80
#}

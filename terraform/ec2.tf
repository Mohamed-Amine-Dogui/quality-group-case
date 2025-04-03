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
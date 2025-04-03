module "alb" {
  source             = "./modules/tf-module-alb"
  enable             = true
  name               = "web-alb"
  vpc_id             = var.vpc_id
  subnet_ids         = [var.subnet_1a_id, var.subnet_1b_id, var.subnet_1c_id]
  security_group_ids = [aws_security_group.web_sg.id]

  listeners = [
    {
      port               = 80
      protocol           = "HTTP"
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
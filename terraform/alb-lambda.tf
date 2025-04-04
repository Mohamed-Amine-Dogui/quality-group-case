module "alb_lambda" {
  source         = "./modules/tf-module-alb"
  enable         = true
  name           = "lambda"
  project        = var.project
  stage          = var.stage
  git_repository = var.git_repository
  additional_tags = {
    Owner = "douggui.med.amine@gmail.com"
  }

  vpc_id             = var.vpc_id
  subnet_ids         = [var.subnet_1a_id, var.subnet_1b_id]
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
      protocol          = "HTTP"
      target_type       = "lambda"
      health_check_path = "/"
    }
  ]

  lambda_health_check = {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }
}


resource "aws_lambda_permission" "allow_alb" {
  statement_id  = "AllowExecutionFromALB"
  action        = "lambda:InvokeFunction"
  function_name = module.my_lambda.aws_lambda_function_name
  principal     = "elasticloadbalancing.amazonaws.com"
  source_arn    = module.alb_lambda.target_group_arns[0]
}

#resource "aws_lb_target_group_attachment" "lambda_attachment" {
#  target_group_arn = module.alb_lambda.target_group_arns[0]
#  target_id        = module.my_lambda.aws_lambda_function_arn
#}

module "label" {
  source          = "../tf-module-label"
  project         = var.project
  stage           = var.stage
  name            = var.name
  resource_group  = var.resource_group
  git_repository  = var.git_repository
  additional_tags = var.additional_tags
  resources       = ["alb", "tg"]
}


resource "aws_lb" "this" {
  count              = var.enable ? 1 : 0
  name               = module.label.resource["alb"].id
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  tags = module.label.resource["alb"].tags
}


resource "aws_lb_target_group" "this" {
  count    = var.enable ? length(var.target_groups) : 0
  name     = "${module.label.resource["tg"].id}-${count.index}"
  port     = var.target_groups[count.index].port
  protocol = var.target_groups[count.index].protocol
  vpc_id   = var.target_groups[count.index].vpc_id

  target_type = var.target_groups[count.index].target_type

  health_check {
    path = var.target_groups[count.index].health_check_path
  }

  tags = module.label.resource["tg"].tags
}


resource "aws_lb_listener" "this" {
  count             = var.enable ? length(var.listeners) : 0
  load_balancer_arn = aws_lb.this[0].arn
  port              = var.listeners[count.index].port
  protocol          = var.listeners[count.index].protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.this[var.listeners[count.index].target_group_index].arn
  }

}

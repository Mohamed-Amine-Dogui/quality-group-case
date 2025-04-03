########################################################################################################################
###  Terraform and Providers setup
########################################################################################################################
terraform {
  backend "s3" {
    bucket = "qg-case-terraform-backend"
    key    = "statefile.tfstate"
    region = "eu-central-1"
  }

  required_version = "= 1.5.2"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.50.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "3.1.1"
    }

  }
}

provider "null" {
}

provider "aws" {
  region  = var.aws_region
  profile = "qg_case_user"
  default_tags {
    tags = {
      Environment   = var.stage
      GitRepository = var.git_repository
      ProjectID     = var.project
    }
  }
}

########################################################################################################################
###  General locals
########################################################################################################################
locals {
  in_default_workspace  = terraform.workspace == "default"
  in_production         = var.stage == "prd"
  in_development        = var.stage == "dev"
  in_integration        = var.stage == "int"
  count_in_production   = local.in_production ? 1 : 0
  count_in_default      = local.in_default_workspace ? 1 : 0
  workspace_arn_prefix  = terraform.workspace != "default" && var.stage == "dev" ? "*" : ""
  project_stage_pattern = "${local.workspace_arn_prefix}${var.project}-${var.stage}*"
  account_id            = data.aws_caller_identity.current.account_id
  access_arns           = [data.aws_caller_identity.current.arn, "arn:aws:iam::683603511960:root"]
}

########################################################################################################################
###  Convenience data retrieval
########################################################################################################################
data "aws_caller_identity" "current" {}

########################################################################################################################
###  generic resources Labels
########################################################################################################################
module "generic_labels" {

  source         = "git::ssh://git@github.com/Mohamed-Amine-Dogui/tf-module-label.git?ref=tags/0.0.1"
  git_repository = var.git_repository
  project        = var.project
  stage          = var.stage
  layer          = var.stage
  project_id     = var.project_id

  resources = [
    "grant",
    "bucket",
  ]
}



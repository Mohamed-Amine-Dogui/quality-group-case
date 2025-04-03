#########################################################################################################################
####  my_lambda
#########################################################################################################################
#module "my_lambda" {
#
#  source = "git::ssh://git@github.com/Mohamed-Amine-Dogui/tf-module-aws-lambda-vpc.git?ref=tags/0.0.1"
#
#  enable = true
#  depends_on = [
#    module.kms_key,
#  ]
#  stage          = var.stage
#  project        = var.project
#  region         = var.aws_region
#  git_repository = var.git_repository
#
#
#  additional_policy        = data.aws_iam_policy_document.my_lambda_policy.json
#  attach_additional_policy = true
#
#  lambda_unique_function_name = var.my-lambda_unique_function_name
#  artifact_bucket_name        = module.lambda_scripts_bucket.s3_bucket
#  runtime                     = "python3.11"
#  handler                     = var.default_lambda_handler
#  main_lambda_file            = "main"
#  lambda_base_dir             = abspath("${path.cwd}/../lambdas/my_lambda")
#  lambda_source_dir           = abspath("${path.cwd}/../lambdas/my_lambda/src")
#
#  memory_size      = 512
#  timeout          = 900
#  logs_kms_key_arn = module.kms_key.kms_key_arn
#
#  lambda_env_vars = {
#    stage  = var.stage
#    REGION = var.aws_region
#  }
#
#  tags_lambda = {
#    GitRepository = var.git_repository
#    ProjectID     = var.project_id
#  }
#}
#
#########################################################################################################################
#### Policy of my_lambda
#########################################################################################################################
#data "aws_iam_policy_document" "my_lambda_policy" {
#  /*
#  https://docs.aws.amazon.com/kms/latest/developerguide/key-policies.html
#  checkov:skip=CKV_AWS_111:Skip reason - DescribeStatement requires (*) in the policy. See the link below for more information:
#  checkov:skip=CKV_AWS_107:Skip reason - Credentials are not suspended.
#  Source: https://docs.aws.amazon.com/kms/latest/developerguide/kms-api-permissions-reference.html
#  */
#
#  statement {
#    sid    = "AllowReadWriteS3"
#    effect = "Allow"
#    actions = [
#      "s3:Get*",
#      "s3:List*",
#      "s3:Describe*",
#      "s3:Put*",
#      "s3:Delete*",
#      "s3:RestoreObject"
#    ]
#    resources = [
#      "${module.lambda_scripts_bucket.s3_arn}",
#      "${module.lambda_scripts_bucket.s3_arn}/*",
#    ]
#  }
#
#  statement {
#    sid    = "AllowDecryptEncrypt"
#    effect = "Allow"
#    actions = [
#      "kms:Decrypt",
#      "kms:Encrypt",
#      "kms:GenerateDataKey",
#      "kms:ReEncrypt*",
#      "kms:ListKeys",
#      "kms:Describe*"
#    ]
#    resources = [
#      "${module.kms_key.kms_key_arn}",
#      "${module.lambda_scripts_bucket.aws_kms_key_arn}"
#    ]
#  }
#
#  statement {
#    sid    = "AllowPutCustomMetrics"
#    effect = "Allow"
#    actions = [
#      "cloudwatch:PutMetricData",
#      "cloudwatch:PutMetricAlarm"
#    ]
#    resources = [
#      "*"
#    ]
#  }
#
#}
#
#
#########################################################################################################################
## ###   Allows to grant permissions to lambda to use the specified KMS key
## ########################################################################################################################
#resource "aws_kms_grant" "my_lambda_grant_kms_key" {
#  count             = local.count_in_default
#  name              = module.generic_labels.resource["grant"]["id"]
#  key_id            = module.kms_key.kms_key_id
#  grantee_principal = module.my_lambda.aws_lambda_function_role_arn
#  operations = [
#    "Decrypt",
#    "Encrypt",
#    "GenerateDataKey",
#    "DescribeKey"
#  ]
#}

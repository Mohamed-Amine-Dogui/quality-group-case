export AWS_PROFILE=qg_case_user
aws s3 cp my_stack.tfstate s3://esn-dev-source-terraform-state-bucket/incoming/my_stack.tfstate

# Terraform Challenge – The Quality Group

## Zielsetzung

Diese Lösung erfüllt die Anforderung, Terraform-States automatisch zu bereinigen:  
Sobald ein `.tfstate`-File unter einem bestimmten Prefix in einem Quell-S3-Bucket hochgeladen wird, reagiert eine AWS Lambda-Funktion darauf. Die Funktion entfernt sensible `resources`-Informationen und legt eine bereinigte Version mit lediglich den `outputs` im Ziel-Prefix eines (anderen) Buckets ab. Diese bereinigte Datei bleibt vollständig kompatibel mit Terraform als Remote-Backend.

---

## Projektstruktur

```bash
quality-group-case/
├── lambdas/
│   └── my_lambda/
│       ├── build.sh
│       └── src/
│           └── main.py       # Lambda logic: strip resources
├── terraform/
│   ├── modules/
│   │   ├── tf-module-label
│   │   ├── tf-module-aws-lambda
│   │   ├── tf-module-aws-s3-bucket
│   │   └── tf-module-aws-kms-key
│   ├── kms.tf                # KMS key
│   ├── my_lambda.tf          # Lambda module call
│   ├── s3.tf                 # S3 buckets
│   ├── main.tf               # Root composition
│   ├── outputs.tf
│   ├── variables.tf
│   ├── my_stack.tfstate      # Dummy test tfstate file
│   └── README.md             # ← You are here

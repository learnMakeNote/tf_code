# root account have route53
provider "aws" {
  alias = "infra-dev"

  region = "ap-northeast-1"
  access_key = var.route53_account_access_key
  secret_key = var.route53_account_secret_key
  token = var.route53_account_token
}

## external account have vpc
provider "aws" {
  alias = "external-connect"

  region = "ap-northeast-1"
  access_key = var.vpc_account_access_key
  secret_key = var.vpc_account_secret_key
  token = var.vpc_account_token
}

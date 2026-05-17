resource "aws_organizations_organization" "org" {
  aws_service_access_principals = [
    "iam.amazonaws.com",
    "sso.amazonaws.com",
    "cloudtrail.amazonaws.com"
  ]
  enabled_policy_types = [
    "SERVICE_CONTROL_POLICY"
  ]
  feature_set              = "ALL"
  return_organization_only = null
}

resource "aws_organizations_organizational_unit" "workloads" {
  name      = "Workloads"
  parent_id = aws_organizations_organization.org.roots[0].id
}

resource "aws_organizations_organizational_unit" "prod" {
  name      = "Prod"
  parent_id = aws_organizations_organizational_unit.workloads.id
}

variable "prod_hoge_email" {
  type        = string
  description = "The email address of PROD-HOGE root account"
  sensitive   = true
}

resource "aws_organizations_account" "prod_hoge" {
  name      = "prod-hoge"
  email     = var.prod_hoge_email
  parent_id = aws_organizations_organizational_unit.prod.id
}

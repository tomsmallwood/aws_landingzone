resource "aws_organizations_organization" "org" {
  # aws_service_access_principals = [
  #   "cloudtrail.amazonaws.com"
  # ]
  feature_set = "ALL"
}

# deploy AFT
module "aft" {
  source = "github.com/aws-ia/terraform-aws-control_tower_account_factory?ref=1.10.3"

  # Required Vars
  ct_management_account_id  = var.ct_management_account_id
  aft_management_account_id = aws_organizations_account.aft.id
  log_archive_account_id    = var.log_archive_account_id
  audit_account_id          = var.audit_account_id

  ct_home_region              = var.ct_home_region
  tf_backend_secondary_region = var.tf_backend_secondary_region

  # VCS Vars
  vcs_provider                                  = "github"
  account_request_repo_name                     = "aws-ia/terraform-aws-control_tower_account_factory//sources/aft-customizations-repos/aft-account-request"
  global_customizations_repo_name               = "aws-ia/terraform-aws-control_tower_account_factory//sources/aft-customizations-repos/aft-global-customizations"
  account_customizations_repo_name              = "aws-ia/terraform-aws-control_tower_account_factory//sources/aft-customizations-repos/aft-account-customizations"
  account_provisioning_customizations_repo_name = "aws-ia/terraform-aws-control_tower_account_factory//sources/aft-customizations-repos/aft-account-provisioning-customizations"

  # Opt out of reporting metrics
  aft_metrics_reporting = false
}

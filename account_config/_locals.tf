locals {
  name_prefix        = "${var.environment}-"
  global_name_prefix = "${terraform.workspace}-"

  common_tags = merge(
    var.common_tags,
    {
      AccountId = data.aws_caller_identity.current.account_id
      Region    = data.aws_region.current.region
      Workspace = terraform.workspace
      ManagedBy = "Terraform"
    }
  )
}

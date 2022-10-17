terraform {
  backend "azurerm" {
    resource_group_name = "core-infra"
    storage_account_name = "siftertfstate"
    container_name = "sifter-tfstate-container"
    key = "terraform.tfstate"
  }
}

provider "azurerm" {
  version = "=2.10.0"
  features {}
}

locals {
  github_repository = "ingredient-phrase-tagger"

  common_tags = {
    tf_workspace = terraform.workspace
  }

  desired_tf_workspace = "infra-app-${local.github_repository}"
  assert_not_required_workspace = terraform.workspace != local.desired_tf_workspace ? file("ERROR: Are you sure in the proper workspace ${local.desired_tf_workspace}") : null
}

module "config" {
  source = "git@github.com:siftershop/terraform-modules.git//sifter-config?ref=v1.1.14"
}

data "azurerm_key_vault" "sifter_keyvault" {
  name = module.config.sifter_key_vault
  resource_group_name = module.config.sifter_key_vault_resource_group
}

module "devops" {
  source = "git@github.com:siftershop/terraform-modules.git//azure-devops?ref=v1.1.14"
  pipeline_type = "app"

  azdo_org_url = module.config.sifter_azdo_org
  git_repository_org = module.config.sifter_github_org
  git_repository_name = local.github_repository
  git_repository_branch = "main"

  acr_ref = {
    name = module.config.sifter_acr
    resource_group_name = module.config.sifter_acr_resource_group
    sp_name = module.config.sifter_acr_sp
  }

  aks_cluster_ref = null

  keyvault_ref = data.azurerm_key_vault.sifter_keyvault
  github_pat_key = module.config.sifter_github_pat_key
}

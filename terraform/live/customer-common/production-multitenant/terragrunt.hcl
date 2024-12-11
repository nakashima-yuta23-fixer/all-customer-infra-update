terragrunt_version_constraint = "~> 0.69.9"

locals {
  subscription_id              = get_env("ARM_SUBSCRIPTION_ID")
  tenant_id                    = get_env("ARM_TENANT_ID")
  client_id                    = get_env("ARM_CLIENT_ID")
  client_secret                = get_env("ARM_CLIENT_SECRET")
  terraform_version            = get_env("TERRAFORM_VERSION")
  backend_resource_group_name  = get_env("TERRAFORM_BACKEND_RESOURCE_GROUP_NAME")
  backend_storage_account_name = get_env("TERRAFORM_BACKEND_STORAGE_ACCOUNT_NAME")
}

remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    subscription_id      = "${local.subscription_id}"
    key                  = "${path_relative_to_include()}/terraform-dv.tfstate"
    resource_group_name  = "${local.backend_resource_group_name}"
    storage_account_name = "${local.backend_storage_account_name}"
    container_name       = "tfstate"
  }
}

# RenovateのProviderバージョンアップがhclファイルには対応していなかったので、1度目の
# Terragrunt実行のみ下記設定でterraform.tfを作成する。以降、運用時にはterraform.tfは再作成
# ・上書きしない。
# RenovateがTerraformディレクトリ内のterraform.tfに対して、Providerのバージョンを自動で更新
# する運用となる。
# Renovateがhclファイル内の自動バージョン更新に対応すれば、Providerのバージョン更新をこのhcl
# ファイル内で閉じる対応をすると可読性の向上が見込める。
generate "version" {
  path      = "versions.tf"
  if_exists = "skip"
  contents  = <<EOF
terraform {
  required_version = "${local.terraform_version}"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 4.1.0"
    }
    random = {
      source = "hashicorp/random"
      version = "~> 3.6.2"
    }
  }
}
EOF
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  subscription_id = "${local.subscription_id}"
  tenant_id       = "${local.tenant_id}"
  client_id       = "${local.client_id}"
  client_secret   = "${local.client_secret}"

  features {}
}

provider "random" {}
EOF
}

include "root" {
  path = find_in_parent_folders()
}

# terraform {
#   # source = "git::${local.module_repository_name}//terraform/modules/standard_service?ref=54a05285cd6bbc2d2d3dae65e1da1447dda11b6a"
# }

dependency "resource_group" {
  config_path = "../resource_group"

  mock_outputs = {
    resource_group_name = "rg-XXXXXX-dv-je"
  }
}

inputs = {
  resource_group_name = dependency.resource_group.outputs.resource_group_name
}

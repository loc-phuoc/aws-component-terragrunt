include {
  path = find_in_parent_folders("_component/ec2.hcl")
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}
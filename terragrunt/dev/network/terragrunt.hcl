include "ec2" {
  path = find_in_parent_folders("_component/network.hcl")
}

include "root" {
  path = find_in_parent_folders("root.hcl")
}

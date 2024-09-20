################
# Networking Hub
################

resource "spacelift_space" "networking_hub" {
  name = "networking-hub"

  parent_space_id = spacelift_space.aws.id
  description     = "Networking Hub Space"
  labels          = ["aws-networking-hub"]

  inherit_entities = true
}

### DEV ###

resource "spacelift_space" "networking_hub_dev" {
  name = "dev"

  parent_space_id = spacelift_space.networking_hub.id
  description     = "Networking Hub - Dev Environment Space"
  labels          = ["aws-networking-hub-dev"]

  inherit_entities = true
}

### USE1 ###

resource "spacelift_space" "networking_hub_dev_use1" {
  name = "use1"

  parent_space_id = spacelift_space.networking_hub_dev.id
  description     = "Networking Hub - Dev - USE1 Environment Space"
  labels          = ["aws-networking-hub-dev-use1"]

  inherit_entities = true
}

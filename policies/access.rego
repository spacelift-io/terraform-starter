package spacelift

# This example access policy gives everyone in the "Engineering" GitHub team
# read access to all spaces.
#
# You can read more about access policies here:
#
# https://docs.spacelift.io/concepts/spaces/access-control

engineer { input.session.teams[_] == "Engineering" }
login   := input.session.login
is_engineer { engineer[login] }
allow { is_engineer }
deny  { not allow }

# Let's give every Engineering team member read access to any space
space_read[space.id] {
  space := input.spaces[_]
  is_engineer
}

# Assign write role to engineers for spaces with "engineers-are-writers" label
space_write[space.id] {
  space := input.spaces[_]
  space.labels[_] == "engineers-are-writers"
  is_engineer
}

# Assign admin role for the root space for anyone in the admin team
space_admin["root"] {
  input.session.teams[_] == "admin"
}

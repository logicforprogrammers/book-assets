// Alloy is a formal specification language
// that can verify abstract software models satisfy properties.
// Learn more at https://alloytools.org/

sig User {}

sig Group {
  admin: User, 
  members: set User
}

pred admins_members_of_groups {
  all g: Group |
    g.admin in g.members
}

pred is_admin[u: User] {
  some g: Group |
    g.admin = u
}

run group_with_all_admins {
  admins_members_of_groups and
  some g: Group |
    all u: User |
      is_admin[u] implies u in g.members
}

check no_empty_groups {
  admins_members_of_groups =>
    all g: Group | some g.members
}
// Alloy is a formal specification language
// that can verify abstract software models satisfy properties.
// Learn more at https://alloytools.org/

module access_permissions_roles

sig User {
  roles: set Role
}

sig Resource {
  parent: lone Resource
}

sig Role {
  permits: set Resource
}

fun readable_by: Resource -> set User {
  ~(roles.permits) 
} 

pred no_cycles {
  no r: Resource |
    r in r.^parent
}

pred spec {
  no_cycles
}

pred can_access_role[u: User, r: Resource] {
  some role: u.roles |
    r in role.permits 
    || some (r.parent & role.permits)
}

pred can_access[u: User, r: Resource] {
  u in r.readable_by
  || u in r.^parent.readable_by
}

pred parent_implies_child {
  all u: User, r: Resource |
    can_access[u, r] => 
      all child: r.~parent |
        can_access[u, child]
}

check {spec => parent_implies_child} for 5

pred refinement {
  all u: User, r: Resource |
    can_access_role[u, r] <=> can_access[u, r]
}

check {spec => refinement} for 3

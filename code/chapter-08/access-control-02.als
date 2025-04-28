// Alloy is a formal specification language
// that can verify abstract software models satisfy properties.
// Learn more at https://alloytools.org/

module access_permissions

sig User {}

sig Resource {
  readable_by: set User
  , parent: lone Resource
}

fact no_cycles {
  no r: Resource |
    r in r.^parent
}

pred can_access[u: User, r: Resource] {
  u in r.readable_by
  || u in r.^parent.readable_by
}

assert parent_implies_child {
  all u: User, r: Resource |
    can_access[u, r] => 
      all child: r.~parent | //r.~parent = children of r 
        can_access[u, child]
}

check parent_implies_child
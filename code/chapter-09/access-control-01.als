// Alloy is a formal specification language
// that can verify abstract software models satisfy properties.
// Learn more at https://alloytools.org/
// This version has a bug.

module access_permissions

sig User {}

sig Resource {
  readable_by: set User, 
  parent: lone Resource
}

pred no_cycles {
  no r: Resource |
    r in r.^parent
}

pred spec {
  no_cycles
}

pred can_access[u: User, r: Resource] {
  u in r.readable_by
  || u in r.parent.readable_by
}

pred parent_implies_child {
  all u: User, r: Resource |
    can_access[u, r] => 
      all child: r.~parent |
        can_access[u, child]
}

check {spec => parent_implies_child} for 3

// The information below gives nicer error reporting. Delete it for the generalized model
one sig Child, Parent, Grandchild extends Resource {}
fact {
  Child.parent = Parent
  Grandchild.parent = Child
}

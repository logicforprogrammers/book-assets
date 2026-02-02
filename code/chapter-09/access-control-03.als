// Alloy is a formal specification language
// that can verify abstract software models satisfy properties.
// Learn more at https://alloytools.org/

module access_control

sig User {
    policies: set Policy,
    groups: set UserGroup,
}

sig UserGroup {
    group_policies: set Policy,
}

sig Resource {}

sig Policy {
    allows: set Resource,
    denies: set Resource,
}

pred covers_something[p: Policy] {
    some p.allows + p.denies
}

pred pre {
    all p: Policy |
        covers_something[p]
}

pred policy_allows[p: Policy, r: Resource] { r in p.allows }
pred policy_denies[p: Policy, r: Resource] { r in p.denies }

pred can_access[u: User, r: Resource] {
    some p: u.policies + u.groups.group_policies |
        policy_allows[p, r]
    && all p: u.policies + u.groups.group_policies |
        !policy_denies[p, r]
}

pred prop_denial_prevents_access {
    all u: User, r: Resource |
        (some p: u.policies | policy_denies[p, r]) =>  !can_access[u, r]
}

check {
   pre => prop_denial_prevents_access
} for 2

run { pre && some p: Policy | !(some p.denies) } for 20
run { pre && some p: Policy | !(some p.allows) } for 20

// For generating an "unusual edge case" in the book
run { pre && 
  some u: User, g: u.groups, r: Resource |
    some p1: u.policies, p2: g.group_policies |
      p1 != p2 &&
      policy_allows[p1, r] && policy_denies[p2, r]
} for 1 but 2 Policy
  

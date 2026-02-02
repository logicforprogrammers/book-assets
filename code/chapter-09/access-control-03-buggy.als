// Alloy is a formal specification language
// that can verify abstract software models satisfy properties.
// Learn more at https://alloytools.org/
// This model has two bugs.

module access_control

sig User {
    policies: set Policy,
    groups: set UserGroup,
}

sig UserGroup {
    group_policies: set Policy
}

sig Resource {}

sig Policy {
    allows: some Resource,
    denies: some Resource,
}

pred policy_allows[p: Policy, r: Resource] { r in p.allows }
pred policy_denies[p: Policy, r: Resource] { r in p.denies }

pred can_access[u: User, r: Resource] {
    some p: u.policies + u.groups.group_policies | 
        policy_allows[p, r] && !policy_denies[p, r] // uh-oh
}

pred prop_denial_prevents_access {
    all u: User, r: Resource |
        (some p: u.policies | policy_denies[p, r]) => 
          !can_access[u, r]
}

check {
    prop_denial_prevents_access
} for 2 but 0 UserGroup

run { some p: Policy | !(some p.denies) } for 20
run { some p: Policy | !(some p.allows) } for 20

// Alloy is a formal specification language
// that can verify abstract software models satisfy properties.
// Learn more at https://alloytools.org/

module access_control

sig User {
    policies: set Policy,
    var groups: set UserGroup,
}

sig UserGroup {
    group_policies: set Policy
}

sig Policy {
    allows: set Resource,
    denies: set Resource
}

sig Resource {}

pred policy_allows[p: Policy, r: Resource] { r in p.allows }

pred policy_denies[p: Policy, r: Resource] { r in p.denies }

pred can_access[u: User, r: Resource] {
    some p: u.policies + u.groups.group_policies | policy_allows[p, r] 
    && all p: u.policies + u.groups.group_policies | !policy_denies[p, r]
}

pred changing_permissions {
    some u: User, r: Resource |
        eventually can_access[u, r] &&
        eventually !can_access[u, r]
}

run {changing_permissions} for 1

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

sig Policy {
    allows: some Resource,
}

sig Resource {}

pred policy_allows[p: Policy, r: Resource] { r in p.allows }

// I like helper predicates
pred can_access[u: User, r: Resource] {
    some p: u.policies + u.groups.group_policies | 
        policy_allows[p, r]
}

pred no_access[u: User] {
    all r: Resource |
        !can_access[u, r]
}

no_shirt_no_policy_no_access: check {
    all u: User |
        !(some u.policies) => no_access[u]
} for 1

// there is a user with 1. no policies
// and 2. NOT no_access (ie, access to something)
shirtless: run {
    some u: User |
        !(some u.policies) && !no_access[u]
} for 1

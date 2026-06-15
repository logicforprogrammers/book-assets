// Alloy is a formal specification language
// that can verify abstract software models satisfy properties.
// Learn more at https://alloytools.org/

module access_control

sig User {
    policies: set Policy, // 0 or more
}

sig Policy {
    allows: some Resource,  // 1 or more
}

sig Resource {}

pred can_access[u: User, r: Resource] {
    some p: u.policies |
        r in p.allows
}

// find an instance where some user can access a resource
// `label:` is optional
base_case: run {
    some u: User, r: Resource |
        can_access[u, r]
} for 3 // up to 3 Users, Policies, and Resources

// Alloy is a formal specification language
// that can verify abstract software models satisfy properties.
// Learn more at https://alloytools.org/

module cms

sig Item {
    category: one Category, // 1
    links: set Item // 0 or more
}

sig Category {
    parent: lone Category,
    rank: one Int
}

pred rank_rule {
    all c: Category |
        some c.parent => (c.parent.rank < c.rank)
}

check {
    rank_rule => no_parent_cycles
} for 4

pred self_parent[c: Category] {
    c = c.parent
}

pred no_self_parents {
    all c: Category |
        !self_parent[c]
}

pred no_parent_cycles {
    all c: Category |
        !(c in c.^parent)
}

// `label:` is optional
parent_cycle: run {
    no_self_parents && !no_parent_cycles
} for 3



impossible_ancestries: run {
    no_parent_cycles && !rank_rule
} for 4

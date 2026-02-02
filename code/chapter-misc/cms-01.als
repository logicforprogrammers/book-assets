// Alloy is a formal specification language
// that can verify abstract software models satisfy properties.
// Learn more at https://alloytools.org/

module cms

sig Item {
    category: one Category, // 1
    links: set Item // 0 or more
}

sig Category {
    parent: lone Category // 0 or 1
}

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

pred no_grandparents {
    all c: Category |
        no c.parent.parent
}

check {
    no_grandparents => no_parent_cycles
} for 4

impossible_ancestries: run {
    no_parent_cycles && !no_grandparents
} for 4

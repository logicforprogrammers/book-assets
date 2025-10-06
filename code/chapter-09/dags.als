// Alloy is a formal specification language
// that can verify abstract software models satisfy properties.
// Learn more at https://alloytools.org/

module dags

sig Category {
    children: set Category
}

pred dag {
    all c: Category |
        !(c in c.^children)
}

fun parents: Category -> Category {
    ~children
}

pred tree {
    all c: Category |
        !(c in c.^parents) && 
        #(c.parents) <= 1
}

trees_are_dags: check {tree => dag} for 5 // passes
dags_are_trees: check {dag => tree} for 5 // fails

fun siblings[c: Category]: set Category {
    c.parents.children - c
}

pred no_chiblings[c: Category] {
    #(c.children & c.siblings) = 0
}

no_tree_chiblings: check {
    tree => all c: Category | no_chiblings[c]
} for 5 // passes

no_dag_chiblings: check {
    dag => all c: Category | no_chiblings[c]
} for 5 // fails

chiblings_defines_tree: check {
    (dag && all c: Category | no_chiblings[c]) => tree   
} for 5 // fails

/*
┌─────────────┬──────────┐
│this/Category│children  │
├─────────────┼──────────┤
│Category$0   │Category$3│
│             ├──────────┤
│             │Category$4│
├─────────────┼──────────┤
│Category$1   │Category$0│
├─────────────┼──────────┤
│Category$2   │Category$0│
│             ├──────────┤
│             │Category$1│
├─────────────┼──────────┤
│Category$3   │Category$4│
├─────────────┼──────────┤
│Category$4   │          │
└─────────────┴──────────┘
*/
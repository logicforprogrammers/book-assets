// Alloy is a formal specification language
// that can verify abstract software models satisfy properties.
// Learn more at https://alloytools.org/

sig User {
  referrer: lone User,
  created_at: disj Int
}

sig Group {
  admin: User, 
  members: set User
}

pred admins_members_of_groups {
  all g: Group |
    g.admin in g.members
}

pred is_admin[u: User] {
  some g: Group |
    g.admin = u
}

pred no_self_loops {
  all u: User |
    u != u.referrer
}

pred no_cycles {
  all u: User |
    u !in u.^referrer
}

pred referral_must_come_later {
  all u, ref: User |
    u.referrer = ref => gt[u.created_at, ref.created_at]

}

run some_implementation {
  referral_must_come_later
  User = User.(^referrer + ^~referrer)
} for 4 but exactly 5 User

check implementation_works {
  referral_must_come_later => no_cycles
}

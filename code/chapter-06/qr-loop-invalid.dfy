// Dafny is a formal verification language,
// Meaning Dafny code can be proven to be correct (match a spec).
// Learn more at https://dafny.org/
// This version will not compile, as it is missing a loop invariant.

method qr_loop(x: int, y: int) returns (q: int, r: int)
  requires x >= 0
  requires y > 0
  ensures q*y + r == x
  ensures 0 <= r < y
  ensures q >= 0
{
  q := 0;
  r := x;
  while r >= y
    invariant q*y + r == x
  {
    q := q + 1;
    r := r - y;
  }
}



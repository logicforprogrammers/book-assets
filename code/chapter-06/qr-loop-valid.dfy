// Dafny is a formal verification language,
// meaning Dafny code can be proven to be correct (match a spec).
// learn more at https://dafny.org/
// this version is the fixed version of qr-loop-invalid.dfy

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
    invariant r >= 0
  {
    q := q + 1;
    r := r - y;
  }
}



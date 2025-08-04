// Dafny is a formal verification language,
// Meaning Dafny code can be proven to be correct (match a spec).
// Learn more at https://dafny.org/

method qr(x: int, y: int) returns (q: int, r: int)
  requires x >= 0
  requires y > 0
  ensures q*y + r == x  // a
  ensures 0 <= r < y    // b
  ensures q >= 0        // c
{
  q := x / y;
  r := x - q*y;
}

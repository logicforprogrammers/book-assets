// Dafny is a formal verification language,
// Meaning Dafny code can be proven to be correct (match a spec).
// Learn more at https://dafny.org/

method qr(x: int, y: int) returns (q: int, r: int)
{
  q := x / y; // floor division
  r := x - q*y;
}

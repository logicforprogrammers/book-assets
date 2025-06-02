// Dafny is a formal verification language,
// Meaning Dafny code can be proven to be correct (match a spec).
// Learn more at https://dafny.org/

method max(s: seq<int>) returns (out: int)
requires |s| > 0
ensures out in s
ensures forall i :: 0 <= i < |s| ==> s[i] <= out
{  
  var i := 0;
  out := s[0];
  while i < |s|
  invariant out in s
  invariant 0 <= i <= |s|
  invariant forall j :: 0 <= j < i ==> s[j] <= out
  {
    if s[i] >= out {
        out := s[i];
    }
    i := i + 1;
  }
}

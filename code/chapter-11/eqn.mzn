% Minizinc is a constraint solving language.
% Try this online: https://play.minizinc.dev/
% Learn more at https://www.minizinc.org/

var -1000.0..1000.0: x;
constraint x*x + 6*x = 9;

solve satisfy;

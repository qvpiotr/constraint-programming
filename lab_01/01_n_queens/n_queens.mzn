include "alldifferent.mzn";

% VARIABLES 
int: N;
array [1..N] of var 1..N: rows;

% CONSTRAINTS 
% constraint forall(i in 1..N, j in i+1..N)(rows[i] != rows[j]);
constraint alldifferent(rows);
constraint forall(i in 1..N, j in i+1..N)(abs(rows[i] - rows[j]) != (j - i));

solve satisfy; 

% OUTPUT EXAMPLE  
output [ if fix(rows[j]) == i then "|Q" else "|_" endif ++
  if j == N then "\n" else "" endif | i,j in 1..N];

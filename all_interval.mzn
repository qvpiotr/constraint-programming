include "globals.mzn";
int: n;
set of int: Set = 0..n-1;
set of int: Set2 = 0..n-2;

array[Set] of var Set: series;


%constraints
constraint forall(i,j in Set where i != j)(series[i] != series[j]);

constraint forall(i,j in Set where j < n-1 /\ i < n-1 /\ i != j)(
     abs(series[i+1] - series[i]) != abs(series[j+1] - series[j]));
     
%symetry breaking
constraint series[0] < series[n-1];

%redundant constraints
constraint all_different([abs(series[i+1] - series[i]) | i in Set2]);


solve satisfy;

output [show(series)];
include "alldifferent.mzn";

% PARAMETERS        
int: n;

% VARIABLES        
array[0..n-1] of var 0..n: magic;
  
% Constraints 
constraint forall(i in 0..n-1)(magic[i] = (sum(j in 0..n-1)(bool2int(magic[j]=i))));

solve satisfy;
  
%%%%%%%%%%%%%%%%%%%%%%%%
% EXAMPLE OUTPUT  
%%%%%%%%%%%%%%%%%%%%%%%%
% - magic - magic sequence     
%%%%%%%%%%%%%%%%%%%%%%%%
output [ "magic sequence = ", show(magic),";\n"];

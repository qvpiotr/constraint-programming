% PARAMETERS
int: nodesNumber;
array [1..nodesNumber,1..nodesNumber] of var bool: edges; 
 
% VARIABLES         
array [1..nodesNumber] of var 1..nodesNumber: nodes;
var int: colorsNumber=max(nodes);

% CONSTRAINTS
constraint forall(i in 1..nodesNumber, j in i+1..nodesNumber where edges[i,j] == true)(nodes[i] != nodes[j]); 

% GOAL  
solve minimize colorsNumber;

% OUTPUT EXAMPLE
output [show(colorsNumber), " colors\n",] ++
       [show(nodes[i]) ++ " " | i in 1..nodesNumber]

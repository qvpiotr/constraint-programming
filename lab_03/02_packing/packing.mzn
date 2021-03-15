include "diffn.mzn";
include "cumulative.mzn";

% Parameters
%%%%%%%%%%%
int: n;                      % How many squares do we have?
set of int: SQUARES = 1..n;  % Set of the available squares

% Variables
%%%%%%%%%%%
var n..sum([i | i in SQUARES]): height;    % height of the container
var n..sum([i | i in SQUARES]): width;     % width of the conainer
var sum([i*i | i in SQUARES])..n*sum([i | i in SQUARES]): area = height * width; % container's area
array[SQUARES] of var 0..sum([i | i in SQUARES]) - 1: x; % squares' coordinates in the container
array[SQUARES] of var 0..sum([i | i in SQUARES]) - 1: y; % squares' coordinated in the container
  
% Constraints 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 

% Constraint 1: Squares should fit inside the container
constraint forall(i in SQUARES)(x[i] + i <= width /\ y[i] + i <= height);
  
% Constraint 2: Squares should not overlap
constraint forall(i,j in SQUARES where i < j)(
x[i] >= x[j] + j \/ x[j] >= x[i] + i \/ y[i] >= y[j] + j \/ y[j] >= y[i] +i
);


% global constraint diffn
constraint diffn(x,y,SQUARES,SQUARES);

%redundant constraints
constraint cumulative(x,SQUARES,SQUARES,height);
constraint cumulative(y,SQUARES,SQUARES,width);

%symetry breaking 
constraint height <= width;

array[1..2*n] of var 0..sum([i | i in SQUARES]) - 1: coordinates = [
   if i mod 2 == 0 then
     y[n - (i div 2) + 1]
   else
      x[n - (i div 2)]
   endif
  | i in 1..2*n
];


% Goal
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

solve :: seq_search([ int_search([height,width], input_order, indomain_min, complete),
                      int_search(coordinates, input_order, indomain_min, complete)
]) minimize area; 
  

% Boring output  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
output [ show(i) ++ " > (" ++ show(x[i]) ++ "," ++ show(y[i]) ++ ")\n" | i in 1..n] ++
  ["area = " ++ show(width) ++ " * " ++ show(height) ++ " = " ++ show(area)];
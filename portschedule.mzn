int: nr; % number of reclaimers
           % number of rails = nr for stages A,B,C,D,E
           % number of rails = (nr + 1) div 2 for stage F
set of int: RECLAIMER = 1..nr;
bool: stageF; % is this stage F data

int: ns; % number of stockpiles
set of int: STOCKPILE = 1..ns;
array[STOCKPILE] of int: size; % size in 10000 tonnes
array[STOCKPILE] of SHIP: ship; % which ship carries stockpile
 
int: maxtime; % time considered
set of int: TIME = 0..maxtime;

int: nsh; % number of ships
set of int: SHIP = 1..nsh;
array[SHIP] of TIME: arrival; % when ship arrives in port

int: len; % length of pad
set of int: POSITION = 0..len;

int: stack_time;
int: reclaim_time;
int: reclaim_speed;

array[STOCKPILE] of var POSITION: westend;
array[STOCKPILE] of var POSITION: eastend;
array[STOCKPILE] of var TIME: stack;
array[STOCKPILE] of var TIME: endstack;
array[STOCKPILE] of var TIME: reclaim;
array[STOCKPILE] of var TIME: finished = [reclaim[i]+reclaim_time*size[i]|i in STOCKPILE];
array[STOCKPILE] of var RECLAIMER: which;

% Go crazy here

% Stage A - Packing Problem DONE
% Two stockpiles can't overlap in "spacetime"
% 1) what's the relation between endstack and stack times
constraint forall(i in STOCKPILE)(endstack[i] = stack[i]+stack_time*size[i]);
% 2) what's the relation between finished and stack times ???????
constraint forall(i in STOCKPILE)(finished[i] > stack[i]);
% 3) what's the relation between reclaim and endstack times
constraint forall(i in STOCKPILE)(reclaim[i] >= endstack[i]);
% 4) what's the relation between finished and reclam times

% 5) what's the relation between eastend and westend offsets
constraint forall(i in STOCKPILE)(eastend[i] = westend[i]+size[i]);
constraint forall(i in STOCKPILE)(eastend[i] <= len /\ westend[i] >= 0);

% 6) packing problem
%    a) stockpiles should not overlap in "spacetime", treat them as rectangles
% constraint diffn(westend,eastend,size,duration);
constraint forall(s1,s2 in STOCKPILE where s1<s2)(eastend[s1]<=westend[s2] \/ eastend[s2]<=westend[s1]\/finished[s1]<=stack[s2]\/finished[s2]<=stack[s1]);
%    b) stockpiles can't use more space than there is available ????
constraint forall(i in STOCKPILE)(stack[i]+size[i]*stack_time <=reclaim[i]);
%    c) we can't go beyond the time limit ????
constraint forall(i in STOCKPILE)(finished[i]<=maxtime);


% Stage B DONE
% Two stockpiles reclaimed by the same reclaimer do not overlap in time
%
% Tip: write your first custom predicate, i.e.
% predicate not_overlap(var STOCKPILE: s1, var STOCKPILE: s2) = reclaim[s2] >= finished[s1] \/ finished[s2] <= reclaim[s1];
% % <something something> ;
predicate not_overlap(var int: s1, var int: s2, var int: f1, var int: f2) = (s2 >= f1 \/ f2 <= s1);

constraint forall(s1,s2 in STOCKPILE where s1<s2 /\ which[s1]==which[s2])(not_overlap(reclaim[s1],reclaim[s2],finished[s1],finished[s2]));

% Stage C DONE
% 1) no stockpile can be reclaimed onto a ship before the arrival time of the ship
constraint forall(i in STOCKPILE)(arrival[ship[i]] <= reclaim[i]);
% 2) also no two stockpiles can be reclaimed onto the same ship at the same time. Make sure these reclaims do not overlap in time.
% TIP: reuse your "not_overlap" predicate
constraint forall(s1,s2 in STOCKPILE where s1<s2 /\ ship[s1]==ship[s2])(not_overlap(reclaim[s1],reclaim[s2],finished[s1],finished[s2]));



% Stage D DONE
% Add constraints to your model to ensure that if a reclaimer finishes reclaiming a stockpile with westend at x and then has to start reclaiming a stockpile with westend at y there is at least |y − x| ∗ reclaim speed time between these two events.
% TIP: just make your "not_overlap" predicate smarter
% TIP: you can introduce local variables in the constraints/predicates
% let {
%  <local variables>
% } in <then something>

constraint forall(s1,s2 in STOCKPILE where s1<s2 /\ which[s1]==which[s2])(reclaim[s1] >= finished[s2] + abs(westend[s1]-westend[s2])*reclaim_speed \/ finished[s1] + abs(westend[s2]-westend[s1])*reclaim_speed <= reclaim[s2]);



% Stage E DONE
% Add a definition of the objective to your model and change the model to minimize this value.
% You may well need to significantly change your search strategy to get good solutions for the objective.

% TIP: definetely change the line below
var int: obj = sum(i in SHIP)(max([finished[j]|j in STOCKPILE where ship[j] = i]) - arrival[i]);




% Stage F DONE
% Add constraints in your model so that the two reclaimers on rail i numbered 2i − 1 and 2i for i ∈ 1..nr div 2 remain so the western one 2i − 1 is never east of the eastern one 2i. Note they can legitimately be in the same position (this is for simplicity, its not very real). Note that if there are
% an odd number of reclaimers the last reclaimer is on its own rail and has no further constraints.
% TIP: do some "channeling" and model reclaimers' positions explicitely with a new array of variables.

constraint not stageF \/ forall(s1,s2 in STOCKPILE where s1<s2 /\ which[s1]=which[s2]+1 /\ which[s1] mod 2 = 0)(not not_overlap(reclaim[s1],reclaim[s2],finished[s1],finished[s2])->eastend[s2]<=westend[s1]);

constraint not stageF \/ forall(s1,s2 in STOCKPILE where s1<s2 /\ which[s2]=which[s1]+1 /\ which[s2] mod 2 = 0)(not not_overlap(reclaim[s1],reclaim[s2],finished[s1],finished[s2])->eastend[s1]<=westend[s2]);



solve :: seq_search([ int_search([obj], input_order, indomain_min, complete),
                      int_search(westend, input_order, indomain_min, complete)
]) minimize obj; 


% don't change the output
output 
["westend  = ", show(westend), ";\n"] ++
["eastend  = ", show(eastend), ";\n"] ++
["stack    = ", show(stack), ";\n"] ++
["endstack = ", show(endstack), ";\n"] ++
["reclaim  = ", show(reclaim), ";\n"] ++
["finish   = ", show(finished) , ";\n"] ++
["which    = ", show(which), ";\n"] ++
["obj = ",show(obj), ";\n"]
;

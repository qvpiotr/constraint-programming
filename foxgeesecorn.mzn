int: f;
int: g;
int: c;
int: k;
set of int: Cap = 0..k;
int: t;
set of int: Trips = 1..t;
int: pf;
int: pg;
int: pc;

array[Trips] of var Cap: fox;
array[Trips] of var Cap: geese;
array[Trips] of var Cap: corn;

var int: maxValue = f*pf+g*pg+c*pc;
set of int: time = 0..t;  



% Go crazy here
array[time] of var 0..f: rf;
array[time] of var 0..g: rg;
array[time] of var 0..c: rc;

array[time] of var 0..f: lf;
array[time] of var 0..g: lg;
array[time] of var 0..c: lc;

%beginning
constraint (lf[0]=f /\ lg[0]=g /\ lc[0]=c);    
constraint (rf[0]=0 /\ rg[0]=0 /\ rc[0]=0);

% WEST -> EAST
constraint forall(i in Trips)(
  if (i mod 2) == 1 then(
    let{
        var int: lf_i =     
        if ((lf[i-1] - fox[i]) > 0 /\ (lc[i-1] - corn[i]) > 0 /\ (lg[i-1] - geese[i]) == 0) then lf[i-1] - fox[i] - 1
           
        elseif ((lf[i-1] - fox[i]) > 0 /\ (lg[i-1] - geese[i]) > 0 /\ ((lf[i-1] - fox[i]) > (lg[i-1] - geese[i]))) then lf[i-1] - fox[i] - 1
        
        else lf[i-1]-fox[i]
        
        endif
       } in lf[i]=lf_i
       
    /\
    
    let{
        var int: lg_i =
        if ((lg[i-1] - geese[i]) > 0 /\ (lf[i-1] - fox[i]) > 0 /\ (lf[i-1] - fox[i]) <= (lg[i-1] - geese[i])) then lg[i-1] - geese[i] - lf[i-1] + fox[i]
        
        elseif ((lg[i-1] - geese[i]) > 0 /\ (lc[i-1] - corn[i]) > 0 /\ (lf[i-1]- fox[i]) == 0 /\ ((lg[i-1] - geese[i]) > (lc[i-1] - corn[i]))) then lg[i-1] - geese[i] - 1
        
        else lg[i-1] - geese[i]
        
        endif
      } in lg[i]=lg_i 
      
    /\
        
    let{
        var int: lc_i = 
        
        if ((lc[i-1] - corn[i]) > 0 /\ (lf[i-1] - fox[i]) > 0 /\ (lg[i-1] - geese[i]) == 0) then lc[i-1] - corn[i] - 1
        
        elseif ((lc[i-1] - corn[i]) > 0 /\ (lf[i-1] - fox[i]) == 0 /\ (lg[i-1] - geese[i]) > 0 /\ (lg[i-1] - geese[i]) <= (lc[i-1] - corn[i])) then lc[i-1] - corn[i] - lg[i-1] + geese[i]
    
        elseif ((lc[i-1] - corn[i]) > 0 /\ (lf[i-1] - fox[i]) == 0 /\ (lg[i-1] - geese[i]) > 0 /\ (lg[i-1] - geese[i]) > (lc[i-1] - corn[i])) then lc[i-1] - corn[i] - 1
        
        else lc[i-1] - corn[i]      
        endif    
      } in lc[i] = lc_i
      
    )
else lf[i] = lf[i-1] + fox[i] /\ lg[i] = lg[i-1] + geese[i] /\ lc[i] = lc[i-1] + corn[i]

endif 
);

% WEST <- EAST
constraint forall(i in Trips)(
  if (i mod 2) == 0 then(
    let{
        var int: rf_i =
        if ((rf[i-1] - fox[i]) > 0 /\ (rc[i-1] - corn[i]) > 0 /\ (rg[i-1] - geese[i]) == 0) then rf[i-1] - fox[i] - 1
        
        elseif ((rf[i-1] - fox[i]) > 0 /\ (rg[i-1] - geese[i]) > 0 /\ ((rf[i-1] - fox[i]) > (rg[i-1] - geese[i]))) then rf[i-1] - fox[i] - 1
        
        else rf[i-1]-fox[i]   
        endif
       } in rf[i]=rf_i
       
    /\
    
    let{
        var int: rg_i =
        if ((rg[i-1] - geese[i]) > 0 /\ (rf[i-1] - fox[i]) > 0 /\ (rf[i-1] - fox[i]) <= (rg[i-1] - geese[i])) then rg[i-1] - geese[i] - rf[i-1] + fox[i]
            
        elseif ((rg[i-1] - geese[i]) > 0 /\ (rc[i-1] - corn[i]) > 0 /\ (rf[i-1]- fox[i]) == 0 /\ ((rg[i-1] - geese[i]) > (rc[i-1] - corn[i]))) then rg[i-1] - geese[i] - 1      
        else rg[i-1] - geese[i]   
        endif   
      } in rg[i]=rg_i 
      
    /\
        
    let{
        var int: rc_i = 
        if ((rc[i-1] - corn[i]) > 0 /\ (rf[i-1] - fox[i]) > 0 /\ (rg[i-1] - geese[i]) == 0) then rc[i-1] - corn[i] - 1
        
        elseif ((rc[i-1] - corn[i]) > 0 /\ (rf[i-1] - fox[i]) == 0 /\ (rg[i-1] - geese[i]) > 0 /\ (rg[i-1] - geese[i]) <= (rc[i-1] - corn[i])) then rc[i-1] - corn[i] - rg[i-1] + geese[i]
        
        elseif ((rc[i-1] - corn[i]) > 0 /\ (rf[i-1] - fox[i]) == 0 /\ (rg[i-1] - geese[i]) > 0 /\ (rg[i-1] - geese[i]) > (rc[i-1] - corn[i])) then rc[i-1] - corn[i] - 1
        
        else rc[i-1] - corn[i]
        endif
      } in rc[i] = rc_i
      
    )
else rf[i] = rf[i-1] + fox[i] /\ rg[i] = rg[i-1] + geese[i] /\ rc[i] = rc[i-1] + corn[i]

endif 
);

constraint forall(i in Trips)(fox[i]+geese[i]+corn[i] <= k);


constraint fox[1] + geese[1] + corn[1] >= 1;

constraint obj <= maxValue /\ obj >= pf;


constraint forall(i in Trips)(
  if (i mod 2) == 1 then (fox[i] <= lf[i-1] /\ geese[i] <= lg[i-1] /\ corn[i] <= lc[i-1])
  else (fox[i] <= rf[i-1] /\ geese[i] <= rg[i-1] /\ corn[i] <= rc[i-1])  
  endif 
);


var int: obj = rf[t]*pf + rg[t]*pg + rc[t]*pc;   
   


solve :: seq_search([int_search(fox, first_fail, indomain_max, complete),int_search([t], first_fail, indomain_split, complete)])

maximize obj;


   



output ["fox = ", show(fox), ";\n"] ++
     ["geese = ", show(geese), ";\n"]++
     ["corn = ", show(corn), ";\n"]++
     ["trips = ", show(t), ";\n"]++
     ["obj = ", show(obj), ";\n"];   
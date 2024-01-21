 global env
 set i $env(var)
 mol new solutioncal$i.pdb 
 set solute [atomselect top "not water"] 
 $solute writepdb solutecal$i.pdb
 exit
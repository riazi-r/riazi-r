set gama [atomselect top "segname PROA and resid 17 to 132 or segname PROB and resid 15 to 165 or segname PROC and resid 1 to 107 or segname CARA or segname PROD and resid 17 to 132 or segname PROE and resid 15 to 165 or segname PROF and resid 1 to 107 or segname CARC"]

set beta [atomselect top "segname PROG and resid 133 to 193 or segname PROH and resid 166 to 461 or segname PROI and resid 108 to 411 or segname CARB"]

#set gb [atomselect $gama1 $gama2 $beta]
set gb [atomselect top "segname A19 and resid 17 to 132 or segname B19 and resid 15 to 165 or segname C19 and resid 1 to 107 or segname CARA or segname PROD and resid 17 to 132 or segname PROE and resid 15 to 165 or segname PROF and resid 1 to 107 or segname CARC or segname PROG and resid 133 to 193 or segname PROH and resid 166 to 461 or segname PROI and resid 108 to 411 or segname CARB"]
set com1 [measure center $gama weight mass]
set com2 [measure center $beta weight mass]
set dist [veclength [vecsub $com1 $com2]]
set mw1 [measure sumweights $gama weight mass]
set mw2 [measure sumweights $beta weight mass]
set ch1 [eval "vecadd [$gama get charge]"]
set ch2 [eval "vecadd [$beta get charge]"]

#set matrix [transaxis x +3]
#$sel2 moveby [vecscale -1.0 $com2]
#$sel2 move $matrix
#$sel2 moveby $com2
#$sel moveby [vecscale -1.0 $com]
#$sel move $matrix
#$sel moveby $com
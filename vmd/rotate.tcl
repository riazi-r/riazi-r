set sel [atomselect top "segname PAE1 PAF1 PAG1 PAH1 HAB1"]
set sel2 [atomselect top "segname PAA1 PAB1 PAC1 PAD1 HAA1"]
set com [measure center $sel weight mass]
set com2 [measure center $sel2 weight mass]
#set matrix [transaxis x +3]
#$sel2 moveby [vecscale -1.0 $com2]
#$sel2 move $matrix
#$sel2 moveby $com2
#$sel moveby [vecscale -1.0 $com]
#$sel move $matrix
#$sel moveby $com
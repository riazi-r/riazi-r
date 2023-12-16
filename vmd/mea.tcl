set gama [atomselect top "index 0 to 12145"]
set beta [atomselect top "index 12146 to 22566"]
set com [measure center $gama weight mass]
set com2 [measure center $beta weight mass]
set mw1 [measure sumweights $gama weight mass]
set mw2 [measure sumweights $beta weight mass]
set ch1 [eval "vecadd [$gama get charge]"]
set ch2 [eval "vecadd [$beta get charge]"]
set dist [veclength [vecsub $com $com2]]
#$gama moveby {0 0 2}
#set matrix [transaxis x +3]
#$sel2 move $matrix
#$sel2 moveby $com2
#$sel moveby [vecscale -1.0 $com]
#$sel move $matrix
#$sel moveby $com
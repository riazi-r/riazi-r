#Here it is assumed thata there are 4 CAL ions as legands and 2 identical Protein segments each harboring 2 CAL ions as ligand in a mirror style (Like Firinogen).
#Also it is assumed that the position of one of the pairs of CAL ions relative to their protein segment is ok and hence can be used
# to midify and finetune the position of the other 2 CAL ions wrt. their pertinent protein segment.

set a [atomselect top "segname CO1"]
set b [atomselect top "segid PROC and (same resid as (protein and within 5 of segname CO1))"]
set list1 [$b get resid]
set c [atomselect top "segname EO1"]
set d [atomselect top "segid PROL and resid $list1"]
set com [measure center $a]
set com2 [measure center $b]
set m [vecsub $com $com2]
set com3 [measure center $c]
set com4 [measure center $d]
set n [vecsub $com3 $com4]
set diff [vecsub $m $n]
$c moveby $diff

set a [atomselect top "segname BO1"]
set b [atomselect top "(same resid as (protein and within 5 of segname BO1)) and segid PROB"]
set list1 [$b get resid]
set c [atomselect top "segname DO1"]
set d [atomselect top "segid PROK and resid $list1"]
set com [measure center $a]
set com2 [measure center $b]
set m [vecsub $com $com2]
set com3 [measure center $c]
set com4 [measure center $d]
set n [vecsub $com3 $com4]
set diff [vecsub $m $n]
$c moveby $diff

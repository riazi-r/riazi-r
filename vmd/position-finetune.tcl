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
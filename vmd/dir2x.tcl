set right [atomselect top "segid PROA to PROC CARA or index 0 to 5917"]
set left [atomselect top "segid PROJ to PROL CARB or index 5918 to 16940"]
set com [measure center $left weight mass]
set com2 [measure center $right weight mass]
set dir [vecnorm [vecsub $com2 $com]]
set matrix [transvecinv $dir]
set all [atomselect top all]
$all move $matrix
$all writegro solute-rotate.gro

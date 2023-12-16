set a [atomselect top "segname PROC and resid 398 and name CD"] 
set aindex [$a get index]

set b [atomselect top "segname MROF and resid 406 and name NZ"] 
set bindex [$b get index]

topo addbond $aindex $bindex
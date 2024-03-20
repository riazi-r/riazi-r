set a [atomselect top "segname PROC and resid 398 and name CD"] 
set aindex [$a get index]

set b [atomselect top "segname PROL and resid 406 and name NZ"] 
set bindex [$b get index]

topo addbond $aindex $bindex
topo guessdihedrals
topo guessangles
#topo guessimpropers [tolerance <degrees>]

#topo getbondlist [type|order|both|none]
#topo getanglelist
#topo get(dihedral|improper)list

topo numbonds
topo numangles
topo numdihedrals
topo numimpropers
topo numcrossterms

set all [atomselect top all]
package require topotools
set mol [::TopoTools::selections2mol $all]
animate write psf crossed.psf $mol
animate write pdb crossed.pdb $mol

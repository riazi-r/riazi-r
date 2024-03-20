set nh2glutamin [atomselect top "segname PROC and resid 398 and name NE2"] 
set nh2index [$nh2glutamin get index]
set h1glutamin [atomselect top "segname PROC and resid 398 and name HE21"] 
set h1index [$h1glutamin get index]
set h2glutamin [atomselect top "segname PROC and resid 398 and name HE22"] 
set h2index [$h2glutamin get index]
set cglutamin [atomselect top "segname PROC and resid 398 and name CD"] 
set cindex [$cglutamin get index]

set hlysin [atomselect top "segname PROL and resid 406 and name HZ3"]
set hindex [$hlysin get index]
set nlysin [atomselect top "segname PROL and resid 406 and name NZ"] 
set nindex [$nlysin get index]


topo delbond $nh2index $cindex
topo delbond $nh2index $h1index
topo delbond $nh2index $h2index
topo delbond $hindex $nindex
topo addbond $cindex $nindex

set nh2glutamin2 [atomselect top "segname PROL and resid 398 and name NE2"] 
set nh2index2 [$nh2glutamin2 get index]
set h1glutamin2 [atomselect top "segname PROL and resid 398 and name HE21"] 
set h1index2 [$h1glutamin2 get index]
set h2glutamin2 [atomselect top "segname PROL and resid 398 and name HE22"] 
set h2index2 [$h2glutamin2 get index]
set cglutamin2 [atomselect top "segname PROL and resid 398 and name CD"] 
set cindex2 [$cglutamin2 get index]

set hlysin2 [atomselect top "segname PROC and resid 406 and name HZ3"]
set hindex2 [$hlysin2 get index]
set nlysin2 [atomselect top "segname PROC and resid 406 and name NZ"] 
set nindex2 [$nlysin2 get index]

topo delbond $nh2index2 $cindex2
topo delbond $nh2index2 $h1index2
topo delbond $nh2index2 $h2index2
topo delbond $hindex2 $nindex2
topo addbond $cindex2 $nindex2


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

#set all [atomselect top all]
set crossed [atomselect top "not (index $nh2index $h1index $h2index $hindex $nh2index2 $h1index2 $h2index2 $hindex2)"]
package require topotools
set mol [::TopoTools::selections2mol $crossed]
animate write psf crossed.psf $mol
animate write pdb crossed.pdb $mol

#merge two copies of the solute into one file
if {0} {
set midlist {}
set mol [mol new solute.psf waitfor all]
mol addfile solute.pdb
lappend midlist $mol
set mol2 [mol new solute2.psf waitfor all]
mol addfile solute2.pdb
lappend midlist $mol2           
    
set mol [::TopoTools::mergemols $midlist]

animate write psf combined2.psf $mol
animate write pdb combined2.pdb $mol
}
if {1} {
set tcl_precision 2
mol new step3_input.psf
mol addfile step3_input.pdb
set all [atomselect top all]
$all writegro step3_input_original.gro
set left [atomselect top "segid PROA PROB PROC or serial 1 to 2525"]
set right [atomselect top "segid PROD or serial 2526 to 5747"]
#$sel2 moveby {0.2 0 0}
set cm [measure center $left weight mass]
set cm2 [measure center $right weight mass]
set diff [vecsub $cm $cm2]
set dist [veclength $diff]
global env
set i $env(var)
#set i "20.0"
if {$dist != $i} {
 set delta [expr $i-$dist]
 set dir [vecnorm $diff]
 #set dir {0 1 0}
 $left moveby [vecscale $delta $dir]
}

}
set all [atomselect top all]
$all writegro step3_input.gro

 exit
 
if {0} {
mol load pdb solute.pdb psf solute.psf
#set a [atomselect top "segname PROA"]
mol load pdb solute2.pdb psf solute2.psf
resetpsf
readpsf solute.psf
coordpdb solute.pdb
# Select the protein.
set prot [atomselect top protein]
set glyc [atomselect top glycan]
set pre [expr 2]
# Delete the residues corresponding to the atoms we selected.
foreach segid [$prot get segid] resid [$prot get resid] {
$prot set segid $segid$pre
}
# Have psfgen write out the new psf and pdb file (VMD’s structure and
# coordinates are unmodified!).
$prot writepdb prot.pdb
writepsf test.psf
writepdb test.pdb
exit
}
if {0} {
set a [atomselect top all]
set minmax [measure minmax $a]
set xmin [lindex [lindex $minmax 0] 0]
set ymin [lindex [lindex $minmax 0] 1]
set zmin [lindex [lindex $minmax 0] 2]
set xmax [lindex [lindex $minmax 1] 0]
set ymax [lindex [lindex $minmax 1] 1]
set zmax [lindex [lindex $minmax 1] 2]
set dx [expr ($xmax-$xmin)/2]
set dy [expr ($ymax-$ymin)/2]
set dz [expr ($zmax-$zmin)/2]
package require solvate
solvate solute.psf solute.pdb -x $dx +x $dx -y $dy +y $dy -z $dz +z $dz -o solution
exit
}


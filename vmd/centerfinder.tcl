set tcl_precision 3
set outfile [open solute.info w]
mol new solute.gro
mol addfile solute.psf

set right [atomselect top "segid PROA to PROC CARA or serial 1 to 5918 "]
set left [atomselect top "segid PROJ to PROL CARB or serial 5919 to 11836 "]
set com [measure center $left weight mass]
set com2 [measure center $right weight mass]


#in case COM distance of left & right groups needs to be changed, set below if argument from {0} to {1}:

if {0} {
set dist_init [vecdist $com $com2]
set goal_init "10.0"
if {$dist_init != $goal_init} {
 set dir [vecnorm [vecsub $cm $cm2]]
 set delta [expr $goal_init-$dist_init]
 $left moveby [vecscale $delta $dir]
 }
 }
#set index [$a list]
#for {set i 0} {$i < [llength $index]} {incr i} {
#get {x y z}

set meter 10
foreach coord [$left get {x y z}] index [$left get index] {
 set dist [vecdist $coord $com]
 if { $dist <= $meter} {
  set meter $dist
  set centeratom1 $index
  }
  }

set meter 10
foreach coord [$right get {x y z}] index [$right get index] {
 set dist2 [vecdist $coord $com2]
 if { $dist2 <= $meter} {
  set meter $dist2
  set centeratom2 $index
  }
  }

set molid [molinfo top]
mol delrep 0 $molid
mol selection "not water and not protein"
mol color name
mol rep cpk 
mol addrep top

mol selection "protein"
mol color name
mol rep NewCartoon
mol addrep top

mol selection "index $centeratom1 $centeratom2"
mol color ColorID 1
mol rep VDW 4
mol addrep top 

set centeratom1 [expr ($centeratom1+1)]
puts $outfile "index of centeratom_left in gro/pdb file: $centeratom1"
set centeratom2 [expr ($centeratom2+1)]
puts $outfile "index of centeratom_right in gro/pdb file: $centeratom2"


set dist [vecdist $com2 $com]
puts $outfile "COM distance: $dist" 
set dir [vecnorm [vecsub $com2 $com]]
puts $outfile "direction vector : $dir"

set minmax [measure minmax [atomselect top all]]
set xbox [expr [lindex [lindex $minmax 1] 0]-[lindex [lindex $minmax 0] 0]]
set ybox [expr [lindex [lindex $minmax 1] 1]-[lindex [lindex $minmax 0] 1]]
set zbox [expr [lindex [lindex $minmax 1] 2]-[lindex [lindex $minmax 0] 2]]
puts $outfile "minmax coordinates: $minmax"
puts $outfile "box dimension without padding: X= $xbox Y= $ybox Z= $zbox"

set center [molinfo top get center]
puts $outfile "center coordinates: $center"

close $outfile 

set matrix [transvecinv $dir]
set all [atomselect top all]
$all move $matrix
$all writegro solute-rotate.gro

exit

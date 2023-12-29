set tcl_precision 3
#mol new boxedsoln.gro
set left [atomselect top "segid PROA to PROC CARA or index 0 to 5917"]
set right [atomselect top "segid PROJ to PROL CARB or index 5918 to 11835"]
set com [measure center $left weight mass]
set com2 [measure center $right weight mass]

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

mol selection "index $centeratom_down $centeratom_up"
mol color ColorID 1
mol rep VDW 4
mol addrep top 

set centeratom1 [expr ($centeratom1+1)]
puts "index of centeratom_left in gro/pdb file: $centeratom1"
set centeratom2 [expr ($centeratom2+1)]
puts "index of centeratom_right in gro/pdb file: $centeratom2"


set dist [vecdist $com2 $com]
puts "COM distance: $dist" 
set dir [vecnorm [vecsub $com2 $com]]
puts "direction vector : $dir"

set minmax [measure minmax [atomselect top all]]
set xbox [expr [lindex [lindex $minmax 1] 0]-[lindex [lindex $minmax 0] 0]]
set ybox [expr [lindex [lindex $minmax 1] 1]-[lindex [lindex $minmax 0] 1]]
set zbox [expr [lindex [lindex $minmax 1] 2]-[lindex [lindex $minmax 0] 2]]
puts "minmax coordinates: $minmax"
puts "box dimension without padding: X=$xbox Y=$ybox Z=$zbox"

set center [molinfo top get center]
puts "center coordinates: $center"

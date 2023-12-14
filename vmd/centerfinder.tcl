set tcl_precision 3
mol new boxedsoln.gro
set left [atomselect top "segid PROA to PROC CARA or index 0 to 5917"]
set right [atomselect top "segid PROJ to PROL CARB or index 5918 to 11835"]
set com [measure center $left weight mass]
set com2 [measure center $right weight mass]
set meter 10
#set index [$a list]
#for {set i 0} {$i < [llength $index]} {incr i} {
#get {x y z}

foreach coord [$left get {x y z}] index [$left get index] {
 set dist [vecdist $coord $com]
 if { $dist <= $meter} {
  set meter $dist
  set centeratom1 $index
  }
  }
set centeratom1 [expr ($centeratom1+1)]
puts "centeratom_left: $centeratom1"

set meter 10
foreach coord [$right get {x y z}] index [$right get index] {
 set dist2 [vecdist $coord $com2]
 if { $dist2 <= $meter} {
  set meter $dist2
  set centeratom2 $index
  }
  }
set centeratom2 [expr ($centeratom2+1)]
puts "centeratom_right: $centeratom2"
mol selection {index $centeratom1 $centeratom2}

set dist [vecdist $com $com2]
puts "com distance: $dist" 
set dir [vecsub $com2 $com]
puts "direction vector : $dir"

set minmax [measure minmax [atomselect top all]]
set xbox [expr [lindex [lindex $minmax 1] 0]-[lindex [lindex $minmax 0] 0]]
set ybox [expr [lindex [lindex $minmax 1] 1]-[lindex [lindex $minmax 0] 1]]
set zbox [expr [lindex [lindex $minmax 1] 2]-[lindex [lindex $minmax 0] 2]]
puts "minmax coordinates: $minmax"
puts "box dimension without padding: X=$xbox Y=$ybox Z=$zbox"

set center [molinfo top get center]
puts "center coordinates: $center"

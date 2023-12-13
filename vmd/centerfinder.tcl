#mol new boxedsoln.gro
set left [atomselect top "index 0 to 5917"]
set right [atomselect top "index 5918 to 11835"]
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
puts "$centeratom1"

set meter 10
foreach coord [$right get {x y z}] index [$right get index] {
 set dist2 [vecdist $coord $com2]
 if { $dist2 <= $meter} {
  set meter $dist2
  set centeratom2 $index
  }
  }
puts "$centeratom2"
mol selection {index $centeratom1 $centeratom2}

set dist [vecdist $com $com2]
puts "com distance: $dist" 
set dir [vecsub $com2 $com]
puts "direction vector : $dir"
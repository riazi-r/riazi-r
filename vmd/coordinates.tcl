mol new solvate.pdb
set sel [atomselect top "name OH2"]
$sel num
set xyz [$sel get {x y z}]
set outfile [open sol.info w]
puts $outfile $xyz
close $outfile
exit
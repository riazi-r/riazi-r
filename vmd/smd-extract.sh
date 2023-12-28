### Open the log file for reading and the output .dat file for writing
global env
set i $env(var)
set file [open "smd-10-$i-log.txt" r]
set file2 [open "smd.10-$i-restart-log.txt" r]
set output [open "force$i.dat" w]

### Loop over all lines of the log file
while { [gets $file line] != -1 } {

   ### Determine if a line contains SMD output. If so, write the
   ### current z position followed by the force along z scaled by
   ### by the direction of pulling (0,0,-1)

   if {[string range $line 0 3] == "SMD "} {
      puts $output "[expr [lindex $line 5]]        [expr [lindex $line 6]]        [expr [lindex $line 7]]"
   }

}

### Close the log file and the output file
close $file

while { [gets $file2 line] != -1 } {

   ### Determine if a line contains SMD output. If so, write the
   ### current z position followed by the force along z scaled by
   ### by the direction of pulling (0,0,-1)

   if {[string range $line 0 3] == "SMD "} {
      puts $output "[expr [lindex $line 5]]        [expr [lindex $line 6]]        [expr [lindex $line 7]]"
   }

}

### Close the log file and the output file
close $file2
close $output

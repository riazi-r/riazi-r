### Open the log file for reading and the output .dat file for writing
set file [open "AmtB-SMD01A.log" r]
set output [open "FvsP-1A.dat" w]

### Loop over all lines of the log file
while { [gets $file line] != -1 } {

   ### Determine if a line contains SMD output. If so, write the
   ### current z position followed by the force along z scaled by
   ### by the direction of pulling (0,0,-1)

   if {[string range $line 0 3] == "SMD "} {
      puts $output "[expr [lindex $line 4]] [expr -1*[lindex $line 7]]"
   }

}

### Close the log file and the output file
close $file
close $output

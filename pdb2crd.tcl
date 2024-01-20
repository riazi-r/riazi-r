proc writecharmmcoor {filename usemolid outtype} {
	# Requirements: PSF and coordinates loaded in VMD 
	# Arguments: filename (string), molid to use (int), and type of charmm coordinate file to write (string: normal/expanded)
	# can take a while on files with >50,000 atoms
	
	set numatoms [molinfo $usemolid get numatoms]
	set all [atomselect top "all"]
	
	# check if normal-format compatible
	if {[string match $outtype "normal"]==1} {
		if { $numatoms > 99999 } {
			puts "Using expanded format, number of atoms is greater than 99999"
			set outtype "expanded"
		}
		set maxseg 0
		foreach {segname} [lsort -unique [$all get segname]] {
			set current [string length $segname]
			if { $current > $maxseg } {
				set maxseg $current
			}
		}
		if { $maxseg > 4 } {
			puts "Using expanded format, at least one VMD segment name is more than 4 characters"
			set outtype "expanded"
		}	
		set maxres 0
		foreach {resname} [lsort -unique [$all get resname]] {
			set current [string length $resname]
			if { $current > $maxres } {
				set maxres $current
			}
		}	
		if { $maxres > 4 } {
			puts "Using expanded format, at least one VMD residue name is more than 4 characters"
			set outtype "expanded"
		}			
	}
	unset maxres
	unset maxseg
	$all delete
	
	
	# Begin writing CHARMM file
	set output [open $filename "w"]
	
	# header
	puts $output "* CHARMM coordinates generated from VMD"
	if {[string match $outtype "normal"]==1} {
		puts $output "[format "%5i" $numatoms]"
	}
	if {[string match $outtype "expanded"]==1} {
		puts $output "[format "%10i" $numatoms]  EXT"
	}

	# atom lines
	set weighting "0"
	set countres "1"
	for {set i 0} {$i < $numatoms} {incr i} {
		# gather atom information
		set selection [atomselect $usemolid "index $i"]
	
		set segmentid [$selection get segname]
		set residueid [$selection get resid]
		# increment CHARMM residue number as segment ID or residue ID changes
		if {$i > 0} {
			if {$prevresid != $residueid || $prevsegmentid != $segmentid} {
				set countres [expr "$countres + 1"]
			}
		}
		set resno "$countres"
		set prevresid [$selection get resid]
		set prevsegmentid [$selection get segname]
	
		# output
		if {[string match $outtype "normal"]==1} {
			puts $output "[format "%5i" [expr "$i + 1"]][format "%5i" $resno] [format "%-4s" [$selection get resname]] [format "%-4s" [$selection get name]][format "%10.5f" [$selection get x]][format "%10.5f" [$selection get y]][format "%10.5f" [$selection get z]] [format "%-4s" $segmentid] [format "%-4s" $residueid][format "%10.5f" $weighting]"
        }

		if {[string match $outtype "expanded"]==1} {
			puts $output "[format "%10i" [expr "$i + 1"]][format "%10i" $resno]  [format "%-8s" [$selection get resname]]  [format "%-8s" [$selection get name]][format "%20.10f" [$selection get x]][format "%20.10f" [$selection get y]][format "%20.10f" [$selection get z]]  [format "%-8s" $segmentid]  [format "%-8s" $residueid][format "%20.10f" $weighting]"
		}

		# cleanup
		$selection delete
		unset selection
		unset resno
		unset segmentid
		unset residueid
	}
	close $output
	puts "Done with conversion"
set ref [atomselect 0 "segid PROA to PROC"]
set sel [atomselect 1 "segid PROJ to PROL"]
set matrix [measure fit $sel $ref]
set all [atomselect 1 all]
$all move $matrix
set cal [atomselect 1 "segid CAL"]
$cal writepdb cal.pdb
mol new cal.pdb
package require psfgen	 
topology top_all27_prot_lipid.inp	
segment cal {pdb cal.pdb}	 
coordpdb cal.pdb cal	 
guesscoord	 
writepdb cal.pdb	 
writepsf cal.psf
# then cal.psf and cal.pdb shall be merged with solute files to give the final solutecal files.

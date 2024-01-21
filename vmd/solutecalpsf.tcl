resetpsf
readpsf solutioncal.psf
coordpdb solutioncal.pdb
mol load psf solutioncal.psf pdb solutioncal.pdb
# Select waters that are more than 10 Angstroms from the protein.
set badwater1 [atomselect top "resid TIP3W"]
# Delete the residues corresponding to the atoms we selected.
foreach segid [$badwater1 get segid] resid [$badwater1 get resid] {
delatom $segid $resid
}
# Have psfgen write out the new psf and pdb file (VMD's structure and
# coordinates are unmodified!).
writepsf solutecal.psf
writepdb solutecal.pdb
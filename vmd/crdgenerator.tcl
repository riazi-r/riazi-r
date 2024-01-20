mol new solute.psf 
mol addfile solute.pdb
source pdb2crd.tcl
writecharmmcoor "solute.crd" 0 "normal"
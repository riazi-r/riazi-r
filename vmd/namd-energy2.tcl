set PSF_FILE spheres
set DCD_FILE spheres_7.2
mol new ${PSF_FILE}.psf
mol addfile ${DCD_FILE}.dcd waitfor all
set sel1 [atomselect top "segid WT1"]
set sel2 [atomselect top "segid WT2"]
set exec "C:/Users/Sony/Desktop/watersphere/NAMD2/namd2"
set prm "{C:/Users/Sony/Desktop/watersphere/toppar_water_ions.str}"
set tempfile "sphener"
set outfile "sphener"
set xsc "{C:/Users/Sony/Desktop/watersphere/namd-temp.xsc}"
package require namdenergy
namdenergy -sel $sel1 $sel2 -exe $exec - par $prm -vdw -elec -nonb -timemult 2 -keepforce -extsys $xsc -pme -tempname ${tempfile} -ofile ${outfile}
#############################################################
exit

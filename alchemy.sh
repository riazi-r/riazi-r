FREE_ENERGY=`pwd`
NAMD=/home/riazi/namdgpu
ermod=/home/riazi/ermod/build
#for (( i=1; i<1; i++ ))

for i in 2 6 11 12 3 7 
do
    #i=$i
    BEAD=B$i
    cd $BEAD
    mkdir fepback
    cd fepback 
    cp ../fepback.conf ../solution.pdb ../solution.psf ./
    cp -r ../toppar ./
    cp ../solutionRUN/solutionRUN.coor ./
    cp ../solutionRUN/solutionRUN.vel ./
    cp ../solutionRUN/solutionRUN.xsc ./	   
	
		
	 #Runs for FEP BAR Calculation
       if $NAMD/charmrun $NAMD/namd3 +idlepoll +p6 +devices 0 fepback.conf > fepback_B$i.log
       then
       cd ..
       mkdir fepfwd
       cd fepfwd
       cp ../fepforw.conf ../solution.pdb ../solution.psf ./
       cp -r ../toppar ./
       cp ../fepback/fepback.coor ./
       cp ../fepback/fepback.vel ./
       cp ../fepback/fepback.xsc ./
       $NAMD/charmrun $NAMD/namd3 +idlepoll +p6 +devices 0 fepforw.conf > fepforw_B$i.log
       else false
       fi 
	   
	cd ../fepback
	mv fepback.fepout fepback_B$i.fepout 
	mv fepback.coor fepback_B$i.coor
	mv fepback.vel fepback_B$i.vel
	mv fepback.xsc fepback_B$i.xsc
	mv fepback.xst fepback_B$i.xst
	
		
	cd ../fepfwd 
	mv fepforw.fepout fepforw_B$i.fepout 
	mv fepforw.coor fepforw_B$i.coor
	mv fepforw.vel fepforw_B$i.vel
	mv fepforw.xsc fepforw_B$i.xsc
	mv fepforw.xst fepforw_B$i.xst
	echo "Ending. Job completed for bead = $BEAD"
	cd $FREE_ENERGY
done
 
exit;

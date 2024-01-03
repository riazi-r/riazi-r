#!/bin/bash

# Set some environment variables 
FREE_ENERGY=`pwd`
NAMD=/home/riazi/namdgpu
ermod=/home/riazi/ermod/build
#for (( i=1; i<1; i++ ))
for i in 11 12 3 7 
do
    #i=$i
    BEAD=B$i
    cd $BEAD
    #mkdir Run
	#cd Run
	#mv $FREE_ENERGY/$BEAD/solute.psf $FREE_ENERGY/$BEAD/solute.pdb ./
	cp $FREE_ENERGY/fepback.conf $FREE_ENERGY/fepforw.conf ./
    cp $FREE_ENERGY/solventmin.conf $FREE_ENERGY/solventNPT.conf $FREE_ENERGY/solventRUN.conf $FREE_ENERGY/solutionmin.conf ./
	cp $FREE_ENERGY/solutionNVT.conf $FREE_ENERGY/solutionNPT.conf $FREE_ENERGY/solutionRUN.conf ./
	#cp  $FREE_ENERGY/solutemin.conf $FREE_ENERGY/soluteNVT.conf $FREE_ENERGY/soluteRun.conf ./
    cp $FREE_ENERGY/pass.txt ./
    sudo cp $FREE_ENERGY/gen_structure $FREE_ENERGY/gen_input $ermod/share/ermod/tools/NAMD/
	cp $FREE_ENERGY/toppar.zip $FREE_ENERGY/fep.tcl ./

    unzip toppar.zip	
	vmd -e $FREE_ENERGY/solutiongen2.tcl
        sleep 10
	vmd -e $FREE_ENERGY/solventgen.tcl
	vmd -e $FREE_ENERGY/fixgen.tcl
	vmd -e $FREE_ENERGY/fepgen.tcl
	vmd -e $FREE_ENERGY/pbcgen.tcl
	python3 $FREE_ENERGY/pbcwriter.py
	

    # Runs for Solution Equilibration
    mkdir solutionmin
    cd solutionmin
    cp ../solutionmin.conf ../solution.psf ../solution.pdb ./
    cp -r ../toppar ./
    $NAMD/charmrun $NAMD/namd3 +idlepoll +p6 +devices 0 solutionmin.conf > solutionmin_$BEAD.log &&
    cd ..
    mkdir solutionNVT
    cd solutionNVT
    cp ../solutionNVT.conf ../solution.psf ../solution.pdb ./
    cp -r ../toppar ./
    cp ../solutionmin/solutionmin.coor ./
    $NAMD/charmrun $NAMD/namd3 +idlepoll +p6 +devices 0 solutionNVT.conf > solutionNVT_$BEAD.log &&
    cd ..
    mkdir solutionNPT
    cd solutionNPT
    cp ../solutionNPT.conf ../solution.psf ../solution.pdb ./
    cp -r ../toppar ./
    cp ../solutionNVT/solutionNVT.coor ./
    cp ../solutionNVT/solutionNVT.vel ./
    cp ../solutionNVT/solutionNVT.xsc ./
    $NAMD/charmrun $NAMD/namd3 +idlepoll +p6 +devices 0 solutionNPT.conf > solutionNPT_$BEAD.log &&
    cd ..
    mkdir solutionRUN
    cd solutionRUN
    cp ../solutionRUN.conf ../solution.psf ../solution.pdb ./	
    cp -r ../toppar ./
    cp ../solutionNPT/solutionNPT.coor ./
    cp ../solutionNPT/solutionNPT.vel ./
    cp ../solutionNPT/solutionNPT.xsc ./
	# Runs for ERMOD Feed preparation
    $NAMD/charmrun $NAMD/namd3 +idlepoll +p6 +devices 0 solutionRUN.conf > solutionRUN_$BEAD.log &&
    vmd -e $FREE_ENERGY/rigidgen.tcl
    cd ..
    mkdir solventmin
    cd solventmin
    cp ../solventmin.conf ../solvent.psf ../solvent.pdb ./
    cp -r ../toppar ./
    $NAMD/charmrun $NAMD/namd3 +idlepoll +p6 +devices 0 solventmin.conf > solventmin_$BEAD.log &&
    cd ..
    mkdir solventNPT
    cd solventNPT
    cp ../solventNPT.conf ../solvent.psf ../solvent.pdb ./
    cp -r ../toppar ./
    cp ../solventmin/solventmin.coor ./
    $NAMD/charmrun $NAMD/namd3 +idlepoll +p6 +devices 0 solventNPT.conf > solventNPT_$BEAD.log &&
    cd ..
    mkdir solventRUN
    cd solventRUN
    cp ../solventRUN.conf ../solvent.psf ../solvent.pdb ./
    cp -r ../toppar ./
    cp ../solventNPT/solventNPT.coor ./
    cp ../solventNPT/solventNPT.vel ./
    cp ../solventNPT/solventNPT.xsc ./
    $NAMD/charmrun $NAMD/namd3 +idlepoll +p6 +devices 0 solventRUN.conf > solventRUN_$BEAD.log &&
    #$NAMD/charmrun $NAMD/namd3 +idlepoll +p2 +devices 0 solutemin.conf > solutemin.log
    #$NAMD/charmrun $NAMD/namd3 +idlepoll +p2 +devices 0 soluteNVT.conf > soluteNVT.log
	#$NAMD/charmrun $NAMD/namd3 +idlepoll +p2 +devices 0 soluteRUN.conf > soluteRUN.log
	
       
    cd ..
		
	#ERMOD Runs 
	cat input.txt | $ermod/share/ermod/tools/NAMD/gen_structure --psf solution.psf --conf solutionRUN.conf &&
    
	cd soln
	$ermod/share/ermod/tools/NAMD/gen_input --dcd ../solutionRUN/solutionRUN.dcd --log ../solutionRUN/solutionRUN_$BEAD.log &&
	cp $FREE_ENERGY/parameters_er_soln ./ &&
	rm parameters_er &&
	mv parameters_er_soln parameters_er &&
       sudo mpirun -np 4 $ermod/bin/ermod --allow-run-as-root &
	
	cd ../refs
	$ermod/share/ermod/tools/NAMD/gen_input --dcd ../solventRUN/solventRUN.dcd --log ../solventRUN/solventRUN_$BEAD.log --rigid  ../solutionRUN/solute_rigid.pdb &&
	cp $FREE_ENERGY/parameters_er_refs ./
	rm parameters_er
	mv parameters_er_refs parameters_er
	#cp $FREE_ENERGY/pass.txt ./
	sudo mpirun -np 4 $ermod/bin/ermod --allow-run-as-root &&
	
	cd ..
	sudo mpirun -np 4 $ermod/bin/slvfe --allow-run-as-root |& tee -a slvfe_$BEAD.log &
				
	#
	#tar czvf refs_B_$i.tar.gz refs
	#tar czvf soln_B_$i.tar.gz soln
    #cp  refs_B_$i.tar.gz /content/gdrive/MyDrive/sim/ 
    #cp  soln_B_$i.tar.gz /content/gdrive/MyDrive/sim/
	#tar czfv B$i.tar.gz $FREE_ENERGY/B$i
    #cp  B$i.tar.gz /content/gdrive/MyDrive/sim/
	
	echo "Ending. Job completed for  = $BEAD"
	cd $FREE_ENERGY
done
 
exit;

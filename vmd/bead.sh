start=`date +%s`

pairs=`pwd`
method=smd
for i in 1-2 2-2 2-3 2-4 3-4
#1-1 4-4 1-3 1-4 3-3 
do
  destination=$pairs/$i/Run/$method.auto
  source1=$pairs/$i/Run/charmm-gui/gromacs
  source2=$pairs/$i/Run
  source3=$pairs/source  
  cd $source1
  #first=$(awk '/ATOM/{print NR}' $source1/step3_input.pdb)
  first=$(awk '/ATOM/ { print NR; exit}' $source1/step3_input.pdb)
  last=$(awk '$0~"ATOM"{n=NR}END{print n}' $source1/step3_input.pdb)
     #i=0
     #j=1
  echo > bead$i.txt
  
  for (( line=$first; line<=$last; line+=1 ))
  do
   resid=$(awk -v "a=$line" 'NR==a {print $5}' $source1/step3_input.pdb)
   resname=$(awk -v "a=$line" 'NR==a {print $4}' $source1/step3_input.pdb)
   atom=$(awk -v "a=$line" 'NR==a {print $3}' $source1/step3_input.pdb)
   #awk '{ $0 = "'$resid'':''$resname'':''$atom' " } {print}' bead.txt > temp.txt && mv temp.txt bead.txt
   echo -n "$resid:$resname:$atom " >> bead$i.txt	
	
  done
	 
#sed -e "s/.\{160\}/&\n/g" < bead.xml

done

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
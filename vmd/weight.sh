start=`date +%s`

pairs=`pwd`
method=smd
for i in 4-4 
#1-1  1-3 1-4 3-3 1-2 2-2 2-3 2-4 3-4
do
  destination=$pairs/$i/Run/$method.auto
  source1=$pairs/$i/Run/charmm-gui/gromacs
  source2=$pairs/$i/Run
  source3=$pairs/source  
  cd $source1
  first=$(awk '/!NATOM/ { print NR; exit}' $source1/step3_input.psf)
  first=$((first+1))
  last=$(awk '$0~"!NBOND"{n=NR}END{print n}' $source1/step3_input.psf)
  last=$((last-2))
     #i=0
     #j=1
  echo > weight$i.txt
  
  for (( line=$first; line<=$last; line+=1 ))
  do
   weight=$(awk -v "a=$line" 'NR==a {print $8}' $source1/step3_input.psf)
   echo -n "$weight " >> weight$i.txt	
	
  done
	 
#sed -e "s/.\{160\}/&\n/g" < bead.xml

done

end=`date +%s`
echo Execution time was `expr $end - $start` seconds.
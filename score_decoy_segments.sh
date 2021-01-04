PDB=$1
read -a BREAKPOINTS < ~/twodomain_predcons/validationset/$PDB.sschunks
END=${BREAKPOINTS[-1]}
unset BREAKPOINTS[-2]
unset BREAKPOINTS[-1] 			# remove last two breakpoints
for DECOY in $(ls); do
	SCOREFILE=/data/pegasus/west/saint_results/validationset/C_scores_$PDB/"$DECOY"
	echo -n $DECOY " " > $SCOREFILE
	for BREAKPOINT in ${BREAKPOINTS[@]}; do
		NATIVE=~/twodomain_predcons/validationset/"$PDB"_"$BREAKPOINT"_$END.pdb
		OUTPUT=/data/pegasus/west/saint_results/validationset/split_decoys_C_$PDB/C_"$BREAKPOINT"_$DECOY 
		awk -v BP=$BREAKPOINT -v E=$END '{if ($6>BP && $6<=E) print $0}' $DECOY > $OUTPUT && TMalign=`~/Project/homes/oliveira/SAINT_laura/3rdparty/TMalign $OUTPUT $NATIVE | grep -m 1 TM-score= | awk '{print $2}'`
		echo -n $TMalign " " >> $SCOREFILE
	done
	echo -ne '\n' >> $SCOREFILE
done 



		

PDB=$1
SEG=$(grep "$PDB" ~/VALIDATIONSTUFF//Validationset_segments.txt | cut -d " " -f 2)
NATIVE=~/VALIDATIONSTUFF/$PDB.d1.pdb
for DECOY in $(ls ); do
	SCOREFILE=~/VALIDATIONSTUFF/whole_d1_scores_$PDB.txt
#	if [ ! -s $SCOREFILE ]
#		then
	OUTPUT=/data/pegasus/not-backed-up/west/validationset_d1/whole_d1_decoys_$PDB/"$DECOY"
	awk -v BP=$SEG '{if ($6<=BP) print $0}' $DECOY > $OUTPUT && 
	TMalign=$(~/Project/homes/oliveira/SAINT_laura/3rdparty/TMalign $OUTPUT $NATIVE | grep -m 1 TM-score= | awk '{print $2}')
	echo $PDB d1 $PDB.d1 $DECOY "whole" $TMalign >> $SCOREFILE
#	fi
done



		

PDB=$1
#SEG=$(grep "$PDB" /data/pegasus/not-backed-up/west/validationset_d2/Validationset_segments.txt | cut -d " " -f 2)
NATIVE=~/VALIDATIONSTUFF/$PDB.d1B.pdb
for DECOY in $(ls); do
	SCOREFILE=/data/pegasus/not-backed-up/west/validationset/whole_d1B_scores_$PDB/"$DECOY"
	if [[ -s $SCOREFILE ]] ; then
		:
#		echo "$SCOREFILE has data."
	else
#		echo "$SCOREFILE is empty."
#	OUTPUT=/data/pegasus/not-backed-up/west/validationset_d2/d2_decoys_$PDB/"$DECOY"
		echo -n $PDB.d1B $DECOY "whole " > $SCOREFILE
#	awk -v BP=$SEG '{if ($6>BP) print $0}' $DECOY > $OUTPUT && 
		TMalign=$(~/Project/homes/oliveira/SAINT_laura/3rdparty/TMalign $DECOY $NATIVE | grep -m 1 TM-score= | awk '{print $2}')
		echo $TMalign >> $SCOREFILE
	fi ; 
done



		

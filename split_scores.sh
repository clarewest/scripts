#!/bin/bash
PDB=$1
rm "$PDB"_d2.scores_final.txt
#rm eleanor_"$PDB".scores_final.txt
NATIVE="$PDB"_d2_seg_*.pdb
#NATIVE=/data/pegasus/west/saint_prep/twodomain_eleanor/"$PDB"_inverse*
#for DECOY in $(ls "$PDB"_c_n*/pegasus.stats.ox.ac.uk/*.cut); do
for DECOY in $(ls cut_decoys_"$PDB"/*); do
#	d2TM=`~/Project/Scripts/TMscore $DECOY $NATIVE | awk '/^TM-score    =/ { print $3; }'`
	d2TM=`~/Project/homes/oliveira/SAINT_laura/3rdparty/TMalign $DECOY $NATIVE | grep -m 1 TM-score= | awk '{print $2}'`
#	d2TM=`~/Project/Scripts/TMscore cut_decoys_"$PDB"/$DECOY $NATIVE | awk '/^TM-score    =/ { print $3; }'`
	echo $d2TM $PDB domain2 whole >> "$PDB"_d2.scores_final.txt
done

#for DECOY in $(awk '{print $2}' $PDB.scores_final.txt ); do d1TM=`~/Project/Scripts/TMscore "$PDB"_c_n_"$PDB".flib_10000_1000_t2.5_linear/$DECOY ../saint_prep/"$PDB".d1.pdb | awk '/^TM-score    =/ { print $3; }'`; d2TM=`~/Project/Scripts/TMscore "$PDB"_c_n_"$PDB".flib_10000_1000_t2.5_linear/$DECOY ../saint_prep/"$PDB".d2.pdb | awk '/^TM-score    =/ { print $3; }'` ; echo $DECOY $d1TM $d2TM >> "$PDB"_split.scores_final.txt; done

#!/bin/bash
PDB=$1
DOM=$2
METHOD=$3
SERVER=`echo $(hostname -f | cut -d "." -f1)`

#for DOM in $(echo d1 d2); do
	NATIVE=~/FINAL_SET_NATIVES/"$PDB"_new.pdb
	for DECOY in $(awk '{print $2}' $PDB.scores_final.txt); do
#	TMscore=`~/Project/homes/oliveira/SAINT_laura/3rdparty/TMscore "$PDB"_c_n_"$PDB".flib_*_linear/$DECOY $NATIVE | awk '/^TM-score    =/ { print $3; }'`
#		TMalign=`~/Project/homes/oliveira/SAINT_laura/3rdparty/TMalign d1intermediates_$PDB/$DECOY $NATIVE | grep -m 1 TM-score= | awk '{print $2}'`
		TMalign=`~/Project/homes/oliveira/SAINT_laura/3rdparty/TMalign "$PDB"_c_n_"$PDB".flib_*_linear/$DECOY $NATIVE | grep -m 1 TM-score= | awk '{print $2}'`
#		TMalign=`~/Project/homes/oliveira/SAINT_laura/3rdparty/TMalign $DECOY $NATIVE | grep -m 1 TM-score= | awk '{print $2}'`
#		TMalign=`~/Project/homes/oliveira/SAINT_laura/3rdparty/TMalign "$DOM"_decoys_"$PDB"/$DECOY $NATIVE | grep -m 1 TM-score= | awk '{print $2}'`
#		SOURCEDECOY=`echo $DECOY | cut -d "_" -f 1-10`
		echo $DECOY.$SERVER $PDB $TMalign $DOM $METHOD >> ~/FINAL_SET_NATIVES/"$PDB"."$DOM"_$METHOD.scores.txt
	done
#done

#for DECOY in $(awk '{print $2}' $PDB.scores_final.txt ); do d1TM=`~/Project/Scripts/TMscore "$PDB"_c_n_"$PDB".flib_10000_1000_t2.5_linear/$DECOY ../saint_prep/"$PDB".d1.pdb | awk '/^TM-score    =/ { print $3; }'`; d2TM=`~/Project/Scripts/TMscore "$PDB"_c_n_"$PDB".flib_10000_1000_t2.5_linear/$DECOY ../saint_prep/"$PDB".d2.pdb | awk '/^TM-score    =/ { print $3; }'` ; echo $DECOY $d1TM $d2TM >> "$PDB"_split.scores_final.txt; done

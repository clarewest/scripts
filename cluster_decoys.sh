
#!/bin/bash
declare -a ARRAY
DIR="/data/pegasus/west/saint_results/"
PDB="3or2F.d1"
FILE=$1
DECOYS="/data/pegasus/west/saint_results/"$PDB"_c_n_"$PDB".flib_10000_1000_t2.5_linear"
i=0
SET=`echo $FILE | cut -d "." -f 4`


for NATIVE in $(awk '{print $2}' $FILE)
	do
	j=0
	for MODEL in $(awk '{print $2}' "$DIR"/"$PDB".scores_final.txt)
		do
			ARRAY[$j]=`~/Project/Scripts/TMscore "$DECOYS"/$MODEL "$DECOYS"/$NATIVE | awk '/^TM-score    =/ { print $3; }'`
			((j++))
		#	echo $j
		done
	echo ${ARRAY[*]} >> "$PDB"_cluster_$SET.mat
done



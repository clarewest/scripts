echo "Set Target Length Beff SCOP_Class NumCon TargetPPV" > target_details.txt
for TARGET in $(cat list.txt); do LEN=$(tail -n1 $TARGET.fasta.txt | tr -d '\n' | wc -c); BEFF=$(cat $TARGET.beff); SCOP="unknown"; NUMCON=$(cat $TARGET.ppv | awk '{print $3}'); PPV=$(cat $TARGET.ppv | awk '{print $1}'); echo Foldon1 $TARGET $LEN $BEFF $SCOP $NUMCON $PPV; done  >> target_details.txt

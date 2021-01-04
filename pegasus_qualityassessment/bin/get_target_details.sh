echo "Set Target Length Beff SCOP_Class NumCon TargetPPV" > target_details.txt
for TARGET in $(cat list.txt); do LEN=$(cat $TARGET.fasta.ss2 | wc -l | awk '{print $1-2}'); BEFF=$(cat $TARGET.beff); SCOP="unknown"; NUMCON=$(cat $TARGET.ppv | awk '{print $3}'); PPV=$(cat $TARGET.ppv | awk '{print $1}'); echo Foldon1 $TARGET $LEN $BEFF $SCOP $NUMCON $PPV; done  >> target_details.txt

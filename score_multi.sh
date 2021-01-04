#rm score_table.txt
#rm score_table_reverse.txt
##rm score_table_invitro.txt
for OUTPUT in $(echo 1T43 1T43_N)
do

    rm /data/cockatrice/west/$OUTPUT.tmp
	echo $OUTPUT
	`cd $OUTPUT ; ~/Project/Scripts/score.sh $OUTPUT > /data/cockatrice/west/$OUTPUT.tmp ; cd /data/cockatrice/west/ `
    sed '1q;d' $OUTPUT.tmp >> $OUTPUT_score_table.txt
    sed '2q;d' $OUTPUT.tmp >> $OUTPUT_score_table_invitro.txt
    sed '3q;d' $OUTPUT.tmp >> $OUTPUT_score_table_reverse.txt 
   # rm /data/cockatrice/west/$OUTPUT.tmp
    cat $OUTPUT.tmp
done

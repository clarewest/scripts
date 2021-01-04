for FILE in $(awk '{print $2}' $1.scores_final.txt); do
#	echo "search: " $3$FILE$5
#	echo "filename: " $3inter_$FILE #| tee "$1"_d1intermediates/${DECOY}_$5
	SEARCH=`echo "$3"'\'/$FILE$5`
	cat $3/inter_$FILE | sed -n "/$SEARCH/,/END/p" > d1intermediates_$1/${FILE}$5
done

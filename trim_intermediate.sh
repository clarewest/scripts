BOUNDARY=`grep "$1" to_update_intermediates.txt | awk '{print $2}'`
for DECOY in $(ls d1intermediates_$1/); do
	awk -v B=$BOUNDARY '/^ATOM/ {if ($6<=B) print $0}' d1intermediates_$1/$DECOY > d1intermediates_$1/$DECOY.tmp && mv d1intermediates_$1/$DECOY.tmp d1intermediates_$1/$DECOY
done

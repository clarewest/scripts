
LIST=$1
for I in $(cat $LIST)
do
  # Clare edit: using -g instead of -n to handle scientific notation for very high values
  # $TARGET $DECOY $PPV $SCORE(x2) $EIGEN $SAULO $COMB $CON(x3) $Neff $TM $TM2 $PCONS $PROQ(x4) $PCOMBC;
    sort -k 6,6g -k 8,8gr $I.results_pcombc.txt | tail -n 75 > $I.tmp;
    sort -k 8,8gr $I.results_pcombc.txt | tail -n 75 >> $I.tmp;
    sort -k 20,20g $I.results_pcombc.txt | tail -n 75 >> $I.tmp;
    sort $I.tmp | uniq  > $I.results_filtered75.txt;
#    sort $I.tmp | uniq | grep -v " NA " > $I.results_filtered75.txt;
    ct=$(wc $I.results_filtered75.txt | awk '{print $1}');
    ct2=$(wc $I.tmp | awk '{print $1}');
    echo $I $ct $ct2
    rm $I.tmp
done

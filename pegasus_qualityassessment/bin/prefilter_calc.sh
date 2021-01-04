
K=1
LIST=$1
LEN=$(wc -l $LIST)
for I in $(cat $LIST)
do
#    break
    echo $I "($K/$LEN)";
    # echo $TARGET $DECOY $PPV $SCORE(x2) $EIGEN $SAULO $COMB $CON(x3) $Neff $TM $TM2 $PCONS $PROQ(x4);
    # echo $TARGET $DECOY $PPV $SCORE $EIGEN $SAULO $COMB $CON $Neff $TM $TM2 $PCONS;
#    sort -k 3,3n -k 8,8nr $I.results_proq3d.txt > $I.results_sorted_ppv.txt &
#    sort -k 4,4n -k 8,8nr $I.results_proq3d.txt > $I.results_sorted_mapalign.txt &
#    sort -k 5,5n -k 8,8nr $I.results_proq3d.txt > $I.results_sorted_maplen.txt &
    sort -k 6,6n -k 8,8nr $I.results_proq3d.txt > $I.results_sorted_eigen.txt &  
#    sort -k 7,7nr -k 8,8nr $I.results_proq3d.txt > $I.results_sorted_contact.txt &
    sort -k 8,8nr $I.results_proq3d.txt > $I.results_sorted_saint2.txt &
#    sort -k 15,15n -k 8,8nr $I.results_proq3d.txt > $I.results_sorted_pcons.txt &
#    sort -k 16,16n $I.results_proq3d.txt > $I.results_sorted_proq2d.txt &
#    sort -k 17,17n $I.results_proq3d.txt > $I.results_sorted_roscen.txt &
#    sort -k 18,18n $I.results_proq3d.txt > $I.results_sorted_rosfa.txt &
#    sort -k 19,19n $I.results_proq3d.txt > $I.results_sorted_proq3d.txt &
    sed 's/nan/0.0/g' $I.results_proq3d.txt | awk '{ print $0,(0.3*$15 + 0.6*$19 + 0.01*$3)/1.9}' | sort -k 20 -n | awk '{$NF=""; print $0}' > $I.results_sorted_pcombc.txt &
#    awk '{ print $0,$8-$7 }' $I.results_proq3d.txt | sort -k 20 -n -r | awk '{$NF=""; print $0}' > $I.results_sorted_saint2raw.txt; 
    K=$((K+1));
done

#for J in {1..100}
#do
    #done #> TableCombined.txt

J=75
    tail -n $J --quiet *.results_sorted_saint2.txt *.results_sorted_eigen.txt *.results_sorted_pcombc.txt | sort -k 2 -u > All.tmp
    GUY1=$(wc All.tmp | awk '{print $1}')
    GUY2=$(awk '$14 >= 0.5 {print $1}' All.tmp | wc | awk '{print $1}')
    GUY3=$(awk '$14 >= 0.5 {print $1}' All.tmp | sort | uniq | wc | awk '{print $1}')
    echo $J $GUY2 $GUY1 $GUY3 $LEN "Combined" > Table.txt


for I in $(cat /data/icarus/not-backed-up/oliveira/New_Dataset/data/Training/List_Training.txt)
do
    # echo $TARGET $DECOY $PPV $SCORE $EIGEN $SAULO $COMB $CON $Neff $TM $TM2 $PCONS $PCOMBC;
    head -n 1000 $I.results_pcombc.txt | sort -k 3,3n -k 8,8nr  | tail -n $1 | sort -k 14 -n | tail -n 1 | awk '{print $0,"PPV"}';
    head -n 1000 $I.results_pcombc.txt | sort -k 4,4n -k 8,8nr  | tail -n $1 | sort -k 14 -n | tail -n 1 | awk '{print $0,"MapAlign"}';
    head -n 1000 $I.results_pcombc.txt | sort -k 5,5n -k 8,8nr  | tail -n $1 | sort -k 14 -n | tail -n 1 | awk '{print $0,"MapLength"}';
    head -n 1000 $I.results_pcombc.txt | sort -k 6,6n -k 8,8nr  | tail -n $1 | sort -k 14 -n | tail -n 1 | awk '{print $0,"EigenTHREADER"}';
    head -n 1000 $I.results_pcombc.txt | sort -k 7,7nr -k 8,8nr | tail -n $1 | sort -k 14 -n | tail -n 1 | awk '{print $0,"Contact"}';
    head -n 1000 $I.results_pcombc.txt | sort -k 8,8nr  | tail -n $1 | sort -k 14 -n | tail -n 1 | awk '{print $0,"SAINT2"}';
    head -n 1000 $I.results_pcombc.txt | sort -k 15,15n -k 8,8nr | tail -n $1 | sort -k 14 -n | tail -n 1 | awk '{print $0,"PCons"}';
    head -n 1000 $I.results_pcombc.txt | sort -k 16,16n | tail -n $1 | sort -k 14 -n | tail -n 1 | awk '{print $0,"ProQ2D"}';
    head -n 1000 $I.results_pcombc.txt | sort -k 17,17n | tail -n $1 | sort -k 14 -n | tail -n 1 | awk '{print $0,"ProQRosCen"}';
    head -n 1000 $I.results_pcombc.txt | sort -k 18,18n | tail -n $1 | sort -k 14 -n | tail -n 1 | awk '{print $0,"ProQRosFA"}';
    head -n 1000 $I.results_pcombc.txt | sort -k 19,19n | tail -n $1 | sort -k 14 -n | tail -n 1 | awk '{print $0,"ProQ3D"}';
    head -n 1000 $I.results_pcombc.txt | sort -k 20,20n | tail -n $1 | sort -k 14 -n | tail -n 1 | awk '{print $0, "PCombC"}'
    head -n 1000 $I.results_pcombc.txt | awk '{ print $0,$8-$7 }' | sort -k 21,21nr | tail -n $1 | sort -k 14 -n | tail -n 1 | awk '{$NF="SAINT2_Raw"; print $0}'
    head -n 1000 $I.results_pcombc.txt | sort -k 14,14n | tail -n 1 | awk '{print $0,"Best"}';
done

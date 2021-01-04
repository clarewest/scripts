for I in $(cat list.txt); do awk '{if (NF==19) print $0}' $I.results_proq3d.txt | sed 's/nan/0.0/g'  | awk '{ print $0,(0.3*$15 + 0.6*$19 + 0.01*$3)/1.9}' > $I.results_pcombc.txt ; done

LIST=$1
for I in $(cat $LIST); do
  sed 's/nan/0.0/g' $I.results_proq3d.txt | awk '{ print $0,(0.3*$15 + 0.6*$19 + 0.01*$3)/1.9}' > $I.results_pcombc.txt
done

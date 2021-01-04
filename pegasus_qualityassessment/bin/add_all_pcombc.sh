sed 's/nan/0.0/g' results_proq3d.txt | awk '{ print $0,(0.3*$15 + 0.6*$19 + 0.01*$3)/1.9}' > results_pcombc.txt

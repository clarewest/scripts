for PDB in $(awk '{print $1}' training_features.txt); do FEATURES=$(grep $PDB training_features.txt); sed "s/$/ $FEATURES/" $PDB.results_filtered75.txt ; done > training_topAll.txt 

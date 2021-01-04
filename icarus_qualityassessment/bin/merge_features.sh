SET=$1
for PDB in $(cat ../list.txt); do FEATURES=$(grep $PDB "$SET"_features.txt); sed "s/$/ $FEATURES/" $PDB.results_filtered75.txt; done > Method2_"$SET"topAll.txt

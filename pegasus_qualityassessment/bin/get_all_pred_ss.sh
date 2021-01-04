for PDB in $(cat list.txt); do SS=$(awk -v ORS='' '{print $3}' $PDB.fasta.ss); echo $PDB $SS; done

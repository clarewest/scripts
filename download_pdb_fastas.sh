#!/bin/bash

if [ $# -ne 1 ]
then
  echo -e "\nUsage:\n\n./download_pdb_fastas.sh List.txt\n\nList.txt could be any text file containing the 4 digit PDB codes for download, one PDB code per line.\n\n";
else
  for PDB in $(cat $1)
  do
#    cd "$PDB" 
    PDB_lc=`echo "$PDB" | tr '[:upper:]' '[:lower:]'`;
    grep -A 1 $PDB_lc ~/Project/pdb_seqres.txt > $PDB.fasta.txt
#    cd ..
  done
fi

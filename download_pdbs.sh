#!/bin/bash

if [ $# -ne 1 ]
then
  echo -e "\nUsage:\n\n./download_pdbs.sh List.txt\n\nList.txt could be any text file containing the 4 digit PDB codes for download, one PDB code per line.\n\n";
else
  for PDB in $(cat $1)
  do
    PDB_lc=`echo "$PDB" | tr '[:upper:]' '[:lower:]'`;
    CORE=${PDB_lc:1:2};
#    mkdir "$PDB"
#    cd "$PDB"
    wget "ftp://ftp.rcsb.org/pub/pdb/data/structures/divided/pdb/$CORE/pdb$PDB_lc.ent.gz";
    gunzip pdb$PDB_lc.ent.gz;
    cp pdb$PDB_lc.ent $PDB.pdb
    rm pdb$PDB_lc.ent*
#    cd ..
  done
fi

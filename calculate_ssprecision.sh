#!/usr/bin/bash

##### Check to see if PDB file exists
if [ ! -f "$1".pdb ]
then
    echo "$1.pdb file not found. Please, make sure the PDB file is the current directory";
    exit;
fi

##### Calculate the secondary structure using DSSP:
/users/oliveira/dssp-2.2.1/mkdssp -i "$1".pdb -o "$1".dssp

##### Parse the secondary structure to a single line file
#sed -e '1,/RESIDUE AA STRUCTURE/d' "$1".dssp | cut -c 17 | sed -e 's/[ ]/C/' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' > $1.dssp_ss

if [ ! -f "$1".fasta.ss2 ]
then
    echo "$1.fasta.ss2 file not found. Please, make sure that the appropriate PSIPRED files are in the current directory";
    exit;
fi

tail -n +3 "$1".fasta.ss2 | awk '{print $3}' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' > "$1".psipred_ss

# In the future, we might use SPIDER2 instead of PSIPRED for SS.
#tail -n +2 "$1".seq_pdb.spd3 | awk '{print $3}' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' > "$1".ss_spider

PERC=`/users/oliveira/SAINT2_Diagnostics/validate_ss "$1".dssp "$1".psipred_ss`
#PERC2=`/users/oliveira/validate_ss "$PDB"_A.ss_dssp "$PDB"_A.ss_spider`
echo "Precision of SS Prediction = $PERC"





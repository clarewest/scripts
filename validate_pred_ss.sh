#!/usr/bin/bash

if [ ! -f "$1".dssp ]
then
    ##### Calculate the secondary structure using DSSP:
    /data/icarus/west/progs/xssp-3.0.1/mkdssp -i "$1".pdb -o "$1".dssp
fi 

##### Parse the secondary structure to a single line file
#sed -e '1,/RESIDUE AA STRUCTURE/d' "$1".dssp | cut -c 17 | sed -e 's/[ ]/C/' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' > $1.dssp_ss
sed -e '1,/RESIDUE AA STRUCTURE/d' "$1".dssp | cut -c 17 | sed -e 's/[ ]/C/' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' | sed 's/[GI]/H/g' | sed 's/[B]/E/g' | sed 's/[ST]/C/g' > $1.dssp_ss

### PSIPRED 
#tail -n +3 "$1".fasta.ss2 | awk '{print $3}' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' > "$1".psipred_ss
cat "$1".psipred.ss | awk '{print $3}' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' > "$1".psipred_ss

#### METAPSICOV PSIPRED
cat "$1".metapsicov.ss | awk '{print $3}' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' > "$1".metapsicov_ss

### SOON ADD DeepCNF HERE

###


PSI=`~/Project/Scripts/validate_ss "$1".dssp_ss "$1".psipred_ss`
MET=`~/Project/Scripts/validate_ss "$1".dssp_ss "$1".metapsicov_ss`
echo "$1 $PSI $MET"


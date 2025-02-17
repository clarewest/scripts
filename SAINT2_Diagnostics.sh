#!/usr/bin/bash

##### Check to see if PDB file exists
if [ ! -f "$1".pdb ]
then
    echo "$1.pdb file not found. Please, make sure the PDB file is the current directory";
    exit;
fi

if [ ! -f "$1".dssp ]
then
    ##### Calculate the secondary structure using DSSP:
    ~/bin/dssp-2.0.4-linux-amd64 -i "$1".pdb -o "$1".dssp
fi 

##### Parse the secondary structure to a single line file
#sed -e '1,/RESIDUE AA STRUCTURE/d' "$1".dssp | cut -c 17 | sed -e 's/[ ]/C/' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' > $1.dssp_ss
sed -e '1,/RESIDUE AA STRUCTURE/d' "$1".dssp | cut -c 17 | sed -e 's/[ ]/L/' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' > $1.dssp_ss


if [ ! -f "$1".fasta.ss ]
then
    echo "$1.fasta.ss file not found. Please, make sure that the appropriate predicted secondary structure files are in the current directory";
    exit;
fi

#tail -n +3 "$1".fasta.ss2 | awk '{print $3}' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' > "$1".deepcnf_ss
cat "$1".fasta.ss | awk '{print $3}' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' > "$1".deepcnf_ss

# In the future, we might use SPIDER2 instead of PSIPRED for SS.
#tail -n +2 "$1".seq_pdb.spd3 | awk '{print $3}' | sed -e ':a' -e 'N' -e '$!ba' -e 's/\n//g' > "$1".ss_spider

#PERC=`~/Project/Scripts/validate_ss "$1".dssp_ss "$1".psipred_ss`
PERC=`~/Project/Scripts/validate_ss "$1".dssp_ss "$1".deepcnf_ss`
#PERC2=`/users/oliveira/validate_ss "$PDB"_A.ss_dssp "$PDB"_A.ss_spider`
echo "Precision of SS Prediction = $PERC"

exit 

##### Calculate the torsion angles using Biopython:
~/Project/Scripts/GetTorsionAngles.py "$1" 2> /dev/null;

## Need to work out how spd3 and SPINE-X differ ###
##### Validate the torsion angles and compute the MAE
#if [ ! -f "$1".spXout ]
#then
#    echo "$1.spXout file not found. Please, make sure that the appropriate SPINE-X files are in the current directory";
#    exit;
#fi

#PERCs=`/users/oliveira/SAINT2_Diagnostics/validate_torsion.py $1`
#PERC1=`echo $PERCs | awk '{print $1}'`;
#PERC2=`echo $PERCs | awk '{print $2}'`;
#PERC3=`echo $PERCs | awk '{print $3}'`;
#PERC4=`echo $PERCs | awk '{print $4}'`;

#echo "MAE Predicted Phi: = $PERC1"
#echo "MAE Predicted Psi: = $PERC2"
#echo "MAE Predicted Phi Loops: = $PERC3"
#echo "MAE Predicted Psi Loops: = $PERC4"

##### Validate the fragment library
if [ ! -f "$1".lib_rmsd ]
then
    echo "$1.lib_rmsd file not found. Please, make sure that the file $1.lib_rmsd is in the current directory";
    exit;
fi

if [ ! -f "$1".fasta.txt ]
then
    echo "$1.fasta.txt file not found. Please, make sure that the file $1.fasta.txt is in the current directory";
    exit;
fi


LIB=`/users/oliveira/SAINT2_Diagnostics/gentable $1.lib_rmsd $1 1.5`
Prec=`echo $LIB | awk '{print $1}'`;
Cov=`echo $LIB | awk '{print $2}'`;

echo "Fragment Library Precision = $Prec"
echo "Fragment Library Coverage  = $Cov"

##### Validate the contacts
if [ ! -f "$1".metapsicov_stage1_messages ]
then
    echo "$1.metapsicov_stage1_messages file not found!";
else
    CON=`grep "True Positives" $1.metapsicov_stage1_messages`;
    CON1=`echo $CON | awk '{print $3}'`;
    CON2=`echo $CON | awk '{print $4}'`;
    CON3=`echo $CON | awk '{print $5}'`;
    echo "Predicted Contacts (stage 1): $CON2/$CON3 ($CON1%)"
fi

if [ ! -f "$1".metapsicov_stage2_messages ]
then
    echo "$1.metapsicov_stage2_messages file not found!";  
else
    CON=`grep "True Positives" $1.metapsicov_stage2_messages`;
    CON1=`echo $CON | awk '{print $3}'`;
    CON2=`echo $CON | awk '{print $4}'`;
    CON3=`echo $CON | awk '{print $5}'`;
    echo "Predicted Contacts (stage 2): $CON2/$CON3 ($CON1%)"
fi

tail -n +2 $1.fasta.ss2 > $1.tmp_ss
./Violin.R $1
rm $1.tmp_ss



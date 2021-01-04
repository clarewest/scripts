#!/usr/bin/bash

SAINT2_Dg="/data/portal/userdata/proteins/oliveira/SAINT2_Diagnostics/"
CHAIN=$(grep "^ATOM" $1.pdb | head -n 1 | awk '{print $5}' | cut -c 1);

tail -n +2 $1.spd3 | awk '{print $5,$6}' > $1.pred_angles


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

cp $1.dssp_ss $1.dssp_psi
echo "Frags_per_Pos Prec Cov Prec_H Prec_B Prec_O Prec_L Cov_H Cov_B Cov_L Avg_Len"
/data/icarus/oliveira/Flib/gentable $1.lib_rmsd $1 1.5
$SAINT2_Dg/convert $1



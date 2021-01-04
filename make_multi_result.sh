#!/bin/bash

rm Results.txt
echo "PDB BEST_CT BEST_IV BEST_RV" > Results.txt

for pdb in $(cat $1)
  do 
    ~/Project/Scripts/make_results.sh $pdb >> Results.txt
  done

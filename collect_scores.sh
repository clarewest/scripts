#!/bin/bash

PDB=$1

rm $PDB.ct_scores.txt
rm $PDB.iv_scores.txt
rm $PDB.rv_scores.txt

for file in $(ls $PDB/scores_cotrans*)
  do
    awk '{print $1, $2}' $file >> $PDB.ct_scores.txt;
  done

for file in $(ls $PDB/scores_invitro*)
  do
    awk '{print $1, $2}' $file >> $PDB.iv_scores.txt;
  done

for file in $(ls $PDB/scores_reverse*)
  do
    awk '{print $1, $2}' $file >> $PDB.rv_scores.txt;
  done



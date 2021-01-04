#!/bin/bash

OUTPUT=$1;
CT="ct_scores.txt"
IV="iv_scores.txt"
RV="rv_scores.txt"
CT_BEST=`sort -k 1 -n $OUTPUT.$CT | tail -n 1 | awk '{print $1}'`;
HIGH=`sort -k 13 -n -r $OUTPUT.$CT | tail -n 5 | sort -k 1 -n | tail -n 1 | awk '{print $1}'`;
AVRG="$(awk '{sum+=$1} END { print sum/NR}' $OUTPUT.$CT)";
DECOYS="$(wc $OUTPUT.$CT -l | awk '{ print $1 }')";
#echo $OUTPUT $AVRG $HIGH $BEST $DECOYS

IV_BEST=`sort -k 1 -n $OUTPUT.$IV | tail -n 1 | awk '{print $1}'`;
HIGH=`sort -k 13 -n -r $OUTPUT.$IV | tail -n 5 | sort -k 1 -n | tail -n 1 | awk '{print $1}'`;
AVRG="$(awk '{sum+=$1} END { print sum/NR}' $OUTPUT.$IV)";
DECOYS="$(wc $OUTPUT.$IV -l | awk '{ print $1 }')";
#echo $OUTPUT $AVRG $HIGH $BEST $DECOYS

RV_BEST=`sort -k 1 -n $OUTPUT.$RV | tail -n 1 | awk '{print $1}'`;
HIGH=`sort -k 13 -n -r $OUTPUT.$RV | tail -n 5 | sort -k 1 -n | tail -n 1 | awk '{print $1}'`;
AVRG="$(awk '{sum+=$1} END { print sum/NR}' $OUTPUT.$RV)";
DECOYS="$(wc $OUTPUT.$RV -l | awk '{ print $1 }')";
#echo $OUTPUT $AVRG $HIGH $BEST $DECOYS
echo $OUTPUT $CT_BEST $IV_BEST $RV_BEST



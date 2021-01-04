#!/bin/bash
set -u
set -e

### SET-UP ###
function progress {
  ### Put a progress tracker in here ###
  ls *.results_proq3d.txt | wc -l
}
TARGET=$((245))   
BLOBS=50            ### 50 is 2% increments 
FACE2=" (>_<) "
FACE1=" (-_-) "
FACE3="\(^o^)/"
#############

COMPLETE=$(progress)
BLOB=$(($TARGET/$BLOBS + 1))
TIP=">"
PROG=""
PERCENT=0
CUBLOB=0
V=0
SPACE=""

for i in $(seq 1 1 $BLOBS); do
  SPACE=$SPACE" "
done

while [[ $COMPLETE -lt $TARGET ]]; do
  COMPLETE=$(progress)
  if [ $COMPLETE -gt $(($CUBLOB+$BLOB))  ]; then
    while [ $COMPLETE -gt $(($CUBLOB+$BLOB)) ]; do
      CUBLOB=$(($CUBLOB + $BLOB))
      PROG="=""$PROG"
      SPACE=${SPACE:1}
      PERCENT=$(($PERCENT + 2))
    done
    if [ $V -eq 0 ]; then
      FACE=$FACE1
      V=1
    else
      FACE=$FACE2
      V=0
    fi
    echo -ne " $FACE $PERCENT"%"[$PROG$TIP$SPACE]\r"
  fi
  sleep 2
done

PROG=""
for i in $(seq 1 1 $BLOBS); do
  PROG=$PROG"="
done

echo " $FACE3 100"%"[$PROG]"

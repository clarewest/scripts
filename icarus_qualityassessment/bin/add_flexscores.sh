DATASET=$2
export QA=/data/icarus/not-backed-up/west/QualityAssessment/
for I in $(cat $1); do
  echo $I
  for J in $(awk '{print $2}' $I.results_proq3d.txt); do
    ENDSCORE=$(grep "$J" $QA/data/$DATASET/endscore_"$I"_* | awk '{print $2}');
    FLEXSCORE=$(grep "$J" $QA/data/$DATASET/flexscore_"$I"_* | awk '{print $2,$3,$4}');
    grep "$J " $I.results_proq3d.txt | awk -v endscore=$ENDSCORE -v flexscore="$FLEXSCORE" '{print $0,endscore,flexscore}';
  done  > $I.results_scaffold.txt;
  echo $I;
done

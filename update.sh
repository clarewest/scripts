f=$1
rm all_scores.txt
for pdb in $(cat $f)
  do
    ~/Project/Scripts/collect_scores.sh $pdb;
    ~/Project/Scripts/score.sh $pdb >> all_scores.txt;
  done
~/Project/Scripts/make_multi_result.sh $f

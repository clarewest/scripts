
export QA=/data/icarus/not-backed-up/west/QualityAssessment/
I=$1
DATASET=$2

echo $I $DATASET
echo $I
for J in $(awk '{print $2}' results.txt)
do
    GUY=$(tail -n 1 $QA/data/$DATASET/ProQ3D_$I/"$J".pdb.proq3.global); 
    grep "$J " results.txt | awk -v guy="$GUY" '{print $0,guy}';
done > results_proq3d.txt;
echo $I;

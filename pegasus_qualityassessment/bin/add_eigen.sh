
export QA=/data/icarus/not-backed-up/west/QualityAssessment/
I=$1

for J in $(awk '{print $2}' $I.results.txt)
do
    GUY=$(grep "$J" $QA/data/Training/$I.out | awk '{print $1}');
    grep "$J " $I.results.txt | awk -v guy=$GUY '{print $0,guy}';
done > $I.results_eigen.txt;
echo $I;

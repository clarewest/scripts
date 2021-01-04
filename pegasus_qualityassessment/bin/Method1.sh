for I in $(cat /data/pegasus/not-backed-up/oliveira/New_Dataset/data/Training/List_Training.txt)
do
    GUY=$(/data/pegasus/not-backed-up/oliveira/New_Dataset/bin/extract_features.sh $I)
#   sort -k 8,8nr $I.results_filtered.txt | tail -n $1 | sort -k 14 -n | awk -v x="$GUY" '{print $0,x,"SAINT2"}';
    sort -k 14,14n $I.results_filtered.txt  | tail -n 1 | awk -v x="$GUY" '{print $0,x,"Best"}';

done

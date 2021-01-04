rm Results_Flib.txt 

GUY=$(wc $1 | awk '{print $1}');

for J in $(seq 0.1 0.1 2.0)
do
    echo "----------   $J   -----------"
    rm table_Flib.txt

    K=1;
    for I in $(cat $1)
    do
        ../gentable $I.lib_rmsd $I $J >> table_Flib.txt
        echo "($K/$GUY)";
        K=$(expr $K + 1);
    done
    ~/tables.R table_Flib.txt >> Results_Flib.txt
done

rm table_Flib.txt 
K=1;
J=1.0;
for I in $(cat $1)
do
        ../gentable $I.lib_rmsd $I $J >> table_Flib.txt
        echo "($K/$GUY)";
        K=$(expr $K + 1);
done


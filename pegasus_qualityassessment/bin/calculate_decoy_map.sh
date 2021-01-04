for J in $(cat $1.lst)
do 
    tail -n 1 $1/$J.out_map
done

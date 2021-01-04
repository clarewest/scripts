paste $1.out $1.lst | awk '{if (NF>1) print $1,$2,$3,$5}' | column -tR1,2,3 

ss=`cat $1`
for i in $(seq 1 ${#ss}); do  echo "$i ${ss:i-1:1}"; done 

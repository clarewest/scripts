for MODEL in $(cat $1.pcons_lst); do sed -i 's/^\(ATOM\)\(.\{17\}\)./\1\2A/' $MODEL ; done

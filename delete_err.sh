for PDB in $(cat 1VCQ_list.txt)
do
	for dir in $PDB/*
		do
		rm $dir/err*
		done
done


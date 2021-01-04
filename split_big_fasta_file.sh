while read line
do
    if [[ ${line:0:1} == '>' ]]
    then
        outfile=$(echo $line | cut -d " " -f1 | sed 's/^>//').fasta.txt
        echo $line > $outfile
    else
        echo $line >> $outfile
    fi
done < $1

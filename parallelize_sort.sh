maxjobs=40
parallelize () {
        while [ $# -gt 0 ] ; do
                jobcnt=(`jobs -p`)
                if [ ${#jobcnt[@]} -lt $maxjobs ] ; then
#		    (CODE=`echo "${1:0:5}"`; awk -v "CODE=$CODE" '{if ($1==CODE) print $0}' cathtwodomain_nofrags.txt >> short_twodomain_nofrags_dataset.txt) &
#		    (CODE=`echo "${1:0:5}"`; awk -v "CODE=$CODE" '{if ($1==CODE && $3=="F00") print $1}' cath-domain-boundaries.txt >> short_nonredundant_onedomain_nofrags.txt) & 	
#		    (CODE="$1""00"; awk -v "CODE=$CODE" '{if ($1==CODE) print substr($1, 1, 5), $2}' cath-short.txt >> lengths_twodomain.txt) &
			(awk -v "CODE=$1" '{if ($1==CODE) print $1, $9, $13}' short_twodomain_nofrags_dataset.txt >> nonredundant_dataset_breakpoints.txt) &	
                    shift
                fi
        done
        wait
}

LIST=`cat good.5codes`
parallelize $LIST


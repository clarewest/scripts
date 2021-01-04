maxjobs=15
parallelize () {
        while [ $# -gt 0 ] ; do
                jobcnt=(`jobs -p`)
                if [ ${#jobcnt[@]} -lt $maxjobs ] ; then
                    ../../bin/calculate_bf $1.aln | awk '{print $2}' > $1.beff &
                    shift  
                fi
        done
        wait
}

LIST=`cat extra_list.txt`
parallelize $LIST

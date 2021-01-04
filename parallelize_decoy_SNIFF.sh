maxjobs=40
parallelize () {
        while [ $# -gt 0 ] ; do
                jobcnt=(`jobs -p`)
                if [ ${#jobcnt[@]} -lt $maxjobs ] ; then
#		    (CODE=`echo "${1:0:4}"`; CHAIN=`echo "${1:4:1}"`; ~/Project/Scripts/get_panchenko3_chunks.py "$CODE".pdb "$CHAIN") &
		    ~/Project/Scripts/get_decoy_panchenko_chunks.py $1 A &
                    shift
                fi
        done
        wait
}

LIST=`awk '{print $2}' /data/portal/userdata/proteins/oliveira/DecoyFun/scores/1CZT_scores.txt`
parallelize $LIST


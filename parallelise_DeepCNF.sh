maxjobs=12
parallelize () {
        while [ $# -gt 0 ] ; do
                jobcnt=(`jobs -p`)
                if [ ${#jobcnt[@]} -lt $maxjobs ] ; then
#			nohup $SAINT2/scripts/eleanor_run_saint2.sh $1 cir . 
#			$SAINT2/scripts/eleanor_run_saint2.sh $1 ci . &
			/data/icarus/west/RaptorX_Property_Fast/oneline_command.sh $1.fasta 1 1 > $1.log &
                        shift
                fi
        done
        wait
}

LIST=`cat list.txt`
parallelize $LIST


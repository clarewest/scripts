maxjobs=20
parallelize () {
        while [ $# -gt 0 ] ; do
                jobcnt=(`jobs -p`)
                if [ ${#jobcnt[@]} -lt $maxjobs ] ; then
#			nohup $SAINT2/scripts/eleanor_run_saint2.sh $1 cir . 
#			$SAINT2/scripts/eleanor_run_saint2.sh $1 ci . &
			~/Project/homes/oliveira/SAINT2/scripts/run_saint2_intermediates.sh $1 /data/cockatrice/west/saint_prep/ &
                        shift
                fi
        done
        wait
}

LIST=`for i in {1..8999}; do cat monomers.txt; done`
parallelize $LIST


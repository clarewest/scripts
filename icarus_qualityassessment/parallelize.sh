# This should be the number of parallel tasks you want to run
maxjobs=40

parallelize () {
        while [ $# -gt 0 ] ; do
                jobcnt=(`jobs -p`)
                if [ ${#jobcnt[@]} -lt $maxjobs ] ; then
			/path/to/rosetta-3.5/rosetta_source/bin/AbinitioRelax.linuxgccrelease @flags &
                fi
        done
        wait
}

parallelize

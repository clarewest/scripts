maxjobs=4
parallelize () {
        while [ $# -gt 0 ] ; do
                jobcnt=(`jobs -p`)
                if [ ${#jobcnt[@]} -lt $maxjobs ] ; then
		    (CODE=`echo "${1:0:4}"`; CHAIN=`echo "${1:4:1}"`; ~/Project/Scripts/get_first_residue.py "$CODE".pdb "$CHAIN") &
#		    ~/Project/Scripts/get_panchenko3_chunks.py "$1".pdb A &
                    shift
                fi
        done
        wait
}

LIST=`cat nonredundant_twodomain.txt`
parallelize $LIST


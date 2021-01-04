# This should be the number of parallel tasks you want to run
maxjobs=10

parallelize () {
        while [ $# -gt 0 ] ; do
                jobcnt=(`jobs -p`)
                if [ ${#jobcnt[@]} -lt $maxjobs ] ; then
                        #python /data/icarus/oliveira/Flib_Coevo/scripts/process_new.py /data/icarus/not-backed-up/oliveira/PDB/ < $1.lib > $1.flib 2> $1.log &
                        #../../bin/runproq3D.sh $1 &
                        ../../bin/runsimpleproq3D.sh $1 &
                        shift  
                fi
        done
        wait
}

#LIST=`cat oldtrain.txt`
LIST=`head -n1 list.txt`
parallelize $LIST

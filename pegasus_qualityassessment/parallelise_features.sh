maxjobs=12
parallelize () {
        while [ $# -gt 0 ] ; do
                jobcnt=(`jobs -p`)
                if [ ${#jobcnt[@]} -lt $maxjobs ] ; then
#  /data/pegasus/west/proq3/clare_finish_ProQ3 $1 &
#      ../../bin/run_pcons.sh $1 &  
#                ../../bin/runproq3D.sh $1 &
#                bash ../../get_features.sh --target $1 --mapalign --saint2 --tmscore --prepeigen --eigenthreader > $1.progress &
#                bash ../../get_features.sh --target $1 --mapalign --saint2 --tmscore > $1.progress &
#                 bash ../../get_features.sh --target $1 --tmscore > $1.progress &
#                 bash ../../get_features.sh --target $1 --prepeigen --eigenthreader  > $1.progress &
                 bash ../../get_features.sh --target $1 --mapalign  > $1.progress &
#                 bash ../../get_features.sh --target $1 --gatherproq > $1.progress &
#                 bash ../../get_features.sh --target $1 --chain A --ppv > $1.progress &
             #   bash ../../get_features.sh --target $1 --ppv --chain ${1:5:1} > $1.progress &
#                  bash ../../get_features.sh --target $1 --pcons > $1.progress &
                shift
                fi
        done
        wait
}

LIST=`echo 1VFF`
#LIST=`cat list.txt`
#LIST=`cat proq_finish.txt`
#LIST=`cat todo_ordered_meta_pcons.txt`
parallelize $LIST


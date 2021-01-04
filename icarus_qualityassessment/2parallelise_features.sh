maxjobs=6
parallelize () {
        while [ $# -gt 0 ] ; do
                jobcnt=(`jobs -p`)
                if [ ${#jobcnt[@]} -lt $maxjobs ] ; then
#      ../../bin/run_pcons.sh $1 &  
#                  ../../bin/runproq3D.sh $1 &
#                   /data/icarus/west/proq3/clare_finish_ProQ3 $1 &
              #   bash ../../get_features.sh --target $1 --ppv --mapalign --saint2 --tmscore --gatherpcons --gatherproq --gathereigen > $1.progress &
        #      bash ../../get_features.sh --target $1 --scaffold $(cat $1.seg) $(cat $1.term) --ppv  > $1.progress &
              bash ../../get_features.sh --target $1 --scaffold $(cat $1.seg) $(cat $1.term) --ppv --saint2 --tmscore --stmscore --gathersampled > $1.progress &
#                 bash ../../get_features.sh --target $1 --flexrmsd --sampledrmsd > $1.progress &
#                 bash ../../get_features.sh --target $1 --pcons  > $1.progress &
#                 bash ../../get_features.sh --target $1 --prepeigen --eigenthreader > $1.progress &
                shift
                fi
        done
        wait
}

#LIST=`cat list_training.txt`
LIST=`cat ~/catchupvalidation.txt`
parallelize $LIST


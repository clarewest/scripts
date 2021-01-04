maxjobs=4
parallelize () {
        while [ $# -gt 0 ] ; do
                jobcnt=(`jobs -p`)
                if [ ${#jobcnt[@]} -lt $maxjobs ] ; then
#      ../../bin/run_pcons.sh $1 &  
#                 ../../bin/runproq3D.sh $1 &
#                  /data/icarus/west/proq3/clare_finish_ProQ3 $1 &
              #   bash ../../get_features.sh --target $1 --ppv --mapalign --saint2 --tmscore --gatherpcons --gatherproq --gathereigen > $1.progress &
#                 bash ../../get_features.sh --target $1 --tmscore > $1.progress &
#                 bash ../../get_features.sh --target $1 --gatherproq > $1.progress &
#                 bash ../../get_features.sh --target $1 --chain A  --ppv  > $1.progress &
#               bash ../../get_features.sh --target $1 --prepeigen --eigenthreader > $1.progress &
#               bash ../../get_features.sh --target $1 --eigenthreader > $1.progress &
#                 bash ../../get_features.sh --target $1  --pcons > $1.progress &
#              bash ../../get_features.sh --target $1 --scaffold $(cat $1.seg) $(cat $1.term) --ppv  > $1.progress &
#              bash ../../get_features.sh --target $1 --scaffold $(cat $1.seg) $(cat $1.term) --gathersampled > $1.progress &
                 bash ../../get_features.sh --target $1 --flexrmsd --sampledrmsd  > $1.progress &
#                 bash ../../get_features.sh --target $1  --flexrmsd   > $1.progress &
#                 bash ../../get_features.sh --target $1 --mapalign  > $1.progress &
#                 bash ../../get_features.sh --target $1 --saint2 > $1.progress &
                shift
                fi
        done
        wait
}

#LIST=`cat redo.txt`
#LIST=`cat topup.txt`
LIST=`cat list_test.txt`
#LIST=`cat pcons_test.txt`
#LIST=`cat ~/catchupvalidation.txt`
parallelize $LIST


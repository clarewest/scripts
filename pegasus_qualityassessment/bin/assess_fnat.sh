export QA=/data/icarus/not-backed-up/west/QualityAssessment/

TARGET_LIST=$1
CONTACT=5.0
threads=5

parallelize () {
        while [ $# -gt 0 ] ; do
                jobcnt=(`jobs -p`)
                if [ ${#jobcnt[@]} -lt $threads ] ; then
                    echo $1
                    get_fnat $1 &
                    shift
                fi
        done
        wait
}

get_fnat () {
    TARGET=$1
    CHAIN_TARGET=A
    DECOY_DIR=$TARGET

    if [ ! -f $TARGET.proxy_map_$CONTACT ]
    then
        # Compute the true contact map and the PDB sequence:
        $QA/bin/getcontactsSparse3.py $TARGET.pdb $CHAIN_TARGET $CONTACT 2> $TARGET.log
    fi
    DONE=$(ls $TARGET/*.proxy_map_$CONTACT 2>/dev/null | wc -l)
    TOTAL=$(wc -l < $TARGET.lst)
    if [ $DONE -lt $TOTAL ]; then
        for DECOY in $(cat $TARGET.lst); do
            if [ ! -f $DECOY_DIR/$DECOY.proxy_fasta_$CONTACT ]|[ ! -f $DECOY_DIR/$DECOY.proxy_map_$CONTACT ]
            then
                $QA/bin/getcontactsSparse3.py $DECOY_DIR/$DECOY $CHAIN_TARGET $CONTACT 2>> $TARGET.log
            fi
        done
    fi 
    if [ ! -f fnat_$TARGET.txt ]; then 
#        ARGS=$(grep $TARGET set_full_details.txt | awk -v contact=$CONTACT '{print $1, $4-$2-15, $3, contact}') ## Target seg terminus contact_distance
        ARGS=$(grep $TARGET fake_segs.txt | grep $TARGET fake_segs.txt | awk -v contact=$CONTACT '{print $1, $6, $5, contact}')
        python $QA/bin/fnat.py $ARGS
    fi
}

# Running on each target
LIST=$(cat $TARGET_LIST)
parallelize $LIST



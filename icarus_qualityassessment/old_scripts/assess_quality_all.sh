TARGET=$1;
CHAIN_TARGET=$2;
DECOY_DIR=$3;
threads=20

export QA=/data/icarus/not-backed-up/west/QualityAssessment/

parallelize () {
        while [ $# -gt 0 ] ; do
                jobcnt=(`jobs -p`)
                if [ ${#jobcnt[@]} -lt $threads ] ; then
                    $QA/assess_quality.sh $TARGET $CHAIN_TARGET $DECOY_DIR $1 &
                    shift
                fi
        done
        wait
}

if [ ! -f $TARGET.metapsicov.stage1 ]
then
    echo "Contact file for $TARGET not found. Moving onto the next target" 1>&2;
    exit;
fi

# Clare edit: if we don't have the native structure we can't do this
# Clare edit: _stage1 will be empty if there are no contacts even if this has already run
if [ -f $TARGET.pdb ]
then
    if [ ! -f $TARGET.metapsicov_stage1_messages ]
    then
        # Compute the true contact map and the PDB sequence:
        $QA/bin/getcontactsSparse3.py $TARGET.pdb $CHAIN_TARGET 8.0 2> $TARGET.log
        # Contacts are usually calculated using the fasta sequence of the target ($TARGET.metapsicov.stage1).
        # This line corrects the contacts so the numbering matches the sequence on the PDB (and not on the fasta)
        $QA/bin/convert $TARGET.proxy_fasta $TARGET.aln $TARGET.metapsicov.stage1 $TARGET.proxy_map > $TARGET.metapsicov_stage1 2> $TARGET.metapsicov_stage1_messages
    fi
else 
  awk '{if ($5>=0.5) print $1,$2,$5,0}' $TARGET.metapsicov.stage1 > $TARGET.metapsicov_stage1
fi

### Even if there were no predicted contacts this file will exist (and just contain the length)
if [ ! -s $TARGET.meta_map ]
then
    ## Clare edit: this length will be wrong if any residues are missing in the native structure
#    LENGTH=$(head -n 1 $TARGET.proxy_map)
    LENGTH=$(cat $TARGET.fasta.ss | wc -l)
    ## Clare edit: my version reads the original metapsicov files, with a cut-off argument, rather than the validated metapsicov file
#    $QA/bin/parse_metapsicov $TARGET.metapsicov_stage1 $LENGTH > $TARGET.meta_map
    $QA/bin/clare_parse_metapsicov $TARGET.metapsicov.stage1 $LENGTH 0.5 > $TARGET.meta_map
fi

if [ ! -s $TARGET.beff ]
then
  #  $QA/bin/calc_neff $TARGET.aln 0.90 | awk '{print $3}' > $TARGET.neff;
$QA/bin/calculate_bf $TARGET.aln | awk '{print $3}' > $TARGET.beff;
fi

if [ ! -s $TARGET.ppv ]
then
    if [ -f $TARGET.pdb ]
    then
        grep "True Positives:" $TARGET.metapsicov_stage1_messages | awk '{print $3,$4,$5}' > $TARGET.ppv
      else 
        NCON=$(cat $TARGET.con | wc -l)
        echo "0 0 $NCON" > $TARGET.ppv
      fi
fi 


# Running map align
LIST=$(head -n 500 $TARGET.lst )
#LIST=$(cat $TARGET.good_lst )
parallelize $LIST

QA=/data/pegasus/not-backed-up/west/QualityAssessment/
TARGET=$1
CHAIN_TARGET=$2

if [ -f $TARGET.pdb ]
then
    if [ ! -f $TARGET.models.metapsicov_stage1_messages ]
    then
        # Compute the true contact map and the PDB sequence:
        $QA/bin/getcontactsSparse3.py $TARGET.pdb $CHAIN_TARGET 8.0 2> $TARGET.log
        # Contacts are usually calculated using the fasta sequence of the target ($TARGET.metapsicov.stage1).
        # This line corrects the contacts so the numbering matches the sequence on the PDB (and not on the fasta)
        $QA/bin/convert $TARGET.proxy_fasta $TARGET.aln $TARGET.models.metapsicov.stage1 $TARGET.proxy_map > $TARGET.models.metapsicov_stage1 2> $TARGET.models.metapsicov_stage1_messages
    fi
fi

### Even if there were no predicted contacts this file will exist (and just contain the length)
if [ ! -s $TARGET.meta_map ]
then
    ## Clare edit: this length will be wrong if any residues are missing in the native structure
#    LENGTH=$(head -n 1 $TARGET.proxy_map)
    LENGTH=$(cat $TARGET.fasta.ss2 | wc -l | awk '{print $1-2}' )
    ## Clare edit: my version reads the original metapsicov files, with a cut-off argument, rather than the validated metapsicov file
#    $QA/bin/parse_metapsicov $TARGET.metapsicov_stage1 $LENGTH > $TARGET.meta_map
    $QA/bin/clare_parse_metapsicov $TARGET.models.metapsicov.stage1 $LENGTH 0.5 > $TARGET.meta_map
fi

if [ ! -s $TARGET.ppv ]
then
    if [ -f $TARGET.pdb ]
    then
        grep "True Positives:" $TARGET.models.metapsicov_stage1_messages | awk '{print $3,$4,$5}' > $TARGET.ppv
      else 
        NCON=$(cat $TARGET.con | wc -l)
        echo "0 0 $NCON" > $TARGET.ppv
      fi
fi 


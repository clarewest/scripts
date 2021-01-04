QA=/data/pegasus/not-backed-up/west/QualityAssessment/
TARGET=$1
DECOY_DIR=$TARGET
for DECOY in $(cat $TARGET.lst); do
  PPV=$(unbuffer $QA/bin/convert $DECOY_DIR/$DECOY.proxy_fasta $TARGET.aln $TARGET.models.metapsicov.stage1 $DECOY_DIR/$DECOY.proxy_map 2>&1 | grep "^True Positives" | awk '{print $3}');
  echo $TARGET $DECOY $PPV
done 


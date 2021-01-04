
export QA=/data/icarus/not-backed-up/west/QualityAssessment/
TARGET=$1
DECOY_DIR=$1
for DECOY in $(cat $TARGET.lst);
do
    $QA/bin/convert $DECOY_DIR/$DECOY.proxy_fasta $TARGET.aln $TARGET.metapsicov.stage1 $DECOY_DIR/$DECOY.proxy_map 2> $1.tmp >/dev/null;
    GUY=$(grep "^True Positives" $1.tmp | awk '{print $3,$4}');
    echo $DECOY $GUY;
done
rm $1.tmp


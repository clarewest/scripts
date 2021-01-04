export QA=/data/pegasus/not-backed-up/west/QualityAssessment/
TARGET=$1
for MODEL in $(cat $TARGET.lst); do 
  $QA/bin/convert $TARGET/$MODEL.proxy_fasta $TARGET.aln $TARGET.metapsicov.stage1 $TARGET/$MODEL.proxy_map > $TARGET/$MODEL.metapsicov_stage1 2> $TARGET/$MODEL.metapsicov_stage1_messages
done



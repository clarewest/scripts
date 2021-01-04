export QA=/data/icarus/not-backed-up/west/QualityAssessment/
TARGET=$1
DECOY_DIR=$1
TDB_DIR=$DECOY_DIR/TDB_DIR
mkdir $TDB_DIR
for DECOY in $(cat $TARGET.lst); do
  if [ ! -f $DECOY_DIR/$DECOY.dssp ]; then 
    $QA/bin/dssp-2.0.4-linux-amd64 -i $DECOY_DIR/$DECOY > $DECOY_DIR/$DECOY.dssp
  fi
  if [ ! -f $DECOY_DIR/TBD_DIR/$DECOY.eig ]; then
    $QA/bin/strsum_eigen $DECOY_DIR/$DECOY.pdb $DECOY_DIR/$DECOY.dssp $TDB_DIR/$DECOY.tdb $TDB_DIR/$DECOY.eig
  fi
done

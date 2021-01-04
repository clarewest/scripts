TARGET=$1
R=".repacked"

for DECOY in $(cat $TARGET.proq_lst);
do
  MODEL=ProQ3D_$DECOY
  rm $MODEL$R.proq3.svm $MODEL$R.proq2.svm $MODEL$R.highres.svm $MODEL$R.lowres.svm $MODEL.ss2 $MODEL.acc $MODEL.psi $MODEL.mtx $MODEL.rosetta.log
  rm  $MODEL$R.proq3 $MODEL$R.proq2 $MODEL$R.highres $MODEL$R.lowres
  rm $MODEL$R $MODEL$R.minimized $MODEL$R.ss2 $MODEL$R.acc $MODEL$R.psi $MODEL$R.mtx
done

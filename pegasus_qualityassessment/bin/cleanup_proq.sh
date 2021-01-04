TARGET=$1
R=".repacked"
M=".minimized"

for DECOY in $(cat $TARGET.proq_lst);
do
  MODEL=ProQ3D_$DECOY
 # rm $MODEL$R.proq3.svm $MODEL$R.proq2.svm $MODEL$R.highres.svm $MODEL$R.lowres.svm $MODEL.ss2 $MODEL.acc $MODEL.psi $MODEL.mtx $MODEL.rosetta.log
 # rm  $MODEL$R.proq3 $MODEL$R.proq2 $MODEL$R.highres $MODEL$R.lowres
 # rm $MODEL$R $MODEL$R.minimized $MODEL$R.ss2 $MODEL$R.acc $MODEL$R.psi $MODEL$R.mtx
  rm $MODEL$R.silent
  rm $MODEL$R.features.[0-9]*.temp $MODEL$R.features.[0-9]*.temp2
  rm $MODEL$R$M.features.highres.[0-9]*.temp $MODEL$R$M.features.lowres.[0-9]*.temp $MODEL$R$M.features.lowres_global.[0-9]*.temp $MODEL$R.features.proq2.[0-9]*.temp $MODEL$R.features.proq2.[0-9]*.temp2 $MODEL$R.features.proq2.[0-9]*.temp3 $MODEL$R.features.target.[0-9]*.temp $MODEL$R$M.score.[0-9]*.temp $MODEL$R$M.score.[0-9]*.temp2 $MODEL$R$M.score.[0-9]*.temp3 $MODEL$R$M.score.[0-9]*.temp4 $MODEL$R.features.rsa_ss.[0-9]*.temp
done

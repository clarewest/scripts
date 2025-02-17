TARGET=$1
R=".repacked"
M=".minimized"

#for DECOY in $(cat $TARGET.proq_lst);

MODEL=ProQ3D_$TARGET/
  rm $MODEL*$R.proq3.svm 
  rm $MODEL*$R.proq2.svm 
  rm $MODEL*$R.highres.svm 
  rm $MODEL*$R.lowres.svm 
  rm $MODEL*.pdb.ss2 
  rm $MODEL*.pdb.acc 
  rm $MODEL*.pdb.psi 
  rm $MODEL*.pdb.mtx 
  rm $MODEL*.rosetta.log
  rm $MODEL*$R.proq3 
  rm $MODEL*$R.proq2 
  rm $MODEL*$R.highres 
  rm $MODEL*$R.lowres
  rm $MODEL*$R 
  rm $MODEL*$R.minimized 
  rm $MODEL*$R.ss2 
  rm $MODEL*$R.acc 
  rm $MODEL*$R.psi 
  rm $MODEL*$R.mtx
  rm $MODEL*$R.silent
  rm $MODEL*$R.features.[0-9]*.temp $MODEL*$R.features.[0-9]*.temp2
  rm $MODEL*$R$M.features.highres.[0-9]*.temp 
  rm $MODEL*$R$M.features.lowres.[0-9]*.temp 
  rm $MODEL*$R$M.features.lowres_global.[0-9]*.temp 
  rm $MODEL*$R.features.proq2.[0-9]*.temp 
  rm $MODEL*$R.features.proq2.[0-9]*.temp2
  rm  $MODEL*$R.features.proq2.[0-9]*.temp3 
  rm $MODEL*$R.features.target.[0-9]*.temp 
  rm $MODEL*$R$M.score.[0-9]*.temp 
  rm $MODEL*$R$M.score.[0-9]*.temp2 
  rm $MODEL*$R$M.score.[0-9]*.temp3 
  rm $MODEL*$R$M.score.[0-9]*.temp4 
  rm $MODEL*$R.features.rsa_ss.[0-9]*.temp
  rm $MODEL*$R.list
  rm $MODEL*.pdb 
  rm $MODEL*.pdb.fasta

#done

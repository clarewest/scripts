#!/usr/bin/env python3
import sys
from statistics import mean

PDB=sys.argv[1]
T=int(sys.argv[2])

sspredfile=PDB+".fasta.ss"
#out=PDB+"fasta.ss3"
out=open("N_ss_pred_list.txt","a")
confidence=list()
ss=list()

with open(sspredfile,"r") as inp:
  for line in inp:
    c=sorted([float(i) for i in line.strip().split()[3:6]],reverse=True)
    x=int((c[0]-(c[1]+c[2]))*10)
    if x<0:
      x=0
    confidence.append(x)
    ss.append(line.strip().split()[2])
#    print(line.strip()+" "+str(x)) 
rs_confidence=mean(confidence[T:])
un_confidence=mean(confidence[:T])
rs_coil=ss[T:].count("C")/len(ss)
un_coil=ss[:T].count("C")/len(ss)
print(PDB, rs_confidence, un_confidence, (rs_confidence - un_confidence), rs_coil, un_coil, (rs_coil - un_coil), file=out)

out.close()

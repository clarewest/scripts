#!/usr/bin/env python3
import sys
from statistics import mean
from collections import Counter

PDB=sys.argv[1]
missing_length=int(sys.argv[2])

sspredfile=PDB+".fasta.ss"
out=open("C_ss_pred_list_2.txt","a")
#print("PDB R_conf T_len UR_len UR_conf D_confidence R_coil R_helix R_beta UR_coil UR_helix UR_beta", file=out)    ### Print column headings
confidence=list()
ss=list()
SSEs=['C','H','E']

with open(sspredfile,"r") as inp:
  for line in inp:
    ## Calculate integer confidence for each residue prediction ##
    c=sorted([float(i) for i in line.strip().split()[3:6]],reverse=True)
    x=int((c[0]-(c[1]+c[2]))*10)
    if x<0:
      x=0
    confidence.append(x)
    ## Get predicted secondary structure sequence ##
    ss.append(line.strip().split()[2])
## Get average confidence of resolved and unresolved regions ##
rs_confidence=mean(confidence[:-missing_length])
un_confidence=mean(confidence[-missing_length:])
## Get proportions of predicted secondary structure elements of missing region and equivalent length from resolved opposite terminus ##
unresolved_ss=ss[-missing_length:]
resolved_ss=ss[:missing_length]
unresolved_counter=Counter(unresolved_ss)
resolved_counter=Counter(resolved_ss)
unresolved_SSEs=[unresolved_counter[SSE]/len(unresolved_ss) for SSE in SSEs]
resolved_SSEs=[resolved_counter[SSE]/len(resolved_ss) for SSE in SSEs]
## Append to file for plotting ##
print(PDB, len(ss), missing_length, rs_confidence, un_confidence, (rs_confidence - un_confidence), *resolved_SSEs, *unresolved_SSEs, file=out)

out.close()

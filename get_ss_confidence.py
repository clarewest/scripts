#!/usr/bin/env python3
import sys
from statistics import mean

if len(sys.argv) != 5:
    print("Usage: ./get_ss_confidence.py PDBcode MissingLen Terminus SSpredfile")
    sys.exit()

PDB=sys.argv[1]
M=int(sys.argv[2])
T=["N","C"].index(sys.argv[3])
sspredfile=sys.argv[4]

#out="ss_conf_list.txt"
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
#        print(line.strip()+" "+str(x)) 
term_confidence=[mean(confidence[:M]), mean(confidence[-M:])]
term_coil=[ (ss[:M].count("C")/M) , (ss[-M:].count("C")/M) ]
if T:
    term_confidence.reverse()
    term_coil.reverse()
term_confidence.append(mean(confidence[M:-M]))
term_coil.append(ss[M:-M].count("C")/(len(ss)-2*M))
lens=[len(ss), len(ss)-2*M]
print(*sys.argv[1:-1], *term_confidence, *term_coil, *lens)



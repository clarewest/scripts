#!/usr/bin/env python3
import sys
from statistics import mean

target=sys.argv[1]
begin=int(sys.argv[2])
end=int(sys.argv[3])

pconsfile=target+".pcons.txt"
out=open(target+".sampledpcons","a")
meanpcons = []
with open(pconsfile,"r") as pf:
  for line in pf:
    if line.startswith(target):
      meanpcon = mean(float(pcon) for pcon in line.strip().split()[begin+1:end+1])
      decoy = line.strip().split()[0]
      meanpcons.append(decoy + " {:.3f}".format(meanpcon))
print("\n".join(meanpcons), file=out)
out.close()

#!/usr/bin/env python3
import xml.etree.ElementTree as etree
import sys
sfid=sys.argv[1] 
f=sfid+".xml"
o=sfid+".out"
tree=etree.parse(f)
entry=tree.getroot()

for protein in entry:
    p = [protein.attrib[key] for key in ["pdb_id","number_of_residues"]]
#    print(sfid, *p)

length = int(p[1])
seq=["1"]*length

with open(sfid+".residues","r") as r:
  for residue in r:
    residue = residue.strip().strip("<br>").split("; ")
    if len(residue)==3:
      i = int(residue[0])-1
      if residue[2] == "EARLY":
        seq[i] = 2
      elif residue[2] == "MEDIUM":
        seq[i] = 3
      elif residue[2] == "LATE":
        seq[i] = 4
#print(*seq,sep="")
print(sfid, *seq)



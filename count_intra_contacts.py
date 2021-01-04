#!/usr/bin/env python
import sys
pdb=sys.argv[1]
boundary=int(sys.argv[2])
confile=pdb+".con"
contacts=[]
outfile="long_contacts.txt"
with open(confile,"r") as f:
    for line in f:
        contacts.append( [ int(i) for i in line.strip().split()[:2] ] )
inter=0
intraC=0
for contact in contacts:
    if (contact[0]<=boundary and contact[1]>boundary):
        inter+=1
    elif  (contact[0]>boundary and contact[1]>boundary) :
        intraC+=1
with open(outfile,"a") as out:
    out.write(pdb+" "+str(inter)+" "+str(intraC)+"\n")


#!/usr/bin/env python
import sys
pdb=sys.argv[1]
length=int(sys.argv[2])
confile=pdb+".con"
f=open(confile,"r")
contacts=[]
scan=[]
for line in f:
    contacts.append(line.strip().split()[:2])
contacts=[[int(i) for i in contact] for contact in contacts]
for boundary in range(1,length+1):
    intra=0
    for contact in contacts:
        if (contact[0]<=boundary and contact[1]<=boundary) or (contact[0]>boundary and contact[1]>boundary) :
            intra+=1
    scan.append(intra)
out=open(pdb+".conSNIFF","w")
for i in scan:
    out.write(str(i)+" ")
out.write("\n")

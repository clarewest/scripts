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
    intra_1=0
    intra_2=0
    for contact in contacts:
        if (contact[0]<=boundary and contact[1]<=boundary):
            intra_1+=1
        elif  (contact[0]>boundary and contact[1]>boundary) :
            intra_2+=1
    scan.append((float(intra_1)+float(intra_2))/2)
out=open(pdb+".conSNIFF2","w")
for i in scan:
    out.write(str(i)+" ")
out.write("\n")

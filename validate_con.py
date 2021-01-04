#!/usr/bin/python

from sys import argv
PDB=argv[1]
mode=argv[2]
realfile=PDB+".proxy_map"
if mode == "foldon":
    outfile=PDB+".foldon.con"
    confile1=PDB+".d1.con.tmp"
    confile2=PDB+".d2.con.tmp"
    with open (PDB+".d1.length","r") as f:
        f1len=int(f.readline().strip())
else:
    outfile=PDB+".whole.con"
    confile1=PDB+".con"
real=list()
con=list()
with open(realfile,"r") as f:
    trash=int(f.readline().strip())
    for line in f.readlines():
        real.append([int(n) + 1 for n in line.strip().split()])
with open(confile1,"r") as c1:
    for line in c1.readlines(): 
        con.append([int(n) for n in line.strip().split()[:2]])
if mode =="foldon":
    with open(confile2,"r") as c2:
        for line in c2.readlines():
            con.append([int(n) + f1len for n in line.strip().split()[:2]])
validated=[ [pcon[0],pcon[1], 1] if pcon in real else [pcon[0],pcon[1], 0]  for  pcon in con]
with open(outfile,"w") as f: 
    for line in validated:
        contact=" ".join(str(x) for x in line)
        f.write(PDB+" "+mode+" "+contact+"\n")

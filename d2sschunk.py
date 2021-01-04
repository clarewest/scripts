#!/usr/bin/env python
from Bio.PDB import*
import sys

def sschunk(pdb,length,chain):
        ssfile=pdb+".fasta.ss.long"
        f=open(ssfile,"r")
        breakpoints=[]
        coils = [int(coil[0]) for coil in [line.rstrip().split() for line in open(ssfile,"r")] if coil[1]=="C"] 
        for index, res in enumerate(coils):
            if (coils[index] < length):
                if ((coils[index+1] - coils[index]) > 1) :
                    breakpoints.append(coils[index])
        out=open(pdb+".d2.sschunks","w")
        for i in breakpoints:
            out.write(str(i)+" ")
        out.write("\n")

if __name__ == '__main__':
        argc = len(sys.argv)
        if argc != 4:
                print "Usage: /path/to/sschunk.py PDBcode Length Chain"
        else:
                sschunk(sys.argv[1],int(sys.argv[2]),sys.argv[3])




#!/usr/bin/env python3
from Bio.PDB import*
import sys

def sschunk(pdb,length,chain):
        ssfile=pdb+".long.dssp"
        f=open(ssfile,"r")
        breakpoints=[]
        coils = [int(coil[0]) for coil in [line.rstrip().split() for line in open(ssfile,"r")] if coil[1]=="C"] 
        for index, res in enumerate(coils):
            if (coils[index] < length):
                if ((coils[index+1] - coils[index]) > 1) :
                    breakpoints.append(coils[index+1])
        out=open(pdb+".sschunks","w")
        for i in breakpoints:
            out.write(str(i)+" ")
        out.write("\n")
#        breakpoints.insert(0,1)
#        segments=[[breakpoints[i],end] for i,start in enumerate(breakpoints) for end in breakpoints[i+2:]]     # Get all sschunks
#        segments=[[breakpoints[0],end] for end in breakpoints[2:]]                                             # Get from 1 to each breakpoint
#        segments=[[start,breakpoints[-1]] for start in breakpoints[:-2]]                                        # Get from each breakpoint to last breakpoint
#        get_segments(pdb+".pdb", chain, segments)

def get_segments(pdb, chain,segments):
        pdb_parser = PDBParser(PERMISSIVE=0)                    # The PERMISSIVE instruction allows PDBs presenting errors.
        pdb_structure = pdb_parser.get_structure(pdb,pdb)
        i=1
        while pdb_structure[0][chain].has_id(i)==0:
            i+=1
        start = i
        length = len([residue for residue in pdb_structure[0][chain].get_residues() if is_aa(residue.get_resname())])
        for segment in segments:
            i=segment[0]+(start-1)
            j=segment[1]+(start-1)
            output = pdb[:-4] +"_"+str(segment[0])+"_"+str(segment[1])+".pdb"
            extract(pdb_structure, chain, i, j, output)

if __name__ == '__main__':
        argc = len(sys.argv)
        if argc != 4:
                print("Usage: /path/to/sschunk.py PDBcode Length Chain")
        else:
                sschunk(sys.argv[1],int(sys.argv[2]),sys.argv[3])




#!/usr/bin/env python
import os
import sys
import subprocess
from sys import stdout
from Bio.PDB import*
#from Bio.PDB import PDBParser, PPBuilder, PDBIO, Select, Dice, is_aa

def panchenko(pdb, chain):
    pdb_parser = PDBParser(PERMISSIVE=0)                    # The PERMISSIVE instruction allows PDBs presenting errors.
    pdb_structure = pdb_parser.get_structure(pdb,pdb)
    i=1                                                     # Determine index of first residue
    while pdb_structure[0][chain].has_id(i)==0:
        i+=1                                                # i is the start, j is the stop
    start=i
    print("Starting at residue:", start)
    j=i+9
    scores=list()                                           # Create empty list to hold scores
    length = len([residue for residue in pdb_structure[0][chain].get_residues() if is_aa(residue.get_resname())])
    minf = 10                                               # Define minimum length of a foldon
    th = 3                                                  # Define local minimum threshold
    param=dict(pdb=pdb,chain=chain,length=length)
    n=0
    print 'Chunking at %d to %d...' % (i,j)
    scores.append(chunk(i,j,pdb_structure,param))
    print(scores)
    j+=1
    n+=1
    print 'Chunking at %d to %d...' % (i,j)
    scores.append(chunk(i,j,pdb_structure,param))
    print(scores)
    while j<=param['length']:
        while scores[n] - scores[n-1] > th:                 # while descending
            print 'Descending...'
            j+=1
            n+=1
            scores.append(chunk(i,j,pdb_structure,param))
        print("Foldon found: ",i,"to ",j)
        i=j
        j+=1
        while scores[n] - scores[n-1] < 0:                   # while ascending
            print 'Ascending...'
            j+=1 
            n+=1
            scores.append(chunk(i,j,pdb_structure,param))
    print("End of protein")
        
    
def chunk(start,stop,pdb_structure,param):
    output = param['pdb'][-8:-4] +"_"+param['chain']+"_"+str(start)+"_"+str(stop)+".pdb"
    extract(pdb_structure, "A", start, stop, output)
    command="~/Project/Scripts/score_chunks.sh "+output
    raw=subprocess.check_output(command,shell=True,executable='/bin/bash')
    return float(raw)

if __name__ == '__main__':
    argc = len(sys.argv)
    if argc != 3:
        print "Usage: /data/oliveira/Benchmarking/scripts/get_sequences_from_pdb.py Filename Chain"
    else:
        panchenko(sys.argv[1],sys.argv[2])

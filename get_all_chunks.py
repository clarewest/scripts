#!/usr/bin/env python

import os
import sys
from sys import stdout
from Bio.PDB import*
#from Bio.PDB import PDBParser, PPBuilder, PDBIO, Select, Dice, is_aa

def get_chunk(pdb, chain):
        pdb_parser = PDBParser(PERMISSIVE=0)                    # The PERMISSIVE instruction allows PDBs presenting errors.
        pdb_structure = pdb_parser.get_structure(pdb,pdb)
        i=1
        while pdb_structure[0][chain].has_id(i)==0:
            i+=1
        start = i
        length = len([residue for residue in pdb_structure[0][chain].get_residues() if is_aa(residue.get_resname())])
        chunk = 10
        for i in range(start,length+1-10):
            for j in range(start+9,length+1):
                if (j-i>=9):
                    output = pdb[-8:-4] +"_"+chain+"_"+str(i)+"_"+str(j)+".pdb"
                    extract(pdb_structure, "A", i, j, output)

if __name__ == '__main__':
        argc = len(sys.argv)
        if argc != 3:
                print "Usage: /path/to/get_all_chunks.py PDB.pdb Chain"
        else:
                get_chunk(sys.argv[1],sys.argv[2])

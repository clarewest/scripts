#!/usr/bin/env python

import os
import sys
import io
from sys import stdout
from Bio.PDB import PDBParser, PPBuilder, PDBIO, Select

def get_sequence(pdb, chain):
    pdb_parser = PDBParser(PERMISSIVE=0)                    # The PERMISSIVE instruction allows PDBs presenting errors.
    pdb_structure = pdb_parser.get_structure(pdb,pdb+".pdb")
    pdb_chain = pdb_structure[0][chain]
    i = 1
    lista=[]
    for residue in pdb_chain:
        if i < int(sys.argv[3]) or i > int(sys.argv[4]):
            lista.append(residue.get_id())
            #pdb_chain.detach_child(residue.get_id())
        i+=1
    for x in lista:
        pdb_chain.detach_child(x)

    io = PDBIO()
    io.set_structure(pdb_chain)
    output = sys.argv[5]+"_segment.pdb"
    io.save(output)

if __name__ == '__main__':
        argc = len(sys.argv)
        if argc != 6:
                print "Usage: get_segment_from_pdb.py PDB Chain Res1 Res2 output_dir"
        else:
                get_sequence(sys.argv[1],sys.argv[2])


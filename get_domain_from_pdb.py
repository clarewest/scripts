#!/usr/bin/env python3

import os
import sys
from sys import stdout
from Bio.PDB import PDBParser, PPBuilder, PDBIO, Select

class SelectDomain(Select):
    def __init__(self, chain_letters, start, stop):
        self.chain_letters = chain_letters
        self.start = start
        self.stop = stop

    def accept_chain(self, chain):
        return (chain.get_id() in self.chain_letters)

    def accept_residue(self, residue):
        if self.start <= residue.get_id()[1] <= self.stop:
            return 1
        else:
            return 0

def get_sequence(pdb, chain, first, last, output):
    pdb_parser = PDBParser(PERMISSIVE=0)                    # The PERMISSIVE instruction allows PDBs presenting errors.
    pdb_structure = pdb_parser.get_structure(pdb,pdb)

    pdb_chain = pdb_structure[0][chain]
    ppb=PPBuilder()
    Sequence = ""
    for pp in ppb.build_peptides(pdb_chain):
        Sequence = Sequence + pp.get_sequence()

    io = PDBIO()
    io.set_structure(pdb_structure)
#        if pdb[-5] == chain:
#            output = pdb
#        else:
#            output = pdb[:-4]+chain+".pdb"
### writing out sequence to fasta
#    out = open(output[:-4]+".fasta.txt","w")
#    out.write(">"+output[:-4]+"\n")
#        out.write(str(Sequence[first-1: last-2])+"\n")
#        out.close()
    io.save(output,SelectDomain(chain, first, last))

if __name__ == '__main__':
        argc = len(sys.argv)
        if argc != 6:
                print("Usage: ./get_domain_from_pdb.py Filename Chain First Last Output")
        else:
                get_sequence(sys.argv[1],sys.argv[2], int(sys.argv[3]), int(sys.argv[4]), sys.argv[5])

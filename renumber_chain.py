#!/usr/bin/env python3

import os
import sys
from sys import stdout
from Bio.PDB import PDBParser, PPBuilder, PDBIO, Select

class SelectChains(Select):
    def __init__(self, chain_letters):
        self.chain_letters = chain_letters

    def accept_chain(self, chain):
        return (chain.get_id() in self.chain_letters)

def get_sequence(pdb, chain):
        pdb_parser = PDBParser(PERMISSIVE=0)                    # The PERMISSIVE instruction allows PDBs presenting errors.
        pdb_structure = pdb_parser.get_structure(pdb,pdb)

        pdb_chain = pdb_structure[0][chain]
        ppb=PPBuilder()
        Sequence = ""
        for pp in ppb.build_peptides(pdb_chain):
                Sequence = Sequence + pp.get_sequence()
        start = [ residue.id[1] for residue in pdb_chain ][0]
        if start is not 1:
            for residue in pdb_chain:
                residue.id = (' ', residue.id[1] - start + 1, ' ')
        io = PDBIO()
        io.set_structure(pdb_structure)
#        output = pdb[-8:-4] +"_"+chain+".pdb"
        output = "renumbered_"+pdb
#        out = open(output[:-4]+".fasta.txt","w")
#        out.write(">"+pdb[-8:-4]+"_"+chain+"\n")
#        out.write(str(Sequence))
#        out.close()
        io.save(output,SelectChains(chain))

if __name__ == '__main__':
        argc = len(sys.argv)
        if argc != 3:
                print("Usage: renumber_chain.py PDBfilename Chain")
        else:
                get_sequence(sys.argv[1],sys.argv[2])

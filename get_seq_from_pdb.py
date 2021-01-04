#!/usr/bin/env python3

import os
import sys
from sys import stdout
from Bio.PDB import PDBParser, PPBuilder, PDBIO, Select
import warnings

class SelectChains(Select):
    def __init__(self, chain_letters):
        self.chain_letters = chain_letters

    def accept_chain(self, chain):
        return (chain.get_id() in self.chain_letters)

def get_sequence(pdb, chain):
        if chain is "%":
                chain = " "
        warnings.filterwarnings('always', message='.*discontinuous at.*')
        pdb_parser = PDBParser(PERMISSIVE=0, QUIET=True)                    # The PERMISSIVE instruction allows PDBs presenting errors.
        pdb_structure = pdb_parser.get_structure(pdb,pdb)

        pdb_chain = pdb_structure[0][chain]
        ppb=PPBuilder()
        Sequence = ""
        for pp in ppb.build_peptides(pdb_chain, aa_only=False):
                Sequence = Sequence + pp.get_sequence()

        io = PDBIO()
        io.set_structure(pdb_structure)
        output = pdb[0:-4]+".pdb"
        out = open(output[:-4]+".fasta.atom","w")
        out.write(">"+pdb[0:-4]+"\n")
        out.write(str(Sequence)+"\n")
        out.close()
#       io.save(output,SelectChains(chain))

if __name__ == '__main__':
        argc = len(sys.argv)
        if argc != 3:
                print("Usage: /data/oliveira/Benchmarking/scripts/get_sequences_from_pdb.py Filename Chain")
        else:
                get_sequence(sys.argv[1],sys.argv[2])

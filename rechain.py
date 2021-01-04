#!/usr/bin/env python

import os
import sys
from sys import stdout
from Bio.PDB import PDBParser, PPBuilder, PDBIO, Select

class SelectChains(Select):
    def __init__(self, chain_letters):
        self.chain_letters = chain_letters

    def accept_chain(self, chain):
        return (chain.get_id() in self.chain_letters)

def rechain(pdb):
        pdb_parser = PDBParser(PERMISSIVE=0)                    # The PERMISSIVE instruction allows PDBs presenting errors.
        pdb_structure = pdb_parser.get_structure(pdb,pdb)
        old_chain = [ chain.get_id() for chain in pdb_structure.get_chains() ][0]
        chain = "A"
	pdb_chain = pdb_structure[0][old_chain]
        if pdb_chain.id != chain:
            pdb_chain.id = chain
	io = PDBIO()
	io.set_structure(pdb_structure)
        output = pdb
	io.save(output,SelectChains("A"))

if __name__ == '__main__':
        argc = len(sys.argv)
        if argc != 2:
                print "Usage: /data/oliveira/Benchmarking/scripts/get_sequences_from_pdb.py Filename Chain"
        else:
                rechain(sys.argv[1])

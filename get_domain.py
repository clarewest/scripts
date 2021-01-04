#!/usr/bin/env python

import os
import sys
from sys import stdout
from Bio.PDB import*
#from Bio.PDB import PDBParser, PPBuilder, PDBIO, Select

class SelectChains(Select):
    def __init__(self, chain_letters):
        self.chain_letters = chain_letters

    def accept_chain(self, chain):
        return (chain.get_id() in self.chain_letters)

def get_sequence(pdb, chain, start, stop):
        pdb_parser = PDBParser(PERMISSIVE=0)                    # The PERMISSIVE instruction allows PDBs presenting errors.
        pdb_structure = pdb_parser.get_structure(pdb,pdb)

	pdb_chain = pdb_structure[0][chain]
	ppb=PPBuilder()
	Sequence = ""
	for pp in ppb.build_peptides(pdb_chain, aa_only=False):
		Sequence = Sequence + pp.get_sequence()
#	output = pdb[-8:-4] +"_"+chain+".pdb"
        output = pdb[:-4] + chain + "_" + start + "_" + stop + ".pdb"
#	out = open(output[:-4]+".fasta.txt","w")
#	out.write(">"+output[:-4]+"\n")
#	out.write(str(Sequence))
#	out.close()
	extract(pdb_structure, chain, int(start), int(stop), output)
#	extract(pdb_structure, SelectChains(chain), start, stop, output)

if __name__ == '__main__':
        argc = len(sys.argv)
        if argc != 5:
                print "Usage: /path/to/script/get_domain_from_pdb.py Filename Chain Start Stop"
        else:
                get_sequence(sys.argv[1],sys.argv[2], sys.argv[3], sys.argv[4])

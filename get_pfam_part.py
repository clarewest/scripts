#!/usr/bin/env python

import os
import sys
from sys import stdout
#from Bio.PDB import PDBParser, PPBuilder, PDBIO, Select, Dice
from Bio.PDB import*
from Bio.PDB.Polypeptide import three_to_one
from Bio.PDB.Polypeptide import is_aa

class SelectChains(Select):
    def __init__(self, chain_letters):
        self.chain_letters = chain_letters

    def accept_chain(self, chain):
        return (chain.get_id() in self.chain_letters)

def get_sequence(pdb, chain, start, stop, renum):
        pdb_parser = PDBParser(PERMISSIVE=0)                    # The PERMISSIVE instruction allows PDBs presenting errors.
        output = pdb[:-4] + chain + "_" + str(start) + "_" + str(stop) + ".pdb"
        try:
          pdb_structure = pdb_parser.get_structure(pdb,pdb)
        except IOError:
          with open("error.out",'a') as fout:
            fout.write("NOPDB: "+output[:-4]+"\n")
        else:
	  pdb_chain = pdb_structure[0][chain]
#         wholeseq = [[three_to_one(residue.get_resname()),residue.get_id()[1]] if is_aa(residue.get_resname(), standard=True) else ["X",residue.get_id()[1]] for residue in pdb_structure[0][chain].get_residues() ]
 #         partseq = [res[0] for res in wholeseq if start <= res[1] <= stop ]
          output = pdb[:-4] + chain + "_" + str(start) + "_" + str(stop) + ".pdb"
          if (renum != 0):
            print(renum)
            for residue in pdb_chain:
              i = residue.id[1]
              residue.id = (" ", i-renum, " ")
#            with open("error.out",'a') as fout:
#              fout.write("NORES: "+output[:-4]+"\n")
#          else:
	  extract(pdb_structure, chain, start, stop, output)
#            if sum(["X" in res for res in partseq]) > 0:
#              with open("IDs_missing_residues.txt","a+") as err:
#                err.write(output[:-4]+"\n")
#            else:
#              with open("IDs_complete.txt","a+") as IDS:
#                IDS.write(output[:-4]+"\n")
#	    out = open(output[:-4]+".fasta.txt","w")
#	    out.write(">"+output[:-4]+"\n")
#	    out.write(''.join(partseq)+"\n")
#	    out.close()

if __name__ == '__main__':
        argc = len(sys.argv)
        if argc == 2:
          get_sequence(sys.argv[1].split()[0],sys.argv[1].split()[1], int(sys.argv[1].split()[2]), int(sys.argv[1].split()[3]), int(sys.argv[1].split()[4]))
        elif argc == 6:
          get_sequence(sys.argv[1],sys.argv[2], int(sys.argv[3]), int(sys.argv[4]), int(sys.argv[5]))
        else:
          print "Usage: /path/to/script/get_domain_from_pdb.py Filename Chain Start Stop Renum"

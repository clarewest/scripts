        #!/usr/bin/env python
import os
import sys
import subprocess
import csv
from sys import stdout
from Bio.PDB import*

class SelectChains(Select):
    def __init__(self, chain_letters):
        self.chain_letters = chain_letters

    def accept_chain(self, chain):
        return (chain.get_id() in self.chain_letters)

def get_structure(pdb):
    pdb_parser = PDBParser(PERMISSIVE=0,QUIET=True)                    # The PERMISSIVE instruction allows PDBs presenting errors.
    try:
        pdb_structure = pdb_parser.get_structure(pdb,pdb)
    except IOError:
        with open("error.out",'a') as fout:
            fout.write("NOPDB: "+pdb+"\n")
    else:
        return(pdb_structure)

def write_out(listoflists, outfile):
    with open(outfile, "w") as f:
        wr = csv.writer(f, delimiter=" ")
        wr.writerows(listoflists)

def get_average_pcon(pcons, residues):
    model = pcons.strip().split()
    pcon = [ float(model[i+1]) for i in residues ]
    average_pcon = sum(pcon)/len(pcon)
    return([model[0], round(average_pcon,3)])

def get_sampled_residue_numbers(target):
    chain = "A"
    with open(target+".lst","r") as lst:
        decoy=lst.readline().strip()
    sampled_structure = get_structure(target+"/"+decoy+".cut")
    sampled_residues = [residue.get_id()[1] for residue in sampled_structure[0][chain].get_residues() if is_aa(residue.get_resname())]
    return(sampled_residues)

def get_pcons_local(target):
    sampled_residue_numbers = get_sampled_residue_numbers(target)
    pcons_file = target+".pcons.txt"
    average_pcons = []
    with open(pcons_file, "r") as f:
        line = f.readline()
        if "Too few pdbfiles (0) found" not in line:
            while line[0:4] != target[0:4]:
                line = f.readline()
            average_pcons.append([target] + get_average_pcon(line, sampled_residue_numbers))
            for line in f:
                if line.strip() != "END":
                    average_pcons.append([target] + get_average_pcon(line, sampled_residue_numbers))
    write_out(average_pcons, target+".pcons_local.txt")

if __name__ == '__main__':
    argc = len(sys.argv)
    if argc != 2:
        print "Usage: get_local_pcons.py Target"
    else:
        get_pcons_local(sys.argv[1])


#!/usr/bin/env python
import os
import sys
import subprocess
import numpy as np
from sys import stdout
from Bio.PDB import*
#from Bio.PDB import PDBParser, PPBuilder, PDBIO, Select, Dice, is_aa

def panchenko(pdb, chain):
    pdb_parser = PDBParser(PERMISSIVE=0,QUIET=True)                    # The PERMISSIVE instruction allows PDBs presenting errors.
    code=pdb[:-4]
    try:
        pdb_structure = pdb_parser.get_structure(pdb,pdb)
#    except Bio.PDB.PDBExceptions.PDBConstructionException:
#        with open("error.out",'a') as fout:
#            fout.write("UNPARSEABLE: "+code+chain)
    except IOError:
        with open("error.out",'a') as fout:
            fout.write("NOPDB: "+code+chain+"\n")
    else:
        start=list(pdb_structure[0][chain].get_residues())[0].get_id()[1]
    #    print("Starting at residue:", start)
        resnums= [residue.get_id()[1] for residue in pdb_structure[0][chain].get_residues() if is_aa(residue.get_resname())]
        start = resnums[0]
        end = resnums[-1]
        trueLength = len(resnums)
        length = end - start + 1
        supLength = int(code.split('_')[2])-int(code.split('_')[1])+1
        if length == supLength:
            with open("rightLength.txt","a") as f:
                f.write(str(code)+"\n")   
        else:
            with open("wrongLength.txt","a") as f:
                f.write(str(code)+"\n")   

def chunk(start,stop,pdb_structure,param):
    output = param['pdb'][-8:-4] +"_"+param['chain']+"_"+str(start)+"_"+str(stop)+".pdb"
    extract(pdb_structure,param['chain'], start, stop, output)
    command="~/Project/Scripts/score_chunks.sh "+output
    raw=subprocess.check_output(command,shell=True,executable='/bin/bash')
    os.remove(output)
    return float(raw)

def scan(start,stop,i,pdb_structure,param,sc_matrix,breakpoints,dips,scores):
    for j in range(start+9,stop-9):
        try:
            score=(chunk(start,j,pdb_structure,param)+chunk(j,stop,pdb_structure,param))/2
        except ValueError:
            with open("error.out",'a') as fout:
                fout.write("ScoreError: "+param['code']+param['chain']+" "+str(j)+"\n")
        else:    
            sc_matrix[i,j-1]=score
#           print(j)
    try:
        minpoint=(np.argmin(sc_matrix[i,(start+9-1):(stop-9-1)])+start+9)
#    dip=((np.sum(sc_matrix[i,(start+9):stop])/(stop-(start+9)))-sc_matrix[i,minpoint])
    except ValueError:
        with open("error.out",'a') as fout:
            fout.write("ValueError: "+param['code']+param['chain']+"\n")
    else:
        dip=min((sc_matrix[i,(start+9-1)]-sc_matrix[i,minpoint-1]),(sc_matrix[i,(stop-10-1)]-sc_matrix[i,minpoint-1]))
        i+=1
        if ( minpoint - start ) > param['minf'] and ( stop - minpoint ) > param['minf']:
            breakpoints.append(minpoint)
            dips.append(dip)
            scores.append((param['allscore']-sc_matrix[(i-1),(minpoint-1)]))
#            print("Breaking at: ",minpoint)
            scan(start,minpoint,i,pdb_structure,param,sc_matrix,breakpoints,dips,scores)
            scan(minpoint,stop,i,pdb_structure,param,sc_matrix,breakpoints,dips,scores)

    
if __name__ == '__main__':
    argc = len(sys.argv)
    if argc != 3:
        print "Usage: /data/oliveira/Benchmarking/scripts/get_sequences_from_pdb.py Filename Chain"
    else:
        panchenko(sys.argv[1],sys.argv[2])

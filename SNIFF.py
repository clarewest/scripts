#!/usr/bin/env python3
import os
import sys
import subprocess
import numpy as np
from sys import stdout
from Bio.PDB import*
#from Bio.PDB import PDBParser, PPBuilder, PDBIO, Select, Dice, is_aa

def panchenko(pdb, chain):
    pdb_parser = PDBParser(PERMISSIVE=0,QUIET=True)                    # The PERMISSIVE instruction allows PDBs presenting errors.
    code=pdb[-8:-4]
    try:
        pdb_structure = pdb_parser.get_structure(pdb,pdb)
    except IOError:
        with open("error.out",'a') as fout:
            fout.write("NOPDB: "+code+chain+"\n")
    else:
        start=list(pdb_structure[0][chain].get_residues())[0].get_id()[1]
    #    print("Starting at residue:", start)
        resnums= [residue.get_id()[1] for residue in pdb_structure[0][chain].get_residues() if is_aa(residue.get_resname())]
        start = resnums[0]
        length = len(resnums)
        end = resnums[length-1]
        minf = 15                                                                   # Define minimum length of a foldon
        sc_matrix = np.matrix(np.zeros((20,end)))                                   # Begin a matrix for the scores
        param=dict(pdb=pdb,chain=chain,length=length,minf=minf,code=code)           # Struct to make variables manageable
        param['allscore'] = chunk(start,end,pdb_structure,param)
        i=0
        breakpoints=list()
        dips=list()
        scores=list()
        scan(start,end,i,pdb_structure,param,sc_matrix,breakpoints,dips,scores)     # SNIFF
        sc_matrix=sc_matrix[~(sc_matrix==0).all(1).A1]                              # Remove all-zero rows
        np.savetxt(pdb[:-4]+'_chunks.out',sc_matrix)                                # Output SNIFF results
        bps=ds=ss=""
        for bp in breakpoints:
            bps+=str(bp)+" "
        for dip in dips:
            ds+=str(dip)+" " 
        for score in scores:
            ss+=str(score)+" "    
        with open("breakpoints.txt","a") as f:                                      # Output breakpoints
            f.write(pdb[:-4]+" "+bps+"\n")
        with open("dips.txt","a") as f:                                             # Output 'dip' of breakpoints' (difference between min point and lowest energy end)
            f.write(pdb[:-4]+" "+ds+"\n")
        with open("scores.txt","a") as f:
            f.write(pdb[:-4]+" "+ss+"\n")                                           # Output 'score' of breakpoints (difference between min point and energy of entire protein)
        with open("wholescores.txt","a") as f:
            f.write(pdb[:-4]+" "+str(param['allscore'])+"\n")                       # Output energy of entire protein

def chunk(start,stop,pdb_structure,param):                                                  # Create pdb file, score and remove
    output = param['pdb'][:-4] +"_"+param['chain']+"_"+str(start)+"_"+str(stop)+".pdb"
    extract(pdb_structure,param['chain'], start, stop, output)
    command="~/Project/Scripts/score_chunks.sh "+output
    raw=subprocess.check_output(command,shell=True,executable='/bin/bash')
    os.remove(output)
    return float(raw)

def scan(start,stop,i,pdb_structure,param,sc_matrix,breakpoints,dips,scores):               # Recursive function to scan for minimum, cut and scan again until the minimum foldon size is reached
    for j in range(start+9,stop-9):
        try:
            score=(chunk(start,j,pdb_structure,param)+chunk(j,stop,pdb_structure,param))/2  # Score average energy of peptide either side of j
        except ValueError:
            with open("error.out",'a') as fout:
                fout.write("ScoreError: "+param['code']+param['chain']+" "+str(j)+"\n")
        else:    
            sc_matrix[i,j-1]=score
#           print(j)
    try:
        minpoint=(np.argmin(sc_matrix[i,(start+9-1):(stop-9-1)])+start+9)                   # Get minimum point
#    dip=((np.sum(sc_matrix[i,(start+9):stop])/(stop-(start+9)))-sc_matrix[i,minpoint])
    except ValueError:
        with open("error.out",'a') as fout:
            fout.write("ValueError: "+param['code']+param['chain']+"\n")
    else:
        dip=min((sc_matrix[i,(start+9-1)]-sc_matrix[i,minpoint-1]),(sc_matrix[i,(stop-10-1)]-sc_matrix[i,minpoint-1]))      # Get 'dip' value of breakpoint
        i+=1
        if ( minpoint - start ) > param['minf'] and ( stop - minpoint ) > param['minf']:                                    # Append scores and cut again if minimum foldon size is not reached
            breakpoints.append(minpoint)
            dips.append(dip)
            scores.append((param['allscore']-sc_matrix[(i-1),(minpoint-1)]))
#            print("Breaking at: ",minpoint)
            scan(start,minpoint,i,pdb_structure,param,sc_matrix,breakpoints,dips,scores)
            scan(minpoint,stop,i,pdb_structure,param,sc_matrix,breakpoints,dips,scores)

    
if __name__ == '__main__':
    argc = len(sys.argv)
    if argc != 3:
        print("Usage: /path/to/script/SNIFF.py PDBfilename Chain")
    else:
        panchenko(sys.argv[1],sys.argv[2])

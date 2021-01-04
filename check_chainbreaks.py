#!/usr/bin/env python
# coding: utf-8
import os
import sys
import glob
import Bio
from Bio.PDB import PDBParser, PPBuilder, PDBIO
import warnings

io = PDBIO()
warnings.filterwarnings('always', message='.*discontinuous at.*')
filename=sys.argv[1]
pdb_parser = PDBParser(PERMISSIVE=0,QUIET=True)

#pdbs = glob.glob("/data/pegasus/west/CLIPT/*.pdb")
with open(filename) as f:
    pdbs=f.read().splitlines()
for pdb in sorted(pdbs):
  code = pdb[:-4]
  chainid = pdb[4]
  pdbfile = pdb
  print code + chainid
  try:
    struc = pdb_parser.get_structure(code, pdbfile)
  except Bio.PDB.PDBExceptions.PDBConstructionException:
    with open("unparsable.5codes",'a') as fout:
      fout.write(code + '\n')
    continue
  except IOError:
    with open("missingpdbs.txt",'a') as fout:
      fout.write(pdbfile + '\n')
    continue
  chain = struc[0][chainid]
  resnums = [resi.id[1] for resi in chain]
#  calphas = [resi['CA'] for resi in chain]
  #print code + chainid
  # find gaps in numbering
  breaks = [j for i,j in enumerate(resnums) if i != 0 and j != resnums[i-1]+1 ]
#  dists = [j - calphas[i-1] for i,j in enumerate(calphas) if i != 0 ]
  # measure c-alpha distances
#  breakdists = [j for i,j in enumerate(calphas) if i != 0 and (j - calphas[i-1]) > 4]
  #print breakdists
  #print breaks
  # use in built polypeptide builder
  ppb=PPBuilder()
  if len(ppb.build_peptides(struc[0][chainid])) > 1:
    with open("bad.5codes",'a') as fout:
      fout.write(code + '\n')
    if False:
      #for pp in ppb.build_peptides(struc): 
      print pp.get_sequence()
      io.set_structure(pp)
      io.save("/tmp/test.pdb")
  else:
    with open("good.5codes",'a') as fout:
      fout.write(code + '\n')
  #print '\n'.join(map(str,dists))
  #if len(breaks) > 0:
  if False:
    print "breaks", breaks
    print resnums
    print len(resnums)
#for resi in chain:
#    print resi.id[1]
    


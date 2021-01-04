# coding: utf-8
import glob
import Bio.PDB
import numpy
from Bio.PDB import PDBParser, PPBuilder, PDBIO
import warnings
import sys
import os

def set_atom_lists(ref_chain, alt_chain, seq, val):
  ref_atoms = []
  alt_atoms = []
  for ref_res, alt_res, amino, allow in zip(ref_chain, alt_chain, seq, val):
      if not ref_res.resname == alt_res.resname:
        print ref_res.resname, alt_res.resname
        exit()
      assert ref_res.id      == alt_res.id
      assert amino == Bio.PDB.Polypeptide.three_to_one(ref_res.resname)
      if allow:
        for atomtype in ["CA","C","O","N"]:
          ref_atoms.append(ref_res[atomtype])
          alt_atoms.append(alt_res[atomtype])
  return ref_atoms, alt_atoms
  
args = sys.argv
homo = "--homo" in args or "-h" in args         # Segment and native not from same file 
crystal = "--crystal" in args or "-c" in args   # Segment from a different crystal structure
end = "--end" in args or "-e" in args           # Ignore segment in RMSD
saulo = "--saulo" in args or "-s" in args       # No segment, different file set-up
rosetta = "--rosetta" in args or "-r" in args   # Saulo but with different file set-up
if crystal:
  args.remove("-c")
if homo:
  args.remove("-h")
if saulo:
  args.remove("-s")
if end:
  args.remove("-e")
if rosetta:
  args.remove("-r")
if len(args) != 4:
  print "USAGE:    script.py [-h] [-c] [-e] [-s] <pdbcode> <pathtodata> <decoysuperfolder>"
pdbcode = args[1]                                                                       # Full name of target 
pathtodata = args[2]                                                                    # Proteinprep directory
decoysuperfolder = args[3]                                                              # Decoy directory path 
rev = "_rev" == decoysuperfolder[-4:]

print "Homology model scaffold:", homo

io = PDBIO()
warnings.filterwarnings('always', message='.*discontinuous at.*')
pdb_parser = PDBParser(PERMISSIVE=1,QUIET=True)

if saulo or rosetta:
  seg = 0                                                       
else:
  with open(pdbcode + ".seg") as fin:
    seg = int(fin.readline().strip())

if homo:
  pdb = pathtodata + "/real_" + pdbcode + ".pdb"                                            # PDB file of native structure (pdbcode.pdb is the template for seg)
else:
  pdb = pathtodata + "/" +  pdbcode + ".pdb"
native = pdbcode                                      
print "Using target structure: ", pdb
chain = pdbcode[4]
if saulo or rosetta:                                           # Scaffold chain is A for homology model or normal decoy
  decoychain = "A"
elif crystal:
  with open(pathtodata + "/" + pdbcode + ".chain") as fin:    # Otherwise its template crystal structure chain
      decoychain = fin.readline().strip()
      if len(decoychain) is 0:
        decoychain = " "
#else:
#  decoychain = chain                                        # For normal SAINT2 Eleanor it's the same as seg
#  tmhs = [ [ int(i) for i in line.strip().split() ] for line in lines[4:] ]
with open(pathtodata + "/" + pdbcode + ".length") as fin:
  length = int(fin.readline().strip())

print "Number of residues to score:", length-seg                                      # Length of sampled region 

with open(pathtodata + "/" + pdbcode + ".fasta.txt") as fin:
  lines = fin.readlines()
  sequence = lines[1].strip()

print(len(sequence))
print(length)
print(seg)

########## Setting atoms to score ##########
score_residues = [False] * len(sequence)
if rev:
  score_range = tmhs[:score_tmhs]
elif saulo or rosetta:
  score_residues = [True] * len(sequence)           # Inclue all in scoring
else:
  for i in range(seg,length):
    score_residues[i] = True                         # Include only sampled region in scoring
#for tmh in score_range:
#  for i in range(tmh[0]-1,tmh[1]):
#    valid[i] = True
######### Settings atoms as scaffold ######
if homo:                                            # If seg is not from the native, it needs to be superimposed
  homo_scaf_residues = [False] * len(sequence)
  if rev:
    scaf_range = tmhs[3:]
  else:
    for i in range(0,seg):
      homo_scaf_residues[i] = True
if end or saulo or rosetta:
  homo_scaf_residues =  [ i for i in score_residues ]  # Superimpose same region as scoring 
#  for tmh in scaf_range:
#    for i in range(tmh[0]-1,tmh[1]):
#      homo_valid[i] = True
###########################################

structure = pdb_parser.get_structure(native, pdb)
nat_chain = structure[0][chain]


########## What is cncode ################
if saulo:
  decoys = [ decoyfile for decoyfile in glob.glob(decoysuperfolder + "/" + pdbcode + "*linear*") ]
elif rosetta: 
  decoys = [ decoyfile for decoyfile in glob.glob(decoysuperfolder + "/*") ]
else:
  decoys = [ decoyfile for decoyfile in glob.glob(decoysuperfolder + "/icarus.stats.ox.ac.uk/" + pdbcode + "*linear*") if decoyfile[-4:] != ".cut" and decoyfile[-9:] != ".rescored" ]

if end:
  pref = "endscore_"
else:
  pref = "pyscore_"

#if os.path.exists(pref + decoysuperfolder):
#  with open(pref + decoysuperfolder) as fin:
#    donedecoys = [ line.strip().split()[0] for line in fin.readlines() ]
#  donedecoys = [ decoysuperfolder + "/" + filename.rsplit("_",2)[1] + "/" + filename for filename in donedecoys ]
#  decoys = sorted(list(set(decoys) - set(donedecoys)))


count = len(decoys)
print "Number of decoys to score:", count  
with open(pref + decoysuperfolder,'a') as fout:
  for decoy in decoys:
    decoyname = decoy.rsplit('/',1)[1]
    decoy_structure = pdb_parser.get_structure(pdbcode, decoy)
    try:
      decoy_chain = decoy_structure[0]
    except KeyError:
      print decoy
      continue
    decoy_chain = decoy_structure[0][decoychain]

    nat_score_atoms, decoy_score_atoms =  set_atom_lists(nat_chain, decoy_chain, sequence, score_residues)     # List of residues to score RMSD

    if homo or saulo or end or rosetta:

      nat_scaf_atoms, decoy_scaf_atoms =  set_atom_lists(nat_chain, decoy_chain, sequence, homo_scaf_residues)     # List of atoms to set as scaffold

      super_imposer = Bio.PDB.Superimposer()
      super_imposer.set_atoms(nat_scaf_atoms, decoy_scaf_atoms)                                                    # Superimpose scaffold of decoy and target

      super_imposer.apply(decoy_chain.get_atoms())  
      if count == 1:
        with open("homo_seg_accuracy",'a') as foutseg:
          foutseg.write(decoysuperfolder + "\t%0.2f" % (super_imposer.rms) + "\n")                      # Output RMSD of homology model against target segment (only for the last decoy)

      #io=Bio.PDB.PDBIO()
      #io.set_structure(decoy_structure)
      #io.save("pdb_out_filename.pdb")


    rmsd = numpy.sqrt(sum([ (pair[0] - pair[1]) ** 2 for pair in zip(decoy_score_atoms, nat_score_atoms) ]) / len(decoy_score_atoms))      # Get RMSD of sampled region after superimposition
    #print rmsd
    fout.write("{}\t{:.6f}\n".format(decoyname, rmsd))                                                                                     # Output RMSD of decoy

    count -= 1
    if count % 200 == 0:
      print "count", count
  #if homo:
  #  print '\t'.join([str(res.id[1]) for res,val in zip(nat_chain,homo_valid) if val])
  #print '\t'.join([str(res.id[1]) for res,val in zip(nat_chain,valid) if val])

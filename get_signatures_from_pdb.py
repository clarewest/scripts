#!/usr/bin/env python

import os
import sys
from sys import stdout
from Bio.PDB import PDBParser, CaPPBuilder, is_aa, Selection
from math import sqrt,pow,log

# This function takes an input PDB code and returns a structure 
# object.
def pdb_buildstructure(pdbfile):
		pdb_parser = PDBParser(PERMISSIVE=1) 	# The PERMISSIVE instruction allows PDBs presenting errors.
		return pdb_parser.get_structure("name",pdbfile)    # This command gets the structure of the PDB

# This function takes a PDB and returns an object with
# the structural data of chain "chain" of the model "model". 
def pdb_getchain(pdb, chain = "A", model = 0):
	pdb_structure = pdb_buildstructure(pdb)
	return pdb_structure[model][chain]

# This function takes a polypeptide and removes the terminal regions without secondary structure
def pp_trim(pp):
        with open(pdb[:-4]+".dssp","r") as dssp:
                ss=dssp.readline().strip("\n")
        struc=[i for i in range(0,len(ss)) if ss[i] in ["H","E"]]
        pp=pp[struc[0]:struc[-1]+1]
        return pp
   
# This function takes a residue and returns the c_beta atom (or c_alpha for glycine)
def res_getcbeta(res):
        if res.has_id("CB"):
                c_beta = res["CB"]
        else:
                c_beta = res["CA"]
        return c_beta

def norm(atom_1,atom_2):
	return sqrt(pow((atom_1[0]-atom_2[0]),2) + pow((atom_1[1]-atom_2[1]),2) + pow((atom_1[2]-atom_2[2]),2))

# This function takes an input polypeptide and returns the centre of geometry using 
# backbone as default or all atoms if sidechain=1
def pp_getcgeom(pp,sidechains=0):
        if sidechains: 
                sum_coords = sum([atom.get_coord() for atom in Selection.unfold_entities(pp,"A")])               
                centre_g = sum_coords/len(Selection.unfold_entities(pp,"A"))
        else:
                backbone = ["CA","CB","N","O"]
                coords = [atom.get_coord() for atom in Selection.unfold_entities(pp,"A") if atom.get_id() in backbone]
                centre_g = sum(coords)/len(coords)
        return centre_g

# This function takes an input of a list of distances and returns the Moment of Intertia
def get_MoI(dists):
        MoI = sum([pow(dist,2) for dist in dists])/len(dists)
        return MoI

# This function outputs a sparse matrix with the residue contacts for
# chain "chain" of the protein "pdb". The variable "dist" is used to
# determine the distance cutoff for residues to be considered in contact.

def pdb_polypep(pdb,chain,trim):	
	i=0
	# Get chain code from 6th letter in pdb name
	pdb_chain = pdb_getchain(pdb,chain)
	ppb=CaPPBuilder()
	# Initialise building of a polypeptide and its sequence
	# If a mutated residue is present in a chain it is classed as a hetatm
	# However, not all hetatms in a chain are part of the sequence. The CaPPBuilder
	# makes sequences by requiring CA-CA distances to be <4.3A. Common hetatms are
	# identified such that an MSE hetatm will be replaced by an M in the sequence
	polypepTot = ppb.build_peptides(pdb_chain, aa_only=False)[0] 
	sequen = polypepTot.get_sequence()
	# Add to the polypeptide
	for polypep_raw in ppb.build_peptides(pdb_chain, aa_only=False)[1:]:
		sequen     += (polypep_raw.get_sequence())
		polypepTot += polypep_raw
        # Remove unstructured terminal ends
        if trim:
                polypepTot=pp_trim(polypepTot)
	# Sometimes the terminal residue in a protein isn't fully resolved
	last_res = polypepTot[-1]
	if last_res.has_id("CA") or last_res.has_id("CB"):
		polypep = polypepTot      # If resolved take whole AA
#		file_seq.write(">sequence\n%s\n" %sequen)
##		file_seq.write("%s" %sequen)
	else:
		polypep = polypepTot[:-1] # Otherwise take all but the last AA 	
#		file_seq.write(">sequence\n%s\n" %sequen[:-1])		
##		file_seq.write("%s" %sequen[:-1])		
#	file_map.write( str(len(polypep)) +"\n" )
#	sys.stderr.write(pdb+'\n')
        return polypep

def pdb_contacts(polypep,dist):
        i=0
        N=0.0
        sum_Lij=0.0
	for residue1 in polypep:
	# Quite frequently residues do not have resolved CB, in which case use CA
	# If no CA exists, print ERROR. Grep the output if running unsupervised.
			try:	
				if residue1.has_id("CB"): #get_resname() == "GLY":
					c_alpha=residue1["CB"]		
				else:
					c_alpha=residue1["CA"]
			except:
				sys.stdout.write("ERROR")
				raise
			i+=1
			j=0
			for residue2 in polypep:
					try:
						if residue2.has_id("CB"): #get_resname() == "GLY":
							c_alpha2=residue2["CB"]
						else:					
							c_alpha2=residue2["CA"]
					except:
						file_map.write("ERROR")
						raise
					j+=1
					if (norm(c_alpha.get_coord(),c_alpha2.get_coord()) < dist): # 3.5 ):
                                                Lij = abs((i-1)-(j-1))
                                                if Lij > contact_min:
                                                    sum_Lij = sum_Lij + Lij
                                                    N = N + 1.0
#                                                file_map.write("%d %d\n" %(i-1,j-1))
        AbsCO = sum_Lij *(1/N)
        RelCO = sum_Lij * (1/(N*len(polypep)))
        file_co.write("%s %d %f %f\n" % (pdb[:-4],N,AbsCO,RelCO))

def pdb_signatures(polypep):
        c_geom=pp_getcgeom(polypep)     # Centre of Geometry 
        distances = [norm(c_geom,res_getcbeta(residue).get_coord()) for residue in polypep]
        MCR=list()
        w_MCR=list()
        for core_size in [4,8]:
                core = [distances.index(sorted(distances)[i]) for i in range(0,core_size)]       # indices of core residues
                W = [1/sorted(distances)[i] for i in range(0,core_size)]                         # weights for core residues
                w_MCR.append(sum([i*w for i,w in zip(core,W)])/(sum(W)*len(polypep)))                  # weighted MCR
                MCR.append((sum(core)/float(len(core)))/len(polypep))                                  # Mean Central Residue
        MoI = get_MoI(distances)                                                                    # Moment of Inertia
        hydrophobic = ["ALA","CYS","ILE","LEU","MET","PHE","PRO","TRP","VAL"]
        h_polypep=[residue for residue in polypep if residue.get_resname() in hydrophobic]  
        h_MoI = get_MoI([norm(pp_getcgeom(h_polypep),res_getcbeta(residue).get_coord()) for residue in h_polypep])  # Hydrophobic MoI
        NC_cen=list()
        r_MoI=list()
        for blob_size in [1,4,8]:
                NC_cen.append(log(norm(c_geom,pp_getcgeom(polypep[:blob_size]))/norm(c_geom,pp_getcgeom(polypep[-blob_size:])))) # Using CoG of blob_size N- and C-terminal residues
                r_MoI.append(log(get_MoI(distances[:blob_size])/get_MoI(distances[-blob_size:])))     # Relative MoI
        file_sig.write("%s " % pdb[:-4] + "%f %f " % tuple(MCR) + "%f %f " % tuple(w_MCR) + "%f %f %f " % tuple(NC_cen) + "%f " % MoI + "%f %f %f " % tuple(r_MoI) + "%f\n" % h_MoI)

if __name__ == '__main__':
	argc = len(sys.argv)
	if argc < 2:
		print "Usage: ./get_signatures_from_pdb.py filename.pdb Chain 8.0 4"
	else:
		pdb=sys.argv[1]
		chain=sys.argv[2]
		dist=float(sys.argv[3])
                contact_min=int(sys.argv[4])
#		file_seq = open(pdb[:-4]+".proxy_fasta", 'w')
#		file_map = open(pdb[:-4]+".proxy_map",'w')
                file_co = open("/data/cockatrice/west/ASTRAL/contacts/"+pdb[:-4]+".co","w")
#                for trim in [0,1]:
                trim=0
                polypep = pdb_polypep(pdb,chain,trim)
                if not trim:
#		        pdb_contacts(polypep,dist)
                        file_sig = open("/data/cockatrice/west/NewDomains/"+pdb[:-4]+".sig","w") 
                else:
                        file_sig = open("/data/cockatrice/west/ASTRAL/signatures/"+pdb[:-4]+".sig.trimmed","w")
                pdb_signatures(polypep)



import os
import sys
import glob

def getInterCons(contactfile,boundary,term):
    with open(contactfile,"r") as f:
        length=int(f.readline().strip())
        contacts=[]
        for line in f:
            contacts.append([int(i) for i in line.strip().split()[:2]])
    if term == "C":
        intercons=[ contact for contact in contacts if (contact[0]<=seg and contact[1]>seg) ]
    elif term == "N":
        intercons=[ contact for contact in contacts if (contact[0]<(length-seg) and contact[1]>=(length-seg)) ]
    return(intercons)

def getFnat(nativeContacts,decoyContacts):
    nat = [ True if contact in nativeContacts else False for contact in decoyContacts]
    fnat = round(float(sum(nat))/float(len(nativeContacts)),2)                            # Fraction of native inter-contacts reproduced in decoy
    fnonnat = round(1-(float(sum(nat))/float(len(nat))),2)                              # Fraction of incorrect intercontacts found in decoy
    return(fnat,fnonnat)
   
def pdb_contacts(pdb,seg,dist):
    fout=open("fnat_"+pdb+".txt","a")
    nativemap=pdb+".proxy_map_"+dist
    nintercons=getInterCons(nativemap,seg,terminus)
    decoymaps = [ decoymap for decoymap in glob.glob(pdb+"/"+pdb+"*.proxy_map_"+dist) if decoymap not in [nativemap] ]
    for decoymap in decoymaps:
#        print(decoymap)
        decoy=decoymap.split("/")[1][:-14]
        dintercons=getInterCons(decoymap,seg,terminus)
        [fnat,fnonnat]=getFnat(nintercons,dintercons)
        fout.write(pdb+" "+decoy+" "+str(fnat)+" "+str(fnonnat)+"\n")

if __name__ == '__main__':
    argc = len(sys.argv)
    if argc < 3:
	print "Usage: ./fnat.py <PDBID> <Seg> <Terminus>"
    else:
	pdb=sys.argv[1]
        seg=int(sys.argv[2])
        terminus=sys.argv[3]
        contactdist=sys.argv[4]
	pdb_contacts(pdb,seg,contactdist)


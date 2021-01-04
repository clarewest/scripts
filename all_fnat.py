import os
import sys
 
def fnat(pdb,chain,dist,decoys):
    mapdirectory=decoydirectory+"contactmaps"
    if not os.path.exists(mapdirectory):
        os.makedirs(mapdirectory)
    native=pathtodata+pdb
    os.system("~/Project/Scripts/getcontactsSparse3.py "+)
    

if __name__ == '__main__':
	argc = len(sys.argv)
	if argc < 5:
		print "Usage: ./fnat.py <PDBID> <Chain> <DecoyChain> <ContactDistance> <PathToData> <PathToDecoys>"
	else:
		pdb=sys.argv[1]
		chain=sys.argv[2]
                decoychain=sys.argv[3]
		dist=float(sys.argv[4])
                pathtodata=sys.argv[5]
                pathrodecoys=sys.argv[6]
		file_seq = open(pdb[:-4]+".proxy_fasta", 'w')
		file_map = open(pdb[:-4]+".proxy_map",'w')
		pdb_contacts(pdb,chain,dist)


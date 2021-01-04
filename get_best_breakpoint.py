
with open("foldon1A_firstres.txt","r") as f:
	for line in f:
		fields=line.strip().split()
		if len(fields) == 3:
			firstres=int(fields[1])
			breakpoint=int(fields[2])-(firstres-1)
			PDB=fields[0]
			with open(PDB+".sschunks","r") as f2:
				sschunks=f2.readline().strip().split()
				diffs=[abs(breakpoint-int(sschunk)) for sschunk in sschunks]
				bestpoint=sschunks[diffs.index(min(diffs))]
				with open("foldon1A_segments.txt","a") as out:
					out.write(PDB+" "+bestpoint+" "+str(int(bestpoint)+firstres-1)+"\n")


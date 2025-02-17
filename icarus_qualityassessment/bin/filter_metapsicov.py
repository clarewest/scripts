import sys
import csv

def writeOut(listoflists, outfile):
    with open(outfile, "w") as f:
        wr = csv.writer(f, delimiter=" ")
        wr.writerows(listoflists)

vcon_flag=True ### whether to generate vcon file
target=sys.argv[1]
terminus=sys.argv[2]
missing=int(sys.argv[3])

fasta = target+".fasta"
orig_validated_file=target+".metapsicov_stage1_ori" ### all predicted contacts for sequence, validated
new_metapsicov_file=target+".metapsicov.stage1"      ### missing region and correct flex
new_validated_file=target+".metapsicov_stage1"       ### validatied format 
new_vcon_file=target+".vcon"                         ### confile format ## 31 36 0.980248

### original prediction format ## 31 36 0 8 0.980248
new_validated = [] ### validation format ##  31 36 0.980248 1

with open(fasta, "r") as fin:
    fin.readline()
    length=len(fin.readline().strip())

if terminus == "C":
    begin = 1
    end = length - missing + 1
    segbegin = begin 
    segend = end - 15
elif terminus == "N":
    begin = missing + 1
    end = length 
    segbegin = begin + 15
    segend = end
else:
    print("Not a valid terminus")

with open(orig_validated_file, "r") as incon:
    for predcon in incon:
        con = predcon.strip().split()
        #### if contact is not in the segment region ####
        if ((int(con[0]) and int(con[1])) not in range(segbegin, segend)):
            #### if contact is outside validation region (for Flib or SAINT2, comment in, as being correct is enough to include) 
            if ((int(con[0]) or int(con[1])) not in range(begin, end+1)): # or (int(con[3])==1):
                if con[2] >= 0.5:
                    new_validated.append(con)

new_metapsicov = [ [con[0],con[1],0,8,con[2]] for con in new_validated ]
writeOut(new_metapsicov, new_metapsicov_file)
writeOut(new_validated, new_validated_file)

if vcon_flag:
    vcons = [ con[:3] for con in new_validated ]
    writeOut(vcons, new_vcon_file)

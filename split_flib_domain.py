#!/usr/bin/python

from sys import argv

domain_boundary=int(argv[2])-1
out1 = argv[1][:-4]+"d1.flib"
out2 = argv[1][:-4]+"d2.flib"
f1 = open(out1,"w")
f2 = open(out2,"w")

with open(argv[1],"r") as f:
    pos = 1
    s = 0 
    pre_domain_boundary = 1
    for line in f.readlines():
        fields = line.split()
        # New Fragment:
        if fields[0]=="F":
            pos = int(fields[3]) 
            if pos >= domain_boundary:
                pre_domain_boundary=0
            if pre_domain_boundary:
                f1.write(line) 
            else:
                f2.write("F "+str(s)+" P "+str(pos-domain_boundary)+" L "+fields[5]+" S "+fields[7]+" = "+fields[9]+" "+fields[10]+"    "+fields[11]+"\n")#
                s+=1
        else:
            if pre_domain_boundary:
                f1.write(line)
            else:
                f2.write(line)


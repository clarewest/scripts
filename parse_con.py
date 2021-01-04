#!/usr/bin/python3

from sys import argv

domain_boundary = int(argv[2])
with open(argv[1],"r") as f:
    for line in f.readlines():
        fields=line.strip().split()
        i=int(fields[0])-domain_boundary
        j=int(fields[1])-domain_boundary
        if(i>0 and j>0):
            print(i, j, " ".join(fields[2:len(fields)]))
#            print line.strip()

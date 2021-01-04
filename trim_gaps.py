#!/usr/bin/env python
from Bio import AlignIO
from Bio import SeqIO
from itertools import groupby
import os
import sys

def countGaps(alignment):
    g = []
    for record in alignment:
        groups=groupby(record)
        result = [(label, sum(1 for _ in group)) for label, group in groups]
        gaps = [ result[end][1] if result[end][0] == "-" else 0 for end in [0,-1] ]     # N and C terminal gaps 
        g.append(gaps)
    if sum([ 1 if i > 0 else 0 for i in g[0] ]):
        print("Put an exception here") ## Raise an exception - gap in fasta sequence
    return(g[1])

def main():
    alifile = sys.argv[1]
    t = ["N", "C"]
    aliout=alifile.split(".atom.needle")[0]+".atom.trimmed"
    seqout=alifile.split(".")[0]+".trimmed.fasta"
    alignment=list(AlignIO.parse(alifile, "fasta", seq_count=2))[0]
    gaps = countGaps(alignment)
    if sys.argv[2] in t:                          ## If a terminus is given, only trim the other end
        gaps[t.index(sys.argv[2])] = 0
    new_alignment=alignment[:, gaps[0]:len(alignment[0])-gaps[1]]
    AlignIO.write(new_alignment, aliout, "fasta")
    SeqIO.write(new_alignment[0], seqout, "fasta")

if __name__ == "__main__":
    main()


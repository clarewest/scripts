#!/usr/bin/env python
from Bio import AlignIO
from Bio import SeqIO
from itertools import groupby
import os
import sys

def fillX(alignment):
    mut_seq = alignment[0].seq.tomutable()
    for X in [ i for i, residue in enumerate(alignment[0].seq) if residue == "X" ]:
        mut_seq[X] = alignment[1].seq[X]
    alignment[0].seq = mut_seq.toseq()
    return(alignment)

def main():
    alifile = sys.argv[1]
    seqout=alifile.split(".")[0]+".filled.trimmed.fasta"
    alignment=list(AlignIO.parse(alifile, "fasta", seq_count=2))[0]
    filledali = fillX(alignment)
#    AlignIO.write(new_alignment, aliout, "fasta")
    SeqIO.write(filledali[0], seqout, "fasta")

if __name__ == "__main__":
    main()


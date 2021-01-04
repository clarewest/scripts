#!/usr/bin/python
from Bio import SeqIO
import os
import sys
from sys import stdout

def get_sequence(pdb): 
  handle = open(pdb, "rU")
 
  for record in SeqIO.parse(handle, "pdb-seqres") :
    print ">" + record.id + "\n" + record.seq
     
  handle.close()

if __name__ == '__main__':
  argc = len(sys.argv)
  if argc != 2:
    print "Usage: ~/Project/Scripts/get_fasta_from_seqres.py Filename"
  else:
    get_sequence(sys.argv[1])
 

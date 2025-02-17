#!/usr/bin/env python3
## a python script to compare the prediction of predicted secondary structure
## to check that the compiled C script does what I expect it too

import sys

target = sys.argv[1]
true_file = target+".dssp_ss"
pred_file = target+".deepcnf_ss"


def read_ss(filename):
    with open(filename, "r") as f:
        seq = f.readline().strip()
    return(seq)

a = read_ss(true_file)
b = read_ss(pred_file)

if len(a) == len(b):
    precision = sum([ 1 if ss == a[i] else 0 for i, ss in enumerate(b) ])/len(a)
    print(target, round(precision,2))
else:
    print("ERROR:", true_file, "and", pred_file, "sequences are not the same length.", file = sys.stderr)


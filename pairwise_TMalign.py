#!/usr/bin/env python3

import os
import sys
import re
import subprocess
import numpy as np

def TMalign(model1, model2):
    out = subprocess.run(['TMalign', model1, model2], encoding='utf-8', stdout=subprocess.PIPE)
    try:
        out.check_returncode()
        return float(re.split("TM-score= ", out.stdout)[2].split()[0])
    except CalledProcessError:
        print("Missing models: ", model1, model2)

def pairwiseTMalign(models):
    n = len(models)
    pairwiseTM = np.zeros([n,n])
    for i in range(0,n):
        for j in range(i+1,n):
            pairwiseTM[i,j] = TMalign(models[i], models[j])
#    print( pairwiseTM, pairwiseTM.sum()/(((n*n)-n)/2) )
    return [ pairwiseTM, pairwiseTM.sum()/(((n-1)*n)/2) ]

if __name__ == '__main__':
    argc = len(sys.argv)
    if argc < 3:
        print("Usage: pairwise_TM.py List of Models")
    else:
        verboseflag = sys.argv[1] == "--verbose"
        models = sys.argv[1:]
  #      if verboseflag: models.remove("--verbose")
        TMs, meanTM = pairwiseTMalign(models)
  #      if verboseflag:
  #          pass
  #     else:
        print(round(meanTM,2))

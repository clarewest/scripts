#!/usr/bin/bash
/data/pegasus/west/proq3/run_proq3.sh -l missing_$1.txt -fasta $1.fasta -ncores 5 -outpath missing_ProQ3D_$1

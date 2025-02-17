#!/usr/bin/env python3

import Bio
from Bio.PDB import Entity, PDBParser, PPBuilder, Polypeptide
from math import sqrt
from numpy import *
from sys import stdin, argv
import Bio.PDB



if __name__ == '__main__':

        with open(argv[1]+".angles","r") as f:
                next(f)
                torsion_angles=[]
                for line in f:
                        angles=[]
                        fields=line.split()
                        for field in fields:
                                angles.append(field)
                        torsion_angles.append(angles)
        f.close()

        with open(argv[1]+".dssp_ss","r") as f:
                ss = f.readline().strip("\n")
        f.close()

        sum = 0
        num = 0
        output = open(argv[1]+".ss_mae.txt","w");
        with open(argv[1]+".spd3",'r') as f:
                next(f)
                i=0
                j=0
                diff1 = diff2 = diff3 = diff4 = 0.0
                for line in f:
                    fields=(' '.join(line.split())).split()
                    if i>=len(torsion_angles):
                        break
                    if torsion_angles[i][2] != 'NA'  and torsion_angles[i][3] != 'NA':
                        if fields[1] == torsion_angles[i][1]:
                            phi1 = float(fields[4])
                            phi2 = float(torsion_angles[i][2])
                            diff1 += min(abs(phi1-phi2), abs(abs(phi1)+abs(phi2) - 360) )
                            psi1 = float(fields[5])
                            psi2 = float(torsion_angles[i][3])
                            diff2 += min(abs(psi1-psi2), abs(abs(psi1)+abs(psi2) - 360) )
                            output.write(str(i)+" "+str(min(abs(phi1-phi2), abs(abs(phi1)+abs(phi2) - 360)))+" "+str(min(abs(psi1-psi2), abs(abs(psi1)+abs(psi2) - 360) ) )+"\n" )
                            if ss[i]=='L':
                                diff3 += min(abs(phi1-phi2), abs(abs(phi1)+abs(phi2) - 360) )
                                diff4 += min(abs(psi1-psi2), abs(abs(psi1)+abs(psi2) - 360) )
                                j=j+1
                    i=i+1
                print("%s %.2f %.2f %.2f %.2f" % (argv[1],diff1/i,diff2/i,diff3/j,diff4/j))

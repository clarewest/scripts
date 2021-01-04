#!/usr/bin/env python
import sys

def get_contact_order(filename):

    sum_Lij = 0
    N = 0.0
    contact_min = 5

    with open(filename, "r") as f:
        L = float(f.readline())
        for contact in f: 
            contact  = [float(i) for i in contact.strip("\n").split(" ")]
            Lij = abs(contact[0]-contact[1])
            if Lij >= contact_min:
                sum_Lij = sum_Lij + Lij
                N = N + 1.0

    AbsCO = sum_Lij *(1/N)
    RelCO = sum_Lij * (1/(N*L))

    protein  = filename.split('/')[0]
    print "%s %d %f %f" % (protein,N,AbsCO,RelCO)
  

if __name__ == '__main__':
    argc = len(sys.argv)
    if argc != 2:
        print "Usage: ~/Project/Scripts/contact_order.py contact_file"
    else:
        get_contact_order(sys.argv[1])

from sys import argv



true_file = open(argv[1],"r")
pred_file = open(argv[2],"r")

for line1,line2 in zip(true_file,pred_file):
    true_ss = line1.strip()
    pred_ss = line2.strip()
    break

if len(true_ss)!=len(pred_ss):
    print "ERROR: ",argv[1][0:6]
else:
    precision = 0.0
    for i in range(len(true_ss)):
        A=pred_ss[i]
        B=true_ss[i]
#        if B!='H' and B!='E':
#           B='C'
        precision += (A==B)
    print round(precision/len(true_ss)*100,2)
true_file.close()
pred_file.close()

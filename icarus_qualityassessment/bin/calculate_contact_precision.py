from sys import argv

with open(argv[1],"r") as f:
    num_con=0
    num_sr=0
    num_lr=0
    true_con= true_sr = true_lr = 0.0
    for line in f.readlines():
        fields = line.strip().split()
        fields[0] = int(fields[0])
        fields[1] = int(fields[1])
        fields[-1] = int(fields[-1])

        num_con+=1
        true_con += fields[-1]
        if abs(fields[1]-fields[0]) > 23:
           num_lr += 1
           true_lr += fields[-1]
        else:
           num_sr += 1
           true_sr += fields[-1]
 
    print argv[1][0:6],num_sr,num_lr,num_con,
    if num_sr > 0:
        print round(true_sr/num_sr,2),
    else:
        print "NA",
    if num_lr > 0:
        print round(true_lr/num_lr,2),
    else:
        print "NA",
    if num_con > 0:
        print round(true_con/num_con,2)
    else:
        print "NA"
        

from itertools import groupby
import csv
ssfile='all_pred_ss.txt'
targets_scop=[]
elements = [ 'H', 'E' ]
cutoff=0.5

def write_out(listoflists, outfile):
    with open(outfile, "w") as f:
        wr = csv.writer(f, delimiter=" ")
        wr.writerows(listoflists)

def switches_distinguish_ab(predicted_ss): 
    # group into consecutive elements and collapse, then remove coil regions
    groups = [ group[0] for group in [list(g) for _, g in groupby(predicted_ss)]]
    groups[:] = (group for group in groups if group != 'C')
    # change to 0s and 1s, subtract consecutive regions to count number of changes between SS types
    binaries = [ elements.index(group) for group in groups ]
    switches = sum([ abs(binaries[i] - binaries[i+1]) for i in range(0, len(binaries)-1) ])
    max_switches = len(groups) - 1
    if switches >= 5:
#    if float(switches)/float(max_switches) >= cutoff:
        return("c")
    else:
        return("d")

def stretches_distinguish_ab(predicted_ss): 
    # group into consecutive elements and collapse, then remove coil regions
    groups = [ group[0] for group in [list(g) for _, g in groupby(predicted_ss)]]
    groups[:] = (group for group in groups if group != 'C')
    longest_stretch = max([len(group) for group in [list(g) for _, g in groupby(groups) ] ])
    if longest_stretch < 4:
        return("c")
    else:
        return("d")

def comb_distinguish_ab(predicted_ss): 
    # group into consecutive elements and collapse, then remove coil regions
    groups = [ group[0] for group in [list(g) for _, g in groupby(predicted_ss)]]
    groups[:] = (group for group in groups if group != 'C')
    # change to 0s and 1s, subtract consecutive regions to count number of changes between SS types
    longest_stretch = max([len(group) for group in [list(g) for _, g in groupby(groups) ] ])
    binaries = [ elements.index(group) for group in groups ]
    switches = sum([ abs(binaries[i] - binaries[i+1]) for i in range(0, len(binaries)-1) ])
    max_switches = len(groups) - 1
    if switches >= 5 or float(switches)/float(max_switches) > 0.5 :
        return("c")
    else:
        return("d")

def get_SCOP(predicted_ss):
    definitions = [ 0.15, 0.1 ]
    proportions = [ float(predicted_ss.count(element))/len(predicted_ss) for element in elements ]
    outcome = [ proportions[i] > definitions[i] for i in [0,1] ]
    if outcome == [1,0]:
        return("a")
    elif outcome == [0,1]:
        return("b")
    elif sum(outcome) == 0:
        return("z")
    else:
        return(switches_distinguish_ab(predicted_ss))

with open(ssfile, 'r') as f:
     for i,line in enumerate(f):
         line = line.strip().split()
         targets_scop.append([line[0],line[1],get_SCOP(line[1])])
#         print(targets_scop[i])
write_out(targets_scop, "output_switches_method.txt")



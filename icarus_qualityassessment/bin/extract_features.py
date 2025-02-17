import sys
import csv

def getFeatures(decoylist, index, reverse=False):
  sorted_decoys = sorted(decoylist, key=itemgetter(index))
  if (reverse):
    measure_max = sorted_decoys[0][index]
    measure_min = sorted_decoys[-1][index]
  else:
    measure_min = sorted_decoys[0][index]
    measure_max = sorted_decoys[-1][index]
  measure_med = sorted_decoys[int((len(decoylist)/2))][index]
  measure_spread = float(measure_max) - float(measure_med)
  return([ measure_min, measure_max, measure_med, measure_spread ])


target = sys.argv[1]
indexer = [ 'TARGET', 'DECOY', 'PPV', 'MAPALIGN', 'MAPALIGNlen', 'EIGEN', 'SAULO', 'COMB', 'TargetPPV', 'Ttruecontacts', 'Ttotalcontacts', 'Neff' 'MapTM', 'TM'    , 'PCONS', 'PROQ2', 'ProQRosCen', 'ProQRosFA', 'ProQ3D', 'PCOMBC' ] 
#decoys = [ row for row in csv.DictReader(open(decoyfile), header, delimiter=" ") ]
decoys = [ line.strip().split() for line in open(decoyfile,'r').readlines() ]



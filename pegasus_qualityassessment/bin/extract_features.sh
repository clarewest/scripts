DATASET=$2
#DIR=/data/icarus/not-backed-up/west/QualityAssessment/data/$DATASET/
DIR=~/TMP_RFQA/$DATASET/

set -u

### TARGET-SPECIFIC FEATURES ###
BASIC_INFO=$(grep ${1:0:4} $DIR/list_full.txt | awk '{print $1,$5+1,$12,$7}'); # Target Length SCOP_Class Beff
#BASIC_INFO=$(grep $1 $DIR/list_full.txt); # Target Length SCOP_Class Beff
NUM_CON=$(wc $DIR/$1.con | awk '{print $1}')

TM=$(sort -k 14 -n $1.results_filtered75.txt | tail -n 1 | awk '{print $14}');

### DECOY-SPECIFIC FEATURES ###

# $TARGET $DECOY $PPV $SCORE(x2) $EIGEN $SAULO $COMB $CON(x3) $Neff $TM $TM2 $PCONS $PROQ(x4) $PCOMBC

# 1. SAINT2 Score
#  $TM    $FILE                                                               $SOLV    $ORIE    $RAPDF  $LJ      $CORE    $SAULO  $RG      $DIAM     $COMB
#0.368020 1AYA_B_c_n_1AYA_B.flib_10000_1000_t2.5_linear_s0_t1511487079_p30561 -6.13812 -4.18075 14.0195 -60.6268 -47.8119 29.4192 18.8317  33.3317   -28.7116

## Clare edit: Non-SAINT2 decoys can have clashes, giving scientific-notation-high S2 scores, which bash arithmetic can't handle
## Adding +0 forces it to print in awk's standard number form
## sort -g means it can cope with scientific notation
## in future it might be safer to make this change in assess_quality.sh
# (a) Maximum value:
S2_MAX=$(sort -k 8,8gr $1.results_filtered75.txt | tail -n 1 | awk '{print $8}');
# (b) Minimum value:
S2_MIN=$(sort -k 8,8g $1.results_filtered75.txt | tail -n 1 | awk '{print $8+0}');
# (c) Median value:
LINES=$(wc $1.results_filtered75.txt | awk '{print $1}')
S2_MED=$(sort -k 8,8gr $1.results_filtered75.txt | head -n $((LINES / 2))  | tail -n 1 | awk '{print $8}');
# (d) Spread:
S2_SPR=$(echo "$S2_MAX - $S2_MED" | bc)

# 2. SAINT2 Contact Score

# (a) Maximum value:
CON_MAX=$(sort -k 7,7nr $1.results_filtered75.txt | tail -n 1 | awk '{print $7}');
# (b) Minimum value:
CON_MIN=$(sort -k 7,7n $1.results_filtered75.txt | tail -n 1 | awk '{print $7}');
# (c) Median value:
CON_MED=$(sort -k 7,7nr $1.results_filtered75.txt | head -n $((LINES / 2)) | tail -n 1 | awk '{print $7}');
# (d) Spread:
CON_SPR=$(echo "$CON_MAX - $CON_MED" | bc)
# 3. PPV-Related Scores

# (a) PPV Maximum-value:
PPV_MAX=$(sort -k 3,3n $1.results_filtered75.txt| tail -n 1 | awk '{print $3}');
# (b) Overall Number of Satisfied Predicted Contacts:
PPV_NUM=$(bc -l <<< "$PPV_MAX*$NUM_CON");

# 4. MapAlign Scores
#MAX 0_1_0   1AYA_B.meta_map 1AYA_B//1AYA_B_c_n_1AYA_B.flib_10000_1000_t2.5_linear_s0_t1511741596_p39241.map 17.946  -1  16.946  65

# (a) Maximum value:
MAP_MAX=$(sort -k 4,4n $1.results_filtered75.txt | tail -n 1 | awk '{print $4}');
# (b) Minimum value:
MAP_MIN=$(sort -k 4,4nr $1.results_filtered75.txt | tail -n 1 | awk '{print $4}');
# (c) Median value:
MAP_MED=$(sort -k 4,4n $1.results_filtered75.txt | head -n $((LINES / 2)) | tail -n 1 | awk '{print $4}');
# (d) Spread:
MAP_SPR=$(echo "$MAP_MAX - $MAP_MED" | bc)
# (e) Maximum Hit Length:
MAP_MHL=$(sort -k 5,5n $1.results_filtered75.txt | tail -n 1 | awk '{print $5}')

# 5. EigenTHREADER Scores
#19.859 98.7 98.7 1AYA_B_c_n_1AYA_B.flib_10000_1000_t2.5_linear_s0_t1511487079_p30561

# (a) Maximum value:
EIG_MAX=$(sort -k 6,6n $1.results_filtered75.txt | tail -n 1 | awk '{print $6}');
# (b) Minimum value:
EIG_MIN=$(sort -k 6,6nr $1.results_filtered75.txt | tail -n 1 | awk '{print $6}');
# (c) Median value:
EIG_MED=$(sort -k 6,6n $1.results_filtered75.txt | head -n $((LINES / 2)) | tail -n 1 | awk '{print $6}');
# (d) Spread:
EIG_SPR=$(echo "$EIG_MAX - $EIG_MED" | bc)

# 6. PCons Scores
PCONS_MAX=$(sort -k 15,15n $1.results_filtered75.txt | tail -n 1 | awk '{print $15}');
# (b) Minimum value:
PCONS_MIN=$(sort -k 15,15nr $1.results_filtered75.txt | tail -n 2 | head -n 1 | awk '{print $15}');
# (c) Median value:
PCONS_MED=$(sort -k 15,15n $1.results_filtered75.txt | head -n $((LINES / 2)) | tail -n 1 | awk '{print $15}');
# (d) Spread:
PCONS_SPR=$(echo "$PCONS_MAX - $PCONS_MED" | bc)

# 7. ProQ2D Scores
PROQ2D_MAX=$(sort -k 16,16g $1.results_filtered75.txt | tail -n 1 | awk '{print $16+0}');
# (b) Minimum value:
PROQ2D_MIN=$(sort -k 16,16gr $1.results_filtered75.txt | tail -n 2 | head -n 1 | awk '{print $16+0}');
# (c) Median value:
PROQ2D_MED=$(sort -k 16,16g $1.results_filtered75.txt | head -n $((LINES / 2)) | tail -n 1 | awk '{print $16+0}');
# (d) Spread:
PROQ2D_SPR=$(echo "$PROQ2D_MAX - $PROQ2D_MED" | bc)

# 8. ProQRosCen Scores
ROSCEN_MAX=$(sort -k 17,17n $1.results_filtered75.txt | tail -n 1 | awk '{print $17}');
# (b) Minimum value:
ROSCEN_MIN=$(sort -k 17,17nr $1.results_filtered75.txt | tail -n 2 | head -n 1 | awk '{print $17}');
# (c) Median value:
ROSCEN_MED=$(sort -k 17,17n $1.results_filtered75.txt | head -n $((LINES / 2)) | tail -n 1 | awk '{print $17}');
# (d) Spread:
ROSCEN_SPR=$(echo "$ROSCEN_MAX - $ROSCEN_MED" | bc)

# 9. ProQRosFA Scores
ROSFA_MAX=$(sort -k 18,18n $1.results_filtered75.txt | tail -n 1 | awk '{print $18}');
# (b) Minimum value:
ROSFA_MIN=$(sort -k 18,18nr $1.results_filtered75.txt | tail -n 2 | head -n 1 | awk '{print $18}');
# (c) Median value:
ROSFA_MED=$(sort -k 18,18n $1.results_filtered75.txt | head -n $((LINES / 2)) | tail -n 1 | awk '{print $18}');
# (d) Spread:
ROSFA_SPR=$(echo "$ROSFA_MAX - $ROSFA_MED" | bc)

# 10. ProQ3D Scores
PROQ3D_MAX=$(sort -k 19,19n $1.results_filtered75.txt | tail -n 1 | awk '{print $19}');
# (b) Minimum value:
PROQ3D_MIN=$(sort -k 19,19nr $1.results_filtered75.txt | tail -n 2 | head -n 1 | awk '{print $19}');
# (c) Median value:
PROQ3D_MED=$(sort -k 19,19n $1.results_filtered75.txt | head -n $((LINES / 2)) | tail -n 1 | awk '{print $19}');
# (d) Spread:
PROQ3D_SPR=$(echo "$PROQ3D_MAX - $PROQ3D_MED" | bc)

# 11. PCombC Scores
PCOMBC_MAX=$(sort -k 20,20n $1.results_filtered75.txt | tail -n 1 | awk '{print $20}');
# (b) Minimum value:
PCOMBC_MIN=$(sort -k 20,20nr $1.results_filtered75.txt | tail -n 2 | head -n 1 | awk '{print $20}');
# (c) Median value:
PCOMBC_MED=$(sort -k 20,20n $1.results_filtered75.txt | head -n $((LINES / 2)) | tail -n 1 | awk '{print $20}');
# (d) Spread:
PCOMBC_SPR=$(echo "$PCOMBC_MAX - $PCOMBC_MED" | bc)

# OUTPUTTING FEATURES:
echo "$BASIC_INFO $NUM_CON $S2_MAX $S2_MED $S2_MIN $S2_SPR $CON_MAX $CON_MED $CON_MIN $CON_SPR $PPV_MAX $PPV_NUM $MAP_MAX $MAP_MED $MAP_MIN $MAP_SPR $MAP_MHL $EIG_MAX $EIG_MED $EIG_MIN $EIG_SPR $PCONS_MAX $PCONS_MED $PCONS_MIN $PCONS_SPR $PROQ2D_MAX $PROQ2D_MED $PROQ2D_MIN $PROQ2D_SPR $ROSCEN_MAX $ROSCEN_MED $ROSCEN_MIN $ROSCEN_SPR $ROSFA_MAX $ROSFA_MED $ROSFA_MIN $ROSFA_SPR $PROQ3D_MAX $PROQ3D_MED $PROQ3D_MIN $PROQ3D_SPR $PCOMBC_MAX $PCOMBC_MED $PCOMBC_MIN $PCOMBC_SPR $TM"

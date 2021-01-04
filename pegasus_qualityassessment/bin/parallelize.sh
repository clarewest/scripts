# This should be the number of parallel tasks you want to run
maxjobs=6

export metabindir=/data/pegasus/west/metaPSICOV/bin
export metadatadir=/data/pegasus/west/metaPSICOV/data
export SAINT2=/homes/west/SAINT2/SAINT_laura/

parallelize () {
        while [ $# -gt 0 ] ; do
                jobcnt=(`jobs -p`)
                if [ ${#jobcnt[@]} -lt $maxjobs ] ; then
         #              /data/pegasus/west/Flib-Coevo/run_flib_coevo_pipeline.sh $1 -generate_ss -noparsing -disable_flib &
#                       ../../SPIDER3/run_list.sh $1.fasta.txt &
#                        /data/pegasus/west/blast-2.2.17/bin/blastpgp -a 1 -b 0 -j 3 -h 0.001 -d /data/pegasus/west/Databases/nr -i $1.fasta.txt -C $1.chk >& $1.blast &
#                        echo $1.chk > $1.pn
#                        echo $1.fasta.txt > $1.sn
#                        /data/pegasus/west/blast-2.2.17/bin/makemat -P $1 &
#                        /data/pegasus/west/psipred/bin/psipred $1.mtx  /data/pegasus/west/psipred/data/weights.dat /data/pegasus/west/psipred/data/weights.dat2 /data/pegasus/west/psipred/data/weights.dat3 > $1.ss &
#                         /data/pegasus/west/psipred/bin/psipass2 /data/pegasus/west/psipred/data/weights_p2.dat 1 1.0 1.0 $1.ss2 $1.ss > $1.horiz &
#                         /data/pegasus/west/metaPSICOV/bin/solvpred $1.mtx /data/pegasus/west/metaPSICOV/data/weights_solv.dat > $1.solv &

#                         /data/pegasus/west/hh-suite/bin/hhblits -i $1.fasta.txt -d /data/pegasus/west/hh-suite/database/uniprot20_2016_02 -oa3m $1.a3m -n 3 -maxfilt 500000 -diff inf -id 99 -cov 60 -cpu 1 > $1.hhblog &
#                        egrep -v "^>" $1.a3m | sed 's/[a-z]//g' > $1.aln
#                        /data/pegasus/west/PSICOV/psicov -o -d 0.03 -z 1 $1.aln > $1.psicov &
#                        /data/pegasus/west/freecontact-1.0.21/src/freecontact < $1.aln > $1.evfold &
#                        /data/pegasus/west/CCMpred/bin/ccmpred $1.aln $1.ccmpred &
#                         $metabindir/alnstats $1.aln $1.colstats $1.pairstats &
#                         $metabindir/metapsicov $1.colstats $1.pairstats $1.psicov $1.evfold $1.ccmpred $1.ss2 $1.solv $metadatadir/weights_6A.dat $metadatadir/weights_65A.dat $metadatadir/weights_7A.dat $metadatadir/weights_75A.dat $metadatadir/weights_8A.dat $metadatadir/weights_85A.dat $metadatadir/weights_9A.dat $metadatadir/weights_10A.dat $metadatadir/weights_811A.dat $metadatadir/weights_1012A.dat | sort -n -r -k 5 > $1.metapsicov.stage1 &
#                         $metabindir/metapsicovp2 $1.colstats $1.metapsicov.stage1 $1.ss2 $1.solv $metadatadir/weights_pass2.dat | sort -n -r -k 5 > $1.metapsicov.stage2 &
#                         $metabindir/metapsicovhb $1.colstats $1.metapsicov.stage1 $1.ss2 $1.solv $metadatadir/weights_hbpass2.dat | sort -n -r -k 5 > $1.metapsicov.hb &


                         # Parsing of the Contacts #
#                         python ../getcontactsSparse3.py $1.pdb ${1:5:1} 8.0 &
#                         ../convert $1.proxy_fasta $1.aln $1.metapsicov.stage1 $1.proxy_map > $1.metapsicov_stage1 2> $2.metapsicov_stage1_messages &
#                         ../convert $1.proxy_fasta $1.aln $1.metapsicov.stage2 $1.proxy_map > $1.metapsicov_stage2 2> $2.metapsicov_stage2_messages &
#                         ../convert $1.proxy_fasta $1.aln $1.metapsicov.stage3 $1.proxy_map > $1.metapsicov_stage3 2> $2.metapsicov_stage3_messages &

#                         awk '{print $1,$2,$3}' $1.metapsicov_stage1 > $1.con &

                         # Identifying good threading candidates #
#                         /data/pegasus/west/hh-suite/bin/hhblits -d /data/pegasus/west/hh-suite/database/pdb70 -i $1.fasta.txt -o $1.hhr &
                         # Homologue identification using BLASTp #
#                        /data/pegasus/west/ncbi-blast-2.5.0+/bin/blastp -query $1.fasta.txt -db /data/pegasus/west/Databases/pdbaa -evalue 0.05 -outfmt 6  > $1.blast &
#                        awk '{print $2}' $1.blast | sed -e "s/.*pdb|//g" | cut -c 1-4 | sort | uniq | tr '[:upper:]' '[:lower:]' > $1.homol &
                         # Fragment Library Generation #
#                        /data/pegasus/west/Flib-Coevo/run_flib_coevo_pipeline.sh -noparsing $1 &
#                        $SAINT2/scripts/run_saint2_intermediates.sh $1 /data/pegasus/west/New_Dataset/Training/ $1 &
#                        /data/pegasus/west/Flib-Coevo/bin/LibValidator $1 $1.lib ${1:5:1} > $1.lib_rmsd 2> $1.val_log &
#                        ../../bin/calculate_decoy_ppvs.sh $1 > $1.ppvs &
#                         ../../bin/calculate_decoy_map.sh $1 > $1.out_map &
#                         ../../bin/run_eigen.sh $1 New_extras > $1.eigenlog &
                         ../../bin/run_pcons.sh $1 &
                        shift  
                fi
        done
        wait
}

#LIST=`cat List_Training.txt;`
LIST=`cat list.txt;`
#LIST=`cat extra_list.txt;`
#LIST=`for i in {1..999}; do cat ./List_Training.txt; done`  
parallelize $LIST

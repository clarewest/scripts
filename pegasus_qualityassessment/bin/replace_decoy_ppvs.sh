SET=CASP12; for TARGET in $(cat list.txt); do for DECOY in $(cat $TARGET.lst); do PPV=$(grep $DECOY "$SET"_rep_ppvs.txt | awk '{print $3}'); grep $DECOY backup_results_proq3d/$TARGET.results_proq3d.txt | awk -v PPV=$PPV '{$3=PPV; print $0}' ; done > $TARGET.results_proq3d.txt ; done


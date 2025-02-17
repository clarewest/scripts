library(data.table)
library(dplyr)

pcombc <- fread("results_pcombc.txt")
colnames(pcombc)[1:2] <- c("Protein","Decoy")
endscore <- fread("results_endscore.txt", col.names=c("Protein","Decoy","localRMSD"))
fnat <- fread("results_fnat.txt", col.names=c("Protein","Decoy", "Fnat","Fnonnat"))
flexscore <- fread("results_flexscore.txt",col.names=c("Protein","Decoy", "globalRMSD","globalFLEX", "localFLEX"))
localpcons <- fread("results_pcons_local.txt", col.names=c("Protein","Decoy", "Local_Pcons"))
localproq <- fread("results_proq3d_local.txt", col.names=c("Protein","Decoy", "Local_Proq3d"))
t <- pcombc %>% merge(endscore, by=c("Protein","Decoy")) %>% merge(flexscore, by=c("Protein","Decoy"), fill=TRUE) %>% merge(fnat,  by=c("Protein","Decoy")) %>% merge(localpcons, by=c("Protein","Decoy")) %>% merge(localproq, by=c("Protein","Decoy"))
write.table(t, file="results_scaffold.txt", col.names=FALSE, row.names=FALSE, quote=FALSE)

#!/usr/local/bin/Rscript
A <- read.table("/data/cockatrice/west/1VCQ_A/1VCQ_A.con")
C <-read.table("/data/cockatrice/west/1VCQ_C/1VCQ_C.con")
N<-read.table("/data/cockatrice/west/1VCQ_N/1VCQ_N.con")
C[ ,1] <-C[ ,1] +64
C[ ,2] <- C[ ,2] +64
png("~/pub_html/Saulo/1VCQ_Contact_Map.png",width=2000,height=2000,res=300)
plot(A$V1~A$V2,xlab="Residue Number",ylab="Residue Number", main="Predicted Contacts in 1VCQ_A", xlim=c(1,149),ylim=c(1,149),pch=19,col="black")
points(N$V1~N$V2,pch=1,col="red")
points(C$V1~C$V2,pch=1,col="green")
dev.off()



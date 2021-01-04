#!/usr/bin/Rscript

CT <- c("1MSC","2DN2_A","1BSL_A","1VCQ_A","1VCQ_C","1VCQ_N", "1RHS")
t <- read.table(file = "/data/cockatrice/west/signatures.out", row.names=1)
FF <- row.names(t)[! row.names(t) %in% CT]
abs <- t[order(t$V5),]
row.names(abs) <-factor(row.names(abs))
for (protein in FF) {abs$color[row.names(abs) == protein] <- "black"}
for (protein in CT) {abs$color[row.names(abs) == protein] <- "red"}
png("~/pub_html/Saulo/Moment_of_Inertia.png",width=2500,height=2500,res=300)
dotchart(abs$V5,labels=row.names(abs),cex=.7,main="Moment of Inertia (CT in red)",xlab="MOI",color=abs$color)
dev.off()

abs <- t[order(t$V6),]
row.names(abs) <-factor(row.names(abs))
for (protein in FF) {abs$color[row.names(abs) == protein] <- "black"}
for (protein in CT) {abs$color[row.names(abs) == protein] <- "red"}
png("~/pub_html/Saulo/Relative_MoI.png",width=2500,height=2500,res=300)
dotchart(abs$V6,labels=row.names(abs),cex=.7,main="Relative Moment of Inertia(CT in red)",xlab="RMoI",color=abs$color)
dev.off()


abs <- t[order(t$V7),]
row.names(abs) <-factor(row.names(abs))
for (protein in FF) {abs$color[row.names(abs) == protein] <- "black"}
for (protein in CT) {abs$color[row.names(abs) == protein] <- "red"}
png("~/pub_html/Saulo/Hydrophobic_MoI.png",width=2500,height=2500,res=300)
dotchart(abs$V7,labels=row.names(abs),cex=.7,main="Hydrophobic MoI (CT in red)",xlab="HMoI",color=abs$color)
dev.off()

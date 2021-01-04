#!/usr/bin/Rscript

CT <- c("1MSC","2DN2_A","1BSL_A","1VCQ_A","1VCQ_C","1VCQ_N", "1RHS")
t <- read.table(file = "/data/cockatrice/west/contact_orders.out", row.names=1)
FF <- row.names(t)[! row.names(t) %in% CT]
abs <- t[order(t$V3),]
row.names(abs) <-factor(row.names(abs))
for (protein in FF) {abs$color[row.names(abs) == protein] <- "black"}
for (protein in CT) {abs$color[row.names(abs) == protein] <- "red"}
png("~/pub_html/Saulo/Absolute_Contact_Orders.png",width=2500,height=2500,res=300)
dotchart(abs$V3,labels=row.names(abs),cex=.7,main="Absolute Contact Orders (CT in red)",xlab="Absolute Contact Order",color=abs$color)
dev.off()

rel <- t[order(t$V4),]
for (protein in CT) {rel$color[row.names(rel) == protein] <- "red"}
for (protein in FF) {rel$color[row.names(rel) == protein] <- "black"}
png("~/pub_html/Saulo/Relative_Contact_Orders.png",width=2500,height=2500,res=300)
dotchart(rel$V4,labels=row.names(rel),cex=.7,main="Relative Contact Order (CT in red)",xlab="Relative Contact Order",color=rel$color,xlim=c(0,1))
dev.off()




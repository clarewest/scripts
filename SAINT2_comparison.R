#!/usr/local/bin/Rscript
CT <- c("1MSC","2DN2_A","1BSL_A","1VCQ_A","1VCQ_C","1VCQ_N", "1RHS","1IBX_A","1V0D_A","2UXV_A")
t = read.table("score_table.txt")
t2 = read.table("score_table_invitro.txt")
t3 = merge(t,t2,by.x="V1",by.y="V1")
png("~/pub_html/Saulo/TMscores_CT_IV.png",width=2500,height=2500,res=300)
plot(t3$V4.x~t3$V4.y,xlab="SAINT2 In Vitro",ylab="SAINT2 Cotranslational",main="TM-Score Best",pch=19,xlim=c(0,1),ylim=c(0,1))
text(t3$V4.x~t3$V4.y, labels=t3$V1, cex= 0.7, pos=4)
abline(h=0.5,col="blue",lty=2)
abline(v=0.5,col="blue",lty=2)
abline(a=0,b=1,col="black")
for (protein in CT){points(t3[t3$V1==protein,8],t3[t3$V1==protein,4],col="#1f78b4",pch=19)}
legend("bottomright",c("Fast Folders","Cotranslational Folders"),pch=19,col=c("black","#1f78b4"))
dev.off()

t = read.table("score_table.txt")
t2 = read.table("score_table_reverse.txt")
t3 = merge(t,t2,by.x="V1",by.y="V1")
png("~/pub_html/Saulo/TMscores_CT_Rev.png",width=2500,height=2500,res=300)
plot(t3$V4.x~t3$V4.y,xlab="SAINT2 In Reverse",ylab="SAINT2 Cotranslational",main="TM-Score Best",pch=19,xlim=c(0,1),ylim=c(0,1))
text(t3$V4.x~t3$V4.y, labels=t3$V1, cex= 0.7, pos=4)
abline(h=0.5,col="blue",lty=2)
abline(v=0.5,col="blue",lty=2)
abline(a=0,b=1,col="black")
for (protein in CT){points(t3[t3$V1==protein,8],t3[t3$V1==protein,4],col="cyan")}
dev.off()


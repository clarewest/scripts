#!/usr/local/bin/Rscript

saint_plot <- function(first_col,title,labels){
	plot(t$BEST_CT~t$BEST_IV,xlab="SAINT2 In Vitro",ylab="SAINT2 Cotranslational",main=title,pch=21,xlim=c(0,1),ylim=c(0,1),col=first_col, bg=adjustcolor(first_col,alpha.f=tr),asp=1,cex=1.8)
	if (labels==1){
		text(t$BEST_CT ~ t$BEST_IV, labels=t$PDB,cex=0.5,pos=4,offset=0.5)
#		left_labels=c("1V0D_A","1PIN","1RHS","1BSL_A","1BDC","1VII","2DN2_A","2A3D","1QQ3","1LMB_3","1T43","1T43_C")
#		text(t$BEST_CT[! t$PDB %in% left_labels] ~t$BEST_IV[! t$PDB %in% left_labels], labels=t$PDB[! t$PDB %in% left_labels], cex=0.5, pos=4, offset=0.5)
#		text(t$BEST_CT[t$PDB %in% left_labels] ~t$BEST_IV[t$PDB %in% left_labels], labels=t$PDB[t$PDB %in% left_labels], cex= 0.5, pos=2,offset=0.5)
	}
	abline(h=0.5,col="blue",lty=2)
	abline(v=0.5,col="blue",lty=2)
	abline(a=0,b=1,col="black")
}

args=commandArgs(trailingOnly=TRUE)
set=args[1]
colour_plot <- function(sele,c){
	for (protein in sele){points(t[t$PDB==protein,3],t[t$PDB==protein,2],col=c,bg=adjustcolor(c,alpha.f=tr),pch=21,cex=1.8,xlim=c(0,1),ylim=c(0,1))}
}

t = read.table("Results1T43.txt",header=T)

ce=0.8
tr=0.7

cols=c('#a6cee3','#1f78b4','#b2df8a','#33a02c')
#cols <- adjustcolor(cols, alpha.f = tr) 
png(file=paste("~/pub_html/Clare/",set,"_TMscores_CT_IV.png",sep=""),width=800,height=800,pointsize=18)
#png("~/pub_html/Clare/Cren_TMscores_CT_IV.png",width=1000,height=1000,pointsize=18)
par(pty="s")
#par(mfrow=c(2,2),pty="s")

# Names
saint_plot("#66c2a5","TM-Score Best", 1)
#colour_plot(multidomain,cols[2])
#for (protein in s_multidomain){points(t[t$PDB==protein,3],t[t$PDB==protein,2],col=cols[2],pch=1,cex=1.8)}
#legend("bottomright",c("Multidomain","Domain of Multidomain"),pch=c(19,21),col=c(adjustcolor(cols[2],alpha.f=tr),cols[2]),cex=ce)
dev.off()

#png("~/pub_html/Clare/Mechanism_TMscores_CT_IV.png",width=2500,height=2500,res=300,pointsize=18)
#par(pty="s")
# Colour by folding mechanism
#saint_plot(cols[1],"Folding Mechanism",0)
#colour_plot(chap$V1,cols[2])
#colour_plot(ff$V1,cols[3])
#colour_plot(rt$V1,cols[4])
#for (protein in rth$V1){points(t[t$PDB==protein,3],t[t$PDB==protein,2],col=cols[4],pch=1,cex=1.8)}
#legend("bottomright",c("Cotranslational Folders","Require Partner","Ultra Fast Folders","Ribosome Tunnel Folders","Homologues of RT Folders"),pch=c(19,19,19,19,1),col=c(adjustcolor(cols,alpha.f=tr),cols[4]),cex=ce)
#dev.off()

#png("~/pub_html/Clare/CLass_TMscores_CT_IV.png",width=2500,height=2500,res=300,pointsize=18)
# Colour by class
#par(pty="s")
#cols=c('#66c2a5','#fc8d62','#8da0cb','#e78ac3')
#saint_plot(cols[1],"SCOP Class",0)
#colour_plot(b$V1,cols[2])
#colour_plot(a$V1,cols[1])
#colour_plot(ab$V1,cols[3])
#colour_plot(a_b$V1,cols[4])
#for (protein in syn$V1){points(t[t$PDB==protein,3],t[t$PDB==protein,2],col="black",pch=1,cex=1.8)}
#legend("bottomright",c("a","b","a/b","a+b","synthetic"),pch=c(19,19,19,19,1),col=c(adjustcolor(cols,alpha.f=tr),"black"),cex=ce)
#dev.off()

#png("~/pub_html/Clare/Length_TMscores_CT_IV.png",width=2500,height=2500,res=300,pointsize=18)
# Colour by length
#par(pty="s")
#cols = c('#6baed6','#4292c6','#2171b5','#084594') 
#saint_plot(cols[1],"Protein Length",0)
#colour_plot(s$V1,cols[1])
#colour_plot(m$V1,cols[2])
#colour_plot(l$V1,cols[3])
#colour_plot(xl$V1,cols[4])
#legend("bottomright",c("<100","101-200","202-300",">300"),pch=19,col=adjustcolor(cols[1],alpha.f=tr),cex=ce)
#legend("bottomright",c("<100","101-200","202-300",">300"),pch=19,col=(cols),cex=ce)

#dev.off()




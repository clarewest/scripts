#!/usr/local/bin/Rscript
library(ggplot2)
source("~/Project/Scripts/multiplot.R")
pdbs<-read.table("Validation_breakpoints_length.txt",fill=TRUE,col.names=c("PDB","firstres","boundary"))
pdbs$decoyboundary<-(pdbs$boundary-pdbs$firstres)+1
#pdbs<-read.table("Validation_set.txt",col.names=c("PDB"))
plots=list()
i=1
for (pdb in pdbs$PDB){
  t<-read.table(paste(pdb,".conSNIFF",sep=""))
  t2<-read.table(paste(pdb,".fasta.ss.long",sep=""),col.names=c("pdb.res","SS"))
  t2$conSNIFF<-as.numeric(t[1,])[1:length(t2$SS)]
  t2$seq<-seq_along(t2$SS)
  if (pdb=="2qskA"){
    plots[[i]]<-ggplot(t2)+geom_line(aes(x=seq,y=conSNIFF,colour=SS,group=1)) + geom_vline(xintercept=pdbs[which(pdbs$PDB==pdb),4],col="red",lty="dashed",size=0.2) + labs(x="", y="",title=pdb) + theme_bw()
  }
  else{
  plots[[i]]<-ggplot(t2)+geom_line(aes(x=seq,y=conSNIFF,colour=SS,group=1)) +  geom_vline(xintercept=pdbs[which(pdbs$PDB==pdb),4],col="red",lty="dashed",size=0.2) + labs(x="", y="",title=pdb) + guides(colour=FALSE) + theme_bw()
  }
  i=i+1
}
pdf(file="~/pub_html/Clare/Validation_conSNIFF.pdf")    
multiplot(plotlist=plots[1:16],cols=3)
multiplot(plotlist=plots[17:31],cols=3)         
multiplot(plotlist=plots[31:41],cols=3)         
dev.off()   

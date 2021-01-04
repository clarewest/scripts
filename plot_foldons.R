#!/usr/local/bin/Rscript
library(RColorBrewer)
##### SIMPLE SNIFF PLOT #####

sniff <- function(pdb,t){
  m<-read.table(paste(pdb,"_chunks.out",sep=""))
  m<-as.matrix(m)
  m[m==0]<- NA 
  start=(as.numeric(head(which(m[1,] != 0, arr.ind=TRUE),1)))
  plot(m[1,],type="l",xlim=c(start,ncol(m)),ylim=c(min(-150),max(0)),main=pdb,xlab="Residue number",ylab="Panchenko Score",xaxt='n',yaxt='n')
  axis(1,at=seq(20,ncol(m),by=20))
  axis(2,at=seq(-140,0,by=20))
  col<- c("black",brewer.pal(5,"Set2"))
  abline(v=(subset(t,PDB==pdb)$break_1))
  if (nrow(m)>1){
    for (i in c(2:nrow(m))){
      lines(c(1:ncol(m)),m[i,],lty=1,col=col[i])
    }
    bps=as.numeric(t[t$PDB==pdb,3:ncol(t)])
    for (i in c(1:length(bps))){ 
      abline(v=bps[i],col="lightgray",lty=2)
    }
  }
}

#pdf(file="~/pub_html/Clare/multiple_sniff.pdf")
par(mfrow = c(3, 3))
par(cex = 0.6)
par(mar = c(2, 0, 2, 0), oma = c(4, 4, 0.5, 0.5))
par(tcl = -0.25)
par(mgp = c(2, 0.6, 0))

breakpoints<-read.table("breakpoints.txt",fill=TRUE,col.names=c("PDB",paste("break", 1:13, sep="_")))
for (PDB in breakpoints$PDB){
  sniff(PDB,breakpoints)
}
#dev.off()


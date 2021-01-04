library(ggplot2)
library(scales)

multiplot <- function(..., plotlist=NULL, file, cols=1, layout=NULL) {
  library(grid)
  
  # Make a list from the ... arguments and plotlist
  plots <- c(list(...), plotlist)
  
  numPlots = length(plots)
  
  # If layout is NULL, then use 'cols' to determine layout
  if (is.null(layout)) {
    # Make the panel
    # ncol: Number of columns of plots
    # nrow: Number of rows needed, calculated from # of cols
    layout <- matrix(seq(1, cols * ceiling(numPlots/cols)),
                     ncol = cols, nrow = ceiling(numPlots/cols))
  }
  
  if (numPlots==1) {
    print(plots[[1]])
    
  } else {
    # Set up the page
    grid.newpage()
    pushViewport(viewport(layout = grid.layout(nrow(layout), ncol(layout))))
    
    # Make each plot, in the correct location
    for (i in 1:numPlots) {
      # Get the i,j matrix positions of the regions that contain this subplot
      matchidx <- as.data.frame(which(layout == i, arr.ind = TRUE))
      
      print(plots[[i]], vp = viewport(layout.pos.row = matchidx$row,
                                      layout.pos.col = matchidx$col))
    }
  }
}

pdbs<-read.table("~/predcon_twodomain.txt",col.names=c("pdb"))
guess<-read.table("/data/pegasus/west/CLIPT/twodomain/breakpoints.txt",fill=TRUE,col.names=c("pdb",paste("break", 1:7, sep="_")))
breakpoints<-read.table("/data/pegasus/west/CLIPT/twodomain/real_breakpoints.txt",col.names=c("pdb","breakpoint"))
lengths<-read.table("/data/pegasus/west/CLIPT/twodomain/lengths_twodomain.txt",col.names=c("pdb","length"))
firstres<-read.table("/data/pegasus/west/CLIPT/twodomain/firstres.txt",col.names=c("pdb","firstres"))
dataset<-merge(pdbs,breakpoints,by="pdb")
dataset<-merge(dataset,firstres,by="pdb")
dataset<-merge(dataset,lengths,by="pdb")
dataset<-merge(dataset,guess[,1:2],by="pdb")
dataset<-unique(dataset)
real_nonredundant<-read.table("/data/pegasus/west/CLIPT/twodomain/really_really_filtered_set.txt",col.names=c("pdb"))
dataset<-merge(dataset,real_nonredundant,by="pdb")

PDB="2g3rA"

plot_contacts <- function(PDB){
  protein<-subset(dataset,pdb==PDB)
  protein$breakpoint<-protein$breakpoint-protein$firstres+1
  protein$break_1<-protein$break_1-protein$firstres+1
#  protein$end<-protein$firstres+protein$length-1
  contacts<-read.table(paste("~/twodomain_predcons/",PDB,".con",sep=""),col.names=c("res1","res2","confidence"))
  plot(contacts$res1,contacts$res2,xlim=c(1,protein$length),ylim=c(1,protein$length),main=PDB,pch=19,col=alpha("#66c2a5",0.5),ylab="",xlab="",xaxt='n',yaxt='n')
  axis(1,at=seq(1,protein$length,by=20),labels=FALSE)
  axis(2,at=seq(1,protein$length,by=20),labels=FALSE)
  abline(v=protein$breakpoint,lty="dashed")
  abline(h=protein$breakpoint,lty="dashed")
  abline(v=protein$break_1,lty="dashed",col="tomato")
  abline(h=protein$break_1,lty="dashed",col="tomato")
  abline(0,1)
}


pdf(file="~/Final_set_predicted_contacts.pdf",width=7,height=7)
par(pty="s")
par(mfrow = c(4, 4))
par(cex = 0.6)
par(mar = c(0, 1, 1, 1), oma = c(0.2, 0.2, .2, 0.2))
par(tcl = -0.25)
par(mgp = c(2, 0.5, 0))
final_set<-read.table("twodomain/Final_set.txt",col.names=c("pdb"))
#for (PDB in dataset$pdb){
for (PDB in final_set$pdb){
  plot_contacts(PDB)
}
dev.off()





p<-ggplot(contacts)+
  geom_point(aes(x=res1,y=res2))+
  geom_vline(xintercept=protein$breakpoint,lty="dashed")+
  geom_hline(yintercept=protein$breakpoint,lty="dashed")+
  scale_x_continuous(limits=c(1,protein$end))+
  scale_y_continuous(limits=c(1,protein$end))+
  geom_abline(intercept=0,slope=1)+
  ggtitle(paste(PDB," Predicted Contacts",sep=""))+
  coord_fixed(ratio=1) +
  theme_bw()
p

multiplot(plotlist=plots,cols = 5)

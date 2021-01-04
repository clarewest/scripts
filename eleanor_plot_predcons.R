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

breakpoints<-read.table("breakpoints.txt",fill=TRUE,col.names=c("pdb",paste("break", 1:13, sep="_")))

plot_contacts <- function(PDB){
  protein<-subset(breakpoints,pdb==PDB)
  contacts<-read.table(paste(PDB,".con",sep=""),col.names=c("res1","res2","confidence"))
  length<-read.table(paste(PDB,".length",sep=""))[1,1]
  plot(contacts$res1,contacts$res2,xlim=c(1,length),ylim=c(1,length),main=PDB,pch=19,col=alpha("#66c2a5",0.5),ylab="",xlab="",xaxt='n',yaxt='n')
  axis(1,at=seq(1,length,by=20),labels=FALSE)
  axis(2,at=seq(1,length,by=20),labels=FALSE)
  abline(v=protein$break_1,lty="dashed",col="tomato")
  abline(h=protein$break_1,lty="dashed",col="tomato")
  abline(0,1)
}


#pdf(file="~/Final_set_predicted_contacts.pdf",width=7,height=7)
par(pty="s")
par(mfrow = c(4, 4))
par(cex = 0.6)
par(mar = c(0, 1, 1, 1), oma = c(0.2, 0.2, .2, 0.2))
par(tcl = -0.25)
par(mgp = c(2, 0.5, 0))htop
for (PDB in breakpoints$pdb){
  plot_contacts(PDB)
}
#dev.off()



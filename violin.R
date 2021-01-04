ctfolders<-c("2DN2_A","1IBX_A","1BSL_A","1VCQ_N","1VCQ_C","1RHS","1VCQ_A","1V0D_A","2UXV_A") 
uffolders<-c("1QQ3","1ENH","1LMB_3","1E0L","1VII","2A3D","2PDD","1PIN_N","1PRB","1BDC","1L2Y") 

png(file="~/pub_html/Clare/distribution_plots_CTF.png",width=2000,height=3000)
plots<- list()
for (i in 1:10){
  p1 <- TMviolins(ctfolders[i])
  plots[[i]] <- p1
}
p2<-TMviolins("1L2Y")
plots[[10]]<-p2
multiplot(plotlist=plots,cols=2)
dev.off()


TMviolins <-function(protein){
  ctprotein<-read.table(paste("/data/cockatrice/west/",protein,"/",protein,".scores_final.txt",sep=""),col.names=rep("CT",11))[-c(2:11)]
  ivprotein<-read.table(paste("/data/cockatrice/west/",protein,"/",protein,".scores_invitro.txt",sep=""),col.names=rep("IV",11))[-c(2:11)]
  rvprotein<-read.table(paste("/data/cockatrice/west/",protein,"/",protein,".scores_reverse.txt",sep=""),col.names=rep("RV",11))[-c(2:11)]
  aprotein<-merge(ctprotein,ivprotein,by=0,sort=F)
  aprotein<-merge(aprotein[,2:3],rvprotein,by=0,sort=F)
  
  
  p<- ggplot(reshape2::melt(aprotein), aes(x = variable, y = value, fill=variable)) + 
    geom_violin(scale="count",col="lightgray") +
    geom_boxplot(width=0.2,fill="white") +
    theme_bw() + 
    coord_flip() + 
    ylim(c(0,1))+
    scale_x_discrete(limits=c("RV","CT","IV")) +
    scale_fill_manual(values=c(adjustcolor(c('#66c2a5','#fc8d62','#8da0cb'),alpha.f=0.7))) +
    theme(legend.position="none") +
    geom_hline(yintercept = 0.5,colour="blue",linetype="longdash") +
    theme(axis.ticks = element_line() ,axis.text.x= element_text(size=14),axis.title.x = element_text(size=16), axis.text.y= element_text(size=14),axis.title.y = element_text(size=16), plot.title = element_text(size=18,face="bold")) +
    labs(title=protein,y="TM Scores",x=NULL)
  return(p)
}

# Multiple plot function
#
# ggplot objects can be passed in ..., or to plotlist (as a list of ggplot objects)
# - cols:   Number of columns in layout
# - layout: A matrix specifying the layout. If present, 'cols' is ignored.
#
# If the layout is something like matrix(c(1,2,3,3), nrow=2, byrow=TRUE),
# then plot 1 will go in the upper left, 2 will go in the upper right, and
# 3 will go all the way across the bottom.
#
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


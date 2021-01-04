#!/usr/local/bin/Rscript
library(ggplot2)

t = read.table("1MSC.lib_rmsd")
dssp = strsplit(readLines("1MSC.dssp"),"")
t$SS = as.factor(dssp[[1]][t$V10+1])

png("1MSC_lib_violin.png",width=25000,height=2000,res = 300)
ggplot(t, aes(factor(V10),V14)) +
geom_violin(aes(fill = SS),scale = "width") +
labs(x="", y = "RMSD (A)") + 
geom_hline(yintercept=1.5)+
  theme(axis.ticks = element_line() , strip.text.x = element_text(color="black", size=16), axis.text.x = element_text(color="black", size=16, angle=45, hjust = 1.0),axis.text.y= element_text(size=14),axis.title.y = element_text(size=16),plot.title = element_text(size=18,face="bold"),legend.text=element_text(size=16)) 
dev.off()

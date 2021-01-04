#!/usr/local/bin/Rscript
library(scales)
library(ggplot2)
breakpoints<-read.table("breakpoints.txt",col.names=c("PDB","breakpoint"))
p.contacts<-read.table("predicted_contacts.txt",col.names=c("PDB","mode","res1","res2","confidence","correct"))
p.contacts<-merge(p.contacts,breakpoints,by="PDB")
r.contacts<-read.table("real_contacts.txt",col.names=c("PDB","m","res1","res2"))
r.contacts$res1<-r.contacts$res1+1
r.contacts$res2<-r.contacts$res2+1
cols=c(alpha("#fb8072",0.5),alpha("#66c2a5",0.5))

p.contacts$type<-ifelse((p.contacts$res1 < p.contacts$breakpoint & p.contacts$res2 < p.contacts$breakpoint), "intra", ifelse((p.contacts$res1 >= p.contacts$breakpoint & p.contacts$res2 >= p.contacts$breakpoint),"intra","inter"))
intra<-subset(p.contacts,type=="intra")
table<-merge((aggregate( correct ~ PDB + mode, data=intra, length)),(aggregate(correct ~ PDB + mode, data=intra, sum)), by= c("PDB","mode"))
names(table)[3:4]<-c("total","correct")
table$precision<-table$correct/table$total
intra.prec<-reshape2::dcast(table, PDB ~ mode, value.var="precision")
#intra.total<-reshape2::dcast(table, PDB ~ mode, value.var="total")
#intra.prec$delta<-intra.total$foldon-intra.total$whole
#intra.correct<-reshape2::dcast(table, PDB ~ mode, value.var="correct")
#intra.prec$c.delta<-intra.correct$foldon-intra.correct$whole
#intra.prec


intra$leo<-(intra$res1*500)+ intra$res2
foo <- split(  intra,intra$PDB  )
foo2 <- numeric(0)
for(i in 1:length(foo)){foo2 <- rbind(foo2,foo[[i]][foo[[i]]$leo %in% as.numeric(names(table(foo[[i]]$leo))[table(foo[[i]]$leo) <= 1]),])}
unique <-foo2

n.unique<- aggregate(leo ~ PDB + mode, unique,length)
names(n.unique)[3]<- "unique"
n.unique$total<- aggregate(correct  ~ PDB + mode, intra, length)[,3]
n.unique$both<-n.unique$total - n.unique$unique


foldon_unique<-subset(unique,mode=="foldon")
n.foldon<-subset(n.unique,mode=="foldon")
n.foldon$cutoff<-aggregate(leo ~ PDB, subset(foldon_unique,confidence>=0.6),length)[,2]

intra.prec$foldon_unique<-aggregate(correct ~ PDB, foldon_unique, mean)[,2]
intra.prec$foldon_unique_cap<-aggregate(correct ~ PDB, subset(foldon_unique,confidence>0.6), mean)[,2]

confidence<-merge(aggregate(confidence ~ PDB,subset(intra,mode=="whole"),mean), aggregate(confidence ~ PDB, foldon_unique, mean), by="PDB")
confidence<-merge(confidence, aggregate(confidence ~ PDB,subset(intra,mode=="foldon"),mean),by="PDB")
names(confidence)[2:4]<- c("whole","foldon_unique","foldon")
confidence$variable<-"Average PPV"
intra.prec$variable<-"Precision"
conf.prec<-rbind(confidence,intra.prec[,c(1,2,3,4,6)])

pdf(file="~/pub_html/Transfer/predicted_contacts_precision.pdf",width=6,height=3)
ggplot(conf.prec) + geom_point(aes(x=whole,y=foldon_unique))+  geom_point(aes(x=whole,y=foldon),colour="black",alpha=0.3,shape=1) + labs(x="Full-length Contacts", y="Additional Foldon Contacts")  + coord_fixed(ratio=1)   + scale_x_continuous(limits=c(0.5,1),expand=c(0,0)) + scale_y_continuous(limits=c(0.5,1),expand=c(0,0))+  geom_abline(  slope=1) +facet_wrap("variable") + theme_bw()+  theme(panel.margin = unit(1, "cm")) 
dev.off()

intra.full<-rbind(subset(unique,mode=="foldon"),subset(intra,mode=="whole"))

pdf(file="~/pub_html/Transfer/Validation_predicted_contacts_accuracy.pdf",width=5,height=5)
ggplot(intra.full) + 
	geom_bar(aes(fill=mode,x=as.character(correct)),stat="count") + 
	facet_wrap(~PDB) +
	theme_bw() +
	labs(y="Number of Contacts", x="") +
	scale_x_discrete(labels=c("False","True")) +
	scale_fill_manual(values=c("#969696","#252525")) + 
	guides(fill=FALSE) 
#ggplot(avs) + 
#	geom_bar(aes(x=PDB,y=correct,fill=mode),stat="identity", position=position_dodge()) + 
#	theme(axis.text.x = element_text(angle = 60, hjust = 1))

dev.off()


#pdf(file="~/pub_html/Transfer/Validation_predicted_contacts_accuracy2.pdf",width=5,height=5)
#ggplot(intra.full) + 
#	geom_bar(aes(x=PDB,fill=interaction(mode, correct)),stat="count") + 
#	theme_bw()  
#ggplot(avs) + 
#	geom_bar(aes(x=PDB,y=correct,fill=mode),stat="identity", position=position_dodge()) + 
#	theme(axis.text.x = element_text(angle = 60, hjust = 1))

#dev.off()


pdf(file="~/pub_html/Transfer/foldon_unique.pdf")
ggplot(intra.full) +
	geom_bar(aes(x=PDB,fill=as.character(correct)),stat="count") +
	theme_bw() +
	guides(fill=FALSE)
dev.off()


pdf(file="~/pub_html/Transfer/foldon_confidence.pdf")
ggplot(subset(intra,mode=="whole"), aes(x=PDB, y=confidence)) + 
	geom_point(colour="blue",alpha=0.6) +
	geom_point(data=foldon_unique, colour="red",alpha=0.6)
dev.off()

all.full<-rbind(subset(unique,mode=="foldon")[,c(1:ncol(unique)-1)],subset(p.contacts,mode=="whole"))

pdf(file="~/pub_html/Transfer/Example_predicted_contacts.pdf",width=6.5,height=3)
palette(cols)
pdb=c("1XWY","1ILW")
ggplot(subset(all.full, PDB %in% pdb)) + 
	geom_point(data=subset(r.contacts,PDB %in% pdb),aes(x=res1,y=res2),size=0.5,shape=15,colour="lightgray",alpha=0.7) +
	geom_point(aes(x=res1,y=res2,colour=interaction(mode,correct)), size=0.5,alpha=0.85,shape=15) +
	geom_vline(aes(xintercept=as.numeric(breakpoint))) +
	geom_hline(aes(yintercept=as.numeric(breakpoint))) +
	scale_x_continuous(expand=c(0,0)) +scale_y_continuous(expand=c(0,0)) +
	coord_fixed(ratio=1)+labs(x="Residue 1",y="Residue 2")  + 
	scale_colour_manual(breaks=c("foldon.1","foldon.0","whole.1","whole.0"),labels=c("True Foldon","False Foldon","True Whole","False Whole"),values=c("#fdae61","#abdda4","#d53e4f","#3288bd")) + 
	theme_bw() +
	facet_wrap(~PDB,ncol=2,scales="free") +
	theme(aspect.ratio = 1,legend.title= element_blank())
dev.off()

pdf(file="~/pub_html/Transfer/Validation_predicted_contacts.pdf",width=12,height=15)
ggplot(all.full) + 
	geom_point(data=r.contacts,aes(x=res1,y=res2),size=0.5,shape=15,colour="lightgray",alpha=0.7) +
	geom_point(aes(x=res1,y=res2,colour=interaction(mode,correct)), size=0.5,alpha=0.85,shape=15) +
	geom_vline(aes(xintercept=as.numeric(breakpoint))) +
	geom_hline(aes(yintercept=as.numeric(breakpoint))) +
	scale_x_continuous(expand=c(0,0)) +scale_y_continuous(expand=c(0,0)) +
	coord_fixed(ratio=1)+labs(x="Residue 1",y="Residue 2")  + 
	facet_wrap(~PDB,ncol=4,scales="free") +
	scale_colour_manual(breaks=c("foldon.1","foldon.0","whole.1","whole.0"),labels=c("True Foldon","False Foldon","True Whole","False Whole"),values=c("#fdae61","#abdda4","#d53e4f","#3288bd")) + 
	theme_bw() +
	guides(colour=FALSE) + 
	theme(aspect.ratio = 1,legend.title= element_blank(), axis.title.x=element_blank(),axis.title.y=element_blank())
avs<-aggregate( correct ~ PDB + mode, data=p.contacts, mean)
dev.off()


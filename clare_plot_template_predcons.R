#!/usr/local/bin/Rscript
library(scales)
library(ggplot2)
breakpoints<-read.table("breakpoints.txt",col.names=c("PDB","breakpoint"))
p.contacts<-read.table("predicted_contacts.txt",col.names=c("PDB","mode","res1","res2","correct"))
p.contacts<-merge(p.contacts,breakpoints,by="PDB")
r.contacts<-read.table("real_contacts.txt",col.names=c("PDB","m","res1","res2"))
r.contacts$res1<-r.contacts$res1+1
r.contacts$res2<-r.contacts$res2+1
cols=c(alpha("#fb8072",0.5),alpha("#66c2a5",0.5))

p.contacts$type<-ifelse((p.contacts$res1 < p.contacts$breakpoint & p.contacts$res2 < p.contacts$breakpoint), "intra_1", ifelse((p.contacts$res1 >= p.contacts$breakpoint & p.contacts$res2 >= p.contacts$breakpoint),"intra_2","inter"))
inter<-subset(p.contacts,type=="inter")
table.inter<-merge((aggregate( correct ~ PDB + mode, data=inter, length)),(aggregate(correct ~ PDB + mode, data=inter, sum)), by= c("PDB","mode"))
names(table.inter)[3:4]<-c("total","correct")
table.inter$precision<-table.inter$correct/table.inter$total
inter.prec<-reshape2::dcast(table.inter, PDB ~ mode, value.var="precision")

table.intra2<-merge((aggregate( correct ~ PDB + mode, subset(p.contacts,type=="intra_2"), length)),(aggregate(correct ~ PDB + mode, data=subset(p.contacts,type=="intra_2"), sum)), by= c("PDB","mode"))
names(table.intra2)[3:4]<-c("total","correct")
table.intra2$precision<-table.intra2$correct/table.intra2$total

#intra.total<-reshape2::dcast(table, PDB ~ mode, value.var="total")
#intra.prec$delta<-intra.total$foldon-intra.total$whole
#intra.correct<-reshape2::dcast(table, PDB ~ mode, value.var="correct")
#intra.prec$c.delta<-intra.correct$foldon-intra.correct$whole
#intra.prec

table.relevant<-merge((aggregate( correct ~ PDB, subset(p.contacts,type=="intra_2"), length)),(aggregate(correct ~ PDB, data=subset(p.contacts,type=="inter"), length)), by= c("PDB"))
names(table.relevant)[2:3]<-c("intra.cons","inter.cons")
write.table(file="/data/icarus/west/saintresults/TemplateScafFold/plotting/contact_totals.txt",table.relevant,col.names=FALSE,row.names=FALSE,quote=FALSE)

ggplot(subset(p.contacts,type=="intra_2" | type=="inter")) + geom_bar(aes(fill=as.character(correct),x=type),stat="count") + facet_wrap(~PDB) + theme_bw() + guides(fill=FALSE)
ggsave(file="~/pub_html/Clare/TemplateScafFold/precision.pdf")

table.total<- merge((aggregate( correct ~ PDB + mode, data=p.contacts, length)),(aggregate(correct ~ PDB + mode, data=p.contacts, sum)), by= c("PDB","mode"))

### Plot maps ###
ggplot(p.contacts) + geom_point(data=r.contacts,aes(x=res1,y=res2),size=0.5,shape=15,colour="lightgray",alpha=0.7) + geom_point(aes(x=res1,y=res2,colour=interaction(mode,correct)), size=0.5,alpha=0.85,shape=15) + geom_vline(aes(xintercept=as.numeric(breakpoint))) + geom_hline(aes(yintercept=as.numeric(breakpoint))) + scale_x_continuous(expand=c(0,0)) +scale_y_continuous(expand=c(0,0)) + coord_fixed(ratio=1)+labs(x="Residue 1",y="Residue 2")  + facet_wrap(~PDB,ncol=4,scales="free") + scale_colour_manual(breaks=c("whole.1","whole.0"),labels=c("True Whole","False Whole"),values=c("#d53e4f","#3288bd")) + theme_bw() + guides(colour=FALSE) +theme(aspect.ratio = 1,legend.title= element_blank(), axis.title.x=element_blank(),axis.title.y=element_blank())
ggsave(file="~/pub_html/Clare/TemplateScafFold/predicted_contacts_maps.pdf")

avs<-aggregate( correct ~ PDB + mode, data=p.contacts, mean)
print(avs)

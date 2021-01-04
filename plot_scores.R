#!/usr/local/bin/Rscript

plot_score <- function(protein,s){
  t<-read.table(paste(protein,"_A.scores_final.txt",sep = ""))
  plot(t$V1,t$V2,type="l",ylab="SAINT2 Score",xlab="Protein Length",main=paste(protein,": CT=",round(s[s$V2==protein,3],digits=2)," IV=",round(s[s$V2==protein,4],digits=2),sep=""))
}

png("~/pub_html/Clare/scan_plots_CT.png",width=2500,height=2500,res=300,pointsize=18)
par(mfrow=c(3,2))
p=c("2DN2","1SFE","1VFF","1XWY","1Z2U","1SDI")
s<-read.table("saulo_scores.txt") 
for (protein in p){plot_score(protein,s)}
dev.off()
png("~/pub_html/Clare/scan_plots_RV.png",width=2500,height=2500,res=300,pointsize=18)
par(mfrow=c(3,2))
p=c("1XD6","1V5C","1T9F","1OBR")
for (protein in p){plot_score(protein,s)}
plot_score("1PIN",s)
abline(v=39,col="red",lty=5)
dev.off()




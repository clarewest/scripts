library(ggplot2)
library(grid)
library(gridBase)
require(gridExtra)
library(plyr)
library(dplyr)
library(tidyr)
library(class)
library(e1071)
library(randomForest)
library(ROCR)
library(AUCRF)
library(caret)

##### Set seed for reproducible results
set.seed(1011)

##### Deal with really big SAINT2 scores forcing scientific notation #####
options(scipen=999)

##### Beautiful colour palettes #####

gg_color_hue <- function(n) {
  hues = seq(15, 375, length = n + 1)
  hcl(h = hues, l = 65, c = 100)[1:n]
}

colours=gg_color_hue(6)


calculate_performance <- function(score,labels,plot_index,add_to_plot=FALSE) {
		#prediction = predict(score,data,type="response")
		pr <- prediction(score, as.factor(labels))
		perf <- performance(pr, "tpr", "fpr")
		auc = performance(pr, measure = "auc")
		plot(perf,main="ROC Curve",col=colours[plot_index],add=add_to_plot) 
		return (c(pr,auc))
}

calculate_performance_glm <- function(data,labels,classifier,plot_index,add_to_plot=FALSE) {
		prediction = predict(classifier,data,type="response")
		pr <- prediction(prediction, as.factor(labels))
		perf <- performance(pr, "tpr", "fpr")
		auc = performance(pr, measure = "auc")
		plot(perf,main="ROC Curve",col=colours[plot_index],add=add_to_plot) 
		return (c(pr,auc))
}

calculate_performance_rf <- function(data,labels,classifier,plot_index,add_to_plot=FALSE) {
		prediction = predict(classifier,data,type="prob")
		pr <- prediction(prediction[,2], as.factor(labels))
		perf <- performance(pr, "tpr", "fpr")
		auc = performance(pr, measure = "auc")
		plot(perf,main="ROC Curve",col=colours[plot_index],add=add_to_plot) 
		return (c(pr,auc))
}

##DATASET="TrainingScafFold_TM"
DATASET="TrainingScafFold_RMSD"
#DATASET="TrainingScafFold_LocalRMSD"
#DATASET="TrainingScafFold_Fnat"

target_pos_proteins <- read.table(paste(DATASET,"RFQAtarget_predictions.txt", sep=""), col.names=c("Protein"))

t = read.table("../output/TrainingScafFold/training_topAll.txt")
t2 = read.table("../output/TrainingScafFold/training_topAll.txt")
#t2 = read.table("Method2_testAll.txt")
#t2 = read.table(paste("../output/",DATASET,"/Method2_",DATASET,"topAll.txt", sep=""))

#t=na.omit(t)
#t2=na.omit(t2)
t[is.na(t)]=0
t2[is.na(t2)]=0


Labels=c("Incorrect","Correct")
#t[,70] = as.factor(Labels[as.integer(t$V14 >= 0.5) + 1])
#t[,71] = as.factor(Labels[as.integer(t$V69 >= 0.5) + 1])
#t2[,70] = as.factor(Labels[as.integer(t2$V14 >= 0.5) + 1])
#t2[,71] = as.factor(Labels[as.integer(t2$V69 >= 0.5) + 1])

head(t2)
colnames(t) = c("Protein", "Decoy", "PPV", "MapAlign", "MapLength", "EigenTHREADER", "Contact","SAINT2", "Target_PPV","NumTrue","NumCon","Neff","TMsegment","TMScore","PCons","ProQ2D","ProQRosCenD","ProQRosFAD","ProQ3D","PCombC","Local_RMSD","Global_RMSD","Global_Flex","Local_Flex","Fnat","Fnonnat","Local_Pcons","Local_ProQ3D","Target","Length","SCOP_Class","Beff","NumCon2","S2_Max","S2_Med","S2_Min","S2_Spr","Con_Max","Con_Med","Con_Min","Con_Spr","PPV_Max","PPV_Num","MA_Max","MA_Med","MA_Min","MA_Spr","MA_LEN","ET_Max","ET_Med","ET_Min","ET_Spr","PC_Max","PC_Med","PC_Min","PC_Spr","ProQ2D_Max","ProQ2D_Med","ProQ2D_Min","ProQ2D_Spr","RosCen_Max","RosCen_Med","RosCen_Min","RosCen_Spr","RosFA_Max","RosFA_Med","RosFA_Min","RosFA_Spr","ProQ3D_Max","ProQ3D_Med","ProQ3D_Min","ProQ3D_Spr","PCombC_Max","PCombC_Med","PCombC_Min","PCombC_Spr","TMScore2","LFlex_Max","LFlex_Med","LFlex_Min","LFlex_Spr","GFlex_Max","GFlex_Med","GFlex_Min", "GFlex_Spr","Top_Local_RMSD","Top_Global_RMSD","Top_Fnat","Top_Fnonnat", "Local_PC_Max","Local_PC_Med","Local_PC_Min","Local_PC_Spr","Local_ProQ3D_Max","Local_ProQ3D_Med","Local_ProQ3D_Min","Local_ProQ3D_Spr")
colnames(t2) = colnames(t) 
head(t2)

if (DATASET=="TrainingScafFold_TM"){
t %>% mutate(Label=as.factor(ifelse((TMScore>=0.7)  , "Correct","Incorrect"))) -> t
t2 %>% mutate(Label=as.factor(ifelse((TMScore>=0.7)  , "Correct","Incorrect"))) -> t2
}

if (DATASET=="TrainingScafFold_Fnat"){
t %>% mutate(Label=as.factor(ifelse((Fnat>=0.8)  , "Correct","Incorrect"))) -> t
t2 %>% mutate(Label=as.factor(ifelse((Fnat>=0.8)  , "Correct","Incorrect"))) -> t2
}

if (DATASET=="TrainingScafFold_LocalRMSD"){
t %>% mutate(Label=as.factor(ifelse(((Local_RMSD <= 2.5))  , "Correct","Incorrect"))) -> t
t2 %>% mutate(Label=as.factor(ifelse(((Local_RMSD <= 2.5))  , "Correct","Incorrect"))) -> t2
}

if (DATASET=="TrainingScafFold_RMSD"){
t %>% mutate(Label=as.factor(ifelse(((Local_RMSD <= 2.5) & (Global_RMSD <= 5))  , "Correct","Incorrect"))) -> t
t2 %>% mutate(Label=as.factor(ifelse(((Local_RMSD <= 2.5) & (Global_RMSD <= 5))  , "Correct","Incorrect"))) -> t2
}

t %>% group_by(Protein) %>% mutate(Label2 = ifelse("Correct" %in% Label, "Correct", "Incorrect")) %>% ungroup() -> t
t2 %>% group_by(Protein) %>% mutate(Label2 = ifelse("Correct" %in% Label, "Correct", "Incorrect")) %>% ungroup() -> t2
t$PPV=t$PPV/100.0
t$PPV_Max=t$PPV_Max/100.0
t$PPV_Num=t$PPV_Num/100.0
t2$PPV=t2$PPV/100.0
t2$PPV_Max=t2$PPV_Max/100.0
t2$PPV_Num=t2$PPV_Num/100.0

#t$SAINT2 = 1.0 - (t$SAINT2-min(t$SAINT2,na.rm=TRUE))/(max(t$SAINT2,na.rm=TRUE)-min(t$SAINT2,na.rm=TRUE)) # Normalise SAINT2 Score?
#t2$SAINT2 = 1.0 - (t2$SAINT2-min(t2$SAINT2,na.rm=TRUE))/(max(t2$SAINT2,na.rm=TRUE)-min(t2$SAINT2,na.rm=TRUE)) # Normalise SAINT2 Score?

plots = vector("list", 4)
##### For now, let us plot and see the three features that we plan to use for our GLM:
for (i in c(1,2,3,4,5,6))
{
	temp = c("PPV_Max","SAINT2","PCons","EigenTHREADER","ProQ3D","PCombC")
	plots[[i]]=ggplot(t2,aes_string(x=temp[i],y="TMScore",col="Label"))+geom_point()
}
# Define a new plotting window with sensible dimensions:
#dev.new(width=12,height=4)
# Arrange plots in a single row and perform the plotting: 
png(paste("~/pub_html/Clare/ScafFoldRFQA/",DATASET,"models_features.png",sep=""),width=12000,height=4000,res=350)
grid.arrange(grobs=plots,nrow=2)
dev.off()

head(t)

training <- target_pos_proteins %>% sample_n(nrow(target_pos_proteins)*0.6)
validation <- target_pos_proteins %>% filter( ! Protein %in% training$Protein)
train_tab <- t %>% filter(Protein %in% training$Protein) 
val_tab <- t %>% filter(Protein %in% validation$Protein) 
#val_tab = t2[t2$Protein %in% target_pos_proteins$Protein,]


#dev.new()

##### GLM
png(paste("~/pub_html/Clare/ScafFoldRFQA/ROCCurve",DATASET,"models.png", sep=""),width=2250,height=2250,res=450)

#fit1 = glm(Label ~ PC_Max + PPV_Max + ProQ2D_Max,family=binomial(link="logit"),data=train_tab)
#result1 = calculate_performance_glm(val_tab,val_tab$Label,fit1,1)
# Use Random Forest Classifier to classify models into Correct/Incorrect
fit2 <- randomForest(as.factor(Label) ~ . -Label -Label2 -Protein -Decoy -Target -TMScore -TMScore2 -TMsegment - NumTrue -Target_PPV -SCOP_Class -Global_RMSD -Local_RMSD -Fnat -Fnonnat -Top_Global_RMSD -Top_Local_RMSD -Top_Fnat -Top_Fnonnat, data=train_tab, importance=TRUE, ntree=500,mtry = 7)	
result2 = calculate_performance_rf(val_tab,val_tab$Label,fit2,1,)
result3 = calculate_performance(-val_tab$ProQ2D,val_tab$Label,2,"TRUE")
result4 = calculate_performance(-val_tab$ProQ3D,val_tab$Label,3,"TRUE")
result5 = calculate_performance(-val_tab$PCombC,val_tab$Label,4,"TRUE")
result6 = calculate_performance(-val_tab$PCons,val_tab$Label,5,"TRUE")
legend("bottomright",	c(paste("RFQA - AUC=",round(result2[[2]]@y.values[[1]],2)),paste("ProQ2D - AUC=",round(result3[[2]]@y.values[[1]],2)),paste("ProQ3D - AUC=",round(result4[[2]]@y.values[[1]],2)),paste("PCombC - AUC=",round(result5[[2]]@y.values[[1]],2)),paste("PCons - AUC=",round(result6[[2]]@y.values[[1]],2))), lwd = 2, lty = 1,col=colours[1:6])
dev.off()

##### Confusion Matrix ##### 
for (cutoff in c(0.5, 0.7)){

png(paste("~/pub_html/Clare/ScafFoldRFQA/ConfusionMatrix",DATASET,"models_",cutoff,".png", sep=""),width=2250,height=2250,res=450)

prediction = predict(fit2,val_tab,type="prob")
Observed <- factor(c("Incorrect", "Incorrect", "Correct", "Correct"))
Predicted <- factor(c("Incorrect", "Correct", "Incorrect", "Correct"))
pr <- prediction(prediction[,2], as.factor(val_tab$Label))
C <- confusionMatrix(factor( Labels[as.integer(unlist(slot(pr,"predictions")) < cutoff)+1],levels=Labels[c(2,1)]) ,val_tab$Label)
C
Y2      <- c(C$table[2,2],C$table[1,2],C$table[2,1], C$table[1,1])
df2 <- data.frame(Observed, Predicted, Y2)
print(ggplot(data =  df2, mapping = aes(x = Observed, y = Predicted)) +  geom_tile(aes(fill = Y2), colour = "white") +   geom_text(aes(label = sprintf("%1.0f", Y2)), vjust = 1) +   scale_fill_gradient(low = "white", high = "lightblue") + ggtitle(paste("Confusion Matrix:",DATASET,cutoff, sep=" ")) + theme_minimal() + theme(legend.position = "none" ,plot.title = element_text(hjust = 0.5)))

dev.off()

png(paste("~/pub_html/Clare/ScafFoldRFQA/RFQAmodel_varImpPlot",DATASET,".png",sep=""))
varImpPlot(fit2)
dev.off()

##### Ranking of correct cases #####

pos_pred_tab2 = val_tab[unlist(slot(result2[[1]],"predictions"))<=cutoff,]
pos_proteins = pos_pred_tab2$Target
a<-rbind(pos_pred_tab2 %>% mutate(Set=paste("RFQAmodel_",cutoff,sep="")), val_tab %>% mutate(Set="All"))

#Tops <- pos_pred_tab2 %>% group_by(Protein) %>% arrange(SAINT2) %>% slice(1:5) %>%  mutate(Top5=sum(TMScore >=0.5)) %>% slice(1) %>% summarise(Top5=Top5, Top1=sum(TMScore>=0.5))
Tops <- a %>% group_by(Set,Protein) %>% arrange(SAINT2) %>% slice(1:5) %>%  mutate(Top5=max(TMScore >=0.5)) %>% slice(1) %>% summarise(Top5=Top5, Top1=sum(TMScore>=0.5))
print("Targets:")
print(unique(subset(Tops, Set!="Set")$Protein))
print("Correct models:")
print(Tops %>% summarise_if(is.numeric, c(sum, length)))
prop <- Tops %>% merge((a %>% group_by(Set, Protein, Label) %>% summarise(n=length(Label)) %>% mutate(total=sum(n),percentage=n/sum(n))), by=c("Set","Protein")) %>% filter(Label=="Correct")%>% merge((val_tab  %>% group_by(Protein) %>% summarise(Neff=max(Neff))), by="Protein") %>% arrange(percentage, Protein) 
write.table(prop, file=paste("~/pub_html/Clare/ScafFoldRFQA/",DATASET,cutoff,"full_details.txt",sep=""), row.names=FALSE, quote=FALSE)
write.table(subset(prop, Set=="All"), file=paste("~/pub_html/Clare/ScafFoldRFQA/",DATASET,cutoff,"brief_details.txt",sep=""), row.names=FALSE, quote=FALSE)
#extra <- Tops %>% merge((a %>% group_by(Set, Protein, Label) %>% summarise(n=length(Label)) %>% mutate(total=sum(n),percentage=n/sum(n))), by=c("Set","Protein")) %>% filter(Label=="Correct")  %>% arrange(percentage) %>% group_by(Protein) %>% mutate(Difference=min(percentage)-max(percentage), Reduction=1-(min(total)/max(total))) 
#print(extra)
}
## Saulo's method:
#correct_top1=0
#correct_top5=0
#for (i in pos_proteins)
#{
#     temp=pos_pred_tab2[pos_pred_tab2$Protein == i,]
#     # Rank
#     top1=temp[which.min(temp$SAINT2), ]
#     temp=temp[order(temp$SAINT2),]
#     top5=temp[which.max(temp[c(1:5),"TMScore"]),]
#     # Now you can do some counting!    
#     correct_top1=correct_top1+as.integer(top1$TMScore >= 0.5)
#     correct_top5=correct_top5+as.integer(top5$TMScore >= 0.5) 
#}





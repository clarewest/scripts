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

##### Set the seed for reproducible results
set.seed(1011)

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



#DATASET="TrainingScafFold_TM"
DATASET="TrainingScafFold_RMSD"
#DATASET="TrainingScafFold_LocalRMSD"
#DATASET="TrainingScafFold_Fnat"
#DATASET="SAINTCASP12"

t = read.table("../output/TrainingScafFold/training_features.txt")
t2 = read.table("../output/TrainingScafFold/training_features.txt")
#t2 = read.table(paste("../output/",DATASET,"/",DATASET,"_features.txt", sep=""))
#t2 = read.table("../output_test/Method1_Test_NoFilt.txt")


t[is.na(t)]=0
t2[is.na(t2)]=0
#t=na.omit(t)
#t2=na.omit(t2)

Labels=c("Incorrect","Correct")
#t[,62] = as.factor(Labels[as.integer(t$V49 >= 0.5) + 1])
#t2[,62] = as.factor(Labels[as.integer(t2$V49 >= 0.5) + 1])

colnames(t) = c("Target","Length","SCOP_Class","Beff","NumCon2","S2_Max","S2_Med","S2_Min","S2_Spr","Con_Max","Con_Med","Con_Min","Con_Spr","PPV_Max","PPV_Num","MA_Max","MA_Med","MA_Min","MA_Spr","MA_LEN","ET_Max","ET_Med","ET_Min","ET_Spr","PC_Max","PC_Med","PC_Min","PC_Spr","ProQ2D_Max","ProQ2D_Med","ProQ2D_Min","ProQ2D_Spr","RosCen_Max","RosCen_Med","RosCen_Min","RosCen_Spr","RosFA_Max","RosFA_Med","RosFA_Min","RosFA_Spr","ProQ3D_Max","ProQ3D_Med","ProQ3D_Min","ProQ3D_Spr","PCombC_Max","PCombC_Med","PCombC_Min","PCombC_Spr","TMScore","LFlex_Max","LFlex_Med","LFlex_Min","LFlex_Spr","GFlex_Max","GFlex_Med","GFlex_Min", "GFlex_Spr","Local_RMSD","Global_RMSD","Fnat","Fnonnat", "Local_PC_Max","Local_PC_Med","Local_PC_Min","Local_PC_Spr","Local_ProQ3D_Max","Local_ProQ3D_Med","Local_ProQ3D_Min","Local_ProQ3D_Spr")
colnames(t2) = colnames(t) 

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

#t %>% mutate(Label=as.factor(ifelse(((Fnat>=0.5) & (Local_RMSD <= 2.5) & (Global_RMSD <= 5))  , "Correct","Incorrect"))) -> t
#t2 %>% mutate(Label=as.factor(ifelse(((Fnat>=0.5) & (Local_RMSD <= 2.5) & (Global_RMSD <= 5))  , "Correct","Incorrect"))) -> t2

t$PPV_Max=t$PPV_Max/100.0
t2$PPV_Max=t2$PPV_Max/100.0

plots = vector("list", 4)
##### For now, let us plot and see the three features that we plan to use for our GLM:
for (i in c(1,2,3,4,5,6))
{
	temp = c("PPV_Max","S2_Max","PC_Max","ET_Max","ProQ3D_Max","PCombC_Max")
	plots[[i]]=ggplot(t,aes_string(x=temp[i],y="TMScore",col="Label"))+geom_point()
}
# Define a new plotting window with sensible dimensions:
#dev.new(width=12,height=4)
# Arrange plots in a single row and perform the plotting: 
#png("~/pub_html/Meeting/Sasquatch_Figure1.png",width=4000,height=4000,res=350)
png(paste("~/pub_html/Clare/ScafFoldRFQA/",DATASET,"target_features.png",sep=""),width=12000,height=4000,res=350)
grid.arrange(grobs=plots,nrow=2)
dev.off()

train_tab <- t %>% sample_n(length(.$Target)*0.6) 
val_tab <- t %>% filter(! Target %in% train_tab$Target)

n <- rbind(train_tab %>% mutate(Set="Training"), val_tab %>% mutate(Set="Validation")) %>% group_by(Set, Label) %>% summarise(Targets=length(Label))
write.table(n, file=paste("~/pub_html/Clare/ScafFoldRFQA/Classification_",DATASET,".txt",sep=""),row.names=FALSE, quote=FALSE)

## Uncomment to save image
#dev.new()
png(paste("~/pub_html/Clare/ScafFoldRFQA/ROCCurve",DATASET,"target.png", sep=""),width=2250,height=2250,res=450)

##### GLM
#png("~/SAINT2_QA/Fig20.png",width=2250,height=2250,res=450)
#result1 = calculate_performance_glm(val_tab,val_tab$Label,fit1,1)
#fit1 = glm(Label ~ PC_Max + PPV_Max + ProQ2D_Max,family=binomial(link="logit"),data=train_tab)
# Use Random Forest Classifier to classify models into Correct/Incorrect
fit2 <- randomForest(as.factor(Label) ~ . -Label -Target -TMScore -SCOP_Class -Local_RMSD -Global_RMSD -Fnat -Fnonnat, data=train_tab, importance=TRUE, ntree=1000,mtry = 7)	
#fit2 <- randomForest(as.factor(Label) ~ . -Label -Target -TMScore , data=train_tab, importance=TRUE, ntree=1000,mtry = 7)	
result2 = calculate_performance_rf(val_tab,val_tab$Label,fit2,1)
result3 = calculate_performance(-val_tab$ProQ2D_Max,val_tab$Label,2,"TRUE")
result4 = calculate_performance(-val_tab$Local_ProQ3D_Max,val_tab$Label,3,"TRUE")
result5 = calculate_performance(-val_tab$PCombC_Max,val_tab$Label,4,"TRUE")
result6 = calculate_performance(-val_tab$Local_PC_Max,val_tab$Label,5,"TRUE")
result7 = calculate_performance(-val_tab$RosFA_Max,val_tab$Label,6,"TRUE")
legend("bottomright",	c(paste("RFQA - AUC=",round(result2[[2]]@y.values[[1]],2)),paste("ProQ2D - AUC=",round(result3[[2]]@y.values[[1]],2)),paste("Local ProQ3D - AUC=",round(result4[[2]]@y.values[[1]],2)),paste("PCombC - AUC=",round(result5[[2]]@y.values[[1]],2)),paste("Local_PCons - AUC=",round(result6[[2]]@y.values[[1]],2)),paste("ROSETTA FA - AUC=",round(result7[[2]]@y.values[[1]],2))), lwd = 2, lty = 1,col=colours)
dev.off()

##### Confusion Matrix ##### 

prediction = predict(fit2,val_tab,type="prob")
Observed <- factor(c("Correct", "Correct","Incorrect", "Incorrect"))
Predicted <- factor(c("Correct", "Incorrect", "Correct", "Incorrect"))
pr <- prediction(prediction[,2], as.factor(val_tab$Label))

for (i in seq(0.05,0.5,0.01) )
{
	cutoff = i
	C <- confusionMatrix(factor( Labels[1 + as.integer(unlist(slot(pr,"predictions")) <= cutoff )  ]) ,val_tab$Label)
	print( i )
	print( ( as.numeric(C$table[1,2])/as.numeric(C$table[1,2]+C$table[1,1]) ) )
}

dev.new()
cutoff=0.5
C <- confusionMatrix(factor( Labels[1 + as.integer(unlist(slot(pr,"predictions")) <= cutoff )  ]) ,val_tab$Label)
Y2      <- c(C$table[1,1],C$table[2,1],C$table[1,2], C$table[2,2])
df2 <- data.frame(Observed, Predicted, Y2)

png(paste("~/pub_html/Clare/ScafFoldRFQA/ConfusionMatrix",DATASET,"target.png", sep=""),width=2250,height=2250,res=450)

#ggplot(data =  df2, mapping = aes(x = Observed, y = Predicted)) +  geom_tile(aes(fill = Y2), colour = "white") +   geom_text(aes(label = sprintf("%1.0f", Y2)), vjust = 1) +   scale_fill_gradient(low = "white", high = "lightblue") + ggtitle("Confusion Matrix for 20% of Training") + theme_bw() + theme(legend.position = "none" )
print(ggplot(data =  df2, mapping = aes(x = Observed, y = Predicted)) +  geom_tile(aes(fill = Y2), colour = "white") +   geom_text(aes(label = sprintf("%1.0f", Y2)), vjust = 1) +   scale_fill_gradient(low = "white", high = "lightblue") + ggtitle("Confusion Matrix: RFQAtarget (0.5)") + theme_bw() + theme(legend.position = "none" ))

dev.off()

### Importance ###
#dev.new()
png(paste("~/pub_html/Clare/ScafFoldRFQA/varImpPlot",DATASET,".png",sep=""))
varImpPlot(fit2)
dev.off()

##### Ranking of correct cases ##### 

#result_tr = calculate_performance_rf(train_tab,train_tab$Label,fit2,2)
#pos_pred_tr = val_tab[unlist(slot(result_tr[[1]],"predictions"))<=cutoff,]
#pos_proteins_tr = pos_pred_tr$Target

pos_pred_tab2 = val_tab[unlist(slot(result2[[1]],"predictions"))<=cutoff,]
pos_proteins = pos_pred_tab2$Target

write.table(pos_proteins, file=paste(DATASET,"RFQAtarget_predictions.txt", sep=""), row.names=FALSE, col.names=FALSE, quote=FALSE)
missed <- t2 %>% filter(! Target %in% pos_pred_tab2$Target) %>% filter(Label=="Correct")

t = read.table("Results_Test_1.txt")
colnames(t)=c("Protein", "Decoy","PPV","Mapalign","Seg_Length","EigenTHREADER","Contact","SAINT2","Contact_PPV","NumTrue","NumCon","Neff","TMsegment","TMScore","PCons","ProQ2D","ProQRosCen","ProQRosFA","ProQ3D","Method")
t$Protein = substr(t$Protein,1,4)

#t2 = data.frame(matrix(vector(), 0, 20, dimnames=list(c(), c(colnames(t)))),stringsAsFactors=F)
t2=t[t$Protein %in% pos_proteins,]
for (i in pos_proteins )
{
     temp=t[t$Protein == i,]
     temp = temp[temp$Method %in% c("SAINT2","EigenTHREADER","PCombC") ,]
     best=temp[which.max(temp$TMScore), ]
     best$Method="Consensus"
#    temp=rbind(temp,best)
     t2=rbind(t2,best)
}

t2$V21="Beff < 100"
t2$V21[t2$Neff >= 100 & t2$Neff < 1000 ]="Beff >= 100 & Beff < 1000"
t2$V21[t2$Neff >= 1000 ]="Beff >= 1000"
colnames(t2)[21]="Neff_Class"
t3=t2
t3$Neff_Class="All Beff"
t2 = rbind(t2,t3)


t2[,22] = factor(Labels[as.integer(t2$TMScore >= 0.5)+1],levels=Labels)
colnames(t2)[22]="Correct"

plot_data <- t2 %>% count(Neff_Class,Method,Correct) %>%  group_by(Neff_Class,Method) %>% mutate(percent = n/sum(n))
plot_data_cor = plot_data[plot_data$Correct=="Correct",]

t = read.table("Results_Test_5.txt")
colnames(t)=c("Protein", "Decoy","PPV","Mapalign","Seg_Length","EigenTHREADER","Contact","SAINT2","Contact_PPV","NumTrue","NumCon","Neff","TMsegment","TMScore","PCons","ProQ2D","ProQRosCen","ProQRosFA","ProQ3D","Method")
t$Protein = substr(t$Protein,1,4)

#t2 = data.frame(matrix(vector(), 0, 20, dimnames=list(c(), c(colnames(t)))),stringsAsFactors=F)
t2=t[t$Protein %in% pos_proteins,]
for (i in pos_proteins )
{
     temp=t[t$Protein == i,]
     temp = temp[temp$Method %in% c("SAINT2","EigenTHREADER","PCombC") ,]
     best=temp[which.max(temp$TMScore), ]
     best$Method="Consensus"
     t2=rbind(t2,best)
}

t2$V21="Beff < 100"
t2$V21[t2$Neff >= 100 & t2$Neff < 1000 ]="Beff >= 100 & Beff < 1000"
t2$V21[t2$Neff >= 1000 ]="Beff >= 1000"
colnames(t2)[21]="Neff_Class"
t3=t2
t3$Neff_Class="All Beff"
t2 = rbind(t2,t3)


t2[,22] = factor(Labels[as.integer(t2$TMScore >= 0.5)+1],levels=Labels)
colnames(t2)[22]="Correct"

plot_data2 <- t2 %>% count(Neff_Class,Method,Correct) %>%  group_by(Neff_Class,Method) %>% mutate(percent = n/sum(n))
plot_data_cor2 = plot_data2[plot_data2$Correct=="Correct",]

png("~/SAINT2_QA/Fig20b.png",width=6500,height=4500,res=340)
plot1= ggplot(plot_data_cor, aes(x = reorder(Method,n,FUN=max), y = n, fill = Method)) + 
geom_col() + 
geom_label(aes(label = n),position = position_stack(vjust = 0.5),show.legend = FALSE,color = "white")+ylim(0,length(pos_proteins))+
geom_hline(yintercept=length(pos_proteins),linetype="dashed")+
facet_wrap(~Neff_Class,ncol=4)+
theme_minimal() + ggtitle("Validation Set - Top 1 Majority vote%")+
labs(x="",y="Number of Cases") +
theme(aspect.ratio=1,axis.ticks = element_line() , strip.text.x = element_text(color="black", size=16), axis.text.x = element_text(color="black", size=16, angle=45, hjust = 1.0),axis.text.y= element_text(size=14),axis.title.y = element_text(size=16),plot.title = element_text(hjust = 0.5,size=18,face="bold"),legend.text=element_text(size=16))
plot2= ggplot(plot_data_cor2, aes(x = reorder(Method,n,FUN=max), y = n, fill = Method)) + 
geom_col() + 
geom_label(aes(label = n),position = position_stack(vjust = 0.5),show.legend = FALSE,color = "white")+ylim(0,length(pos_proteins))+
geom_hline(yintercept=length(pos_proteins),linetype="dashed")+
facet_wrap(~Neff_Class,ncol=4)+
theme_minimal() + ggtitle("Validation Set - Top 5 Majority Vote")+
labs(x="",y="Number of Cases") +
theme(aspect.ratio=1,axis.ticks = element_line() , strip.text.x = element_text(color="black", size=16), axis.text.x = element_text(color="black", size=16, angle=45, hjust = 1.0),axis.text.y= element_text(size=14),axis.title.y = element_text(size=16),plot.title = element_text(hjust = 0.5,size=18,face="bold"),legend.text=element_text(size=16))
grid.arrange(plot1,plot2,nrow=2)
dev.off()



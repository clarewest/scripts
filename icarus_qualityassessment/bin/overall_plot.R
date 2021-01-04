library(ggplot2)
library(dplyr)

DATASET="CASP12"
C <- read.table(paste("../output/",DATASET,"/",DATASET,"_features.txt", sep="")) %>% mutate(Set=DATASET)
DATASET="SAINTCASP12"
S <-  read.table(paste("../output/",DATASET,"/",DATASET,"_features.txt", sep="")) %>% mutate(Set=DATASET)

a <- rbind(C, S)

a[is.na(a)]=0
Labels=c("Incorrect","Correct")
a[,51] = as.factor(Labels[as.integer(a$V49 >= 0.5) + 1])
colnames(a) = c("Target","Length","SCOP_Class","Beff","NumCon2","S2_Max","S2_Med","S2_Min","S2_Spr","Con_Max","Con_Med","Con_Min","Con_Spr","PPV_Max","PPV_Num","MA_Max","MA_Med","MA_Min","MA_Spr","MA_LEN","ET_Max","ET_Med","ET_Min","ET_Spr","PC_Max","PC_Med","PC_Min","PC_Spr","ProQ2D_Max","ProQ2D_Med","ProQ2D_Min","ProQ2D_Spr","RosCen_Max","RosCen_Med","RosCen_Min","RosCen_Spr","RosFA_Max","RosFA_Med","RosFA_Min","RosFA_Spr","ProQ3D_Max","ProQ3D_Med","ProQ3D_Min","ProQ3D_Spr","PCombC_Max","PCombC_Med","PCombC_Min","PCombC_Spr","TMScore","Set","Label")

a$PPV_Max=a$PPV_Max/100.0

lst <- read.table("../list_C.txt", col.names=c("Target", "Method"))
a <- merge(a, lst, by="Target")
ggplot(a, aes(x=Label, fill=Method)) + geom_bar() + facet_grid(~Set, space="free_x", scales="free_y") + theme_bw()
ggsave("~/pub_html/Clare/RFQA/labelcounts.pdf")


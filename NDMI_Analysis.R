######################################################################################
# THIS SCRIPT WILL ANALYSE THE NDMI DATA
#####################################################################################

# LOAD REQUIRED PACKAGES#
require("data.table")

# LOAD IN DATA

# set working directory
setwd("//icnas3.cc.ic.ac.uk/ms3017/CSVs/CSVs")


# you can make a function out of this
import.multiple.csv.files<-function(mypath,mypattern,...)
{
  tmp.list.1<-list.files(mypath, pattern=mypattern)
  tmp.list.2<-list(length=length(tmp.list.1))
  for (i in 1:length(tmp.list.1)){tmp.list.2[[i]]<-read.csv(tmp.list.1[i],...)}
  names(tmp.list.2)<-tmp.list.1
  tmp.list.2
}

csv.import<-import.multiple.csv.files("//icnas3.cc.ic.ac.uk/ms3017/CSVs/CSVs",".csv$",sep=",")


# CREATE SINGLE CSVS
Agriculture<- as.data.frame(csv.import[1])
Urban<-as.data.frame(csv.import[6])
Reserve<-as.data.frame(csv.import[5])
Basin<-as.data.frame(csv.import[2])
Fringe<-as.data.frame(csv.import[3])
Ravine<-as.data.frame(csv.import[4])

values_Agriculture<- c((mean(Agriculture$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change)-
                          (IQR(Agriculture$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change)*1.5)),(
                       mean(Agriculture$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change)+
                         (IQR(Agriculture$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change)*1.5)))

values_Reserve<- c((mean(Reserve$NDMI_Difference_Mangroves_in_Reserve.csv.Percent_Change)-
                          (IQR(Reserve$NDMI_Difference_Mangroves_in_Reserve.csv.Percent_Change)*1.5)),(
                            mean(Reserve$NDMI_Difference_Mangroves_in_Reserve.csv.Percent_Change)+
                              (IQR(Reserve$NDMI_Difference_Mangroves_in_Reserve.csv.Percent_Change)*1.5)))

values_Urban<- c((mean(Urban$NDMI_Difference_Mangroves_in_Urban.csv.Percent_Change)-
                    (IQR(Urban$NDMI_Difference_Mangroves_in_Urban.csv.Percent_Change)*1.5)),(
                      mean(Urban$NDMI_Difference_Mangroves_in_Urban.csv.Percent_Change)+
                        (IQR(Urban$NDMI_Difference_Mangroves_in_Urban.csv.Percent_Change)*1.5)))


values_Basin<- c((mean(Basin$NDMI_Difference_Mangroves_in_Basin.csv.Percent_Change)-
                    (IQR(Basin$NDMI_Difference_Mangroves_in_Basin.csv.Percent_Change)*1.5)),(
                      mean(Basin$NDMI_Difference_Mangroves_in_Basin.csv.Percent_Change)+
                        (IQR(Basin$NDMI_Difference_Mangroves_in_Basin.csv.Percent_Change)*1.5)))


values_Fringe<- c((mean(Fringe$NDMI_Difference_Mangroves_in_Fringe.csv.Percent_Change)-
                    (IQR(Fringe$NDMI_Difference_Mangroves_in_Fringe.csv.Percent_Change)*1.5)),(
                      mean(Fringe$NDMI_Difference_Mangroves_in_Fringe.csv.Percent_Change)+
                        (IQR(Fringe$NDMI_Difference_Mangroves_in_Fringe.csv.Percent_Change)*1.5)))

values_Ravine<- c((mean(Ravine$NDMI_Difference_Mangroves_in_Ravine.csv.Percent_Change)-
                    (IQR(Ravine$NDMI_Difference_Mangroves_in_Ravine.csv.Percent_Change)*1.5)),(
                      mean(Ravine$NDMI_Difference_Mangroves_in_Ravine.csv.Percent_Change)+
                        (IQR(Ravine$NDMI_Difference_Mangroves_in_Ravine.csv.Percent_Change)*1.5)))




values_Agriculture<- c((mean(Agriculture$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change)-
                          (sd(Agriculture$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change)*2)),(
                            mean(Agriculture$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change)+
                              (sd(Agriculture$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change)*2)))

values_Reserve<- c((mean(Reserve$NDMI_Difference_Mangroves_in_Reserve.csv.Percent_Change)-
                      (sd(Reserve$NDMI_Difference_Mangroves_in_Reserve.csv.Percent_Change)*2)),(
                        mean(Reserve$NDMI_Difference_Mangroves_in_Reserve.csv.Percent_Change)+
                          (sd(Reserve$NDMI_Difference_Mangroves_in_Reserve.csv.Percent_Change)*2)))

values_Urban<- c((mean(Urban$NDMI_Difference_Mangroves_in_Urban.csv.Percent_Change)-
                    (sd(Urban$NDMI_Difference_Mangroves_in_Urban.csv.Percent_Change)*2)),(
                      mean(Urban$NDMI_Difference_Mangroves_in_Urban.csv.Percent_Change)+
                        (sd(Urban$NDMI_Difference_Mangroves_in_Urban.csv.Percent_Change)*2)))


values_Basin<- c((mean(Basin$NDMI_Difference_Mangroves_in_Basin.csv.Percent_Change)-
                    (sd(Basin$NDMI_Difference_Mangroves_in_Basin.csv.Percent_Change)*2)),(
                      mean(Basin$NDMI_Difference_Mangroves_in_Basin.csv.Percent_Change)+
                        (sd(Basin$NDMI_Difference_Mangroves_in_Basin.csv.Percent_Change)*2)))


values_Fringe<- c((mean(Fringe$NDMI_Difference_Mangroves_in_Fringe.csv.Percent_Change)-
                     (sd(Fringe$NDMI_Difference_Mangroves_in_Fringe.csv.Percent_Change)*2)),(
                       mean(Fringe$NDMI_Difference_Mangroves_in_Fringe.csv.Percent_Change)+
                         (sd(Fringe$NDMI_Difference_Mangroves_in_Fringe.csv.Percent_Change)*2)))

values_Ravine<- c((mean(Ravine$NDMI_Difference_Mangroves_in_Ravine.csv.Percent_Change)-
                     (sd(Ravine$NDMI_Difference_Mangroves_in_Ravine.csv.Percent_Change)*2)),(
                       mean(Ravine$NDMI_Difference_Mangroves_in_Ravine.csv.Percent_Change)+
                         (sd(Ravine$NDMI_Difference_Mangroves_in_Ravine.csv.Percent_Change)*2)))


Agriculture.withoutoutliers<- Agriculture[Agriculture$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change > values_Agriculture[1] & Agriculture$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change < values_Agriculture[2],]

Urban.withoutoutliers<- Urban[Urban$NDMI_Difference_Mangroves_in_Urban.csv.Percent_Change > values_Urban[1] & Urban$NDMI_Difference_Mangroves_in_Urban.csv.Percent_Change < values_Urban[2],]

Reserve.withoutoutliers<- Reserve[Reserve$NDMI_Difference_Mangroves_in_Reserve.csv.Percent_Change > values_Reserve[1] & Reserve$NDMI_Difference_Mangroves_in_Reserve.csv.Percent_Change < values_Reserve[2],]

Basin.withoutoutliers<- Basin[Basin$NDMI_Difference_Mangroves_in_Basin.csv.Percent_Change > values_Basin[1] & Basin$NDMI_Difference_Mangroves_in_Basin.csv.Percent_Change < values_Basin[2],]

Fringe.withoutoutliers<- Fringe[Fringe$NDMI_Difference_Mangroves_in_Fringe.csv.Percent_Change > values_Fringe[1] & Fringe$NDMI_Difference_Mangroves_in_Fringe.csv.Percent_Change < values_Fringe[2],]

Ravine.withoutoutliers<- Ravine[Ravine$NDMI_Difference_Mangroves_in_Ravine.csv.Percent_Change > values_Ravine[1] & Ravine$NDMI_Difference_Mangroves_in_Ravine.csv.Percent_Change < values_Ravine[2],]





Agriculture.withoutoutliers_over15<- Agriculture.withoutoutliers[Agriculture.withoutoutliers$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change > 15,]

Urban.withoutoutliers_over15<- Urban.withoutoutliers[Urban.withoutoutliers$NDMI_Difference_Mangroves_in_Urban.csv.Percent_Change > 15,]

Reserve.withoutoutliers_over15<- Reserve.withoutoutliers[Reserve.withoutoutliers$NDMI_Difference_Mangroves_in_Reserve.csv.Percent_Change > 15,]

Basin.withoutoutliers_over15<- Basin.withoutoutliers[Basin.withoutoutliers$NDMI_Difference_Mangroves_in_Basin.csv.Percent_Change > 15,]

Fringe.withoutoutliers_over15<- Fringe.withoutoutliers[Fringe.withoutoutliers$NDMI_Difference_Mangroves_in_Fringe.csv.Percent_Change > 15,]

Ravine.withoutoutliers_over15<- Ravine.withoutoutliers[Ravine.withoutoutliers$NDMI_Difference_Mangroves_in_Ravine.csv.Percent_Change > 15,]









hist(Ravine.withoutoutliers$NDMI_Difference_Mangroves_in_Ravine.csv.Percent_Change)






Random_Sample_Agriculture<- replicate(100, sample(Agriculture.withoutoutliers$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change, size=1500, replace=FALSE))
Random_Sample_Reserve<- replicate(100, sample(Reserve.withoutoutliers$NDMI_Difference_Mangroves_in_Reserve.csv.Percent_Change, size=1500, replace=FALSE))
Random_Sample_Urban<- replicate(100, sample(Urban.withoutoutliers$NDMI_Difference_Mangroves_in_Urban.csv.Percent_Change, size=1500, replace=FALSE))
Random_Sample_Fringe<- replicate(100, sample(Fringe.withoutoutliers$NDMI_Difference_Mangroves_in_Fringe.csv.Percent_Change, size=1500, replace=FALSE))
Random_Sample_Basin<- replicate(100, sample(Basin.withoutoutliers$NDMI_Difference_Mangroves_in_Basin.csv.Percent_Change, size=1500, replace=FALSE))
Random_Sample_Ravine<- replicate(100, sample(Ravine.withoutoutliers$NDMI_Difference_Mangroves_in_Ravine.csv.Percent_Change, size=1500, replace=FALSE))


all_together<- c(Random_Sample_Basin, Random_Sample_Ravine, Random_Sample_Agriculture ,Random_Sample_Reserve, Random_Sample_Fringe ,Random_Sample_Urban)

valuestomask<- (sd(all_together*1.5)+ mean(all_together))    

Agriculture.withoutoutliers_NDMI<- Agriculture.withoutoutliers[Agriculture.withoutoutliers$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change > valuestomask,]
Reserve.withoutoutliers_NDMI<- Reserve.withoutoutliers[Reserve.withoutoutliers$NDMI_Difference_Mangroves_in_Reserve.csv.Percent_Change > valuestomask,]
Urban.withoutoutliers_NDMI<- Urban.withoutoutliers[Urban.withoutoutliers$NDMI_Difference_Mangroves_in_Urban.csv.Percent_Change > valuestomask,]
Fringe.withoutoutliers_NDMI<- Fringe.withoutoutliers[Fringe.withoutoutliers$NDMI_Difference_Mangroves_in_Fringe.csv.Percent_Change > valuestomask,]
Ravine.withoutoutliers_NDMI<- Ravine.withoutoutliers[Ravine.withoutoutliers$NDMI_Difference_Mangroves_in_Ravine.csv.Percent_Change > valuestomask,]
Basin.withoutoutliers_NDMI<- Basin.withoutoutliers[Basin.withoutoutliers$NDMI_Difference_Mangroves_in_Basin.csv.Percent_Change > valuestomask,]

Agriculture.withoutoutliers_percent<- Agriculture.withoutoutliers$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change[Agriculture.withoutoutliers$NDMI_Difference_Mangroves_in_Agriculture.csv.Percent_Change >15,]


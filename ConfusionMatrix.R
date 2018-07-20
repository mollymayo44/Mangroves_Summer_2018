#########################################################################
# ACCURACY ASSESSMENT
# THIS SCRIPT WILL MAKE CONFUSION MATRICES FOR ME!
###############################################################################

## LOAD REQUIRED PACKAGES
require("sp")
require("caret")
require("rgdal")

## LOAD DATA
DATA_2015<- as.data.frame(readOGR("/Volumes/EGG/AccuracyAssessment_wGOOGLE/AccuracyAssessment/D2015_randompoints.shp"))
DATA_2018<- as.data.frame(readOGR("/Volumes/EGG/AccuracyAssessment_wGOOGLE/AccuracyAssessment/J2018_randompoints.shp"))

## GET RID OF NA VALUES = 9
DATA_2015.without9<- DATA_2015
DATA_2018.without9<- DATA_2018

DATA_2015.without9$Google[DATA_2015.without9$Google==9]<- NA
DATA_2018.without9$Google[DATA_2018.without9$Google==9]<- NA

DATA_2015.without9$D2015_S<- as.factor(DATA_2015.without9$D2015_S)
DATA_2015.without9$Google<- as.factor(DATA_2015.without9$Google)
DATA_2015.without9.confusionmatrix<- confusionMatrix(data=DATA_2015.without9$D2015_S, reference=DATA_2015.without9$Google)


DATA_2018.without9$J2018_S<- as.factor(DATA_2018.without9$J2018_S)
DATA_2018.without9$Google<- as.factor(DATA_2018.without9$Google)
DATA_2018.without9.confusionmatrix<- confusionMatrix(data=DATA_2018.without9$J2018_S, reference=DATA_2018.without9$Google)

saveRDS(DATA_2015.without9.confusionmatrix, "/Volumes/EGG/AccuracyAssessment_wGOOGLE/ConfusionMatrix_2015.rds")
saveRDS(DATA_2018.without9.confusionmatrix, "/Volumes/EGG/AccuracyAssessment_wGOOGLE/ConfusionMatrix_2018.rds")


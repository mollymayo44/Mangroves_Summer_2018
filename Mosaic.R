##This Code will mosaic chosen sentinel and landsat 5 images

# Load Required Packages
require("RStoolbox")
require("raster")
require("rgdal")
require("sp")
require("rgeos")

#Landsat 5
Landsat_dirs<- "/Volumes/EGG/Landsat_5"
all_folders<- list.dirs(path=Landsat_dirs, full.names=TRUE)
all_folders<- all_folders[grepl(pattern="*Coregistered", all_folders)]

all_bands<-list.files(all_folders, pattern="*CoReg.tif$", full.names = FALSE)
new_folder_mosaicked<- paste0(substr(all_folders[1], start = 1,stop = 22),"/","Mosaicked_Landsat5","/")
#dir.create(new_folder_mosaicked)

first_bands<- seq(1,6,1)
second_bands<- seq(7,12,1)
first_indices<- seq(13,19,1)
second_indices<- seq(20,26,1)

counter<-1
for (i in first_bands){
  rasterofinterest_1<- raster(paste0(all_folders[1],"/",all_bands[i]))
  rasterofinterest_2<- raster(paste0(all_folders[2],"/",all_bands[second_bands[counter]]))
  namefor<- paste0(new_folder_mosaicked,"Landsat5","_",substr(all_bands[i],start=45,stop=59),"_mosaicked.tif",sep="")
  x<-list(rasterofinterest_1, rasterofinterest_2)
  names(x)[1:2]<-c("x","y")
  x$fun<-mean
  x$na.rm=TRUE
  y<-do.call(mosaic,x)
  writeRaster(y, filename = namefor, "GTiff")
  rm(x)
  rm(y)
  rm (rasterofinterest_1)
  rm(rasterofinterest_2)
  gc(reset = TRUE)
  counter= counter + 1
}

counter<-1

for (i in first_indices){
  rasterofinterest_1<- raster(paste0(all_folders[1],"/",all_bands[i]))
  rasterofinterest_2<- raster(paste0(all_folders[2],"/",all_bands[second_indices[counter]]))
  namefor<- paste0(new_folder_mosaicked,"Landsat5","_",substr(all_bands[i],start=24,stop=37),"_mosaicked.tif",sep="")
  x<-list(rasterofinterest_1, rasterofinterest_2)
  names(x)[1:2]<-c("x","y")
  x$fun<-mean
  x$na.rm=TRUE
  y<-do.call(mosaic,x)
  writeRaster(y, filename = namefor, "GTiff")
  rm(x)
  rm(y)
  rm (rasterofinterest_1)
  rm(rasterofinterest_2)
  gc(reset = TRUE)
  counter= counter + 1
}



#Sentinel_2
Sentinel_2<- "/Volumes/EGG/Sentinel_2"
all_folders<- list.dirs(path=Sentinel_2, full.names=TRUE)
all_folders<- all_folders[grepl(pattern="*Coregistered", all_folders)]

new_folder_mosaicked<- paste0(substr(all_folders[1], start = 1,stop = 23),"/","Mosaicked_Sentinel2","/")
#dir.create(new_folder_mosaicked)


foldersofinterest<- c(1,2,4,5,6,7,8,9)
#bandsofinterest<- c(1,3:12)
all_folders<- all_folders[foldersofinterest]

counter<-2
for (i in seq(1,7,2)){
  current_dir<- all_folders[i]
  current_dir_2<-all_folders[counter]
  new_path<- paste0(current_dir,"/",sep="")
  
  all_bands<-list.files(current_dir, pattern="*CoReg.tif$", full.names = FALSE)
  all_bands_2<-list.files(current_dir_2, pattern="*CoReg.tif$", full.names = FALSE)

  
  for (a in seq(1,5,1)){
    rasterofinterest_1<- raster(paste0(current_dir,"/",all_bands[a]))
    rasterofinterest_2<- raster(paste0(current_dir_2,"/",all_bands_2[a]))
    print(rasterofinterest_1)
    print(rasterofinterest_2)
    
    namefor<- paste0(new_folder_mosaicked,"Sentinel_2","_",substr(all_bands[a],start=1,stop=38),"_mosaicked.tif",sep="")
    
    x<-list(rasterofinterest_1, rasterofinterest_2)
    names(x)[1:2]<-c("x","y")
    x$fun<-mean
    x$na.rm=TRUE
    y<-do.call(mosaic,x)
    writeRaster(y, filename = namefor, "GTiff")
    rm(x)
    rm(y)
    rm (rasterofinterest_1)
    rm(rasterofinterest_2)
    gc(reset = TRUE)
  }
  for (b in seq(7,11,1)){
    rasterofinterest_1<- raster(paste0(current_dir,"/",all_bands[b]))
    rasterofinterest_2<- raster(paste0(current_dir_2,"/",all_bands_2[b]))
    print(rasterofinterest_1)
    print(rasterofinterest_2)
    
    namefor<- paste0(new_folder_mosaicked,"Sentinel_2","_",substr(all_bands[b],start=1,stop=30),"_mosaicked.tif",sep="")
    
    x<-list(rasterofinterest_1, rasterofinterest_2)
    names(x)[1:2]<-c("x","y")
    x$fun<-mean
    x$na.rm=TRUE
    y<-do.call(mosaic,x)
    writeRaster(y, filename = namefor, "GTiff")
    rm(x)
    rm(y)
    rm (rasterofinterest_1)
    rm(rasterofinterest_2)
    gc(reset = TRUE)
  }
  counter= counter + 2
}



## Load Required Packages
require("RStoolbox")
require("raster")
require("rgdal")
require("sp")
require("rgeos")

## Load SRTM
srtm_dirs<-"/Volumes/EGG/RADAR/SRTM/"
newstudy<- readOGR(paste0(srtm_dirs,"Smallest_StudyArea.shp"))
srtm_data<- raster(paste0(srtm_dirs, "Smallest_RS.tif"))

NMDWI_mask<- raster("/Volumes/EGG/Final_Land_MNDWI075/Final_Land_MNDWI075.tif")

## Load Landsat 8 + Landsat 5 Data

Landsat_dirs<- "/Volumes/EGG/Landsat_8"
all_folders<- list.dirs(path=Landsat_dirs, full.names=TRUE)

for (i in seq(3,14,1)){
  print(paste0("Working on folder", all_folders[i], sep= " "))
  
  current_dir<- all_folders[i]
  new_path<- paste0(current_dir,"/",sep="")
  
  new_folder_Resampled<- paste0(all_folders[i],"/", substr(all_folders[i],start=24,stop=45),"_Resampled","/")

  dir.create(new_folder_Resampled)
  
  all_bands<-list.files(current_dir, pattern="*rescaled.tif$", full.names = FALSE)
  all_bands2<-list.files(current_dir, pattern="LC0818*", full.names = FALSE)
  all_bands<- c(all_bands,all_bands2)
  all_bands<- grep(pattern=".tif$", all_bands, value=TRUE)

  
  print("Looping through bands 1:6")
  for (j in seq(1,6,1)){
    first<- raster(paste0(new_path,all_bands[j]))
    name_for<- all_bands[j]
    print (first)
    clipped<- crop(x=first, y=newstudy)
    resampled_general<- resample(x=clipped,y=srtm_data, method="bilinear")
    writeRaster( resampled_general, filename=paste0(new_folder_Resampled,substr(name_for,start=1,stop=49),"_20m", ".tif",sep=""),"GTiff")
    rm(clipped)
    rm(first)
    rm(resampled_general)
    gc()
  }
  print ("Looping through bands 7:13")
  for (k in seq(7,13,1)){
    first<- raster(paste0(new_path,all_bands[k]))
    name_for<- all_bands[k]
    print (first)
    clipped<- crop(x=first, y=newstudy)
    resampled_general<- resample(x=clipped,y=srtm_data, method="bilinear")
    writeRaster( resampled_general, filename=paste0(new_folder_Resampled,substr(name_for,start=1,stop=27),"_20m", ".tif",sep=""),"GTiff")
    rm(clipped)
    rm(first)
    rm(resampled_general)
    gc()
  }
  tmp_dir<- tempdir()
  unlink(tmp_dir, recursive = TRUE)
  gc(reset=TRUE)
}


##  Landsat 5 Data
Landsat_dirs<- "/Volumes/EGG/Landsat_5"
all_folders<- list.dirs(path=Landsat_dirs, full.names=TRUE)

for (i in all_folders[3:4]){
  print(paste0("Working on folder", i, sep= " "))
  
  
  current_dir<- i
  new_path<- paste0(current_dir,"/",sep="")
  
  new_folder_Resampled<- paste0(i,"/", substr(i,start=24,stop=45),"_Resampled","/")
  
  dir.create(new_folder_Resampled)
  
  all_bands<-list.files(current_dir, pattern="*rescaled.tif$", full.names = FALSE)
  all_bands2<-list.files(current_dir, pattern="LT0518*", full.names = FALSE)
  all_bands<- c(all_bands,all_bands2)
  all_bands<- grep(pattern=".tif$", all_bands, value=TRUE)
  
  print("Looping through bands 1:6")
  for (j in seq(1,6,1)){
    first<- raster(paste0(new_path,all_bands[j]))
    name_for<- all_bands[j]
    print (first)
    clipped<- crop(x=first, y=newstudy)
    resampled_general<- resample(x=clipped,y=srtm_data, method="bilinear")
    writeRaster( resampled_general, filename=paste0(new_folder_Resampled,substr(name_for,start=1,stop=49),"_20m", ".tif",sep=""),"GTiff")
  }
  print ("Looping through bands 7:13")
  for (k in seq(7,13,1)){
    first<- raster(paste0(new_path,all_bands[k]))
    name_for<- all_bands[k]
    print (first)
    clipped<- crop(x=first, y=newstudy)
    resampled_general<- resample(x=clipped,y=srtm_data, method="bilinear")
    writeRaster( resampled_general, filename=paste0(new_folder_Resampled,substr(name_for,start=1,stop=27),"_20m", ".tif",sep=""),"GTiff")
  }
  tmp_dir<- tempdir()
  unlink(tmp_dir, recursive = TRUE)
  gc(reset=TRUE)
}


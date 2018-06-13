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
new<- cor
## Load Landsat 8 Data

Landsat_dirs<- "/Volumes/EGG/Landsat_8"
all_folders<- list.dirs(path=Landsat_dirs, full.names=TRUE)
all_folders<- all_folders[grepl(pattern="*Resampled", all_folders)]

for (i in seq(1,12,1)){
  print(paste0("Working on folder", all_folders[i], sep= " "))
  
  current_dir<- all_folders[i]
  new_path<- paste0(current_dir,"/",sep="")
  
  new_folder_Coregistered<- paste0(substr(all_folders[i], start = 1,stop = 63),"/", substr(all_folders[i],start=24,stop=45),"_Coregistered","/")

  dir.create(new_folder_Coregistered)

  
  all_bands<-list.files(current_dir, pattern="*20m.tif$", full.names = FALSE)
  all_bands<- grep(pattern=".tif$", all_bands, value=TRUE)
  
  print("Looping through bands 1:13")
  for (j in seq(1,6,1)){
    first<- raster(paste0(new_path,all_bands[j]))
    name_for<- all_bands[j]
    print (first)
    coregistered_general<- coregisterImages(slave=first, master=srtm_data, nSamples=10,000)
    writeRaster(coregistered_general, filename=paste0(new_folder_Coregistered,substr(name_for,start=1,stop=49),"_20m_CoReg", ".tif",sep=""),"GTiff")
    rm(coregistered_general)
    rm(first)
    gc(reset=TRUE)
  }
  for (k in seq(7,13,1)){
    first<- raster(paste0(new_path,all_bands[k]))
    name_for<- all_bands[k]
    print (first)
    coregistered_general<- coregisterImages(slave=first, master=srtm_data, nSamples=10,000)
    writeRaster(coregistered_general, filename=paste0(new_folder_Coregistered,substr(name_for,start=1,stop=27),"_20m_CoReg", ".tif",sep=""),"GTiff")
    rm(coregistered_general)
    rm(first)
    gc(reset=TRUE)
  }
  tmp_dir<- tempdir()
  unlink(tmp_dir, recursive = TRUE)
  gc(reset=TRUE)
}



## Load Landsat 5 Data
Landsat_dirs<- "/Volumes/EGG/Landsat_5"
all_folders<- list.dirs(path=Landsat_dirs, full.names=TRUE)
all_folders<- all_folders[grepl(pattern="*Resampled", all_folders)]

for (i in seq(1,2,1)){
  print(paste0("Working on folder", all_folders[i], sep= " "))
  
  current_dir<- all_folders[i]
  new_path<- paste0(current_dir,"/",sep="")
  
  new_folder_Coregistered<- paste0(substr(all_folders[i], start = 1,stop = 63),"/", substr(all_folders[i],start=24,stop=45),"_Coregistered","/")
  
  dir.create(new_folder_Coregistered)
  
  
  all_bands<-list.files(current_dir, pattern="*20m.tif$", full.names = FALSE)
  all_bands<- grep(pattern=".tif$", all_bands, value=TRUE)
  
  print("Looping through bands 1:13")
  for (j in seq(1,6,1)){
    first<- raster(paste0(new_path,all_bands[j]))
    name_for<- all_bands[j]
    print (first)

    coregistered_general<- coregisterImages(slave=clipped, master=srtm_data, nSamples=10,000)
    rm(clipped)
    writeRaster(coregistered_general, filename=paste0(new_folder_Coregistered,substr(name_for,start=1,stop=49),"_20m_CoReg", ".tif",sep=""),"GTiff")
    rm(coregistered_general)
    rm(first)
    gc(reset=TRUE)
  }
  for (k in seq(7,13,1)){
    first<- raster(paste0(new_path,all_bands[k]))
    name_for<- all_bands[k]
    print (first)
    clipped<- crop(x=first, y=newstudy)
    coregistered_general<- coregisterImages(slave=clipped, master=srtm_data, nSamples=10,000)
    rm(clipped)
    writeRaster(coregistered_general, filename=paste0(new_folder_Coregistered,substr(name_for,start=1,stop=27),"_20m_CoReg", ".tif",sep=""),"GTiff")
    rm(coregistered_general)
    rm(first)
    gc(reset=TRUE)
  }
  tmp_dir<- tempdir()
  unlink(tmp_dir, recursive = TRUE)
  gc(reset=TRUE)
}




## Sentinel 2
dirs<- "/Volumes/EGG/Sentinel_2"
srtm_dirs<-"/Volumes/EGG/RADAR/SRTM/"
newstudy<- readOGR(paste0(srtm_dirs,"Smaller_Study_32.shp"))

all_folders<- list.dirs(path=dirs, full.names=TRUE)
# Search down to current subdirectory within each image folder 
all_folders<- all_folders[grepl(pattern="R20", all_folders)]



for (i in seq(17,23,1)){
  print(paste0("Working on folder", all_folders[i], sep= " "))
  
  current_dir<- all_folders[i]
  new_path<- paste0(current_dir,"/",sep="")
  
  if (i < 17){
    new_folder_Coregistered<- paste0(substr(all_folders[i], start = 1,stop = 58),"/", substr(all_folders[i],start=25,stop=58),"_Coregistered","/")
    dir.create(new_folder_Coregistered)
    
    all_bands<-list.files(new_path, pattern="*rescaled.tif$", full.names = FALSE)
    all_bands2<-list.files(current_dir, pattern="L1C_T*", full.names = FALSE)
    all_bands<- c(all_bands,all_bands2)
    all_bands<- grep(pattern=".tif$", all_bands, value=TRUE)
    
    for (j in seq(1,6,1)){
      first<- raster(paste0(new_path,all_bands[j]))
      name_for<- all_bands[j]
      print (first)
      clipped<- crop(x=first, y=newstudy)
      rm(first)
      gc(reset=TRUE)
      coregistered_general<- coregisterImages(slave=clipped, master=srtm_data, nSamples=10,000)
      rm(clipped)
      gc(reset=TRUE)
      writeRaster(coregistered_general, filename=paste0(new_folder_Coregistered,substr(name_for,start=1,stop=30),"_20m_CoReg", ".tif",sep=""),"GTiff")
      rm(coregistered_general)
      gc(reset=TRUE)
    }
    for (k in seq(7,12,1)){
      first<- raster(paste0(new_path,all_bands[k]))
      name_for<- all_bands[k]
      print (first)
      clipped<- crop(x=first, y=newstudy)
      rm(first)
      gc(reset=TRUE)
      coregistered_general<- coregisterImages(slave=clipped, master=srtm_data, nSamples=10,000)
      rm(clipped)
      gc(reset=TRUE)
      writeRaster(coregistered_general, filename=paste0(new_folder_Coregistered,substr(name_for,start=1,stop=38),"_20m_CoReg", ".tif",sep=""),"GTiff")
      rm(coregistered_general)
      gc(reset=TRUE)
    }
    rm (j)
    rm (k)
    tmp_dir<- tempdir()
    unlink(tmp_dir, recursive = TRUE)
    gc(reset=TRUE)
    gc(reset=TRUE)
     }
  if (i > 16){
    new_folder_Coregistered<- paste0(substr(all_folders[i], start = 1,stop = 107),"/", substr(all_folders[i],start=25,stop=64),"_Coregistered","/")
    dir.create(new_folder_Coregistered)
    
    all_bands<-list.files(current_dir, pattern="*rescaled.tif$", full.names = FALSE)
    all_bands2<-list.files(current_dir, pattern="S2A_USER_PRD_*", full.names = FALSE)
    all_bands<- c(all_bands,all_bands2)
    all_bands<- grep(pattern=".tif$", all_bands, value=TRUE)
    
    for (j in seq(1,6,1)){
      first<- raster(paste0(new_path,all_bands[j]))
      name_for<- all_bands[j]
      print (first)
      clipped<- crop(x=first, y=newstudy)
      rm(first)
      gc(reset=TRUE)
      coregistered_general<- coregisterImages(slave=clipped, master=srtm_data, nSamples=10,000)
      rm(clipped)
      gc(reset=TRUE)
      writeRaster(coregistered_general, filename=paste0(new_folder_Coregistered,substr(name_for,start=1,stop=63),"_20m_CoReg", ".tif",sep=""),"GTiff")
      rm(coregistered_general)
      gc(reset=TRUE)
    }
    for (k in seq(7,12,1)){
      first<- raster(paste0(new_path,all_bands[k]))
      name_for<- all_bands[k]
      print (first)
      clipped<- crop(x=first, y=newstudy)
      rm(first)
      gc(reset=TRUE)
      coregistered_general<- coregisterImages(slave=clipped, master=srtm_data, nSamples=10,000)
      rm(clipped)
      gc(reset=TRUE)
      writeRaster(coregistered_general, filename=paste0(new_folder_Coregistered,substr(name_for,start=1,stop=38),"_20m_CoReg", ".tif",sep=""),"GTiff")
      rm(coregistered_general)
      gc(reset=TRUE)
    }
    tmp_dir<- tempdir()
    unlink(tmp_dir, recursive = TRUE)
    gc(reset=TRUE)}
  tmp_dir<- tempdir()
  unlink(tmp_dir, recursive = TRUE)
  gc(reset=TRUE)
}


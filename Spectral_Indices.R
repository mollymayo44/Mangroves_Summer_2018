#######################################################
#This code will calculate all the spectral indices
######################################################

#Install Required Packages
remove.packages("RStoolbox")
install.packages("ddalpha")
install.packages("recipes")
install.packages("caret", dependencies = c("Depends", "Suggests"))
install.packages("broom", dependencies=TRUE)
install.packages("RStoolbox")
yyyinstall.packages("raster")
install.packages("rgdal")
install.packages("sp")
install.packages("rgeos")
install.packages("pbkrtest")
install.packages("randomForest")
install.packages("devtools")
require("devtools")
install.packages("prodlim")
install.packages("rgdal", type = "source", configure.args="--with-gdal-config=/Library/Frameworks/GDAL.framework/unix/bin/gdal-config --with-proj-include=/Library/Frameworks/PROJ.framework/unix/include --with-proj-lib=/Library/Frameworks/PROJ.framework/unix/lib --with-proj-share=/Library/Frameworks/PROJ.framework/unix/share/proj --with-proj-data=/Library/Frameworks/PROJ.framework/unix/share/proj --with-data-copy=yes")

devtools::install_github('topepo/caret/pkg/caret')

# Load Required Packagess
require("RStoolbox")
require("raster")
require("rgdal")
require("sp")
require("rgeos")
  
########################## ONLY RUN ONCE##################################

# Create Study area map <35 m

srtm_data_preclipped<- raster(paste0(srtm_dirs,"UTM_SRTM_Reclass.tif"))
study_area<- readOGR(paste0(srtm_dirs,"Study_Area_Poly.shp"))
srtm_mask<- crop(x=srtm_data_preclipped,y=study_area)
writeRaster(srtm_mask,paste0(srtm_dirs,"SRTM_Mask.tif"), "GTiff")


##########################################################################

# Load SRTM DATA
srtm_mask<- raster(paste0(srtm_dirs, "SRTM_UTM32_Mask.tif"))

#######################################################################
## These loops will process Landsat data
# It will iterate through all folders (all images)
# First bands are scaled by .0001 to be in the proper range for reflectance
# These bands are then saved for future use
# The quality band is then loaded and turned into a mask
# All bands are then masked by the quality band and stacked
# All Spectral Indices are then calculated

# Set TMP Directory



# Landsat 5,7
dirs<- "/Volumes/EGG/Landsat_5"
srtm_dirs<-"/Volumes/EGG/RADAR/SRTM/"
all_folders<- list.dirs(path=dirs, full.names=TRUE)
study_area<- readOGR(paste0(srtm_dirs,"StudyArea_32N.shp"))


for(i in seq(2,8,1)){
  print(paste0("Working on folder", i, sep= " "))
  current_dir<- all_folders[i]
  all_bands<-list.files(current_dir, pattern="*band", full.names = FALSE)
  all_bands<- grep(pattern=".tif$", all_bands, value=TRUE)
  new_path<- paste0(current_dir,"/",sep="")
  counter<- 1
  print("About to start Band Loop")
   for (j in seq(1,6,1)){
    print(paste0("Working on Band", counter, sep= " "))
    name<- all_bands[j]
    band_new<- raster(paste0(new_path,all_bands[j]))
    band_new[band_new > 16000 | band_new < -2000]<- NA 
    scaledband<- band_new * 0.0001
    writeRaster(scaledband, paste0(new_path,name,"_rescaled.tif"), "GTiff", overwrite=TRUE)
    counter = counter + 1
  }
  print ("Now Working on Quality Bands")
  quality_band<-list.files(path=new_path,pattern="*pixel_qa.tif$")
  quality_band_original <- raster(paste0(new_path,quality_band))
  quality_band_reclassified<- reclassify(quality_band_original, c(0,135,NA,135,137,1,137,223,NA,223,225,2))
  print ("Now Stacking Lord")
  rescaled_all<- list.files(path=new_path, pattern=("rescaled.tif$"), full.names = TRUE)
  rescaled_brick<- stack(rescaled_all)
  masked_brick<- mask(rescaled_brick,quality_band_reclassified, inverse=TRUE)
  print("Now cropping")
  cropped_stack<- crop(x=masked_brick,y=study_area)
  print ("Moving on to indices")
  all_indices<-spectralIndices(cropped_stack, blue = names(cropped_stack)[1], green= names(cropped_stack)[2],
                             red= names(cropped_stack)[3], nir =names(cropped_stack)[4],
                             swir2=names(cropped_stack)[5], swir3=names(cropped_stack)[6], 
                             indices = c("EVI","MNDWI", "NDVI","NDWI", "SAVI"))
  print("Writing Layer Files")
  for(layer in names(all_indices)){
    writeRaster(all_indices[[layer]], filename = file.path(new_path, paste0(substr(new_path, start=24,stop=45),"_",layer,".tif", sep="")), "GTiff")
  }
  print("Calculating AWEI")
  AWEI_part1<- subset(cropped_stack,1) +(subset(cropped_stack,2)* 2.5)
  AWEI_part_2<- 1.5 * (subset(cropped_stack,4)+ subset(cropped_stack,5)) - (0.25* subset(cropped_stack,6))
  AWEI<- AWEI_part1- AWEI_part_2
  writeRaster(AWEI, filename = file.path(new_path, paste0(substr(new_path, start=24,stop=45),"_AWEI",".tif",sep="")), "GTiff")
  print("Calculating NMDI")
  NDMI_part1<- subset(cropped_stack,4) - (subset(cropped_stack,5) - subset(cropped_stack,6))
  NDMI_part2<- subset(cropped_stack,4) + (subset(cropped_stack,5) - subset(cropped_stack,6))
  NDMI<- NDMI_part1/NDMI_part2
  writeRaster(NDMI, filename = file.path(new_path, paste0(substr(new_path, start=24,stop=45),"_NDMI",".tif",sep="")), "GTiff")
  tmp_dir<- tempdir()
  unlink(tmp_dir, recursive = TRUE)
}


# Landsat 8
dirs<- "/Volumes/EGG/Landsat_8"
srtm_dirs<-"/Volumes/EGG/RADAR/SRTM/"
all_folders<- list.dirs(path=dirs, full.names=TRUE)
study_area<- readOGR(paste0(srtm_dirs,"StudyArea_32N.shp"))

for(i in all_folders[13:20]){
  print(paste0("Working on folder", i, sep= " "))
  current_dir<- i
  all_bands<-list.files(current_dir, pattern="*band", full.names = FALSE)
  all_bands<- grep(pattern=".tif$", all_bands, value=TRUE)
  new_path<- paste0(current_dir,"/",sep="")
  counter<- 1
  print("About to start Band Loop")
  for (j in seq(2,7,1)){
    print(paste0("Working on Band", counter, sep= " "))
    name<- all_bands[j]
    band_new<- raster(paste0(new_path,all_bands[j]))
    band_new[band_new > 16000 | band_new < -2000]<- NA 
    scaledband<- band_new * 0.0001
    writeRaster(scaledband, paste0(new_path,name,"_rescaled.tif"), "GTiff", overwrite=TRUE)
    counter = counter + 1
  }
  print ("Now Working on Quality Bands")
  quality_band<-list.files(path=new_path,pattern="*pixel_qa.tif$")
  quality_band_original <- raster(paste0(new_path,quality_band))
  quality_band_reclassified<- reclassify(quality_band_original, c(0,903,NA,903,905,1,905,991,NA,991,993,2, 993,1353, NA))
  print ("Now Stacking Lord")
  rescaled_all<- list.files(path=new_path, pattern=("rescaled.tif$"), full.names = TRUE)
  rescaled_brick<- stack(rescaled_all)
  masked_brick<- mask(rescaled_brick,quality_band_reclassified, inverse=TRUE)
  print("Now cropping")
  cropped_stack<- crop(x=masked_brick,y=study_area)
  print ("Moving on to indices")
  all_indices<-spectralIndices(cropped_stack, blue = names(cropped_stack)[1], green= names(cropped_stack)[2],
                               red= names(cropped_stack)[3], nir =names(cropped_stack)[4],
                               swir2=names(cropped_stack)[5], swir3=names(cropped_stack)[6], 
                               indices = c("EVI","MNDWI", "NDVI","NDWI", "SAVI"))
  print("Writing Layer Files")
  for(layer in names(all_indices)){
    writeRaster(all_indices[[layer]], filename = file.path(new_path, paste0(substr(new_path, start=24,stop=45),"_", layer,".tif",sep="")), "GTiff")
  }
  print("Calculating AWEI")
  AWEI_part1<- subset(cropped_stack,1) +(subset(cropped_stack,2)* 2.5)
  AWEI_part_2<- 1.5 * (subset(cropped_stack,4)+ subset(cropped_stack,5)) - (0.25* subset(cropped_stack,6))
  AWEI<- AWEI_part1- AWEI_part_2
  writeRaster(AWEI, filename = file.path(new_path, paste0(substr(new_path, start=24,stop=45),"_AWEI",".tif",sep="")), "GTiff")
  print("Calculating NMDI")
  NDMI_part1<- subset(cropped_stack,4) - (subset(cropped_stack,5) - subset(cropped_stack,6))
  NDMI_part2<- subset(cropped_stack,4) + (subset(cropped_stack,5) - subset(cropped_stack,6))
  NDMI<- NDMI_part1/NDMI_part2
  writeRaster(NDMI, filename = file.path(new_path, paste0(substr(new_path, start=24,stop=45),"_NDMI",".tif",sep="")), "GTiff")
  tmp_dir<- tempdir()
  unlink(tmp_dir, recursive = TRUE)
}


# Sentinel-2
dirs<- "/Users/MollyRuth/Downloads/L1C_T32NNK_A003594_20171113T094800/"
srtm_dirs<-"/Users/MollyRuth/Downloads/StudyArea_32N/"
study_area<- readOGR(paste0(srtm_dirs,"StudyArea_32N.shp"))

all_folders<- list.dirs(path=dirs, full.names=TRUE)
# Search down to current subdirectory within each image folder 
all_folders<- all_folders[grepl(pattern="R20", all_folders)]
band_list<- as.numeric(list("1","2","3","9","7","8"))

for(i in all_folders[1]){
  print(paste0("Working on folder", i, sep= " "))
  current_dir<- i
  all_bands<-list.files(current_dir, pattern="*_B", full.names = FALSE)
  all_bands<- grep(pattern=".jp2$", all_bands, value=TRUE)
  new_path<- paste0(current_dir,"/",sep="")
  counter<- 1
  print("About to start Band Loop")
  for (j in band_list){
    print(paste0("Working on Band", counter, sep= " "))
    name<- all_bands[j]
    band_new<- readGDAL(paste0(new_path,all_bands[j]))
    band_new<- raster(band_new)
    band_new[band_new > 16000 | band_new < -2000]<- NA 
    scaledband<- band_new * 0.0001
    writeRaster(scaledband, paste0(new_path,name,"_rescaled.tif"), "GTiff", overwrite=TRUE)
    print(name)
    counter = counter + 1
  }
  print ("Now Working on Quality Bands")
  quality_band<-list.files(path=new_path,pattern="*SCL_20m.jp2$")
  quality_band_original <- readGDAL(paste0(new_path,quality_band))
  quality_band_original <- raster(quality_band_original)
  quality_band_reclassified<- reclassify(quality_band_original, c(0,8,NA, 7,11,1))
  print ("Now Stacking Lord")
  rescaled_all<- list.files(path=new_path, pattern=("rescaled.tif$"), full.names = TRUE)
  rescaled_brick<- stack(rescaled_all)
  masked_brick<- mask(rescaled_brick,quality_band_reclassified, inverse=TRUE)
  print("Now cropping")
  cropped_stack<- crop(x=masked_brick,y=study_area)
  print ("Moving on to indices")
  all_indices<-spectralIndices(cropped_stack, blue = names(cropped_stack)[1], green= names(cropped_stack)[2],
                               red= names(cropped_stack)[3], nir =names(cropped_stack)[6],
                               swir2=names(cropped_stack)[4], swir3=names(cropped_stack)[5], 
                               indices = c("EVI","MNDWI", "NDVI","NDWI", "SAVI"))
  print("Writing Layer Files")
  for(layer in names(all_indices)){
    writeRaster(all_indices[[layer]], filename = file.path(new_path, paste0(substr(new_path, start=24,stop=45),"_", layer,".tif",sep="")), "GTiff")
  }
  print("Calculating AWEI")
  AWEI_part1<- subset(cropped_stack,1) +(subset(cropped_stack,2)* 2.5)
  AWEI_part_2<- 1.5 * (subset(cropped_stack,6)+ subset(cropped_stack,4)) - (0.25* subset(cropped_stack,5))
  AWEI<- AWEI_part1- AWEI_part_2
  writeRaster(AWEI, filename = file.path(new_path, paste0(substr(new_path, start=28,stop=61),"_AWEI",".tif",sep="")), "GTiff")
  print("Calculating NMDI")
  NDMI_part1<- subset(cropped_stack,6) - (subset(cropped_stack,4) - subset(cropped_stack,5))
  NDMI_part2<- subset(cropped_stack,6) + (subset(cropped_stack,4) - subset(cropped_stack,5))
  NDMI<- NDMI_part1/NDMI_part2
  writeRaster(NDMI, filename = file.path(new_path, paste0(substr(new_path, start=28,stop=61),"_NDMI",".tif",sep="")), "GTiff")
  tmp_dir<- tempdir()
  unlink(tmp_dir, recursive = TRUE)
}



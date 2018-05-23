# Mangroves_Summer_2018
MRes Second Thesis

This code will process Landsat-5 L2, Landsat-7 L2, Landsat-8 L2, and Sentinel-2 2A imagery

For Landsat:
1) Load Bands
2) Eliminate pixels out of surface reflectance valid range
3) Rescale (0.001)
4) Reclassify Quality Band to create mask for high confidence cloud and medium confidence cloud shadow
5) Use Quality Mask on stacked bands
6) Use study area polygon to crop bands
7) Calculate AWEI, NDMI, EVI, MNDWI, NDVI,NDWI, SAVI 
8) Write all rasters

For Sentinel:
1) Load Bands
2) Eliminate pixels out of surface reflectance valid range
3) Rescale (.001)
4) Reclassify Quality Band to create mask for Medium probability, High probablity, and thin cirrus clouds
5) Use Quality Mask on stacked bands
6) Use study area polygon to crop bands
7) Calculate AWEI, NDMI, EVI, MNDWI, NDVI,NDWI, SAVI 
8) Write all rasters

# -------------------------------------------------------#
# code to download, mosaic, and organize DAYMET data
# --------------------------------------------------------#

# NOTE: the files are saved as .grd files (which is R’s native format). 
# You’d just have to switch the write raster code to save as .tif files instead. 


# libraries ----------------------- #
library(ncdf4)
library(daymetr)
library(raster)
library(rgdal)

#-------------------------------------------------------#
# this is the section you need to change -------------- #


# this is where you want the final products saved
outdir <- "C:/Users/maitlb/Documents/WI-trout-trends/data"   
# note, there will be a folder named temp that you can delete at the end

# Find the corresponding tile numbers of your study area
#tiles for state of wyoming/B's study area
tiles <- c(11925)


#years to loop over
years <- 2015

# data types to loop over
# dtype <- c("dayl", "prcp", "srad", "swe", "tmax", "tmin", "vp") 
??download_daymet_tiles # to identify the different climate variables
dtype <- c("tmax","tmin","prcp")  #this will only download max temp

# end of section you need to change -------------------#
#------------------------------------------------------#

#--------------------------------#
# the section below is automatic #
#--------------------------------#


# create a temp directory
if(dir.exists(paste0(outdir, "/temp")) == TRUE){
  print("Your outdir should not already have a temp directory in it. Please clean out the outdir and try again.")
}else{
  dir.create(paste0(outdir, "/temp"))
}

# create directories for the final products
for(i in 1:length(dtype)){
  if(dir.exists(paste0(outdir, "/",dtype[i])) == TRUE){
    print("Your outdir should not already have a directory with a data type in it. Please clean out the outdir and try again.")
  }else{
    dir.create(paste0(outdir, "/", dtype[i]))
  }
}

#download all the files

for(i in 1:length(tiles)){
  for(e in 1:length(years)){
    for(z in 1:length(dtype)){
      download_daymet_tiles(tiles=tiles[i], start=years[e], 
                            end=years[e], path=paste0(outdir, "/temp"), param=dtype[z], force=T)
    }
  }
}

# change nc files to tif files
nc2tif(paste0(outdir, "/temp"))

# mosaic the tiles, so we have one stack per year per data type
fls <- dir(paste0(outdir, "/temp"))
fls <- fls[grepl('.tif$',fls)==TRUE]

# big loop to do the masaicing across the state
for(i in 1:length(years)){
  for(e in 1:length(dtype)){
    print(paste0(i, " of ", length(years), " years"))
    print(paste0(e, " of ", length(dtype), " data types"))
    fls1 <- grepl(as.character(years[i]), fls)
    fls2 <- grepl(as.character(dtype[e]), fls)
    files <- fls[fls1==TRUE & fls2==TRUE]
    lst <- lapply(1:length(files), function(u){return(stack(paste(paste0(outdir, "/temp"),files[u],sep="/")))})
    moasicd <- do.call(merge, lst)
    writeRaster(moasicd, filename=paste(paste0(outdir, "/", dtype[e]), "/", dtype[e], "_", years[i], ".grd", sep=""), 
                format="raster", overwrite=TRUE, progress="text", bandorder='BSQ', datatype="FLT4S")
  }
}

#-----------------------------------------------------------#
# if everything worked, uncomment the next line and it will 
# delete everything in your temp folder
#-----------------------------------------------------------#
# file.remove(paste0(paste0(outdir, "/temp"), "/", dir(paste0(outdir, "/temp"))))
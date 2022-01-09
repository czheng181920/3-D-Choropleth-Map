# Read the shape file with the rgdal library.
library(rgdal)
library(rgeos)
library(mapproj)
library(tidyverse)
library(broom)

#load Ohio map shapefile
my_spdf <- readOGR(
  dsn= "ODOT_County_Boundaries/" ,
  layer="ODOT_County_Boundaries",
  verbose=FALSE
)

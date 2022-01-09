# clear workspace by doing this: rm(list = ls())
# Read the shape file with the rgdal library.
library(rgdal)
library(rgeos)
library(mapproj)
library(tidyverse)
library(broom)

#load Ohio map shapefile
my_spdf <- readOGR(
  dsn= "./ODOT_County_Boundaries" ,
  layer="ODOT_County_Boundaries",
  verbose=FALSE
)

# 'fortify' the data to get a dataframe format required by ggplot2 library(broom)
spdf_fortified <- tidy(my_spdf, region = "COUNTY_CD")
#the region is whatever variable in the dataset that displays the county names

# Plot empty map of Ohio to check if it worked library(ggplot2)
basicPlot = ggplot() +
  geom_polygon(data = spdf_fortified, aes( x = long, y = lat, group = group),
               fill="lightblue", color="white", size = 1) +
  theme_void()
basicPlot
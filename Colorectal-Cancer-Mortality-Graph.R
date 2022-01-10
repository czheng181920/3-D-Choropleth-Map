# clear workspace by doing this: rm(list = ls())
# Read the shape file with the rgdal library.
library(rgdal)
library(rgeos)
library(mapproj)
library(tidyverse)
library(broom)
library(dplyr)
library(viridis) #color scale


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

###########################################################
#load colorectal mortality data
Data = read.table(file = "./DATA/Colorectal Mortality USCS.txt",
                  header = TRUE, fill = TRUE)

#load ids
ODOTIDS = read.table(file = "./DATA/ODOT County Abbreviation Table.txt", 
                     header = TRUE, fill = TRUE)

#Merge the data and the ids
Data = Data %>%
  left_join(. , ODOTIDS, by=c("County"="County"))

#Merge the data and the choropleth map
spdf_fortified_data = spdf_fortified %>%
  left_join(. , Data, by=c("id"="id"))

basicPlot = ggplot() +
  geom_polygon(data = spdf_fortified_data, 
               aes(fill = Age_Adjusted_Rate, x = long, y = lat, group = group), 
               #fill = whatever value you want to represent the color
               color="gray30", size = 0.6) + 
  #get rid of x & y labels
  theme(axis.title=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        plot.caption = element_text(color = "gray35", size = 7))+
  scale_fill_viridis(breaks = c(5,10,15,20,25,30)) +
  labs(title="Colorectal Cancer Mortality (2014-2018)", y="Latitude", 
       x="Longitude", caption="Source: https://gis.cdc.gov/cancer/USCS/#/StateCounty/") +
  labs(subtitle="per 100,000 people")+
  labs(fill="Age-Adjusted \nRate") +
  scale_size(trans = "reverse")
basicPlot

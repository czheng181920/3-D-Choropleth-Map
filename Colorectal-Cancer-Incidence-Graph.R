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


######

#load colorectal cancer incidence data
Data = read.table(file = "./DATA/Colorectal Incidence USCS.txt",
                  header = TRUE, fill = TRUE)
#had some troubles loading in data
#make sure to organize the data so that there are no spaces, there are headers on the top and the left, and that it is saved as a txt file
#also edited county names so that it was strictly the county name and no “county” → this is to match up with the other files 
#for instance, “Van Wert County” became “Van-Wert” (no spaces and no county)

#load ids
ODOTIDS = read.table(file = "./DATA/ODOT County Abbreviation Table.txt", 
                     header = TRUE, fill = TRUE)

#Merge the data and the ids
Data = Data %>%
  left_join(. , ODOTIDS, by=c("County"="County"))

#Merge the data and the choropleth map
spdf_fortified_data = spdf_fortified %>%
  left_join(. , Data, by=c("id"="id"))


#plot final ggplot
basicPlot = ggplot() +
  geom_polygon(data = spdf_fortified_data, 
               aes(fill = Age_Adjusted_Rate, x = long, y = lat, group = group), 
               #fill = whatever value you want to represent the color
               color="gray30", size = 0.6) + 
  #get rid of x & y axis labels
  theme(axis.title=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        plot.caption = element_text(color = "gray35", size = 7))+
  scale_fill_viridis(breaks = c(35,40,45,50,55)) +
  labs(title="Colorectal Cancer Incidence (2014-2018)", y="Latitude", 
       x="Longitude", caption="Source: https://gis.cdc.gov/cancer/USCS/#/StateCounty/") +
  labs(subtitle="per 100,000 people")+
  labs(fill="Age-Adjusted \nRate") +
  scale_size(trans = "reverse") 

basicPlot


############################################################

#turn 2d into 3d

library(rayshader)
plot_gg(basicPlot, width = 4.3, height = 4)


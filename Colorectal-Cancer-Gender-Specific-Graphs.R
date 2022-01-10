# This file creates three graphs: 
#"Invasive Colorectal Cancer Incidence in Females" graph
#"Invasive Colorectal Cancer Incidence in Males" graph
#"Invasive Colorectal Cancer Incidence Sex Difference" graph

# Read the shape file with the rgdal library.
library(rgdal)
library(rgeos)
library(mapproj)
library(tidyverse)
library(broom)
library(viridis) #color scale
library(dplyr)

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

#load gender specific colorectal cancer data
Data = read.table(file = "./DATA/Colorectal, Invasive, sex.txt",
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

#plot final ggplots (each of the three different plots are below)

############ "Invasive Colorectal Cancer Incidence in Females" graph ######################
basicPlot = ggplot() +
  geom_polygon(data = spdf_fortified_data, 
               aes(fill = Female, x = long, y = lat, group = group), 
               #fill = whatever value you want to represent the color
               color="gray30", size = 0.6) + 
  theme(axis.title=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        plot.caption = element_text(color = "gray35", size = 7))+
  scale_fill_viridis(breaks = c(20,30,40,50,60,70,80), 
                     limits = c(24.3,74.5),
                     option="viridis") +
  labs(title="Invasive Colorectal Cancer Incidence in Females", y="Latitude", 
       x="Longitude", caption="Source: http://publicapps.odh.ohio.gov/EDW/DataCatalog") +
  labs(subtitle="per 100,000 people (2014-2018)")+
  labs(fill="Age-Adjusted \nRate") +
  scale_size(trans = "reverse") 

basicPlot


########### "Invasive Colorectal Cancer Incidence in Males" graph ######################
basicPlot = ggplot() +
  geom_polygon(data = spdf_fortified_data, 
               aes(fill = Male, x = long, y = lat, group = group), 
               #fill = whatever value you want to represent the color
               color="gray30", size = 0.6) + 
  theme(axis.title=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        plot.caption = element_text(color = "gray35", size = 7))+
  scale_fill_viridis(breaks = c(20,30,40,50,60,70,80), 
                     limits = c(24.3,74.5),
                     option="viridis") +
  labs(title="Invasive Colorectal Cancer Incidence in Males", y="Latitude", 
       x="Longitude", caption="Source: http://publicapps.odh.ohio.gov/EDW/DataCatalog") +
  labs(subtitle="per 100,000 people (2014-2018)")+
  labs(fill="Age-Adjusted \nRate") +
  scale_size(trans = "reverse") 

basicPlot

############"Invasive Colorectal Cancer Incidence Sex Difference" graph ######################
basicPlot = ggplot() +
  geom_polygon(data = spdf_fortified_data, 
               aes(fill = Difference, x = long, y = lat, group = group), 
               #fill = whatever value you want to represent the color
               color="gray30", size = 0.6) + 
  theme(axis.title=element_blank(),
        axis.text=element_blank(),
        axis.ticks=element_blank(),
        plot.caption = element_text(color = "gray35", size = 7))+
  scale_fill_viridis(breaks = c(-20,-10,0,10,20,30,40), 
                     #limits = c(-10,40), #wyandot?
                     option="plasma") +
  labs(title="Invasive Colorectal Cancer Incidence Sex Difference", y="Latitude", 
       x="Longitude", caption="Source: http://publicapps.odh.ohio.gov/EDW/DataCatalog") +
  labs(subtitle="per 100,000 people (2014-2018)")+
  labs(fill="Difference in \nAge-Adjusted \nRate (male- \nfemale)") +
  scale_size(trans = "reverse") 
basicPlot



############################################################

#turn 2d into 3d

library(rayshader)
plot_gg(basicPlot, width = 4.3, height = 4)
#install.packages(c('sf', 'nngeo', 'ggplot2', 'ggthemes'))

library(sf)
library(nngeo)
library(ggplot2)
library(ggthemes)

pts_asia = as.data.frame(read.csv('points2.csv', sep = ";"))

#list of points to map

#convert to an sf object and project
pts_asia <- st_as_sf(pts_asia, coords = c("X", "Y"), crs = 4326)

pts_asia <- st_transform(pts_asia, 4326)

#find the nearest n neighbors to each point
neighbors <- 5
nearest <- st_nn(pts_asia, pts_asia, k = neighbors+1, maxdist = 3500000) 

#connect each point to its nearest neighbors
connect_asia <- st_connect(pts_asia, pts_asia, nearest) %>% st_as_sf

#plot
ggplot() + theme_map() +
  geom_sf(data = connect_asia, color = 'white') +                                    #connection lines
  geom_sf(data = pts_asia, color = 'white', shape = 1, size = 3) +                   #points, formatted as open circles
  theme(panel.background = element_rect(fill = '#331E47', colour = '#331E47'))  #purple bg

#code by erdavis1
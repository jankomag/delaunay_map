#install.packages(c('sf', 'nngeo', 'ggplot2', 'ggthemes'))

library(sf)
library(nngeo)
library(ggplot2)
library(ggthemes)
 
pts = as.data.frame(read.csv('points.csv', sep = ";"))
new_points

#list of points to map
oldpts <- data.frame(y = c( 33.4,34.7,38.5,39.7,41.7, 39.1, 30.4, 33.7),
                  x = c( -112,-92.3,-121.4,-104.9,-72.6,-75.5, -84.2,-84.4))
oldpts$id <- seq.int(nrow(pts))

#convert to an sf object and project
pts <- st_as_sf(pts, coords = c("X", "Y"), crs = 4326)
pts <- st_transform(pts, 2163)

#find the nearest n neighbors to each point
neighbors <- 3
nearest <- st_nn(pts, pts, k = neighbors+1) 

#connect each point to its nearest neighbors
connect <- st_connect(pts, pts, nearest) %>% st_as_sf

#plot
ggplot() + theme_map() +
  geom_sf(data = connect, color = 'white') +                                    #connection lines
  geom_sf(data = pts, color = 'white', shape = 1, size = 3) +                   #points, formatted as open circles
  theme(panel.background = element_rect(fill = '#331E47', colour = '#331E47'))  #purple bg

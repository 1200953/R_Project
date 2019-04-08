library(shiny)
library(leaflet)

mdata <- read.csv("assignment-02-data-formated.csv") 

#load map
map <- leaflet::leaflet() %>%
  leaflet::addProviderTiles(providers$OpenStreetMap)

#aggregate data by location
agg = aggregate(mdata,
                by = list(mdata$location),
                FUN = mean)


#set diffrent color for each loaction
pal <- colorFactor('Spectral', mdata$location)


map <- leaflet(mdata) %>% addTiles() %>%
       addCircleMarkers(lng = ~longitude, lat = ~latitude, weight = 5, color = ~pal(location),
                        radius = 5, popup = ~as.character(value), label=~as.character(location)) 

map  # show the map



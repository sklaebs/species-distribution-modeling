data <- read.csv("data/cleanData.csv")

library(leaflet)
library(mapview)

leaflet() %>%
  addProviderTiles("Esri.WorldTopoMap") %>%
  addCircleMarkers(data = data, lat = ~decimalLatitude, 
                    lng = ~decimalLongitude, 
                   radius = 3, 
                   color = "red",
                   fillOpacity = 0.8) %>%
  addLegend(position = "topright", 
            title = "Species Occurences from GBIF", 
            labels = "Habronattus americanus",
            colors = "red",
            opacity = 8)

#save the map




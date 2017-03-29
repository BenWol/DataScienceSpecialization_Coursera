library(leaflet)
# map1
map_BCN <- leaflet() %>% addTiles() %>% addMarkers(lat=41.401652, lng=2.156690,popup = "Plaza del Sol in Gracia, BCN")
map_BCN

# map2
catalonia_flag <- makeIcon(
        iconUrl = "https://upload.wikimedia.org/wikipedia/commons/thumb/8/87/Estelada_blava.svg/255px-Estelada_blava.svg.png",
        iconWidth = 30, iconHeight = 30,
        iconAnchorX = 15, iconAnchorY = 15
)

map_sol <- data.frame(lat=41.401652, lng=2.156690)
map_sol %>% leaflet() %>% addTiles() %>% addMarkers(icon=catalonia_flag)
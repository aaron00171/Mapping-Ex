library(leaflet)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(lubridate)

# load necessary packages
library(geojsonio)

# transfrom .json file into a spatial polygons data frame
states <- 
  geojson_read( 
    x = "https://raw.githubusercontent.com/PublicaMundi/MappingAPI/master/data/geojson/us-states.json"
    , what = "sp"
  )


shinyServer( 
function(input, output, session) {

  labels <- reactive( { 
    
    states2 <- states
    hurr2 <- hurr[hurr$date == input$date,]
    states2$hurrican <-  hurr2$total[match(states$name, hurr2$state)]
    sprintf(
    "<strong>%s</strong><br/>%g sum of totalObligated",
    states2$name, states2$hurrican
  ) %>% lapply(htmltools::HTML) })
  
  statesdata <- reactive( {
  data.frame( hurr[hurr$date == input$date & hurr$state == input$state,3])
  })
  
  statesd <- reactive( 
  
  {
    
    states2 <- states
    hurr2 <- hurr[hurr$date == input$date,]
    
    states2$hurrican <-  hurr2$total[match(states$name, hurr2$state)]
    states2
  })
  
  output$map <-  renderLeaflet( {
  #  states2 <- statesd()
    states2 <-  states
    states2$hurrican <-  hurr$total[match(states2$name, hurr$state)]
    bins <- c(0, 10000, 50000, 1000000,Inf)
    
    pal <- colorBin("YlOrRd", domain = states2$hurrican, bins = bins)
    
    labels <- 
      sprintf(
        "<strong>%s</strong><br/>%g sum of totalObligated",
        states2$name, states2$hurrican
      ) %>% lapply(htmltools::HTML) 
  leaflet( states2) %>%
    setView(-96, 37.8, 4) %>%
    addProviderTiles("MapBox", options = providerTileOptions(
      id = "mapbox.light",
      accessToken = Sys.getenv('MAPBOX_ACCESS_TOKEN'))) %>%
    addPolygons(
      fillColor = ~pal(hurrican),
      weight = 2,
      opacity = 1,
      color = "white",
      dashArray = "3",
      fillOpacity = 0.7,
      highlight = highlightOptions(
        weight = 5,
        color = "#666",
        dashArray = "",
        fillOpacity = 0.7,
        bringToFront = TRUE),
      label = labels,
      labelOptions = labelOptions(
        style = list("font-weight" = "normal", padding = "3px 8px"),
        textsize = "15px",
        direction = "auto")) %>%
    addLegend(pal = pal, values = ~hurrican, opacity = 0.7, title = NULL,
              position = "bottomright")
  
  })
  output$tbl <- renderTable({
    statesdata()
  })


  
}
)

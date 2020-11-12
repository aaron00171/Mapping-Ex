library(leaflet)
library(shiny)
library(RColorBrewer)
library(scales)
library(lattice)
library(dplyr)
library(lubridate)
# library(readxl)
# data <- read_excel("C:/Users/superavis/Documents/TEMPUSE/063-superzip-example/hurricane.xlsx")
# data2 <- data %>% select(state,stateCode,totalObligated,obligatedDate)
# data2$date <- as.Date(substr(data2$obligatedDate,1,10))
# 
# data3 <- data2 %>%  group_by(date, state) %>% summarise(total  = sum(totalObligated,na.rm=T))
# save(data3, file = "hurricane.rdata")
load("C:/Users/aaron/OneDrive/Desktop/mapping/Mapping ex/hurricane.rdata")
hurr <- data3

# Choices for drop-downs
vars1 <- as.character(hurr$date)
vars2 <- as.character(unique(hurr$state))

shinyUI( 
navbarPage("Interactive map", id="nav",

  tabPanel("U.S states hurrican distribution shinyapp",
   
        sidebarLayout( 
          sidebarPanel( 
        h2("Hurrican distribution"),

        selectInput("date", "Date", vars1, selected  = vars1[1]),
        selectInput("state", "State", vars2, selected  = vars2[1]),
        h3("sum of total totalObligated"),
        tableOutput("tbl")),
        mainPanel( 
        
        leafletOutput("map")
        )
      )
)
)
)



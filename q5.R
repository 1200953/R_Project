library(shiny)
library(leaflet)
library(ggplot2) # load ggplot

# ui.R
# Define UI 
ui <- fluidPage( 
  
  # Application title
  headerPanel("coral bleaching"),
  
  # Setting input of side bars
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "coralType", label = "coral types: ",
        choices = c("blue corals", "hard corals", "sea fans", "sea pens", "soft corals" 
        ),
        selected = "blue corals"
      )
    ),
    
    # Show the caption 
    mainPanel(
      h3(textOutput("caption")),
      leafletOutput("myplot")
    )
  )
)


# server.R
#read data into R
mdata <- read.csv("assignment-02-data-formated.csv") 


server <- function(input, output) {
  
  # Return the formula text for printing as a caption
  output$caption <- reactiveText(function() {
    paste("The plot for ", input$coralType)
  })
  
  output$myplot <- renderLeaflet({
    
    #slice the data based on the coral type
    slicedData = subset(mdata,mdata$coralType %in% input$coralType)
    
    map <- leaflet::leaflet() %>%
      leaflet::addProviderTiles(providers$OpenStreetMap)
    
    #set diffrent color for each loaction
    pal <- colorFactor('Oranges', mdata$value)
    
    map <- leaflet(slicedData) %>% addTiles() %>%
      addCircleMarkers(lng = ~longitude, lat = ~latitude, weight = 5, color = ~pal(value), fill = TRUE,
                       radius = 5, popup = ~as.character(value) ,label=~as.character(location)) 
    
    #print the plot
    print(map) })
}


shinyApp(ui, server)
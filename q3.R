library(shiny)
library(datasets)
library(ggplot2) # load ggplot

# Define UI 
ui <- fluidPage( 
  
  # App title
  headerPanel("coral bleaching based on kind"),
  
  # Setting input options
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "coralType", "Please select the coral type: ",
        choices = c("blue corals", "hard corals", "sea fans", "sea pens", "soft corals" 
        ),
        selected = "blue corals"
      ),
      selectInput(
        inputId = "smoother", "Please select the smoother type: ",
        choices = c("lm", "glm", "gam", "loess", "auto"
        ),
        selected = "auto")
    ),
    
    # Show the caption and plot of the requested variable 
    mainPanel(
      h3(textOutput("caption")),
      plotOutput("myplot")
    )
  )
)

#read data into R
mdata <- read.csv("assignment-02-data-formated.csv") 
mdata

server <- function(input, output) {
  
# Return the formula text for printing as a caption
output$caption <- reactiveText(function() {
  paste("The plot for ", input$coralType)
})
  
output$myplot <- renderPlot({
  #slice the data based on the coral type
  slicedData = subset(mdata,mdata$coralType %in% input$coralType)
  #plotting the data based on the input variable   
  n <- ggplot(slicedData, aes(year, value,  size = value, color = site)) + 
    geom_point(aes(color = coralType)) + theme_light()
    
  #rotating x axis lable to make it clearer to read 
  p <- n+theme(axis.text.x = element_text(angle = 90))
  
  #set the coral type 
  p1 <- p+facet_grid((coralType=input$coralType)~~reorder(location, +latitude))

  #set the smoother type
  p2 <- p1 + geom_smooth(method = input$smoother, size=1, color="darkblue")
  
  #print the plot
  print(p2) })
}

shinyApp(ui, server)

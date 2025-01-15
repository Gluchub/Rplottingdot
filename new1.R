# Load the shiny package
library(shiny)

# Define the user interface (UI)
ui <- fluidPage(
  # Title of the application
  titlePanel("Simple Histogram App"),
  
  # Sidebar layout
  sidebarLayout(
    sidebarPanel(
      # Slider input to choose the number of bins
      sliderInput("bins", 
                  "Number of bins:", 
                  min = 1, 
                  max = 50, 
                  value = 30)
    ),
    
    # Main panel to display the plot
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# Define the server logic
server <- function(input, output) {
  
  # Render the plot based on input$bins
  output$distPlot <- renderPlot({
    # Generate 500 random numbers
    x <- rnorm(500)
    
    # Create the histogram with the specified number of bins
    hist(x, 
         breaks = input$bins, 
         col = "skyblue", 
         border = "white", 
         main = "Histogram of Random Numbers", 
         xlab = "Value")
  })
}

# Run the application
shinyApp(ui = ui, server = server)

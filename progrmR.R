# Load required libraries
library(shiny)
library(readxl)    # For reading Excel files
library(ggplot2)   # For creating plots
library(shinythemes)

# Define the UI
ui <- fluidPage(
  theme = shinytheme("cerulean"),  # Add a clean, professional theme
  tags$head(
    tags$style(HTML("
      #dataPlot {
        margin-top: 50px;            /* Move the plot lower */
        height: calc(100vh - 200px); /* Take full available height */
        width: 100vw;                /* Full width */
      }
      .well {
        background-color: #f8f9fa;  /* Light gray background for sidebar */
        border-radius: 8px;
        padding: 15px;
      }
      .navbar {
        margin-bottom: 20px;        /* Space below navbar */
      }
    "))
  ),
  navbarPage(
    title = "Interactive Data Visualization",
    tabPanel(
      "Upload & Visualize",
      sidebarLayout(
        sidebarPanel(
          class = "well",
          fileInput("file", "Upload Excel File:", 
                    accept = c(".xlsx", ".xls")),
          uiOutput("xColumn"),
          uiOutput("yColumn"),
          radioButtons("plotType", "Select Plot Type:",
                       choices = c("Scatterplot", "Histogram"), 
                       inline = TRUE)
        ),
        mainPanel(
          tableOutput("dataTable"),
          plotOutput("dataPlot")  # Only one declaration of plotOutput
        )
      )
    )
  )
)

# Define the server logic
server <- function(input, output, session) {
  # Reactive value to store uploaded data
  data <- reactive({
    req(input$file)  # Ensure a file is uploaded
    tryCatch({
      read_excel(input$file$datapath)  # Read Excel data
    }, error = function(e) {
      showNotification("Error reading the Excel file. Please check the format.", type = "error")
      NULL
    })
  })
  
  # Generate UI for column selection dynamically
  output$xColumn <- renderUI({
    req(data())  # Ensure data is loaded
    selectInput("xCol", "Select X-axis Column:", 
                choices = names(data()), selected = names(data())[1])
  })
  
  output$yColumn <- renderUI({
    req(data())  # Ensure data is loaded
    if (input$plotType == "Scatterplot") {
      selectInput("yCol", "Select Y-axis Column:", 
                  choices = names(data()), selected = names(data())[2])
    }
  })
  
  # Display the uploaded data as a table
  output$dataTable <- renderTable({
    req(data())  # Ensure data is loaded
    head(data(), 10)  # Show first 10 rows
  })
  
  # Generate the plot based on user input
  output$dataPlot <- renderPlot({
    req(data(), input$xCol, input$plotType)  # Ensure data and inputs are available
    
    # Validate inputs for scatterplot
    if (input$plotType == "Scatterplot") {
      req(input$yCol)  # Ensure Y column is selected
    }
    
    # Generate plot based on user choices
    tryCatch({
      if (input$plotType == "Scatterplot") {
        ggplot(data(), aes_string(x = input$xCol, y = input$yCol)) +
          geom_point(color = "blue") +
          labs(title = "Scatterplot", x = input$xCol, y = input$yCol) +
          theme_minimal()
      } else if (input$plotType == "Histogram") {
        ggplot(data(), aes_string(x = input$xCol)) +
          geom_histogram(fill = "skyblue", bins = 30) +
          labs(title = "Histogram", x = input$xCol, y = "Frequency") +
          theme_minimal()
      }
    }, error = function(e) {
      showNotification("Error generating the plot. Please check your data and selections.", type = "error")
      NULL
    })
  })
}

# Run the application
shinyApp(ui = ui, server = server)

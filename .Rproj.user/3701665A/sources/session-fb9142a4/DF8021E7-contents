library(shiny)

if (interactive()) {
  
  library(shiny.semantic)
  
  # basic example
  shinyApp(
    ui = fluidPage(
      box(
        title = "Diamonds",
        solidHeader = TRUE,
        selectInput("cut", "Cut", levels(diamonds$cut)),
        selectInput("color", "Color", levels(diamonds$color)),
        selectInput("clarity", "Clarity", levels(diamonds$clarity)),
        actionButton("update", "Update Plot")
      ),
      box(
        title = "Plot",
        solidHeader = TRUE,
        textOutput("title"),
        plotOutput("plot")
      )
    ),

    server <- function(input, output, session) {
      output$plot <- renderPlot({
        data <- filter(diamonds,
                       cut == input$cut,
                       color == input$color,
                       clarity == input$clarity)
        
        ggplot(data, aes(carat, price)) +
          geom_point(color = "#605CA8", alpha = 0.5) +
          geom_smooth(method = lm, color = "#605CA8")
      })
      
      output$title <- renderText({
        input$update # just here to trigger the function
        
        sprintf("Cut: %s, Color: %s, Clarity: %s",
                input$cut,
                input$color,
                input$clarity)
      })
    } 
  )
}


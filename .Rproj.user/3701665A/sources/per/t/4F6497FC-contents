##
## CETM46 Data Science Product Prototype
## By Chan Chun Tak
## 
## Date: 22 Jan 2023
##
## Application: House Price Prediction Platform
##

library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(readr)
library(caret)
library(rpart)
library(tidyr)
library(tidyverse)
library(googleVis)
library(leaflet)
library(maps)
library(jpeg)
library(plotly)
library(DT)

ds <- read.csv("assign_data.csv")
str(ds)

server <- function(input, output) {
  #output$distrint_ <- renderText
  
  output$distrint_ <- renderText({
    sprintf("xxx", input$y)
  })
}

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Introduction", tabName = "intro", icon = icon("list-alt")),
    menuItem("Predict", tabName = "myPrediction", icon = icon("robot", class = NULL, lib = "font-awesome"))
    
  )
)

body <- dashboardBody(
  tabItems(
    # First tabItem 
    tabItem(tabName = "myPrediction",
      fluidRow(
        box(
          title = "Hong Kong Distrint",
          selectInput(inputId='distrint_', label='Distrint', c("Hong Konge" = "HK", "Kowloon" = "KLN", "New Territories" = "NT"))
        ),
        
      ),
      fluidRow(
        box(
          title = "Size Category",
            selectInput(inputId='category_', label='Category', c("A"="A", "B"="B", "C"="C", "D"="D","E"="E"))
          )
      )
    )
  )
)
  


# Define server logic required to draw a histogram
server <- function(input, output) {

    output$distPlot <- renderPlot({
        # generate bins based on input$bins from ui.R
        x    <- faithful[, 2]
        bins <- seq(min(x), max(x), length.out = input$bins + 1)

        # draw the histogram with the specified number of bins
        hist(x, breaks = bins, col = 'darkgray', border = 'white',
             xlab = 'Waiting time to next eruption (in mins)',
             main = 'Histogram of waiting times')
    })
}

ui <- dashboardPage(header = dashboardHeader(title = "Chan Chun Tak - House Price Prediction App", titleWidth = 350),
                    sidebar = sidebar,
                    body = body, skin = "yellow"
)

# Run the application 
shinyApp(ui, server)

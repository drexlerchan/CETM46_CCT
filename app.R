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
}

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Introduction", tabName = "intro", icon = icon("list-alt"))
    #menuItem("Predict", tabName = "myPrediction", icon = icon("robot", class = NULL, lib = "font-awesome"))
    
  )
)

body <- dashboardBody(
  tabItems(
    #Zero tabItem
    
    tabItem(tabName = 'intro',  #intro 
      fluidRow(
        box(
          background = 'light-blue',
          h2('House Price Prediction Platform'),
                
          tags$p("This is the wine application for the CETM46 Assignment Two written by Chan Chun Tak."), 
          tags$p(""), 
          tags$p("Submited on 23th Jan 2023"),
          width = 48)
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

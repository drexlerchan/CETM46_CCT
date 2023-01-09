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

    output$predict_price <- renderText({
      #if (input$category_ = 'A') {
       # print("hi")
      # }
      input$category_
      #input$distrint_
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
          selectInput('distrint_', label='Distrint', 
            choices = list("Hong Kong" = "HK", "Kowloon" = "KLN", "New Territories" = "NT")
          )
        ),
      ),
      fluidRow(
        box(
          tags$strong("Size Category"),
          tags$p("A = Below 40 Meter square"),
          tags$p("B = 40 to 69.9 Meter Square"),
          tags$p("C = 70 to 99.9 Meter Square"),
          tags$p("D = 100 to 159.9 Meter Square"),
          tags$p("Over 160 Meter Square"),
          selectInput(inputId='category_', label='', 
                      c("A"="A", "B"="B", "C"="C", "D"="D","E"="E")
          )
        )
      ),
      
      fluidRow(
        box(
          textOutput("predict_price")
        )
      )

    )
  )
)
  




ui <- dashboardPage(header = dashboardHeader(title = "Chan Chun Tak - House Price Prediction App", titleWidth = 350),
                    sidebar = sidebar,
                    body = body, skin = "yellow"
)

# Run the application 
shinyApp(ui, server)

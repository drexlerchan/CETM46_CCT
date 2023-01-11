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
head(ds)

server <- function(input, output) {

    output$predict_price <- renderPrint({

      dist_ = input$distrint_
      cate_ = input$category_
      
      ds2 <- ds
      if (dist_ =='HK'){
        fit_1 <- lm(HK ~ Category, data = ds2)  
      }else if (dist_ =='KLN'){
        fit_1 <- lm(KLN ~ Category, data = ds2)  
      }else{
        fit_1 <- lm(NT ~ Category, data = ds2)  
      }
      #summary(fit_1)
      #if (cate_ =='A'){
        #ds2 <- filter(ds2,Category == cate_ )
      #  fit_1 <- lm(HK ~ Category, data = ds2)
        #summary(fit_1)
      #   print("A")
      # }else if (cate_ =='B'){
      #   print("B")
      # }else if (cate_ =='C'){
      #   print("C")
      # }else if (cate_ =='D'){
      #   print("D")
      # }else if (cate_ =='E'){
      #   print("E")
      #}
      #print(cate_)
      aa <- predict(fit_1,newdata = ds2)
      bb <- data.frame(Category=cate_)
      cc <- predict(fit_1,bb)
      cat(cc)
      #ds2 <- filter(ds2,Category == cate_ ) #req(input$category_))
      #head(ds2)
      #fit_1 <- lm(HK ~ Category, data = ds2)
      #summary(fit_1)
    })
    
    output$linearplot <- renderPlotly({
      dist2_ = input$distrint2_
      cate2_ = input$category2_
      
      ds3 <- ds
      if (dist2_ =='HK'){
        ggplt <- ggplot(data = ds3, aes(x = Year, y = HK,colore=Category))
      }else if (dist2_ =='KLN'){
        ggplt <-ggplot(data = ds3, aes(x = Year, y = KLN,colore=Category))  
      }else{
        ggplt <-ggplot(data = ds3, aes(x = Year, y = NT,colore=Category))
      }
      
      ggplt+geom_point() +
        stat_smooth(method = "lm", se = FALSE,  aes(color=Category)) + 
        ggtitle("Linear Model Fitted to Data")
        #ggtitle("Linear Model Fitted to Data")
      
    })

    output$datatable <- DT::renderDataTable(
      DT::datatable(ds)
    )
} # end of server side

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem("Introduction", tabName = "intro", icon = icon("list-alt")),
    menuItem("Predict", tabName = "myPrediction", icon = icon("robot", class = NULL, lib = "font-awesome")),
    menuItem("Histogram", tabName = "histdata" , icon = icon("th")),
    menuItem("DataTable", tabName = "pricedata", icon = icon("download"))
    
  )
)

body <- dashboardBody(

  tabItems(
    # First tabItem 
    tabItem(tabName = "myPrediction",

      fluidRow(width = 10,
        box(
          title = "Hong Kong Distrint",
          selectInput('distrint_', label='Distrint', 
            choices = list("Hong Kong" = "HK", "Kowloon" = "KLN", "New Territories" = "NT")
          )
        ),
        h3("Prediction Price: HKD"),
        h3(textOutput("predict_price"))
      ),
      fluidRow(
        box(
          tags$strong("Size Category"),
          tags$p("A = Below 40 Meter square"),
          tags$p("B = 40 to 69.9 Meter Square"),
          tags$p("C = 70 to 99.9 Meter Square"),
          tags$p("D = 100 to 159.9 Meter Square"),
          tags$p("E = Over 160 Meter Square"),
          selectInput(inputId='category_', label='', 
            c("A"="A", "B"="B", "C"="C", "D"="D","E"="E")
          )
        )
      )#,
      #fluidRow(
      #  box(
      #    h3("Prediction Price: HKD"),
      #    h3(textOutput("predict_price"))
      #  )
      #)
    ), #end tabItem="myPrediction"
    
    tabItem(tabName = "histdata",
      titlePanel("History Data for Hong Kong Private property price in meter "),
            
      sidebarLayout(
              
        sidebarPanel(
          fluidRow( 
                   box(width=300,
                     title = "Hong Kong Distrint",
                     selectInput('distrint2_', label='Distrint2', 
                                 choices = list("Hong Kong" = "HK", "Kowloon" = "KLN", "New Territories" = "NT")
                     )
                   )#,
                   #h3("Prediction Price: HKD"),
                   #h3(textOutput("predict_price"))
          ),
          fluidRow(
            box(width=300,
              tags$strong("Size Category"),
              tags$p("A = Below 40 Meter square"),
              tags$p("B = 40 to 69.9 Meter Square"),
              tags$p("C = 70 to 99.9 Meter Square"),
              tags$p("D = 100 to 159.9 Meter Square"),
              tags$p("E = Over 160 Meter Square"),
              selectInput(inputId='category2_', label='', 
                          c("A"="A", "B"="B", "C"="C", "D"="D","E"="E")
              )
            )
          )
        ),
              
        mainPanel(
          plotlyOutput("linearplot")
        )
      )  
    ), # end or histdata
    
    tabItem(tabName = "pricedata",
      fluidRow(
        h1('House Price History Data'),
        box( width = 8,
          DT::dataTableOutput('datatable'),
        )
      )
    ) # end tabName = "pricedata"
  )
  
  
)


ui <- dashboardPage(header = dashboardHeader(title = "Chan Chun Tak - House Price Prediction App", titleWidth = 350),
                    sidebar = sidebar,
                    body = body, skin = "yellow"
)

# Run the application 
shinyApp(ui, server)

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
library(scales)

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

      aa <- predict(fit_1,newdata = ds2)
      bb <- data.frame(Category=cate_)
      cc <- predict(fit_1,bb)
      cat(cc)

    })
    
    output$linearplot <- renderPlotly({
      dist2_ = input$distrint2_
      cate2_ = input$category2_
      
      ds3 <- ds
      if (dist2_ =='HK'){
        ggplt <- ggplot(data = ds3, aes(x = Year, y = HK,colore=Category)) +
          labs(y= "Hong Kong", x = "Year")
      }else if (dist2_ =='KLN'){
        ggplt <-ggplot(data = ds3, aes(x = Year, y = KLN,colore=Category)) +
          labs(y= "Kowloon", x = "Year")
      }else{
        ggplt <-ggplot(data = ds3, aes(x = Year, y = NT,colore=Category)) +
          labs(y= "New Territories", x = "Year")
      }
      
      ggplt+geom_point() +
        scale_y_continuous(labels = comma) +
        stat_smooth(method = "lm", se = FALSE,  aes(color=Category)) + 
        ggtitle("Linear Model Fitted to Data")

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
  #tabItems(
    #Zero tabItem
    
    tabItem(tabName = 'intro',  #intro 
      fluidRow(
        box(
          background = 'light-blue',
          h2('Hong Kong House Price Prediction Platform'),
                
          tags$p("This is the wine application for the CETM46 Assignment 2 written by Chan Chun Tak."), 
          tags$p(""), 
          tags$p("Submited on 23rd Jan 2022"),
          tags$p(),
          tags$p("The dataset for this product was retrieved from Hong Kong Government and the data between Jan 1999 to Dec 2021."), 
          tags$p("The dataset contains Year, Month, Category, HK, KLN and NT. For details, please refer to the URL below:"),
          tags$a(href = "https://Data.gov.hk", style="color:yellow", "Hong Kong Dataset."),
          tags$p(), 
          tags$p("Thank you."),
          tags$p("---"),
          tags$p("Chan Chun Tak"),
          width = 48
        )
      )
    ),
    
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
      )
    ), #end tabItem="myPrediction"
    
    tabItem(tabName = "histdata",
      titlePanel("History Data for Hong Kong Private property price in Meter Square"),
            
      sidebarLayout(
        sidebarPanel(
          fluidRow( 
            box(width=300,
              title = "Hong Kong Distrint",
              selectInput('distrint2_', label='Distrint2', 
               choices = list("Hong Kong" = "HK", "Kowloon" = "KLN", "New Territories" = "NT")
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


ui <- dashboardPage(header = dashboardHeader(title = "Chan Chun Tak 219575441 - House Price Prediction App", titleWidth = 550),
                    sidebar = sidebar,
                    body = body, skin = "yellow"
)

# Run the application 
shinyApp(ui, server)

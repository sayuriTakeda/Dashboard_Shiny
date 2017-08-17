library(shiny)
library(shinydashboard)

ui <- dashboardPage(
  dashboardHeader(title = "Teste",dropdownMenu(type = "notifications",
                                               icon = icon("question"),
                                               messageItem(
                                                 from = "Sales Dept",
                                                 message = "Sales are steady this month.",
                                                 icon = icon("")
                                               ),
                                               messageItem(
                                                 from = "Sales Dept",
                                                 message = "Sales are steady this month.",
                                                 icon = icon("")
                                               ),
                                               messageItem(
                                                 from = "Sales Dept",
                                                 message = "Sales are steady this month.",
                                                 icon = icon("")
                                               )
  )),
  dashboardSidebar(
    sidebarMenu(
      menuItem("menuIt1", tabName = "graph", icon = icon("dashboard"),
               badgeLabel = "new", badgeColor = "green"),
      menuItem("menuIt2", tabName = "Tabelas", icon = icon("th"))
    )
  ),
  dashboardBody(
    numericInput('clusters', 'Cluster count', 3,
                 min = 1, max = 9),
    tabItems(
      tabItem(tabName = "graph", 
              fluidRow(
                infoBoxOutput("progressBox")),
              fluidRow(
              box(title = "title",
                  solidHeader = TRUE,
                  collapsible = TRUE,
                  status = "primary", 
                  plotOutput("plot1",height = 250))),
              fluidRow(
              box(title = "Inputs", 
                  background = "blue",
                  plotOutput("plot2",height = 250)))
        ),
    
     tabItem(tabName = "Tabelas",h2("botar tabelas aqui"),
             fluidRow(
               box(
                 title = "Title 6",width = 4, background = "maroon",
                 "A box with a solid maroon background"
               )
             ))
  )
))

server <- function(input, output, session) {
  output$plot1 <- renderPlot({plot(iris$Sepal.Length,iris$Sepal.Width)})
  output$plot2 <- renderPlot({plot(iris$Petal.Length,iris$Petal.Width)})
  output$progressBox <- renderInfoBox({infoBox("Progress",paste0(25+input$clusters,"%"),icon = icon("list"),color = "purple")})
}

shinyApp(ui, server)
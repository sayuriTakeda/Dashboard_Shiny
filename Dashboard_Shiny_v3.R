library(shiny)
library(shinydashboard)
library(ggplot2)
library(plotly)
library(dplyr)
library(highcharter)

base <- read.csv2("/home/sayuritakeda/apriori.csv", 
                  fileEncoding = "ISO-8859-1",
                  stringsAsFactors = FALSE)
base <- base[,-7]

base$SUPPORT <- as.double(base$SUPPORT)
base$CONFIDENCE <- as.double(base$CONFIDENCE)
base$LIFT <- as.double(base$LIFT)


df <- data.frame(
  x = base$LHS,
  y = base$RHS,
  Lift = base$LIFT
)


ui <- dashboardPage(skin = "blue",
                    dashboardHeader(title = "Teste"),
                    dashboardSidebar(
                      sidebarMenu(
                        menuItem("Tabela", tabName = "tabela", icon = icon("th"),
                                 badgeLabel = "new", badgeColor = "green"),
                        menuItem("Gráficos", tabName = "Tabelas", icon = icon("area-chart"),
                                 menuSubItem("Sub-item 1", tabName = "subitem1"),
                                 menuSubItem("Sub-item 2", tabName = "subitem2")),
                        menuItem("Help", tabName = "help", icon = icon("question"))
                      )
                    ),
                    dashboardBody(
                      tabItems(
                        tabItem(tabName = "tabela", 
                                fluidRow( 
                                  infoBoxOutput("progressBox"),
                                  infoBoxOutput("progressBox2"),
                                  infoBoxOutput("progressBox3")
                                ),  
                                fluidRow(
                                  dataTableOutput("base")
                                )
                        ),
                        tabItem(
                          tabName = "subitem1",plotlyOutput("plot1") 
                                ),
                        tabItem(
                          tabName = "subitem2",h2("tabela2")
                        ),
                        tabItem(tabName = "help",h2("Help"),
                                fluidRow(
                                  box(
                                    title = "SUPPORT",width = 4, background = "light-blue",
                                    " % de cupons que possuem determinada combinação (LHS) "
                                  ),
                                  box(
                                    title = "CONFIDENCE",width = 4, background = "light-blue",
                                    "Percentual de ocorrência da regra (LHS -> RHS)"
                                  ),
                                  box(
                                    title = "LIFT",width = 4, background = "light-blue",
                                    "Quantas vezes aumenta a chance do RHS dado que o cliente levou o LHS"
                                  )
                                ))
                      )
                    ))

server <- function(input, output, session) {
  
  output$base = renderDataTable({
    base
  })
  
  output$plot1 <- renderPlotly({
    p<-ggplot(df, aes(x, y)) +
    geom_point(aes(colour = Lift),size = 3) +
    scale_colour_gradient(low = "#e6f0ff", high = "#001433") +
    theme(axis.text.x=element_blank(),
          axis.title.x=element_blank(),
          axis.title.y=element_blank()) 
    
    ggplotly(p,  width = 1000, height = 700)})

  output$plot2 <- renderPlot({plot(iris$Petal.Length,iris$Petal.Width)})
  
  output$progressBox <- renderInfoBox({infoBox("SUPPORT",
                                               paste0("Min: ",round(min(base$SUPPORT),3)," /","\n",
                                                      "Max: ",round(max(base$SUPPORT),3)),
                                               color = "blue")})
  output$progressBox2 <- renderInfoBox({infoBox("CONFIDENCE",
                                                paste0("Min: ",round(min(base$CONFIDENCE),1)," /","\n",
                                                       "Max: ",round(max(base$CONFIDENCE),1)),
                                                color = "blue")})
  output$progressBox3 <- renderInfoBox({infoBox("LIFT",
                                                paste0("Min: ",round(min(base$LIFT),1)," /","\n",
                                                       "Max: ",round(max(base$LIFT),1)),
                                                color = "blue")})
}

shinyApp(ui, server)
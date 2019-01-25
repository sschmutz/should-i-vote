# load packages -----------------------------------------------------------
library(shiny)
library(shinythemes)
library(ggplot2)
library(dplyr)
library(sf)
library(gghighlight)
library(shinycustomloader)
library(fontawesome)


# import map data ---------------------------------------------------------
# downloaded Shapefile for Switzerland from https://gadm.org/download_country_v3.html
# read data from level1 (canton)
gadm36_CHE_1 <-
    read_sf(dsn = "data/gadm36_CHE_shp/gadm36_CHE_1.shp") %>%
    mutate(NAME_1_deutsch = c("Aargau", "Appenzell Ausserrhoden", "Appenzell Innerrhoden", "Basel-Landschaft",
                              "Basel-Stadt", "Bern", "Freiburg", "Genf",
                              "Glarus", "Graubünden", "Jura", "Luzern",
                              "Neuenburg", "Nidwalden", "Obwalden", "St. Gallen",
                              "Schaffhausen", "Schwyz", "Solothurn", "Thurgau",
                              "Tessin", "Uri", "Wallis", "Waadt",
                              "Zug", "Zürich")
           )

url_easyvote <- a("easyvote.ch", href = "https://www.easyvote.ch/home/")


# define UI ---------------------------------------------------------------
ui <- fluidPage(
    theme = shinytheme("paper"),

    fluidRow(
        column(12, 
               tags$div(align = "right", 
                        a(href = "https://gist.github.com/mine-cetinkaya-rundel/829cdb7291b09a710efea982ad91f80e", 
                          h4(fa("github", fill = "#B9BABD"))
                          )
                        )
               )
        ),
    
    # Application title
    tags$div(align = "center", titlePanel("Soll ich abstimmen?")),

    fluidRow(
        column(12,
               br(),
               tags$div(align = "center", h5("Stimmrecht im Kanton:"))
               )
        ),
    
    fluidRow(
        column(12,
               tags$div(align = "center", selectInput("selected_canton",
                                                      label = "",
                                                      choices = c("", gadm36_CHE_1$NAME_1_deutsch),
                                                      selected = NULL,
                                                      width = "200px"))
               )
        ),
    
    fluidRow(
        withLoader(plotOutput("map"), type = "html", loader = "loader6")
        ),
    
    fluidRow(
        column(12,
               h5(em(textOutput("result")), align = "center"))
        ),
    
    fluidRow(
        column(12,
               tagList("Fragen?", url_easyvote), align = "center")
        )
    )


# define server logic -----------------------------------------------------
server <- function(input, output) {
    
    output$map <- renderPlot({
        
        gadm36_CHE_1 %>%
            ggplot() +
            geom_sf(fill = "#FF0000", alpha = 0.8) +
            gghighlight(NAME_1_deutsch == input$selected_canton) +
            coord_sf(datum = NA) +
            theme_void()
    })
    
    output$result <- renderText({
        
        if_else(input$selected_canton == "",
                "",
                "du solltest abstimmen")
    })
    }


# create shiny app object -------------------------------------------------
shinyApp(ui = ui, server = server)
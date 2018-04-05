centroid_data <- read.csv('www/Data/Centroid_DA.csv')

ui <- bootstrapPage(
  tags$head(
    tags$title("ER"), 
    tags$style(mainCss)
  ),
  tags$body(
    leafletOutput("map", width = "100%", height = "100%"),
    absolutePanel(id = 'controls', class = 'panel panel-default', 
                  fixed = TRUE, draggable = TRUE, top = 270, left = 33, bottom = "auto", 
                  width = 300, height = "auto",
                  HTML("<br>"),
                  selectInput("pick", "Pick Your DA First!", choices = c("DA Picker", unique(sort(centroid_data$DAUID)))),
                  selectInput("field", "Attribute Field", choices = c("Panels", "Current Output", "Max. Potential"))
    )                              
  )
)

server <- function(input, output){
  
  dauid_popup <- paste0("<strong>")
  
  # Base page 
  output$map <- renderLeaflet({
    if(input$pick == "DA Picker"){
      leaflet(centroid_data) %>% clearControls() %>%
        setMaxBounds(-114.306, 51.205, -113.768, 50.849) %>% 
        addCircles(lng = as.numeric(as.character(centroid_data$xCoord)), lat = as.numeric(as.character(centroid_data$yCoord)), radius = 5, group = "Centroid", popup = ~paste0("<strong>", as.character(DAUID), "</strong>", sep ="")) %>%
        addProviderTiles(providers$CartoDB.DarkMatterNoLabels, group = "Dark") %>%  
        addProviderTiles(providers$Esri.WorldTopoMap, group = "ESRI-Topo") %>% 
        addProviderTiles(providers$Esri.WorldGrayCanvas, group = "ESRI-WorldGray") %>% 
        addProviderTiles(providers$Esri.WorldImagery, group = "ESRI-Imagery") %>% 
        addLayersControl(baseGroups = c("Dark", "ESRI-Topo", "ESRI-WorldGray", "ESRI-Imagery"), overlayGroups = "Centroid", options = layersControlOptions(collapsed = TRUE))
    }
    # Go to where ever you want 
    else{
      shpFile <- readOGR(dsn = "www/Data/OD", layer = paste(input$pick, "_OD", sep = ""))
      boundFile <- readOGR(dsn = "www/Data/Boundaries", layer = paste(input$pick, "_OD", sep = ""), verbose = FALSE)
      
      if(input$field == "Panels"){
        title <- "# of Panels"
        current_field <- shpFile$panel
      }
      else if(input$field == "Current Output"){
        title <- "Current Output (kWh)"
        current_field <- shpFile$output
      }
      else if(input$field == "Max. Potential"){
        title <- "Max. Potential (kWh)"
        current_field <- shpFile$potent
      }
    
      # Create Color Palette  
      palette <- rev(brewer.pal(8, "RdYlGn"))
      pal <- colorBin(palette, domain = current_field, bins = 5, pretty = TRUE, na.color = "#808080",
                alpha = FALSE, reverse = FALSE)
      
      leaflet(shpFile) %>% clearControls() %>% 
        setMaxBounds(-114.306, 51.205, -113.768, 50.849) %>% 
        addPolygons(data = boundFile, fill = FALSE) %>% 
        addPolylines(color = ~pal(current_field), weight = 4, popup = ~paste0("<strong>", current_field, "</strong>", sep = "")) %>% 
        addProviderTiles(providers$CartoDB.DarkMatterNoLabels, group = "Dark") %>%  
        addProviderTiles(providers$Esri.WorldTopoMap, group = "ESRI-Topo") %>% 
        addProviderTiles(providers$Esri.WorldGrayCanvas, group = "ESRI-WorldGray") %>% 
        addProviderTiles(providers$Esri.WorldImagery, group = "ESRI-Imagery") %>% 
        addLayersControl(baseGroups = c("Dark", "ESRI-Topo", "ESRI-WorldGray", "ESRI-Imagery"), options = layersControlOptions(collapsed = TRUE)) %>% 
        addLegend("bottomright", pal = pal, values = ~current_field, title = ~title, opacity = 1)
    }
  })
}

shinyApp(ui, server)
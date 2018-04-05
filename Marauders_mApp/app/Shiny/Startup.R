################################################################
# Function: SetWD()
#
# Purpose: Set working directory of script and return directory
################################################################
this.dir <- setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

library(shiny)
library(leaflet)
library(RColorBrewer)
library(rgdal)

runApp('app.R')
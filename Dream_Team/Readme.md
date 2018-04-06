# Helping Hands Toronto - by the McMaster Dream Team

## ECCE App Challenge 2018

### Team Members
Mark Borthwick, Jayden Choi, Sean Leipe, Chandler Podhorodeski

# Mission Statement

Life in Canada’s largest city is rarely easy, with one in five Toronto residents currently living in poverty. For those struggling to make ends meet, it can be difficult to secure all necessities of western life such as sufficient nutrition, educational resources, and shelter on a daily basis. Currently, many government and private services exist in Toronto that aim to assist low-income residents in one or more areas. The issue is that all too often those in need do not realize these services exist, let alone where to access them until their situation becomes dire.

The goal of **Helping Hands Toronto** is to create an easy-to-use tool that consolidates community resources for at-risk or lower-income families in Toronto, based on open geospatial data hosted by the city. These resources include public libraries, licensed child-care services, youth services, supportive housing locations, and more (for a full list, see **Data Sources**). This app is a convenient interface for displaying the various available services and their locations, identifying and filtering amenities within a given radius of a user-defined location as well as provide directions from a location to a desired facility. Users may also locate services via a search function according to a number of attributes including name, street address, and service type.

# User Guide

## Getting Started

### *Using ArcGIS Online*
Click the link below to access our app!

https://esricanada-ce.github.io/ecce-app-challenge-2018/Dream_Team/app/

### *Using the WAB Developer Edition*
The following instructions assume that the user has the latest version of the Esri Web App Builder (Developer Edition) successfully installed on their device.

1. Download the *app.zip* file from the repository and extract its contents.
2. Open your folder containing the latest version of the WAB.
3. Click on the *startup.bat* file, which will open a link in your browser.
4. Enter your organization's login information into the pop-up.
5. In the Developer window, select the *Import Application* option.
6. Import the zipped file containing the **Helping Hands Toronto** application.

If any problems come up, check out the [Esri Web App Builder FAQ](https://developers.arcgis.com/web-appbuilder/guide/faqs.htm) documentation.

## Explore Resources
Once you've opened the app, use the *Layer List* button in the top right corner to go through the list of available community resources. Simply check the box next to the desired resource to control what shows up as icons on the map. You can see what each icon represents through the nearby *Legend* button.

## Find Specific Resources
Click on the green *Query* button to open a drop-down menu, and select the type of resource you want to search through. You can then search for specific facilities through their name, address, or other characteristics. Clicking on one of the results creates a pop-up with more information on the resource.

## Find Nearby Resources
Click on the blue *Near Me* widget at the bottom of the screen, and either enter your address or click on the map. Use the slider below to decide how far of a distance from your location you want to find resources in.

After selecting the distance, the tool will give you a list of all the community resources close in your area, separated by type. Clicking on a resource type will give you a list of all facilities within the given distance, in order of nearest to farthest. Clicking on an individual resource will open a pop-up with more information about the facility such as its street address, phone number, email address, and more.

For driving directions to your desired location, simply click on the *Directions* tab and step-by-step instructions will show up in the tool window. These can be printed out for reference by using the Print icon in the top right corner of the pop-up.

For walking directions, copy the open the address given from either the *Near Me* or *Query* results and open the orange *Directions* widget. Set your start point, use the address you copied as the end point, and select *Walking Directions* from the drop-down list.

# App Characteristics

**Helping Hands Toronto** aims to assist at-risk individuals through providing an easy way to explore the locations and details for many of Toronto’s social services and displaying them in a single, easy to use app.

The web app includes a *Near Me* function that allows users to pin their location on the map and display all service facilities within a search radius of their choosing. From there, users can filter through support types based on their needs and read specific facility information by clicking the map icons. Users can also acquire walking or driving directions from their location to a selected service center or specified locations through their name, address, or other characteristics using the *Query* widget.

Though any of these specific locations could be found using a Google search, this app lets you explore any of the 9 different resource types, and displays important information that may otherwise be difficult to locate elsewhere.

## Data Sources

This app was designed using the Developer Edition of the ArcGIS Web App Builder.  All data used was obtained from the [City of Toronto’s open data portal](https://www.toronto.ca/city-government/data-research-maps/open-data/). Feature layers were either downloaded directly as point shapefiles, or converted to points from CSV files using their listed latitude and longitude coordinates. The different feature layers representing community resources used in the app are:

* Public libraries
* Long-term care facilities
* Rent banks
* Licensed child-care services
* Air-conditioned public places
* Homeless shelters
* Youth services centres
* Drop-in locations
* Supportive housing locations

For some point layers, key attribute information such as names, email addresses, websites, etc. were either unavailable or formatted incorrectly. This issue was corrected using Arcade expressions with conditional logic.

**Disclaimer**: *Helping Hands Toronto* is not affiliated with any of the City of Toronto organisations or social programs refrenced within the app. This application was created strictly for educational purposes in conjunction with the 2018 ECCE App Challenge. 

## Widgets Used

The web app interface uses the following widgets:

* **Splash screen**: to introduce the user to the app
* **Share**: gives a shareable link to the web app on ArcGIS Online
* **Layer List**: to let the user control which layers are displayed 
* **Legend**: to show the user which icons represent what
* **Query**: to search for specific resources
* **Nearby**: to find resources within a specific distance of and obtain information and driving directions
* **Directions**: to get walking directions for a specific resource

# ohDeer

readme file for ohDeer - a survey and web application to report and analyze animal road impacts

## Mission Statement

Road impacts of animals have had a clear increase in Nova Scotia and right now there is very little infrastructure to ease the transportation of animals through the Nova Scotia road network and many single lane roads that are unsafe when trying to avoid hitting animals. Impacts with animals could not only lead to the death of an animal, but could cause major property damage, or in some cases, cause an accident that leads to more serious injuries of passengers in the vehicle. 

The current method of reporting roadkill is a 1-(800) number that connects the reporter with the Department of Natural Resources, the Department of Transportation, the RCMP, or limited voluntary wildlife rescue organizations (there are currently only two notable in Nova Scotia). This method may be considered more tedious than a user-friendly survey application to facilitate the simplicity of reporting with an easy-to-use interface. With this strategic method, it will be easier to keep track of the observation data by importing it directly into a geodatabase that gives a tangible and accurate georeference and other pertinent information that is associated with the event. 

By engaging the public in reporting roadkill, live data and valuable spatial information can be provided to conservation authorities, government agencies, and municipalities to evaluate areas that are more susceptible to road impacts with animals. Observations being directly available in a geodatabase allow these organizations to query the data in order to gain more spatial information on a specific species. 


## App Characteristics

The goal is for this information to be used to promote road safety by providing live data to those responsible for road maintenance and, in the longer term, to encourage intervention methods (i.e. wildlife passageways, fencing, clearing forest near roads, adding signage, road maintenance). 

Our app has two components: 

1. A user-friendly survey component that gathers crowd-sourced observation data input by the public (the most compatible, user-friendly version is available on the Survey123 app). 
browser link: [Survey123](https://survey123.arcgis.com/share/9ffa6b272cfb4158a502e323dbb78929)
2. The visualization of the road impact observation data via the web application component.
link: [Web App](https://cogsnscc.maps.arcgis.com/apps/webappviewer/index.html?id=775ea1c329c943daa3839daff75e6160)


## App Usage

### Survey:

The survey component of the application allows the user to input their observation data using the Survey 123 Connect interface. The survey can be accessed by searching ohDeer on the Downloadable Surveys list in the Survey123 application (accessible on Android and IOS devices and browser use). 

User options include:

 #### 1. Animal Type   
   - Choose an animal from the drop down list or select other and the user may input the animal type 
 #### 2. Condition of Animal
   - Deceased
   - Wounded
   - Unsure
 #### 3. Image 
 #### 4. Date & Time
 #### 5. Location
   - A map opens to allow user to geographically pin where the observation was made
 #### 6. Notes on Location
   - Gives the user the option to expand on the reference, or, if the user has location services turned off, to input directions via text
 #### 7. Contact Info
   - Full name 
   - Phone number
   - Email

After the observation is submitted, the data is inputted into the geodatabase as a layer file and visualized as a reference point in the web application.

### Web Application:

The web application presents the points on a layer in Web AppBuilder. For the purposes of the app challenge, the point layer contains 30 random points that were created with a python script and populated with observation data to reflect the same fields as input coming from the Survey123 application in order to test the functionality of the analysis in the web application. In addition to the random points, there is a layer that has user-inputted data from the Survey123 application.

The web application includes multiple layers the user can interact with, including: 

  #### 1. Earth at Night
   This NASA image visualizes streetlights in Nova Scotia at night in order to portray the lack of visibility on certain roads. This could inhibit the driver’s ability to recognize an animal in the road. This layer can be overlaid onto the incidents map, which could help identify a correlation between lack of streetlight and more incidents.
   
  #### 2. Significant Species and Habitat
   Notable species are deer and their migratory routes, as they have been a larger portion of reported vehicle collision incidents on Nova Scotia highways, based on safety reports available from the Department of Transportation (DNR) and Infrastructure Renewal. Some of the other species and habitats that are harder to interpret (ie. “Other Habitat”, “Species at Risk”, “Species of Concern”) are also included in the dataset.

  #### 3. Significant Species Buffer
   A buffer of one kilometre was created around the road network layer where the road intersected with the significant species and habitat layer. This layer is valuable to show road stretches that are vulnerable to crossings by significant species.
   
  #### 4. ohDeer Points (Survey123)
   This layer geographically presents the points inputted by the user of the ohDeer Survey123 application. 
  
  #### 5. Simulation Points
   A python script was used to create 30 random points to test the Web App Builder tools. 

  #### 6. Nova Scotia Major Road Network
   Represents the different road classes: Trans Canada Highway, provincial highways, collector roads, and arterial roads


## Limitations

Possible limitations of this app include:

  - Limited reports coming from rural areas where the population is scarce
  
  - Lamp pole data unavailable
  
  - Users having little interest on taking time to fill out a report 
  
  - Users not being able to recognize certain species they see in order to describe them
  
  - Users not having an account to connect with Survey123 will have to be willing to create one
  
  - In the future, including traffic volume data and numbers of species data should be included as a temporal study to see the difference the app is making in regards to animal conservation 


## Data Sources 

Significant Species and Habitat Database, provided by the Department of Natural Resources included shapefile with data for the entire province

Municipalities/Provincial borders and Nova Scotia Road Network provided by NS Open Data Catalogue 

Nova Scotia Earth at Night provided by NASA Worldview Snapshot


## License

GNU General Public License v3.0


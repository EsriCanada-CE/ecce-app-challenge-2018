Azure Web App
=========

Azure is a web app that shows the expected consequences of sea level rise in the City of Vancouver, BC.
****
Team: Water3D
----
We are a team of enthusiastic students at the the University of Waterloo. We decided to participate in the ECCE App Challenge because it is an opportunity for us to learn, strengthen our skills, and have fun together!

  - Stephanie Wen: Hi! I am in my 4th year of Geomatics at the University of Waterloo. I enjoy creating maps of places I’ve never been to. Creating bucket lists in that city, so that one day when I visit I can plan my trips, and accomplish them in the time allotted. I also enjoy sleeping, eating, instagramming, and snapchatting. If we get to go to San Diego I promise a vlog of our experience!

  - Anam Rahman: I am an Environment & Business student, pursuing the GIS Diploma at the University of Waterloo. My work in the insurance industry exposed me to flood risk management, and the need to adapt for climate change in cities. I love how web mapping tools can be used to educate and visualise highly impactful phenomena regarding climate change. I learnt a lot through this challenge and I’m excited to see how GIS can be used as a communication and decision making tool.


  - Jaydeep Mistry: I am a Masters of Environmental Studies student at the University of Waterloo. I did my Undergrad in Geomatics with Computer Science Minor. My education and experiences have made me very passionate about GIS, Open Data, Data Science, and app development. I’ve helped develop various apps, but the spatial apps such as this one have been the most exciting to work on.

  - Juan Carrillo: I am a geomatics engineer currently studying a Master of Science in Geography at the University of Waterloo. With more than five years of work experience in geomatics and project management, I am convinced about the key role of geographic information science and technology to help us mitigate climate change.


Mission statement and main goals
----

Sea level rise is a major global issue. On recent news published by the United Nations Framework Convention on Climate Change, the sea level rising rate is accelerating and it may increase by 65cm by the end of the century [[1]]. Scientists at the U.S. Geological Survey calculated that around 500 million people will be affected by the year 2100 around the world [[2]]. Two major drivers are cause this phenomenon, ice melting in polar regions and atmosphere warming. Both of them closely related with global warming. 

Fortunately, not everything is bad news. Several international organizations and governments are currently working on strategies to prevent and mitigate the effects of sea level rise. More and more non-government organizations and citizen groups are engaging into decision making process and taking action on climate change. The citizen is now recognized as a key player who can positively contribute in many ways to mitigate climate change [[3]]. Over last years, we have seen plenty of examples on how the so called “citizen science” leverages geographic knowledge to support citizens in their initiatives [[4]].  

For the ECCE 2018 Challenge, our team created an ArcGIS Web App called **Azure**. Its main goals are listed below:

  - Provide geographic insights to citizens about the sea level rise issue due to climate change.
  - Allow users to see two simultaneous 2D and 3D visualizations of how their urban environment might be affected by several scenarios of sea level rise.
  - Offer querying capabilities to seelook if a specific address location is in a flood risk areawill be affected, as well as the estimated number of people and economic losses per building.

Value proposition
----
Azure is very unique app because to the extent of our knowledge, it is the first web application that provides an interactive 3D visualization of sea level rise in an urban environment. In addition, it allows users to look for a specific address and have an instant estimate of the affected number of people and economic losses for that location. The app works seamlessly for any desktop or mobile user, and it has an intuitive set of tools to navigate the map and visualize both the 3D urban buildings and the varying sea level scenarios. 

Beyond the visual attractiveness, Azure serves as a communication tool to inform citizens about the estimated consequences of sea level rise in their city. It invites citizens to engage in climate change mitigation initiatives by providing them a local perspective of the issue and make them aware of the importance of creating and implementing ways to mitigate climate change. In addition, government agencies can also use it as a communication tool to inform decision and policy making processes by analysing the crowdsourced citizen data collected in the app built-in feedback form.

We hope that our app will help to raise awareness about climate change, its consequences and the importance of taking immediate measures to mitigate it. Finally, we as a students of the Faculty of Environment at the University of Waterloo, consider this app a little effort towards achieving some of the United Nations Sustainable Development Goals [[5]]. Specially the 11th “Sustainable cities and communities” and the 13th “Climate action”.

Pilot area – City of Vancouver
----
The coast of the Pacific Ocean is populated with some of the world’s largest cities. One of them is the beautiful city of Vancouver. Nearly 2,264,000 people live in the Greater Vancouver area [[6]],  making it one of the most densely populated areas in Canada [[7]]. According to John Clague, a professor at Simon Fraser University in British Columbia, *"Metro Vancouver is the most vulnerable urban area in Canada to sea level rise as we have about 250,000 people living within about a metre of mean sea level."* [[8]]. Another warning flag is a technical study recently published by the city of Vancouver estimates between 500 to 800 buildings would be affected, most of them residential homes [[9]].

Based on the forecasted consequences of sea level rise, the city of Vancouver was selected as a the pilot area for our web app. We consider this app will become a communication tool for the people of Vancouver to discover the effects of sea level rise in their home city.

App workflow
----
**How-to Install Azure web app**
The app was designed to be a single page web-app. All the required code, including the HTML, CSS, Javascript, and every spatial libraries are either within the single HTML document of the web-app or streamed from online resources. To install it, any user can simply download a copy of the HTML page of the app and try to run it on their own browsers.

**User manual**

1.    When the app opens, you are presented with two maps.
  - The top/left one is a 3D scene
  - The bottom/right one is 2D map
  - Both are linked together, and moving one will move the other
  - Both maps show the downtown core of Vancouver City, Canada
2.	Above the maps, you are presented with buttons to change the water level rise scenarios
  - By default, 5 degrees celsius is active
  - You can turn on as many or as few scenarios as you want to see
  - If the button is colored as white, the scenario is not visible on the maps
  - If the button is colored as blue, the scenario is visible on the maps
3.	To interact with the map, you can just Left-Click to drag the view around, zoom in/out. 
  - If you Right-Click the 3D map, you can rotate its compass direction, and angle of view.
  - Additionally you can expand either of the maps to see a more detailed view

4.	Use the address locator, to search for a place of interest or your own address

5.	What to see?
  - As you change the scenarios, both the 3D and 2D maps will update appropriately.
  - You can zoom in the 3D scene and exactly see how high the water level could rise, how much land goes under water, and how many buildings could go under water
  - You can compare the 3D scene with the 2D scene, which shows the exact outline of where the water could rise up to, but the buildings are color coded for which ones will be affected by the highest water level visible.
6.	To know more about the buildings, you can click them on the 2D map to see a pop-up of information which includes:
  - Building ID
  - Building development type
  - Building Zone ID
  - The temperature that the water level has to rise to for it to get affected
  - An approximate number of residents that could be affected
  - An approximate total cost of the building value considered as economic loss
7.  Went too far away from the study area?
  - You can click the “Go to Study Area” button to bring you right back to where the affected buildings are.
8.	Below both the maps, there are summary statistics for important information grouped by each water level scenario.


Software stack
----
The software stack we used to create the Azure web app is mainly comprised of ESRI tools. In addition, several other software tools were implemented to address complementary requirements.

**Spatial analysis.** [ArcMap] and [ArcGIS Pro] were used to integrate the datasets and perform spatial analysis workflows to determine sea levels, identify flooded buildings, and estimate the number of affected people for different scenarios. ArcGIS Pro was specially useful for 3D analysis and visualization. 

**Data hosting.** [ArcGIS online] was used to store the geospatial datasets we present in the app. This tool provides a reliable web environment to store, visualize, and analyze data.

**Web mapping.** [ArcGIS API for JavaScript 4.6] was implemented to enable most of the web mapping functionalities. Particularly, we used the following three libraries to develop some key features:
  - [Watchutils]: Synchronized 2D and 3D map visualization.
  - [Sceneview]: 3D map visualization.
  - [Locator]: Address geocoding and localization.

**Web app user interface.** [Dojo toolkit] and [Bootstrap]. They were specially useful to create the user interface components and to connect map elements with it.

**Charts.** [ESRI Cedar Javascript library]

**Version control system.** [Git]. 

**Source code editing.** [Visual Studio Code].

**Survey for crowdsourced citizen feedback.** [Google Docs].

**Hosting app logo.** [Google Photos].

**Readme file editing.** [Dillinger online markdown editor].

Geospatial open data sources
----
The main source of open data was the online Vancouver data catalogue [[10]]. We focused on datasets with information related to buildings locations, population, and terrain elevation. In addition, the web app uses a 3D Web Scene of Vancouver published by ESRI [[11]]. Below is the list of used datasets:

**From The City of Vancouver’s Open Data Catalogue**
  - Building footprints [[12]]. Extracted from LIDAR data captured in 2009. Shapefile file format.
  - Zoning [[13]]. Updated weekly. Shapefile file format.
  - Digital elevation model [[14]]. Raster with spatial resolution of 1m. Tiff file format.

**From Statistics Canada**
  - 2016 Census Data by Dissemination Area [[15]].

**From the Scholar’s Geoportal**
  - Land Use (LUR). Producer: DMTI Spatial Inc. Date published: 2014-05-15 (publication) [[16]]. 

Data processing
----
The steps below outline the general process and calculations used to create the information layers on our web app map

**Waterbody** 
A waterbody layer was created through manipulation of the Land Use (LUR) dataset from DMTI. A selection was made to choose polygons categorised as “waterbody”, and dissolved to create a single polygon to represent all water features for the study area.

**Sea Level Rise Layers**
To determine the area inundated by rises in sea level, the DEM raster was processed. The Less Than Equal tool was used to extract DEM cells at the required height for each sea level rise scenario. This raster output was converted into a polygon feature class. The output was merged with the aforementioned waterbody layer, to create a consistent boundary. To neaten the polygon, merged output layer was dissolved and converted from multipart to singlepart to create the final floodplain boundary. These steps were repeated for each degree of rise in temperature. 

**Buildings Layer**
  - Building Shape Area:
As the building footprints were originally multipart polygons, the dissolve tool was used to combine overlapping and neighbouring polygons. This gave us an output with one polygon and shape area for each building which could be used for other calculations. 

  - Buildings Flooded:
In order to determine levels of inundation in each sea level scenario, a field for Z level heights was added to the buildings polygon layer. To do this the DEM raster was copied and cell values were converted to 8 bit signed integers for ease of processing. We ran the Add Surface Information tool on the building layer with the integer DEM to add min z values for each polygon. From here, we were able to select by attribute for each threshold level of  sea level rise using the z values assigned for each building. 

  - Building Zoning 
A spatial join was completed between the building footprint and zoning layers.

  - Built Area
To calculate estimates of population density and dwelling cost, built area was calculated by using the Census data, as well as Building footprints. To begin, we intersected the dissemination area with building footprints. Next, the data was summarised in a table by DAUID. Here the sum of the shape areas gave us the ‘built area per census’, which was copied and added as a field in the census data layer. This measurement will be used to make more accurate generalisations for calculations based on building footprint area as opposed to census tract area.  

  - Building Population
In order to calculate an estimate of the number of residents in a building, we used 2016 census data by dissemination area. In the census data table we added a field for population density per built square metre. Total population was divided by Built Area to give us population density. After joining the census data with the building data, an estimate of the number of residents was calculated for each building by multiplying the population density with the building shape area. 

  - Building Cost
In order to calculate an estimate of the cost of buildings, we used 2016 census data by dissemination area. In the census data table we added a field for average cost per square metre. For each dissemination area, the number of dwellings was multiplied by the average cost of dwellings and divided by built area, to determing the average cost per square metre. After joining the census data with the building data, an estimate of the building value was completed by multiplying the average cost per metre with the building shape area. 

Future improvements
----
We have classified what we consider as relevant future improvements in three categories: Technical improvements, user interface design, and communication capabilities. 
  - Technical improvements: Determine more accurate estimates based on climate change models and consideration of more social, environmental, and economic variables.
  - User interface design: Perform user tests to identify app workflow steps that might require redesign or a more user-friendly appearance.
  - Communication capabilities: Evaluate further opportunities to adjust app functionalities to foster engagement and collaboration between different users (citizens, government agencies, researchers, NGOs) based on common interests and initiatives.

Aplicability in other cities or flooding scenarios
----
The Azure web app might be easily implemented in any other coastal city. Geospatial data availability is the main resource required to implement the app. In addition, by using the ESRI tools mentioned in our software stack section, any coastal or flood-prone city might create their own apps following a similar approach. For instance, the tool can be adjusted to use 10yr, 50yr, and 100yr level flood plains to visualise and determine impacts for inland cities.There are endless possibilities to leverage geographic knowledge and technologies in order to foster citizen science and mitigate climate change.

Limitations
----
The main limitations when creating the Azure web app were:

  - Limited time (one week).
  - Uncertainty about sea level rise. Most of the published studies mention the limited accuracy of their estimates, the main reason is the complexity involved in climate change modelling and the relatively short period of time (decades) scientists have been recording data about sea levels compared to the time scale of the phenomenon (hundreds or thousands of years). This app assumes a uniform 2.3m rise in sea-level per degree of change based on a publication by the Intergovernmental Panel on Climate Change [[17]].
  - The affected number of people and economic losses per building are based on rough estimates and do not consider several interrelated social, environmental, and economic variables.

Licence
----
Azure web app is licensed under the [GNU General Public License v3.0].

References
----
* [[1]]    “Global Sea Level Rise Is Accelerating - Study | UNFCCC.” [Online]. Available: https://cop23.unfccc.int/news/global-sea-level-rise-is-accelerating-study. [Accessed: 23-Feb-2018].

* [[2]]	“Center of Excellence for Geospatial Information Science (CEGIS).” [Online]. Available: https://cegis.usgs.gov/sea_level_rise.html. [Accessed: 23-Feb-2018].
* [[3]]	“Global Day of Conversation on Climate Change, Energy and the Green Economy Citizens’ Guide.”
* [[4]]	“Citizen Science Resources | ArcGIS Blog.” [Online]. Available: https://blogs.esri.com/esri/arcgis/2015/09/22/citizen-science-resources/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%253A+MappingCenter+(Mapping+Center). [Accessed: 23-Feb-2018].
* [[5]]	“Sustainable development goals - United Nations.” [Online]. Available: http://www.un.org/sustainabledevelopment/sustainable-development-goals/. [Accessed: 23-Feb-2018].
* [[6]]	“Statistics Canada: Canada’s national statistical agency.” [Online]. Available: http://www.statcan.gc.ca/eng/start. [Accessed: 23-Feb-2018].
* [[7]]	“Population of metropolitan area of Vancouver outpaced national growth rate | Vancouver Sun.” [Online]. Available: http://vancouversun.com/news/local-news/new-census-data-population-of-metropolitan-area-of-vancouver-outpaced-national-growth-rate. [Accessed: 23-Feb-2018].
* [[8]]	“Interactive Map Shows Impact Of Rising Sea Levels On Coastal Cities In Canada.” [Online]. Available: http://www.huffingtonpost.ca/2017/11/08/interactive-maps-show-impact-of-rising-sea-levels-on-coastal-cities-in-canada_a_23271427/. [Accessed: 23-Feb-2018].
* [[9]]	V. O ’connor, P. Eng, T. Lyle, and D. Stuart, “CITY OF VANCOUVER COAST AL FLOOD RISK ASSESSMENT FINAL REPORT,” 2014.
* [[10]]	C. of Vancouver, “Open data catalogue,” 2018.
* [[11]]	“Local Government 3D Basemaps | ArcGIS for Local Government.” [Online]. Available: http://solutions.arcgis.com/local-government/entire-organization/basescenes/. [Accessed: 23-Feb-2018].
* [[12]]	“Vancouver’s Open Data Catalogue: Building Footprints.” [Online]. Available: http://data.vancouver.ca/datacatalogue/buildingFootprints.htm. [Accessed: 23-Feb-2018].
* [[13]]	“Data Catalogue: Zoning data package.” [Online]. Available: http://data.vancouver.ca/datacatalogue/zoning.htm. [Accessed: 23-Feb-2018].
* [[14]]	“Data Catalogue: Digital elevation model.” [Online]. Available: http://data.vancouver.ca/datacatalogue/digitalElevationModel.htm. [Accessed: 23-Feb-2018].
* [[15]]    “Data products, 2016 Census.” [Online]. Available: http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/index-eng.cfm. [Accessed: 23-Feb-2018].
* [[16]]    “Scholars GeoPortal.” [Online]. Available: http://geo1.scholarsportal.info/. [Accessed: 23-Feb-2018].
* [[17]]    “Church, J.A., P.U. Clark, A. Cazenave, J.M. Gregory, S. Jevrejeva, A. Levermann, M.A. Merrifield, G.A. Milne, R.S. Nerem, P.D. Nunn, A.J. Payne, W.T. Pfeffer, D. Stammer and A.S. Unnikrishnan, 2013: Sea Level Change. In: Climate Change 2013: The Physical Science Basis. Contribution of Working Group I to the Fifth Assessment Report of the Intergovernmental Panel on Climate Change [Stocker, T.F., D. Qin, G.-K. Plattner, M. Tignor, S.K. Allen, J. Boschung, A. Nauels, Y. Xia, V. Bex and P.M. Midgley (eds.)]. Cambridge University Press, Cambridge, United Kingdom and New York, NY, USA” [Online]. Available: https://www.ipcc.ch/pdf/assessment-report/ar5/wg1/WG1AR5_Chapter13_FINAL.pdf. [Accessed: 23-Feb-2018].


[1]:https://cegis.usgs.gov/sea_level_rise.html
[2]:https://cegis.usgs.gov/sea_level_rise.html
[3]:http://climatecommunication.yale.edu/wp-content/uploads/2016/02/2010_04_Citizen%E2%80%99s-Guide-to-Taking-Action-on-Climate-Change.pdf
[4]:https://blogs.esri.com/esri/arcgis/2015/09/22/citizen-science-resources/?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%253A+MappingCenter+(Mapping+Center)
[5]:http://www.un.org/sustainabledevelopment/sustainable-development-goals/
[6]:http://www.statcan.gc.ca/eng/start
[7]:http://vancouversun.com/news/local-news/new-census-data-population-of-metropolitan-area-of-vancouver-outpaced-national-growth-rate
[8]:http://www.huffingtonpost.ca/2017/11/08/interactive-maps-show-impact-of-rising-sea-levels-on-coastal-cities-in-canada_a_23271427/
[9]:http://vancouver.ca/files/cov/CFRA-Phase-1-Final_Report.pdf
[10]:http://vancouver.ca/your-government/open-data-catalogue.aspx
[11]:http://data.vancouver.ca/datacatalogue/digitalElevationModel.htm
[12]:http://data.vancouver.ca/datacatalogue/buildingFootprints.htm
[13]:http://data.vancouver.ca/datacatalogue/zoning.htm
[14]:http://solutions.arcgis.com/local-government/entire-organization/basescenes/
[15]:http://www12.statcan.gc.ca/census-recensement/2016/dp-pd/index-eng.cfm
[16]:http://geo1.scholarsportal.info/
[17]:https://www.ipcc.ch/pdf/assessment-report/ar5/wg1/WG1AR5_Chapter13_FINAL.pdf

[ArcMap]:http://desktop.arcgis.com/en/arcmap/
[ArcGIS Pro]:https://pro.arcgis.com/en/pro-app/
[ArcGIS online]:http://www.esri.com/software/arcgis/arcgisonline
[ArcGIS API for JavaScript 4.6]:https://developers.arcgis.com/javascript/index.html
[Watchutils]:https://developers.arcgis.com/javascript/latest/api-reference/esri-core-watchUtils.html
[Sceneview]:https://developers.arcgis.com/javascript/latest/api-reference/esri-views-SceneView.html
[Locator]:https://developers.arcgis.com/javascript/latest/api-reference/esri-tasks-Locator.html
[Dojo toolkit]:https://dojotoolkit.org/
[Bootstrap]:https://getbootstrap.com/docs/3.3/
[ESRI Cedar Javascript library]:https://esri.github.io/cedar/
[Git]:https://git-scm.com/
[Visual Studio Code]:https://code.visualstudio.com/
[Google Docs]:https://docs.google.com/
[Google Photos]:https://photos.google.com/
[Dillinger online markdown editor]:https://dillinger.io/
[GNU General Public License v3.0]:https://www.gnu.org/licenses/gpl-3.0.en.html
    
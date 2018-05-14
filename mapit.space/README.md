# App Challenge 2018 Winner

***mapit.space*** *is the winner of the App Challenge 2018*!

Congratulations from everyone at Esri Canada.

---

# goElectric by mapit.space
### Submission for the 2018 Esri App Challenge
### Team
* Anthony Lee: Lead Researcher
* Alysha van Duynhoven: Lead Developer
* Chris Yee: Project Lead & Designer


## Quick Start

Check out <a href="https://alyshav.com/app/">goElectric</a> to view the live demo site! 

To deploy this app locally, please read SETUP.md in this same folder.

Notes: 
1. This app is best viewed in a desktop web browser. If you are on mobile, please select "Request Desktop Site" in your mobile web browser.
2. We configured the Geometry Service in our web application to use the url: https://sampleserver6.arcgisonline.com/arcgis/rest/ since we do not have access to ArcGIS Server/Enterprise. Since we are using the sample service, our savings calculator results may not always propagate changes immediately. This sample server has limited use and should be swapped out with a dedicated server url. This change can be made in goelectric.html at line 502 following "new GeometryService". If the sample server is down, our Savings Calculator will not work and the server will return a 503 error.


## Video Submission

<a href="https://www.youtube.com/watch?v=gt-5LU6t5Ac&feature=youtu.be" target="_blank">goElectric Video Submission</a>


## Mission Statement

The current paradigm of climate change mitigation has been heavily focused on eliminating the world’s dependence on fossil fuels and promoting cleaner air in major urban areas. The use of fossil fuels adds greenhouse gas emissions, exacerbating climate change processes. They also add several pollutants to the air, dirtying the air which can result in health complications for locals. In urban areas around the world, the use of gasoline-powered vehicles contributes significantly to these problems. Recognizing this, the City of Vancouver (BC) released the <a href="http://vancouver.ca/green-vancouver/greenest-city-action-plan.aspx">2020 Greenest City Action Plan</a> in 2012. The plan outlines 10 goals that the city will aim to reach by 2020 to become the ‘world’s greenest city’. Two of their goals (Goal 1 & 8) involve eliminating the city’s dependence on fossil fuels and to “breathe the cleanest air of any major city in the world.”

The city identified that promoting the switch from fuel-powered vehicles to electric vehicles would be a substantial step in the right direction to making Vancouver the ‘world’s greenest city’. Fully electric vehicles (EVs) have no tailpipe carbon emissions and have the potential to rely solely on clean, renewable energy to run. The typical lifespan of EVs are expected to exceed that of traditional gas-powered vehicles. The city adopted the Electric Vehicle Ecosystem Strategy in 2016 which sought to improve the accessibility of charging stations for electric vehicles within Vancouver. This initiated the city’s push toward switching to electric vehicles.

The goal of our application, goElectric, aims to support the City of Vancouver's Electric Vehicle Ecosystem Strategy by showcasing to residents of Vancouver the benefits of making the switch to EVs. Our application will demonstrate how much Vancouverites can save in terms of fuel costs and how much carbon emissions they would prevent by switching to an EV. Our application not only allows users to observe charging stations locations, but to explore multiple EV models that are currently available in British Columbia with their typical travel routes with start and end markers. Our application will provide custom annual values based on the EV model they select and the customized route they provide. Our application can show where closest charging stations in Vancouver are with a user-specified proximity to the route previously specified. We also illustrate how far EVs can go on one charge or less to demystify misconceptions about EV travel ranges. 


## App Description & Features

Our application was created using the ArcGIS API for JavaScript and can be separated into three tools:

### 1) Savings Calculator
The Savings Calculator provides an estimate of your annual cost to use the EV model selected. It also computes the cost of fuel and carbon emissions if they travelled the same route in a gas-powered vehicle. Using user-defined variables such as the Electric Vehicle model, starting location, destination location, and number of trips per week, the user can obtain dynamic estimations of the average annual electricity costs associated with using the selected EV, along with the total greenhouse gas emissions prevented by opting for an EV. The selection of vehicle options are all the EVs currently available in British Columbia as of March 16, 2018.  

### 2) Charging Stations
The Charging Stations tool uses the previously chosen EV, start location, and destination location, and a user-controlled buffer variable input to compute a buffer around the user’s route. This tool aims to illustrate to users all the charging locations along a route within the specified proximity. Using this tool, the user can find charging locations available between home and work - within the user's definition of ‘along the way’. 

### 3) EV Range
The EV (Electric Vehicle) Range tool illustrates the maximum range achievable by electric vehicles at any percent of battery state. Battery state was included to better represent reality when a user is 'out-and-about'. The battery state (charge level) is variable that the user can set to better understand the possible maximum ranges of the EVs currently available in British Columbia. This tool aims to address any concerns or misconceptions of range that past electric vehicles may have instilled due to previous technological limitations.


## Data Sources

Data used in the creation of our web application came solely from open data sources. The City of Vancouver's municipal boundary and the locations of electric vehicle charging stations were obtained from the  <a href="http://vancouver.ca/your-government/open-data-catalogue.aspx">City of Vancouver’s Open Data Catalogue</a>. The calculations we used to calculate electricity costs and our comparisons with fuel costs & carbon dioxide emission was developed using a variety of sources which consisted of government sources & consultant reports (see “Calculation Explanations” section).


## Calculations & Explanations

### Approximate Annual Cost (AAC)
The Average Electricity Economy (AEE) values for each of our chosen vehicles were obtained from the Canadian Automobile Association’s (CAA) Driving Costs Calculator in kWh/100km. The AEE values for each vehicle were then divided by 100km to obtain a rate per kilometer. The AEE value for the Tesla Model S vehicle was not in the CAA’s calculator and was obtained using information from fueleconomy.gov. To obtain an approximate annual cost to use your electric vehicle, the following formula was used:

Approximate Annual Cost (AAC) = 2 x d x nt x AEE x CEBC x 52

d = Distance, as specified by end-user based on the locations of their start and end placements. This was multiplied by 2 to indicate a round trip

nt = number of trips per, value to be specified by end-user

AEE = Average Electricity Economy, each vehicle has their respective AEE value, will be chosen based on the vehicle chosen from the drop-down list

CEBC = Cost of Electricity in BC at Step 2 ($0.1287/kWh), which is the highest rate that BC Hydro can charge its customers per hour

52 = this value represents how many weeks there are in a year, it was chosen to make the whole equation representative of annual costs

### Approximate CO2 Emissions Not Emitted
The EPA reported that the average gasoline-using vehicle typically emits about 411 grams of carbon dioxide per mile. We converted this value into kilograms per kilometer and obtained a rate of 0.25538kg/km. We will be using this rate to calculate approximately how much end-users will be avoid emitting by using electric vehicles, which have no tailpipe emissions. The following formula was used:

Approximate CO2 Emissions Not Emitted = 2 x d x nt x 0.25538 kg/km x 52

d = Distance, as specified by end-user based on the locations of their start and end placements. This was multiplied by 2 to indicate a round trip

nt = number of trips per, value to be specified by end-user

52 = this value represents how many weeks there are in a year, it was chosen to make the whole equation representative of annual costs

### Average Fuel (Gasoline) Costs in Vancouver (2018)
We also want to compare how much you save annually by using an electric vehicle in terms of fuel savings. To do this, we need the amount the average person spends on a vehicle a year. We found an average fuel consumption rate of 10.8L/100km and an average price of gasoline in Vancouver, BC (144162963 cent per liter; prices from January 1, 2018 – March 16, 2018). Both values are representative of 2018 and were found from Natural Resources Canada and from a report by Pacific Analytics. The values were used to calculate an average rate that consumers spend on gasoline in 2018 which was $0.155696/km then used to calculate annual fuel costs. The following formula was used:

Average Fuel (Gasoline) Costs in Vancouver (2018) = 2 x d x nt x $0.155696/km x 52

d = Distance, as specified by end-user based on the locations of their start and end placements. This was multiplied by 2 to indicate a round trip

nt = number of trips per, value to be specified by end-user

52 = this value represents how many weeks there are in a year, it was chosen to make the whole equation representative of annual costs

### Limitations
The calculations that our web application uses were created under the several ‘worst-case’ assumptions. We assumed that end-users would be making a round trip and that electricity costs in British Columbia would be at <a href="https://www.bchydro.com/accounts-billing/rates-energy-use/electricity-rates/residential-rates.html">step 2, the higher rate</a>. This was done to prevent our application from providing users with underestimations. Additionally, due to a lack of localized research, parts of our calculations made use of national averages or came from American sources of information.


## Known Issues
* We configured the Geometry Service in our web application to use the url: https://sampleserver6.arcgisonline.com/arcgis/rest/ for the purpose of this project. This server has limited use and should be swapped out with a dedicated server url. This change can be made in goelectric.html at line 502.
* In the Charging Stations tab, the intention was to query intersecting charging stations from the CSVLayer (https://developers.arcgis.com/javascript/latest/api-reference/esri-layers-CSVLayer.html) with the buffer output geometry (https://developers.arcgis.com/javascript/latest/api-reference/esri-tasks-GeometryService.html#buffer). This was attempted with Query (https://developers.arcgis.com/javascript/latest/api-reference/esri-tasks-support-Query.html) and QueryTask (https://developers.arcgis.com/javascript/latest/api-reference/esri-tasks-QueryTask.html). However, this spatial relationship query (query.spatialRelationship = "intersects";) was not working as expected, resulting in the omission of this feature. The intended workflow was to allow the user to observe the outputted number of charging stations within the user-specified buffer distance in the "Charging Stations" tab, along with a change in appearance of the intersecting icons.


## Data used
* Electric vehicle charging stations data from: http://data.vancouver.ca/datacatalogue/index.htm
* City Boundary from: http://data.vancouver.ca/datacatalogue/cityBoundary.htm
* List of electric vehicle options available in BC obtained from: https://www.bchydro.com/powersmart/electric-vehicles/owning-an-electric-vehicle/options.html


## References
* http://www.autotrader.ca/newsfeatures/20170302/how-much-does-it-really-cost-to-charge-that-electric-vehicle/
* https://www.bchydro.com/powersmart/electric-vehicles/charging/charging-at-home.html
* https://www.bchydro.com/powersmart/electric-vehicles/owning-an-electric-vehicle/geography.html
* https://www.bchydro.com/powersmart/electric-vehicles/owning-an-electric-vehicle.html
* https://www.bchydro.com/accounts-billing/rates-energy-use/electricity-rates/residential-rates.html
* https://www.caa.ca/carcosts/
* https://www.caa.ca/electric-vehicles/
* http://www.cbc.ca/news/canada/british-columbia/electric-car-drivers-fees-charge-stations-1.4178795
* http://www.driveelectricmn.org/charging/
* https://www.epa.gov/greenvehicles/greenhouse-gas-emissions-typical-passenger-vehicle
* https://www.fueleconomy.gov/feg/Find.do?action=sbs&id=38557
* http://www.nextgreencar.com/
* http://www2.nrcan.gc.ca/eneene/sources/pripri/prices_bycity_e.cfm?productID=1&locationID=2&frequency=D&priceYear=2018&Redisplay=
* http://pacificanalytics.ca/sites/default/files/reports/Vehicle%20Greenhouse%20Gases%20to%202030%
* http://vancouver.ca/green-vancouver/greenest-city-action-plan.aspx


## Free Assets used
* Font Awesome icons: https://fontawesome.com/
* Circuit background: http://nadyn.biz/circuit-board-backgrounds-56-wallpapers/

Other icons and branding were created by Chris Yee.

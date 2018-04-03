# TrailCrew - Submission for the 2018 App Challenge

## Mission Statement 
High volumes of traffic in the National and Provincial Parks across Canada has had a positive impact on Canadian tourism. After last years celebrations of Canada 150th birthday, where all the public was granted free access to the National Parks across the country, one must ask themselves how these increased numbers have affected the park. With large areas to maintain and an ever decreasing budget, it has become increasingly more difficult to properly monitor and protect Canada’s natural areas. High costs and unrealistic manhours would be associated with obtaining all the necessary information about the trails and recreation areas within the Parks.  
Why not use the increasing numbers of the public to aid in collection of real time data through trail, wildlife and facility reports? Introducing TrailCrew, a native mobile and web application that brings together outdoor enthusiasts together with parks staff to help report and maintain the natural world. The goal of this application is to crowdsource the collection of trail information, to allow for better delegation of resources and up to date information on trails and park facilities in the area.  

## About the App
The TrailCrew application is used for two primary purposes: for Parks staff to report, analyse and better allocate their resources and for the public to report real time issues for the parks in their area. Therefore, the app has been implemented as two main interfaces, the mobile app and the web app. Watch our [YouTube walk through here.](https://www.youtube.com/watch?v=btVuybh5eh8&feature=youtu.be "You Tube Walk Through")

#### Native Mobile App - ESRI AppStudio
The mobile app is to be used by the public (or parks staff) to collect data through the reporting of maintenance, wildlife and park abuse issues. The mobile app functions for reporting an issue include:
* Selecting the report type: Users can categorize their report as either a maintenance requests, wildlife sightings, or park abuse. 
* Adding the location: The user can allow the app to use their current location to select where the reported issue occurred, or they can manually select the location on the map.
* Adding a photo: The user can use the camera on their mobile devise to document the issue being reported. This can be done by taking a photo or selecting an existing photo from the phones camera album. 
* Adding Details: Allows the user to add the date the issue occurred, select the issue subtype, and add any additional comments before saving and uploading the report. 
ESRI’s AppStudio was used to generate this application as opposed to the web application and form tools because it would allow for future use of AppStudio’s offline capabilities. This would allow the user the save the report as a draft to be uploaded when connected to the internet when they re-enter a service area.

#### Web App - ESRI WebApp Builder 
The web app is to be used by parks staff to analyse the crowdsourced data collected by users of the mobile app. The web app displays spatial data that park staff can then use to perform analysis and better understand issues to properly allocate resources. The app uses open source data from Geogratis to populate trails throughout Alberta [1], as well as the boundaries for various parks and protected areas within Alberta[2]. The desktop app includes the following widgets
* A legend: Including the three main report types: maintenance requests, wildlife sightings and park abuse. With symbolic icons reflecting the subtype of incident reported. The legend also includes the different parks and protected areas in Alberta. 
Data Filter: Allows the user to view data related to a specific issue by filtering out unwanted report types. 
* Bookmark: This widget allows for the user to save desired locations for quick links to popular areas. 
*	Near Me: is a geocoder that allows the user to show only the features within set radius of their location.
*	About the App: includes the mission statement and basic information about the app.

## Future Improvements
Moving forward the mobile application could be further developed to provide real time trail information to users. This would be an incentive for the public to use app and collect data as it would also influence their enjoyment of the provinces natural areas. The desktop application could be augmented by including statistical analysis, such as heat maps for wildlife sightings, for park staff for better understand and interpret the data being collected. 

## Open Source Data Used 
[1] “Transport networks in Canada - CanVec Series - Transport features”, Government of Canada. [Online] https://open.canada.ca/data/en/dataset/2dac78ba-8543-48a6-8f07-faeef56f9895 
[2] “Downloadable Data Sets”, Alberta Parks. [Online] https://www.albertaparks.ca/albertaparksca/library/downloadable-data-sets/ 

## About the Team

#### Morgan Moe
Morgan is a third year Geomatics Engineering Student at the University of Calgary. Morgan is from Calgary, Alberta, and has a previous degree in Kinesiology from the University of Calgary. Morgan is an ESRI student associate and she enjoys paragliding, hiking and mapping with UAVs. 
#### Jamie Horrelt 
Jamie is a third year Geomatics Engineering Student at University of Calgary. Jamie is from Prince Edward Island and has a previous degree in Business Administration from Bishop’s University. Jamie enjoys hiking, skiing and spending countless hours in the computer lab.
#### Jeffrey Plett
Jeff is a third year Geomatics Engineering Student at University of Calgary. Jeff enjoys hiking, biking and backcountry camping. Jeff works for Parks Canada in the summer at Riding Mountain National Park and he has a passion for using Geomatics technologies to solve Parks related issues.   
# marauders2018

**Mission Statement**
            
The current energy climate in Canada and the United States is heavily reliant on the concept of centralized generation facilities. These facilities are commonly decades old and are connected to a network of high voltage power lines that distribute energy to end users, often hundreds of kilometres away. These systems are commonly dependent on non-renewable and environmentally unfriendly energy sources. They are also notoriously susceptible to power outages and are expensive to maintain; not to mention the end user must pay for transmission and distribution fees for transporting the energy. The shortcomings of the modern Canadian energy system to adapt to advanced technologies has left the door wide open for new, innovative ideas.

Decentralized energy (a.k.a. distributed or on-site generation) is a modern electrical generation strategy with a simple core concept: generate energy where it is needed. This is a feasible strategy for any community, especially with the recent advances and subsequent price drops in renewable energy. Decentralized energy is also highly resilient as it  functions autonomously in localized areas. This means that any power outages on the central grid will not leave communities connected to a microgrid without power. Our app seeks to show the potential and feasibility of decentralized energy when applied to a prominent Canadian city: Calgary, Alberta.

**App Characteristics**

Energy Revolution demonstrates the feasibility of decentralized energy systems (DESs) by creating matrices showing the potential renewable energy that can be generated from each dissemination area (DA) in Calgary. DAs are the smallest standard unit of geography distributed by Statistics Canada, and for the purposes of our app are assumed to be an appropriate representation of a single microgrid. Since decentralized energy is heavily reliant on renewables, which are inherently variable in their power output, an effective network should have a multi-tiered source of energy inputs. This app considers two sources of renewable energy, solar and biogas.

**Solar Energy** 

Solar power is energy from the sun that can be converted into thermal or electrical energy. By clicking on a DA, the user can determine the total number of solar panels that can be supported and how much potential energy can be generated from solar output alone. Even more specifically, the user can zoom in further and click on a single building to identify the amount of solar panels and solar output of that building alone. This app also includes interactive elements that allows the user to draw custom areas on the map, which will provide the set of solar statistics previously mentioned.

**Biogas Energy**

Biogas is another form of clean energy that creates energy from raw materials, such as waste. Our app approximates energy production from biogas using estimates of food waste created by the population in a DA. 

This app allows greater active participation of consumers, as DESs can be tailored to match their requirements as they become the producers themselves. By identifying the economic, social and environmental benefits through an efficient, resilient, low-cost microgrid system, we hope this application can persuade users to promote decentralized energy as the future of energy.

**Development** 

This application utilizes a combination of several open source web services and development platforms. The two web apps consist of two primary components. The first component consists of a Leaflet Web Map API hosted within the R Studio Shiny web application framework and front-end languages (HTML, CSS, JavaScript). Matrices were automatically created using the Stplanr package in R and injected into the shiny app using rgdal, an open source GIS package. The second component consists of pure HTML, CSS, and JavaScript using the Leaflet and ESRI-Leaflet API. The ESRI-Leaflet API consists of the different basemap layers and their geocoding service, which enables to type in their address and zoom in to their location. Python was also used to automaticaly generate different HTML pages (representing each neighborhood) along with JS files containing separate GeoJSON information of the buildings. 

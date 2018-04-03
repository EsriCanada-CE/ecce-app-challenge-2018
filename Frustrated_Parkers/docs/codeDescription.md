#**Application Files description**

##Folders
* Assets: folder containing images used for the application icons.
* Controls: folder containing all the controls used in the application: panes, tool buttons, floating buttons and popups.
* Fonts: folder containing fonts used in the application.
* Images: folder containing all the images used in the application.
* Tasks: folder containing qml files representing route and closest facility tasks. We splitted this classes for a better understanding of the code.
* Views: folder containing qml files for secondary views including in the main views of the app, such as map and geocoding views.

##Main Files
* MyApp: main app file. It links the main two app components: MainPage and Menu Page.
* Main Page: qml file which implements the welcome page of the application. It is a swiping view composed by several MainDelegates (other qml file).
* Menu page: qml file which implements the menu drawer interface that contains all the options and functionalities. It is composed by five Web maps (WemMapPage.qml), one Closest facility functionality (ClosestFacility.qml), one MyCarPage.qml and an about page (AboutPage.qml).
* WeMapPage: qml file implementing a web map view. It will implement the following functionality of the app: explore car parking, Snow restricted parking, Car pooling and electric car parking, explore bicycle parking and explore parking tickets.
* ClosestFacility: qml file implementing the find closest parking lots functionality.
* MyCarPage: qml file implementing the Park my Vehicle functionality.
* AboutPage: qml file implementing a page for about information.
* SideMenuPanel: qml for the side menu panel of the menu drawer (showing menu options).
* tasks/ClosestTask: qml file implementing a ClosestFacilityTask.
* tasks/RouteTask: qml file implementing a RouteTask.
* views/GeocodeView: qml file for the Geocoding functionality.
* views/MapArea: qml file implementing a common mapview for the web maps. They are handled using the mapid for each web map functionality.
* views/Legend: qml file for the map legend.
* views/Sublayers: qml file for the layers control panel.


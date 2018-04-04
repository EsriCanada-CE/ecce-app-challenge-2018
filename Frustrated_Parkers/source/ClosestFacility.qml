import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import ArcGIS.AppFramework 1.0

import Esri.ArcGISRuntime 100.1
import "./views"
import "./controls"
import "./tasks"

//Page to calculate the closest parking lot. It loads the feature layer from ArcGIS online and query the features to add
//them to the facilities list of the closest facility task

Page{
        anchors.fill: parent
        signal openMenu()
        property string titleText:""
        property var descText
        property bool busy: false
        property bool featureLoaded: false
        property string message: ""

        //Variable to store the facilities (parking lots)
        property var facilities: []
        //Params for the closest Facility calculation
        property var facilityParams: null

        //Page header
        header: ToolBar{
            contentHeight: 56*app.scaleFactor
            Material.primary: app.secondaryColor
            RowLayout {
                anchors.fill: parent
                spacing: 0
                Item{
                    Layout.preferredWidth: 4*app.scaleFactor
                    Layout.fillHeight: true
                }
                ToolButton {
                    indicator: Image{
                        width: parent.width*0.5
                        height: parent.height*0.5
                        anchors.centerIn: parent
                        source: "./assets/menu.png"
                        fillMode: Image.PreserveAspectFit
                        mipmap: true
                    }
                    onClicked: {
                        openMenu();
                    }
                }
                Item{
                    Layout.preferredWidth: 20*app.scaleFactor
                    Layout.fillHeight: true
                }
                Label {
                    Layout.fillWidth: true
                    text: titleText
                    elide: Label.ElideRight
                    horizontalAlignment: Qt.AlignLeft
                    verticalAlignment: Qt.AlignVCenter
                    font.pixelSize: app.subtitleFontSize
                    color: app.primaryColor
                }

            }
        }

        contentItem: Rectangle{
            anchors.top:header.bottom

            // Map view
            MapView {
                id: mapView

                anchors.fill: parent

                //Map component
                Map {

                    BasemapStreets {}

                    //Center the map view to toronto
                    initialViewpoint: ViewpointCenter {
                        Point {
                           x:  -79.384707
                           y: 43.667577
                           spatialReference: SpatialReference.createWgs84()
                        }
                        targetScale: 8e5
                    }

                    //Parking lots feature layer
                    FeatureLayer {
                        id: parkingLots
                        selectionColor: "#8B00CD"
                        selectionWidth: 5
                        //It is set to false to only show the selected features
                        visible:false

                        //Parameters for the query (only public parking spots will be queried)
                        QueryParameters {
                            id: queryParams
                            returnGeometry: true
                            whereClause:"Access='Public'"
                        }

                        // feature table
                        ServiceFeatureTable {
                            id: featureTable2
                            url: "https://services1.arcgis.com/56dETZIzFXStwLka/arcgis/rest/services/Parking_Lots/FeatureServer/0"
                        }
                        onLoadStatusChanged: {
                            //Once the layer is loaded, query the features to get the coordinates and add it to the facility list
                            selectFeaturesWithQuery(queryParams, Enums.SelectionModeNew);
                        }
                        // signal handler for selecting features
                        onSelectFeaturesStatusChanged: {
                            if (selectFeaturesStatus === Enums.TaskStatusCompleted) {
                                //We tried to include all the resulting points from the query in the facility list for the ClosestFacility calculation
                                //However, after 100 points, it gets really slow.
                                //We decided to take a sample of the points to show the functionality.
                                //To add all the points, a while loop could be placed here. See commented code below
                                /*
                                while (selectFeaturesResult.iterator.hasNext) {
                                    var feat  = selectFeaturesResult.iterator.next();
                                    var pointQuery = ArcGISRuntimeEnvironment.createObject("Graphic", {geometry: feat.geometry});
                                    var facility = ArcGISRuntimeEnvironment.createObject("Facility", {geometry: pointQuery.geometry});
                                        facilities.push(facility);
                                }*/

                                //We included 10 random public parkings for the facility list
                                for(var k = 0; k < 10 ; k++){
                                    var feat  = selectFeaturesResult.iterator.next();
                                    var pointQuery = ArcGISRuntimeEnvironment.createObject("Graphic", {geometry: feat.geometry});
                                    facilitiesOverlay.graphics.append(pointQuery);
                                    var facility = ArcGISRuntimeEnvironment.createObject("Facility", {geometry: pointQuery.geometry});
                                    facilities.push(facility);
                                }
                                facilityParams.setFacilities(facilities);
                            }
                        }
                    }

                    onLoadStatusChanged: {
                       //load facility task
                        task.load();
                    }
                }

                //Graphics to draw the results from the closest facility calculation
                GraphicsOverlay {
                    id: resultsOverlay
                }

                //Graphics to draw the selected public parking spots
                GraphicsOverlay {
                    id: facilitiesOverlay
                    renderer: SimpleRenderer {
                        symbol: PictureMarkerSymbol {
                            url:"./images/public.png"
                            height: 30
                            width: 30
                        }
                    }
                }

                //Clicking on the map will activate the closest parking lot calculation
                onMouseClicked: {
                    if (busy === true)
                        return;

                    if (facilityParams === null)
                        return;

                    featureLoaded=true;

                    //Clear previous results
                    resultsOverlay.graphics.clear();

                    //Create the incident on the point clicked
                    var incidentGraphic = ArcGISRuntimeEnvironment.createObject(
                                "Graphic", {geometry: mouse.mapPoint, symbol: incidentSymbol});
                    resultsOverlay.graphics.append(incidentGraphic);

                    solveRoute(mouse.mapPoint);

                    //Solve the closest facility calculation
                    function solveRoute(incidentPoint) {

                        var incident = ArcGISRuntimeEnvironment.createObject("Incident", {geometry: incidentPoint});
                        facilityParams.setIncidents( [ incident ] );
                        busy = true;
                        message = "";
                        task.solveClosestFacility(facilityParams);

                    }
                }


                //Including a button to calculate the closest parking lot based on your location
                ColumnLayout{
                    width: 50*app.scaleFactor
                    height: mapView.mapRotation != 0 ? 150*app.scaleFactor + spacing*2 : 100*app.scaleFactor + spacing
                    anchors {
                        right: parent.right
                        rightMargin: 5*app.scaleFactor
                        bottom: parent.bottom
                        //bottomMargin: 10*app.scaleFactor
                        bottomMargin: (parent.height-height)/2
                    }
                    spacing: 1*app.scaleFactor

                    Behavior on anchors.bottomMargin {
                        NumberAnimation {duration: 200}
                    }

                    property color btnColor: "#808080"
                    property color btnActiveColor: "#08452F"

                   MapRoundButton{
                        id: locationBtn
                        Layout.fillWidth: true
                        Layout.preferredHeight: parent.width
                        radius: parent.width/2
                        checkable: true
                        imageColor: positionSource.active && checked ? parent.btnActiveColor : parent.btnColor
                        imageSource: "./images/location.png"
                        onClicked: {
                            if (!mapView.locationDisplay.started) {
                                positionSource.update();

                                //Get the current position
                                var currentPositionPoint = ArcGISRuntimeEnvironment.createObject("Point", {x: positionSource.position.coordinate.longitude, y: positionSource.position.coordinate.latitude, spatialReference: SpatialReference.createWgs84()});

                                //Project the point to the map coordinates
                                var centerPoint = GeometryEngine.project(currentPositionPoint, mapView.spatialReference);

                                var viewPointCenter = ArcGISRuntimeEnvironment.createObject("ViewpointCenter",{center: centerPoint, targetScale: 10000});
                                mapView.setViewpointWithAnimationCurve(viewPointCenter, 2.0,  Enums.AnimationCurveEaseInOutCubic);
                                mapView.locationDisplay.start();
                                mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeRecenter;

                                //Clear results from the last calculation
                                resultsOverlay.graphics.clear();

                                //Create an incident point
                                var incidentGraphic = ArcGISRuntimeEnvironment.createObject(
                                            "Graphic", {geometry:centerPoint, symbol: incidentSymbol});

                                //Add it to the view
                                resultsOverlay.graphics.append(incidentGraphic);

                                solveRoute(incidentGraphic.geometry);

                                //Calculate the closest facility
                                function solveRoute(incidentPoint) {
                                    var incident = ArcGISRuntimeEnvironment.createObject("Incident", {geometry: incidentPoint});
                                    facilityParams.setIncidents( [ incident ] );
                                    busy = true;
                                    message = "";
                                    task.solveClosestFacility(facilityParams);
                                }

                            } else {
                                mapView.locationDisplay.stop();
                            }
                        }
                    }
                }

                locationDisplay {
                    positionSource: positionSource

                }


            }

            //Simbol to draw the incidents
            SimpleMarkerSymbol {
                id: incidentSymbol
                style: "SimpleMarkerSymbolStyleCross"
                color: "black"
                size: 20
            }

            //Simbol to draw the routes
            SimpleLineSymbol {
                id: routeSymbol
                style: "SimpleLineSymbolStyleSolid"
                color: "#8f499c"
                width: 4.0
            }

            //Closest facility task
            ClosestTask{
               id:task

            }

            BusyIndicator {
                Material.accent: "#8f499c"
                anchors.centerIn: parent
                running: busy
            }


        }


        //Bar to show the instructions at the bottom of the page
        Rectangle {
            id: statusBar
            anchors {
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            height: 60 * scaleFactor
            color: "lightgrey"
            border {
                width: 0.5 * scaleFactor
                color: "black"
            }


            Label{
                id:statusBarText
                Layout.preferredWidth: parent.width*0.8
                anchors {
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    leftMargin: 10 * scaleFactor
                }
                padding:10*scaleFactor
                font.family: app.fontFamily.name
                font.pixelSize: 14 * scaleFactor
                bottomPadding: 5*scaleFactor
                text: "Click on a point on the map to find the closest parking lot. To find the closest parking lot from your location, click the location button on the right"
                color: app.secondaryColor
                wrapMode: Text.Wrap
                horizontalAlignment: Text.AlignHCenter
                anchors.horizontalCenter: parent.horizontalCenter
            }

        }
    }


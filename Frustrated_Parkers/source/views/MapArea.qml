import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.1

import QtPositioning 5.3
import QtSensors 5.3

import "../controls"

//Common mapview to display the web maps
MapView{
    id: mapView

    //Graphics layers to draw results and points
    property alias pointGraphicsOverlay: pointGraphicsOverlay
    property alias routeGraphicsOverlay: routeGraphicsOverlay
    property alias directionButton: directionButton
    property alias routeSymbol: routeSymbol

    //Property that will hold the mapid for each webmap
    property string mapid2

    zoomByPinchingEnabled: true
    rotationByPinchingEnabled: true
    wrapAroundMode: Enums.WrapAroundModeEnabledWhenSupported

    // set the transform to animate showing the direction window
    transform: Translate {
        id: translate
        x: 0
        y:0
        Behavior on x { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
        Behavior on y { NumberAnimation { duration: 300; easing.type: Easing.OutQuad } }
    }


    //Map definition
    Map{
        id: map

        //Loading the web map depending on the map id
        initUrl: "http://unbgis.maps.arcgis.com/sharing/rest/content/items/"+mapid2

        onLoadErrorChanged:{
            console.log(mapView.map.loadError.additionalMessage)
        }
        onLoadStatusChanged: {

            if(mapView.map.loadStatus === Enums.LoadStatusLoaded){
                //Loading the legend for each webmap
                legendInfoListModel = mapView.map.legendInfos
                legendInfoListModel.fetchLegendInfos(true)
                //Center the map in toronto with an animation
                var toronto = ArcGISRuntimeEnvironment.createObject("Point", {x: -79.384707, y: 43.667577, spatialReference: SpatialReference.createWgs84()});
                var centerPoint = GeometryEngine.project(toronto, mapView.spatialReference);
                var viewPointCenter = ArcGISRuntimeEnvironment.createObject("ViewpointCenter",{center: centerPoint, targetScale: 8e5});
                mapView.setViewpointWithAnimationCurve(viewPointCenter, 4.0,  Enums.AnimationCurveEaseInOutCubic);

            }

            //Setup the RouteTask once the map is loaded
            setupRouteTask();

        }

        function setupRouteTask() {
            // load the RouteTask
            routeTask.load();
        }

    }


    //Location button to center in the current location
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
            imageSource: "../images/location.png"
            onClicked: {
                if (!mapView.locationDisplay.started) {
                    zoomToCurrentLocation();
                    mapView.locationDisplay.start();
                    mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeRecenter;
                } else {
                    mapView.locationDisplay.stop();
                }
            }
        }
    }

    //Point graphics overlay
    GraphicsOverlay {
        id: pointGraphicsOverlay
        SimpleRenderer {
            PictureMarkerSymbol{
                width: 38*app.scaleFactor
                height: 38*app.scaleFactor
                url: "../images/pin.png"
            }
        }
    }


    // Create a GraphicsOverlay to display the route
    GraphicsOverlay {
        id: routeGraphicsOverlay

        // Set the renderer
        SimpleRenderer {
            SimpleLineSymbol {
                color: "#8B00CD"
                style: Enums.SimpleLineSymbolStyleSolid
                width: 4
            }
        }
    }

    SimpleLineSymbol {
        id: routeSymbol
        style: "SimpleLineSymbolStyleSolid"
        color: "#8f499c"
        width: 4.0
    }

    onSetViewpointCompleted: {
        pointGraphicsOverlay.visible = true;
    }

    locationDisplay {
        positionSource: positionSource
    }


   //Map functions
   function zoomToCurrentLocation(){
        positionSource.update();
        var currentPositionPoint = ArcGISRuntimeEnvironment.createObject("Point", {x: positionSource.position.coordinate.longitude, y: positionSource.position.coordinate.latitude, spatialReference: SpatialReference.createWgs84()});
        var centerPoint = GeometryEngine.project(currentPositionPoint, mapView.spatialReference);
        var viewPointCenter = ArcGISRuntimeEnvironment.createObject("ViewpointCenter",{center: centerPoint, targetScale: 10000});
        mapView.setViewpointWithAnimationCurve(viewPointCenter, 2.0,  Enums.AnimationCurveEaseInOutCubic);
    }

    function zoomToPoint(point){
        var centerPoint = GeometryEngine.project(point, mapView.spatialReference);
        var viewPointCenter = ArcGISRuntimeEnvironment.createObject("ViewpointCenter",{center: centerPoint, targetScale: 10000});
        mapView.setViewpointWithAnimationCurve(viewPointCenter, 4.0,  Enums.AnimationCurveEaseInOutCubic);

    }

    function showPin(point){
        pointGraphicsOverlay.visible = false;
        pointGraphicsOverlay.graphics.remove(0, 1);
        var pictureMarkerSymbol = ArcGISRuntimeEnvironment.createObject("PictureMarkerSymbol", {width: 40*app.scaleFactor, height: 40*app.scaleFactor, url: "../images/pin.png"});
        var graphic = ArcGISRuntimeEnvironment.createObject("Graphic", {geometry: point});
        pointGraphicsOverlay.graphics.insert(0, graphic);
    }

    //Busy Indicator
    BusyIndicator {
        anchors.centerIn: parent
        height: 48 * scaleFactor
        width: height
        running: true
        Material.accent:"#8f499c"
        visible: (mapView.drawStatus === Enums.DrawStatusInProgress)
    }

    // Signal handler for mouse click event on the map view
    onMouseClicked: {
        if(!ready) return;

        var tolerance = 10;
        var returnPopupsOnly = true;
        var maximumResults = 2;
        mapView.identifyLayersWithMaxResults(mouse.x, mouse.y, tolerance, returnPopupsOnly, maximumResults);

        //Added for route calculation (it will hold the point in case the user use the routing option)
        routepoint = ArcGISRuntimeEnvironment.createObject("Point", {x: mouse.mapX,
                                                               y: mouse.mapY,
                                                               spatialReference: SpatialReference.createWebMercator()});
        routeButton.visible=false

    }

    // Signal handler for identifying features
    onIdentifyLayersStatusChanged: {
        if (identifyLayersStatus === Enums.TaskStatusCompleted) {

            pointGraphicsOverlay.graphics.clear()
            popupListModel.clear()
            // No results found
            if(identifyLayersResults.length === 0) return;

            // Going through individual Layer results list
            // individual layer result can be from a FeatureLayer or MapServiceLayer

            for(var k = 0; k < identifyLayersResults.length ; k++){
                var identifyLayerResult = identifyLayersResults[k];
                if(identifyLayerResult.sublayerResults && identifyLayerResult.sublayerResults.length > 0){
                    // Results are from Map Service Layer
                    for(var i = 0; i < identifyLayerResult.sublayerResults.length; i++){
                        var subLayerResult = identifyLayerResult.sublayerResults[i];
                        // iterate through individual features of the sub layer results
                        for(var j = 0; j < subLayerResult.popups.length; j++){
                            var popup = subLayerResult.popups[j];
                            selectedFeature = popup.geoElement;
                            popupDef = popup.popupDefinition;
                            // Appending the result to the model
                            var newPopup = ArcGISRuntimeEnvironment.createObject("Popup", {
                                                                                     initGeoElement: selectedFeature,
                                                                                     initPopupDefinition: popupDef
                                                                                 });
                            // create a popup manager
                            var  newPopupManager = ArcGISRuntimeEnvironment.createObject("PopupManager", {popup: newPopup});
                            popupListModel.append({'popupManager': newPopupManager})


                        }
                    }
                }else{
                    // Results are from Feature Layer
                    // iterate through individual features of the feature Layer results
                    for(var f = 0; f < identifyLayerResult.popups.length; f++){
                        popup = identifyLayerResult.popups[f];
                        selectedFeature = popup.geoElement;
                        popupDef = popup.popupDefinition;
                        // Appending the result to the model
                        newPopup = ArcGISRuntimeEnvironment.createObject("Popup", {
                                                                             initGeoElement: selectedFeature,
                                                                             initPopupDefinition: popupDef
                                                                         });

                        // create a popup manager
                        newPopupManager = ArcGISRuntimeEnvironment.createObject("PopupManager", {popup: newPopup});
                        popupListModel.append({'popupManager': newPopupManager});
                        //Added for route calculation
                        //routepoint = selectedFeature
                        routeButton.visible=true
                    }
                }

            }


        } else if (identifyLayersStatus === Enums.TaskStatusErrored) {
            console.log(errorString);
        }
    }

    // Create a button to show the direction window
    Rectangle {
        id: directionButton

        property bool pressed: false

        visible: false
        anchors {
            right: parent.right
            rightMargin: 5*app.scaleFactor
            bottom: parent.bottom
            //bottomMargin: 10*app.scaleFactor
            bottomMargin: (parent.height-height)/2.5
        }

        width: 45 * scaleFactor
        height: width
        color: pressed ? "#959595" : "#D6D6D6"
        radius: 100
        border {
            color: "#585858"
            width: 1.5 * scaleFactor
        }

        Image {
            anchors.centerIn: parent
            width: 35 * scaleFactor
            height: width
            source: "../assets/menu2.png"
        }

        MouseArea {
            anchors.fill: parent
            onPressed: directionButton.pressed = true
            onReleased: directionButton.pressed = false
            onClicked: {
                // Show the direction window when it is clicked
                translate.x = directionWindow.visible ? 0 : (directionWindow.width * -1);
                directionWindow.visible = !directionWindow.visible;
            }
        }
    }

    //Button for route calculations (only active if a feature is selected)
    FloatActionButtonRoute{
        id:routeButton
        visible:false
    }

}






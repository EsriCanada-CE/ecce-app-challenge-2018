import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import ArcGIS.AppFramework 1.0
import QtPositioning 5.3
import QtSensors 5.3
import QtQuick.Dialogs 1.2


import Esri.ArcGISRuntime 100.1

import "controls" as Controls
import "views"

Page {
    id:page
    signal openMenu()

    property string titleText:""
    property var descText


    property string sampleName

    /*property string compassMode: "Compass"
    property string recenterMode: "Re-Center"
    property string closeMode: "Close"
    property string currentModeText: recenterMode
    property string currentModeImage:"assets/Re-Center.png"*/


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

    // sample starts here ------------------------------------------------------------------
    contentItem: Rectangle{
        anchors.top:header.bottom

         // Create MapView
        MapView {
            id: mapView
            anchors.fill: parent
            Map {
                BasemapStreets {}

               initialViewpoint: ViewpointCenter {
                    id: viewPoint
                    center: Point {
                        x: -79.391472
                        y: 43.702352
                        spatialReference: SpatialReference {wkid: 4326}
                    }
                    targetScale: 8e5
                }
               onLoadStatusChanged: {
                  // initUrl : mapView.map.initUrl
                   if(mapView.map.loadStatus === Enums.LoadStatusLoaded){
                       if(tempGraphic===undefined){

                       }else{

                        graphicsOverlay.graphics.append(tempGraphic);
                       }

                   }
               }





            }

            ColumnLayout{
                width: 50*app.scaleFactor
                height: mapView.mapRotation != 0 ? 150*app.scaleFactor + spacing*2 : 100*app.scaleFactor + spacing
                anchors {
                    right: parent.right
                    rightMargin: 10*app.scaleFactor
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

               Controls.MapRoundButton{
                    id: locationBtn
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.width
                    radius: parent.width/2
                    checkable: true
                    imageColor: positionSource.active && checked ? parent.btnActiveColor : parent.btnColor
                    imageSource: "./images/location.png"
                    onClicked: {
                        if (!mapView.locationDisplay.started) {
                            //zoomToCurrentLocation();
                            mapView.locationDisplay.start();
                            mapView.locationDisplay.autoPanMode = Enums.LocationDisplayAutoPanModeRecenter;
                        } else {
                            mapView.locationDisplay.stop();
                        }
                    }
                }
            }


            //Layer to store car Location
            GraphicsOverlay {
                id: graphicsOverlay
            }

            // set the location display's position source
            locationDisplay {
                positionSource: positionSource
            }



            //! Add Graphics
            onMouseClicked: {  // mouseClicked came from the MapView
                var tolerance = 22;
                var returnPopupsOnly = false;
                var maximumResults = 1000;




                var date =new Date();
                var symbol;
                var name;

                //check if the user clicked bike or car
               // console.log(sampleName);
                if(sampleName==="Bicycle"){
                    symbol=bikeSymbol;
                    name="My Bike"

                }else{
                    name= "My Car";
                    symbol=carSymbol;
                }


                tempGraphic =createGraphic(mouse.mapPoint, symbol,name,date);

                //Check if a existing vehicle has been clicked
                mapView.identifyGraphicsOverlayWithMaxResults(graphicsOverlay, mouse.x, mouse.y, tolerance, returnPopupsOnly, maximumResults);


            }

            // Signal handler for identify graphics overlay
            onIdentifyGraphicsOverlayStatusChanged: {

                if (identifyGraphicsOverlayStatus === Enums.TaskStatusCompleted) {
                    if (identifyGraphicsOverlayResult.graphics.length > 0) {
                        console.log(identifyGraphicsOverlayResult.graphics[0].attributes.count);
                        console.log(identifyGraphicsOverlayResult.graphics[0].attributes.attributeValue("name"));
                        console.log(identifyGraphicsOverlayResult.graphics[0].attributes.attributeValue("time"));

                        var date = identifyGraphicsOverlayResult.graphics[0].attributes.attributeValue("time");
                        popUpAttributes.clearAttributes();
                        popUpAttributes.addAttribute("name",identifyGraphicsOverlayResult.graphics[0].attributes.attributeValue("name"))
                        popUpAttributes.addAttribute("Time parked",Qt.formatDateTime(date, "dd-MM-yy hh:mm"))

                        var date2 = new Date().getTime();

                        var dif = date2-date.getTime();
                        dif=dif/1000;
                        dif=dif/60;
                        popUpAttributes.addAttribute("It's been",dif.toFixed(2).toString()+" minutes")

                        popUpAttributes.visible = 1

                    }
                    else{
                        graphicsOverlay.graphics.clear();
                        // create attributes for the new feature
                        var date =Qt.formatDateTime(new Date(), "dd-MM-yy hh:mm:ss.zzz");
                        var featureAttributes = {"name" : "My Car", "time" : date};
                        graphicsOverlay.graphics.append(tempGraphic);
                    }
                } else if (identifyGraphicsOverlayStatus === Enums.TaskStatusErrored) {
                    console.log("error");
                }

            }
        }

        MessageDialog {
            id: msgDialog
            text: "Tapped on graphic"
        }

        Rectangle {
            id: rect
            anchors.fill: parent
            visible: autoPanListView.visible
            color: "black"
            opacity: 0.7
        }

        ListView {
            id: autoPanListView
            anchors {
                right: parent.right
                bottom: parent.bottom
                margins: 10 * scaleFactor
            }
            visible: false
            width: parent.width
            height: 150 * scaleFactor
            spacing: 10 * scaleFactor
            model: ListModel {
                id: autoPanListModel
            }

            delegate: Row {
                id: autopanRow
                anchors.right: parent.right
                spacing: 10

                Text {
                    text: name
                    font.pixelSize: 25 * scaleFactor
                    color: "white"
                    MouseArea {
                        anchors.fill: parent
                        // When an item in the list view is clicked
                        onClicked: {
                            autopanRow.updateAutoPanMode();
                        }
                    }
                }

                Image {
                    source: image
                    width: 40 * scaleFactor
                    height: width
                    MouseArea {
                        anchors.fill: parent
                        // When an item in the list view is clicked
                        onClicked: {
                            autopanRow.updateAutoPanMode();
                        }
                    }
                }


            }
        }

    }

    // buoy symbol
    PictureMarkerSymbol {
        id: carSymbol
        url: "./images/car.png"
        width: 50.0
        height: 50.0
    }

    // buoy symbol
    PictureMarkerSymbol {
        id: bikeSymbol
        url: "./images/bike.png"
        width: 50.0
        height: 50.0
    }

// sample ends here ------------------------------------------------------------------------
    // create and return a graphic
    function createGraphic(geometry, symbol,name,date) {
        var graphic = ArcGISRuntimeEnvironment.createObject("Graphic");
        graphic.geometry = geometry;
        graphic.attributes.insertAttribute("name", name);
        graphic.attributes.insertAttribute("time", date);
        graphic.symbol = symbol;
        return graphic;
    }


    Controls.FloatActionButton{
        id:switchBtn
    }

    Controls.PopUpPage{
        id:popUp
        visible:false
    }

    Controls.PopUpAttributes{
        id:popUpAttributes
        visible:false
    }

    Component.onCompleted: {
        if(tempGraphic===undefined){
             popUp.visible = 1
        }else{


        }
    }

}

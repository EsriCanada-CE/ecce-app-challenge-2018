import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import ArcGIS.AppFramework 1.0

import Esri.ArcGISRuntime 100.1
import "./views"
import "./controls"
import "./tasks"

/*
  Page containing a web map that will load a different map depending on which menu option is pressed
  */

Page {
    id:page

    signal openMenu()

    //Scale factor
    property real scaleFactor: AppFramework.displayScaleFactor

    //Options taken from the component definition (menu)
    property string titleText:""
    property var descText
    //Map id for loading the web map
    property string mapid
    //Booleans to know when to load legends/layer control
    property bool legend
    property bool layers
    //Numbers to fit the lengend and layers control depending on the web map loaded
    property real legendScale
    property real layerScale

   // property string displayText: "Click or tap to select features."

    //Variables for the pop up window displaying the identified features
    property var popupDef:null
    property string popupTitle
    property real curIndx: -1

    //Variable to keep the Point to calculate route
    property var routepoint
    //Route parameters
    property var routeParameters: null
    //Model for the list to show the route directions
    property var directionListModel: null

    //property bool closestFacilityActive: false

    //List model to show the map legend
    property LegendInfoListModel legendInfoListModel:null
    property bool ready: mapArea.map.loadStatus === Enums.LoadStatusLoaded
    //Selected feature
    property var selectedFeature: null

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

    Rectangle{
        anchors.fill: parent
        color: app.appBackgroundColor

        //Window for displaying the route directions
        Rectangle {
            id: directionWindow
            Material.elevation:4
            anchors {
                right: parent.right
                top: parent.top
                bottom: parent.bottom
            }
            visible: false
            width: Qt.platform.os === "ios" || Qt.platform.os === "android" ? 250 * scaleFactor : 350 * scaleFactor
            color: "#FBFBFB"

            ListView {
                id: directionsView
                anchors {
                    fill: parent
                    margins: 5 * scaleFactor
                }
                header: Component {
                    Text {
                        height: 40 * scaleFactor
                        text: "Directions:"
                        font.pixelSize: 22 * scaleFactor
                    }
                }

                // set the model to the DirectionManeuverListModel returned from the route
                model: directionListModel
                delegate: directionDelegate
            }
        }

        //MapView for loading the web map
        MapArea{
            id: mapArea
            anchors.fill: parent
            mapid2:mapid

            //Legend control
            Legend{
                id:mapLegend
                Material.elevation:1
                visible:false
            }

            //Layers control
            Sublayers{
                id:mapLayers
                Material.elevation:1
                visible:false
            }

            //Geocoding view
            GeocodeView{
                anchors.fill: parent
                currentPoint: parent.currentViewpointCenter.center
                Material.elevation:1
                onResultSelected: {
                    mapArea.zoomToPoint(point);
                    mapArea.showPin(point);
                }
                onSearchTextChanged: {
                    mapArea.pointGraphicsOverlay.visible = false;
                }
            }

            // Neatline rectangle
            Rectangle {
                anchors.fill: parent
                color: "transparent"
                border {
                    width: 0.5 * scaleFactor
                    color: "black"
                }
            }

            //Pane to show the identified features
            Pane {
                id: popupAsDialog
                Material.primary: "lightgrey"
                Material.elevation:2
                padding: 5 * scaleFactor
                visible: popupListModel.count > 0

                anchors {
                    left: parent.left
                    right: parent.right
                    bottom: parent.bottom
                }

                //Swipping view when there is more than one feature selected
                SwipeView{
                    id:swipeView
                    implicitHeight: 150 * scaleFactor
                    implicitWidth: parent.width
                    clip: true
                    Repeater {
                        id: popupViewDialog
                        model:popupListModel
                        Rectangle{
                            color: "lightgrey"
                            clip: true
                            Flickable {
                                anchors.fill:parent
                                contentWidth:parent.width
                                contentHeight: popupColumn.height
                                clip: true
                                flickableDirection: Flickable.VerticalFlick
                                ColumnLayout {
                                    id: popupColumn
                                    width: parent.width *  0.95
                                    anchors.horizontalCenter: parent.horizontalCenter
                                    spacing: 3 * scaleFactor
                                    clip: true
                                    Text {
                                        Layout.preferredWidth:  parent.width
                                        id:itemDesc
                                        text: popupListModel.count> 1? popupManager.popup.title + " (" + curIndx + " of " + popupListModel.count + ")":popupManager.popup.title
                                        elide: Text.ElideRight
                                        color: "black"
                                        font {
                                            pixelSize: 14 * scaleFactor
                                            bold: true
                                        }
                                        renderType: Text.NativeRendering
                                    }
                                    Rectangle {
                                        Layout.preferredWidth: parent.width
                                        Layout.preferredHeight: 2 * scaleFactor
                                        color: "black"
                                    }
                                    Repeater {
                                        model: popupManager.displayedFields
                                        RowLayout {
                                            Layout.fillWidth: true
                                            clip: true
                                            spacing: 5 * scaleFactor
                                            visible: attributeVisible

                                            Text {
                                                Layout.fillWidth: true
                                                Layout.fillHeight: true
                                                text:  label ? label : ""
                                                wrapMode: Text.WrapAnywhere
                                                font.pixelSize: 12 * scaleFactor
                                                color: "gray"
                                            }

                                            Text {
                                                Layout.preferredWidth: popupColumn.width * 0.55
                                                Layout.fillHeight: true
                                                text:formattedValue? formattedValue: popupManager.popup.geoElement.attributes.attributeValue(label)
                                                wrapMode: Text.WrapAnywhere
                                                font.pixelSize: 12 * scaleFactor
                                                color: "#4f4f4f"

                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }

                    onCurrentIndexChanged: {
                        if(currentIndex < 0)return;

                        if(popupListModel.count > 0){
                            var feat = popupListModel.get(currentIndex).popupManager.popup.geoElement;
                            mapArea.pointGraphicsOverlay.graphics.clear()

                            if(feat.geometry.geometryType === Enums.GeometryTypePoint ){
                                var simpleMarker = ArcGISRuntimeEnvironment.createObject("SimpleMarkerSymbol", {color: "#8B00CD", size: 10, style: Enums.SimpleMarkerSymbolStyleCircle});
                                var graphic = ArcGISRuntimeEnvironment.createObject("Graphic", {symbol: simpleMarker, geometry: feat.geometry});
                                // add the graphic to the graphics overlay
                                mapArea.pointGraphicsOverlay.graphics.append(graphic);
                                mapArea.setViewpointCenter(mapArea.pointGraphicsOverlay.extent.center)
                            }else{
                                //graphic = ArcGISRuntimeEnvironment.createObject("Graphic", {symbol: mapArea.simpleFillSymbol, geometry: feat.geometry});
                                //mapArea.polygonGraphicsOverlay.graphics.append(graphic);
                                //mapView.setViewpointGeometryAndPadding(polygonGraphicsOverlay.extent, 100 * scaleFactor)
                            }
                            curIndx = currentIndex + 1
                        }

                    }
                }

            }


            //Loading legend or layers control depending on the web map
            Component.onCompleted: {
                if(legend===true){
                    mapLegend.visible=true
                }

                if(layers===true){
                    mapLayers.visible=true
                }

            }

        }

        //List model for the popup to show the identified features
        ListModel{
            id:popupListModel
        }

}

        //Task for the route calculation
        RouteTask{
            id: routeTask
        }

        //Directions panel to show the route directions
        Component {
            id: directionDelegate
            Rectangle {
                id: rect
                width: parent.width
                height: 35 * scaleFactor
                color: directionWindow.color

                Rectangle {
                    anchors {
                        top: parent.top;
                        left: parent.left;
                        right: parent.right;
                        topMargin: -8 * scaleFactor
                        leftMargin: 20 * scaleFactor
                        rightMargin: 20 * scaleFactor
                    }
                    color: "darkgrey"
                    height: 1 * scaleFactor
                }

                Text {
                    text: directionText
                    anchors {
                        fill: parent
                        leftMargin: 5 * scaleFactor
                    }
                    elide: Text.ElideRight
                    font.pixelSize: 14 * scaleFactor
                }
            }
        }


}

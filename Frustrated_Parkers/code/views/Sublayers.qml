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

//Window to display the layers of each webmap
Rectangle {
    id: layerVisibilityRect
    property bool expanded: false
    Material.elevation:-1
    anchors {
        rightMargin: 10*scaleFactor
        topMargin: 70*scaleFactor
        right: parent.right
        top: parent.top
    }
    height: 40 * scaleFactor
    width: 160 * scaleFactor
    color: "transparent"
    clip: true

    MouseArea {
        anchors.fill: parent
        onClicked: mouse.accepted = true
        onWheel: wheel.accepted = true
    }

    // Animate the expand and collapse of the layer control
    Behavior on height {
        SpringAnimation {
            spring: 3
            damping: .4
        }
    }


Rectangle {
    id: layerVisibilityRect2
    property bool expanded: true
    anchors.fill: parent
    width: layerVisibilityRect.width
    height: layerVisibilityRect.height
    color: "lightgrey"
    opacity: .9
    radius: 5
    border {
        color: "#4D4D4D"
        width: 1
    }


    Column {
        anchors {
            fill: parent
            margins: 10 * scaleFactor
        }
     //   clip: true

        Row{
            spacing: 53 * scaleFactor

        Text {
           // width: parent.width
            text: "Layers"
            wrapMode: Text.WordWrap
            clip: true
            font {
                pixelSize: 18 * scaleFactor
                bold: true
            }
        }

        // icon to allow expanding and collapsing
        Image {
            source: layerVisibilityRect.expanded ? "../assets/dropup_arrow.png" : "../assets/dropdown_arrow.png"
            width: 28 * scaleFactor
            height: width

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    if (layerVisibilityRect.expanded) {
                        layerVisibilityRect2.height = 40 * scaleFactor;
                        layerVisibilityRect2.expanded = false;
                        layerVisibilityRect.height = 40 * scaleFactor;
                        layerVisibilityRect.expanded = false;
                    } else {
                        layerVisibilityRect2.height = layerScale * scaleFactor;
                        layerVisibilityRect2.expanded = false;
                        layerVisibilityRect.height = layerScale * scaleFactor;
                        layerVisibilityRect.expanded = true;
                    }
                }
            }
        }
}
        // Create a list view to display the items
        ListView {
            id: layerVisibilityListView
            anchors.topMargin:  40 * scaleFactor
            width: parent.width
            height: parent.height
            clip: true

            // Assign the model to the list model of sublayers
            model: mapArea.map.operationalLayers

            // Assign the delegate to the delegate created above
            delegate: Item {
                id: layerVisibilityDelegate
                anchors.topMargin:  40 * scaleFactor
                width: parent.width
                height: 35 * scaleFactor

                Row {
                    spacing: 0
                    anchors.verticalCenter: parent.verticalCenter
                    Text {
                        anchors.verticalCenter: parent.verticalCenter
                        width: 80 * scaleFactor
                        text: name
                        wrapMode: Text.WordWrap
                        font.pixelSize: 14 * scaleFactor
                    }

                    Switch {

                        Material.accent: "#8f499c"

                        onCheckedChanged: {
                            layerVisible = checked;
                        }
                        Component.onCompleted: {
                            checked = layerVisible;
                        }

                    }
                }
            }
        }
    }
    }
}

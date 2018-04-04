import QtQuick 2.7
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1

import Esri.ArcGISRuntime 100.1

Rectangle{
    id:routeButton

    property bool pressed: false

    visible: false
    anchors {
        right: parent.right
        rightMargin: 5*app.scaleFactor
        bottom: parent.bottom
        //bottomMargin: 10*app.scaleFactor
        bottomMargin: (parent.height-height)/1.68
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
        source: "../assets/directions.png"
    }

    MouseArea {
        anchors.fill: parent
        onPressed: directionButton.pressed = true
        onReleased: directionButton.pressed = false
        onClicked:{
            //popUp.visible = 1

            if (routeParameters !== null) {
                // set parameters to return directions
                routeParameters.returnDirections = true;

                // clear previous route graphics
                mapArea.routeGraphicsOverlay.graphics.clear();

                // clear previous stops from the parameters
                routeParameters.clearStops();

                var currentPositionPoint = ArcGISRuntimeEnvironment.createObject("Point", {x: positionSource.position.coordinate.longitude, y: positionSource.position.coordinate.latitude, spatialReference: SpatialReference.createWgs84()});
                var stop1 = ArcGISRuntimeEnvironment.createObject("Stop", {geometry: currentPositionPoint, name: "Your Location"});
                var stop2 = ArcGISRuntimeEnvironment.createObject("Stop", {geometry: routepoint, name: "Destination"});
                routeParameters.setStops([stop1, stop2]);
                console.log(routepoint)
                console.log(currentPositionPoint)
                console.log(stop1)
                console.log(stop2)
                // solve the route with the parameters
                routeTask.solveRoute(routeParameters);
        }}
    }

    

}










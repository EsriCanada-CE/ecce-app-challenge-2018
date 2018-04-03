import QtQuick 2.0
import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtGraphicalEffects 1.0
import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import Esri.ArcGISRuntime 100.1
import QtQuick.Dialogs 1.2
import "../controls" as Controls

//RouteTask pointing to our online service

RouteTask {
    id: routeTask
    credential: Credential{
                            username: "ggeteam"
                            password: "GGEGROUP1"
                    }
    url: "http://route.arcgis.com/arcgis/rest/services/World/Route/NAServer/Route_World"

    // Request default parameters once the task is loaded
    onLoadStatusChanged: {
        if (loadStatus === Enums.LoadStatusLoaded) {
            console.log("lolo")
            routeTask.createDefaultParameters();
        }
    }

    // Store the resulting route parameters
    onCreateDefaultParametersStatusChanged: {
        if (createDefaultParametersStatus === Enums.TaskStatusCompleted) {
            console.log("lili")
            routeParameters = createDefaultParametersResult;
        }
    }

    // Handle the solveRouteStatusChanged signal
    onSolveRouteStatusChanged: {
        console.log("lalalal")
        if (solveRouteStatus === Enums.TaskStatusCompleted) {
            // Add the route graphic once the solve completes
            var generatedRoute = solveRouteResult.routes[0];
            var routeGraphic = ArcGISRuntimeEnvironment.createObject("Graphic", {geometry: generatedRoute.routeGeometry});
            mapArea.routeGraphicsOverlay.graphics.append(routeGraphic);

            // set the direction maneuver list model
            directionListModel = generatedRoute.directionManeuvers;

            mapArea.directionButton.visible = true

            mapArea.zoomToCurrentLocation()

            // hide the solve button and show the direction button
            //solveButton.visible = false;
        }
    }
}

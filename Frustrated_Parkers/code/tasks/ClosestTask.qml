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

//ClosestFacility task pointing to our online service

ClosestFacilityTask {
    id: task
    credential : Credential{username : "ggeteam"
                            password : "GGEGROUP1"}
    url: "http://route.arcgis.com/arcgis/rest/services/World/ClosestFacility/NAServer/ClosestFacility_World"

    onLoadStatusChanged: {
        if (loadStatus !== Enums.LoadStatusLoaded)
            return;

        setupRouting();

        function setupRouting() {
            busy = true;
            message = "";
            task.createDefaultParameters();

        }
    }

    onCreateDefaultParametersStatusChanged: {
        if (createDefaultParametersStatus !== Enums.TaskStatusCompleted)
            return;
        busy = false;
        facilityParams = createDefaultParametersResult;
        facilityParams.returnDirections =  true;
        facilityParams.setFacilities(facilities);
    }

    onSolveClosestFacilityStatusChanged: {
        if (solveClosestFacilityStatus !== Enums.TaskStatusCompleted)
            return;

        busy = false;

        if (solveClosestFacilityResult === null || solveClosestFacilityResult.error){}
        else{

            var rankedList = solveClosestFacilityResult.rankedFacilityIndexes(0);
            var closestFacilityIdx = rankedList[0];

            var incidentIndex = 0; // 0 since there is just 1 incident at a time
            var route = solveClosestFacilityResult.route(closestFacilityIdx, incidentIndex);

            var routeGraphic = ArcGISRuntimeEnvironment.createObject(
                    "Graphic", { geometry: route.routeGeometry, symbol: routeSymbol});
            resultsOverlay.graphics.append(routeGraphic);
        }
    }

}

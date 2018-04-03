require([
    "esri/Map",
    "esri/views/SceneView",
    "esri/layers/SceneLayer",
    "esri/layers/FeatureLayer",
    "esri/layers/Layer",
    "dojo/dom",
    "dojo/number",
    "dojo/on",
    "dojo/domReady!"
], function (Map, SceneView, SceneLayer, FeatureLayer, Layer, dom, Number, on) {

    // Create Map
    var map = new Map({
        basemap: "topo",
        ground: "world-elevation"
    });

    // Create the SceneView
    var view = new SceneView({
        container: "viewDiv",
        map: map,
        camera: {
            position: {
                x: -13703000,
                y: 6320000,
                z: 750,
                spatialReference: 3857
            },
            heading: 320,
            tilt: 72
        }
    });

    // Set the environment in SceneView
    view.environment = {
        lighting: {
            directShadowsEnabled: true,
            date: new Date("Sat Mar 10 2018 09:00:00 GMT+1600 (EST)")
        }
    };
    // Create SceneLayer and add to the map
    var sceneLayer = new SceneLayer({
        url: "https://services.arcgis.com/9PtzeAadJyclx9t7/arcgis/rest/services/3D_buildingstats2/SceneServer"
    });
    map.add(sceneLayer);

    // Configure the pop-up
    var popupTemplate = {
        title: "{GreenRoof}",
        content: "Potential rooftop area: {RoofArea} sq meters.<br>Rooftop Elevation: {Z_Max} meters."
    };

    // Register events to controls
    on(dom.byId("timeOfDaySelect"), "change", updateTimeOfDay);
    on(dom.byId("directShadowsInput"), "change", updateDirectShadows);

    // Create the event's callback functions
    function updateTimeOfDay(ev) {
        var select = ev.target;
        var date = select.options[select.selectedIndex].value;

        view.environment.lighting.date = new Date(date);
    }

    // update the shadows
    function updateDirectShadows(ev) {
        view.environment.lighting.directShadowsEnabled = !!ev.target.checked;
    }

    sceneLayer.popupTemplate = popupTemplate;

    });

// open the pseudo tabs - dijit not working...
function openCity(button) {
    var i;
    var x = document.getElementsByClassName("button");
    for (i = 0; i < x.length; i++) {
        x[i].style.display = "none";
    }
    document.getElementById(button).style.display = "block";
};


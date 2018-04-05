function mapout(){
  var cartoDB = L.tileLayer('https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_nolabels/{z}/{x}/{y}.png', {
                attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>'});

  var esriDark = L.esri.basemapLayer('DarkGray');
  var esriSat = L.esri.basemapLayer('Imagery');
  var Topo = L.esri.basemapLayer('Topographic');

  var baseLayers = {
    'Carto-Dark': cartoDB,
    'Esri-Dark': esriDark, 
    'Esri-Satellite': esriSat, 
    'Esri-Topo': Topo
  };

  function getColor(d){
    return d > 100 ? '#7b3294':
           d > 50  ? '#c2a5cf': 
           d > 25  ? '#f7f7f7':
           d > 10  ? '#a6dba0':
                     '#008837';
  } 


  function style(feature){
    return {
      fillColor: getColor(feature.properties.ptEnergy),
      weight: 0.5, 
      opacity: 1, 
      color: 'black',
      fillOpacity: 0.7
    };
  } 


  var popup = new L.Popup({autoPan: false});

  function highlightFeature(e){
    var layer = e.target;
    layer.setStyle({
      weight: 5, 
      color: 'white', 
      dashArray: "",
      fillOpacity: 0.7
    });
    popup.setLatLng(e.latlng);
    popup.setContent('<strong>DAUID: </strong><a href = "HTML/' + layer.feature.properties.DAUID_l + '.html">' + layer.feature.properties.DAUID_l + "</a><br><strong>Population: </strong>" + layer.feature.properties.P__2016 + "<br><strong>Biogas & Solar: </strong>" + layer.feature.properties.ptEnergy + " MWh<br><strong>Biogas-Solar Ratio: </strong>" + (((layer.feature.properties.EnergykWh / 1000) / layer.feature.properties.ptEnergy) * 100).toFixed(1) + " - " + (((layer.feature.properties.Sum_Solaro / 1000) / layer.feature.properties.ptEnergy) * 100).toFixed(1));
    if(!popup._map) popup.openOn(map);
    if(!L.Browser.ie && !L.Browser.opera && !L.Browser.edge){
      layer.bringToFront();
    }
  }

  function resetHighlight(e){
    geojson.resetStyle(e.target);
  }


  function zoomToFeature(e){
    map.fitBounds(e.target.getBounds());
  }

  var geojson;

  function onEachFeature(feature, layer){
    layer.on({
      mouseover: highlightFeature, 
      mouseout: resetHighlight,
      click: zoomToFeature
    });
  }

  var geojson = L.geoJSON(boundary, {style: style, onEachFeature: onEachFeature});

  var overlays = {  
  'DA Boundary': geojson 
  };

  var map = L.map('map', {
                layers:[cartoDB, geojson],
                measureControl: false,
                minZoom: 9
                }).setView([51.0520, -114.0709], 12)
                  .setMaxBounds([[52.0346, -115.358], [50.206, -112.414]]);


  L.control.layers(baseLayers, overlays).addTo(map);

  var searchControl = L.esri.Geocoding.geosearch().addTo(map);
  var results = L.layerGroup().addTo(map);

  searchControl.on('results', function(data){
    results.clearLayers();
    for(var i = data.results.length - 1; i >= 0; i--){
      results.addLayer(L.marker(data.results[i].latlng),{zoom: 12});
    }
  });

  var legend   = L.control({position: 'bottomright'});
  
  legend.onAdd = function(map){
    var div    = L.DomUtil.create('div', 'info legend'),
        grades = [0, 10, 25, 50, 100],
        labels = [];

    for(var i = 0; i < grades.length; i++){
      div.innerHTML += 
        '<i style = "background:' + getColor(grades[i] + 1) + '"></i> ' + grades[i] + (grades[i + 1] ? '&ndash;' + grades[i + 1] + '<br>' : '+');
    }

    return div;
  };

  legend.addTo(map);
}
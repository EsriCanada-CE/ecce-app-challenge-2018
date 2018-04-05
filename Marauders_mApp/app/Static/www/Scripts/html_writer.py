import csv, os.path

html_path = "../HTML/"

with open("../../../Shiny/www/Data/Centroid_DA.csv") as c: 
	for row in c:
		temp = row.split(",")
		with open(html_path + temp[0] + ".html", "w") as h:
			header = """<!DOCTYPE html>
<html lang = "en">
<head>
	<meta charset = "utf-8">
	<meta name = "viewport" content = 'width=device-width, initial-scale=1, shrink-to-fit=no'>
	<meta name = "description" content = "">
	<title>Energy Revolution</title>
	<script src = "../JS/leaflet.js"></script>
	<script src = "../JS/esri_leaflet.js"></script>
	<script src = "../JS/esri-leaflet-geocoder.js"></script>
	<script src = "../JS/leaflet_measure.js"></script>
	<script src = "../JS/custom.js"></script>
	<link rel = "stylesheet" href = "../CSS/leaflet.css">
	<link rel = "stylesheet" href = "../CSS/leaflet_measure.css">
	<link rel = "stylesheet" href = "../CSS/esri-leaflet-geocoder.css">
	<script src = 'https://s3.us-east-2.amazonaws.com/boundariescalgary/""" 
			h.write(header)
			h.write(temp[0])
			h.write("_OD.js'></script>\n\t<script src = 'https://s3.us-east-2.amazonaws.com/buildingscalgary/")
			h.write(temp[0])
			h.write("_OD.js'></script>\n\t<style>\n\thtml, body, #map {\n\t\t\twidth: 100%;\n\t\t\theight: 100%;\n\t\t\tz-index: 9999;\n\t\t}\n\t</style>\n</head>\n<body>\n\t<div id = 'map'></div>\n\t<script>\n\t\tvar defaultStyle = {\n\t\t\tcolor: '#5719d3',\n\t\t\tweight: 2,\n\t\t\topacity: 0.5,\n\t\t\tfillOpacity: 0.5,\n\t\t\tfillColor: 'blue'\n\t\t};\n\n\t\tvar clearStyle = {\n\t\t\tcolor: 'red',\n\t\t\tweight: 3,\n\t\t\tfillOpacity: 0\n\t\t};\n\t\t")

			layer_set = """
	var cartoDB = L.tileLayer('https://cartodb-basemaps-{s}.global.ssl.fastly.net/dark_nolabels/{z}/{x}/{y}.png', {attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a> &copy; <a href="http://cartodb.com/attributions">CartoDB</a>'});\n\t\tvar esriDark = L.esri.basemapLayer('DarkGray');\n\t\tvar esriSat = L.esri.basemapLayer('Imagery');\n\t\tvar Topo = L.esri.basemapLayer('Topographic');\n\n\t\tvar baseLayers = {\n\t\t\t'Carto-Dark': cartoDB,\n\t\t\t'Esri-Dark': esriDark,\n\t\t\t'Esri-Satellite': esriSat,\n\t\t\t'Esri-Topo': Topo\n\t\t};\n\n"""
			h.write(layer_set)
			h.write("var map = L.map('map', {layers: [cartoDB], measureControl: true, minZoom: 11}).setView([")
			h.write(temp[2])
			h.write(", ")
			h.write(temp[1])
			h.write("], 15);\n\n\n\t\tL.geoJSON(boundary, {\n\t\t\tstyle: clearStyle\n\t\t}).addTo(map);\n\n\t\t")
			#.setMaxBounds([[")
			#h.write(temp[2])
			#h.write(", ")
			#h.write(temp[3])
			#h.write("], [")
			#h.write(temp[4])
			#h.write(", ")
			#h.write(temp[5])
			#h.write("]]
			next_set = """
	var infoFt = function(feature, layer){
			layer.bindPopup("<center><h3><strong>Your Rooftop's Solar Potential</strong></h3></center><h3>Roof Area: <font color ='#768fe2'><strong>" + parseInt(feature.properties.Area) + " sq. meters</strong></font></h3><h3># of Panels: <font color = '#768fe2'><strong>" + parseInt(feature.properties.Solarpanel) + "</strong></font></h3><h3>Current Solar Energy: <font color = '#768fe2'><strong>" + (feature.properties.Solarout).toFixed(2) + " kWh</strong></font></h3><h3>Max Solar (per sq.m): <strong><font color = '#768fe2'><strong>" + (feature.properties.Maxsolar).toFixed(2) + " kWh</strong></font></h3><h3>Potential Solar Energy: <font color = '#768fe2'><strong>" + (feature.properties.Mxsolarout).toFixed(2) + " kWh</strong></font></h3>");
		};	

		/* Load Building Here */
		L.geoJSON(buildings, {
			style: defaultStyle, 
			onEachFeature: infoFt
		}).addTo(map);


		L.control.layers(baseLayers).addTo(map);

	</script>
</body>	
</html>
	"""
			h.write(next_set)
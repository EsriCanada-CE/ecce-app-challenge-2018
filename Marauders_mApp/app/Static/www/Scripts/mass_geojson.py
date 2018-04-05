import shapefile, os.path
from json import dumps

temp_dir = "../Data/Buildings/" #Change this 
dir_json = "../Data/Json/Buildings/" #Change this  
dir_js   = "../Data/JS/Buildings/" #Change this 

for file in os.listdir(temp_dir):
	if file.endswith(".shp"):
		reader      = shapefile.Reader(temp_dir + file)
		fields      = reader.fields[1:]
		field_names = [field[0] for field in fields]
		buffer = []
		for sr in reader.shapeRecords():
			atr  = dict(zip(field_names, sr.record))
			geom = sr.shape.__geo_interface__
			buffer.append(dict(type = "Feature", geometry = geom, properties = atr))
		geojson = open(dir_json + file[0:-4] + ".json", "w")
		geojson.write(dumps({
			"type" : "FeatureCollection", 
			"features" : buffer
			}, indent = 2) + "\n")
		geojson.close()
		geo_file = open(dir_json + file[0:-4] + ".json", "r")
		js_file  = open(dir_js + file[0:-4] + ".js", "w")
		js_file.write("var buildings = ") # change this 
		for j in geo_file:
			js_file.write(j)
			js_file.write("\n")
		js_file.write(";")
		js_file.close()
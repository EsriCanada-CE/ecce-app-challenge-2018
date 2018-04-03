# Name: randomPoints36.py
# Purpose: a testing method to create several types of random points for road impact feature class using ArcGIS Pro
# Notes: these points will represent perfect data along the road in contrast to reality points uploaded by users
# Author: Colin W
# Date: March 2018

# Import system modules
import arcpy

# set environment settings
arcpy.env.overWriteOutput = True

try:
    

    # Create random points in an extent defined simply by numbers
    outGDB = "C:\\Users\\Colin Werle\\OneDrive - Nova Scotia Community College\\ESRI App Challenge\\GIS\\AppChallenge2018\\AppChallenge2018.gdb"
    outName = "rdmRptPts2m"
    conFC = "C:\\Users\\Colin Werle\\OneDrive - Nova Scotia Community College\\ESRI App Challenge\\GIS\\AppChallenge2018\\AppChallenge2018.gdb\\NS_MAJ_RD_NET_Dissolve1"
    numPoints = 30
    minDistance = "2 Meter"

    arcpy.CreateRandomPoints_management(outGDB, outName, conFC, "", numPoints, minDistance)

except:

    print(arcpy.GetMessages())
 

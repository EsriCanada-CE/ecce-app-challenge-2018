/* Copyright 2017 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */
import QtQuick 2.7
import QtQuick.Layouts 1.1
import QtQuick.Controls 2.1
import QtQuick.Controls.Material 2.1
import QtGraphicalEffects 1.0
import QtPositioning 5.3
import QtSensors 5.3

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

import "controls" as Controls

/*
  Main map application which is contained in a menu drawer(showing all the different options)
  */

Page{
    property int menuCurrentIndex: 0

    //Variable to keep the vehicle (MyCarPage) when switching between menus
    property var tempGraphic

    //size properties
    property real scaleFactor: AppFramework.displayScaleFactor
    readonly property real baseFontSize: app.width<450*app.scaleFactor? 21 * scaleFactor:23 * scaleFactor
    readonly property real titleFontSize: app.baseFontSize
    readonly property real subtitleFontSize: 1.1 * app.baseFontSize
    readonly property real captionFontSize: 0.6 * app.baseFontSize

    // Load as default page
    Loader{
        id: loader
        anchors.fill: parent
        sourceComponent: page1ViewPage
    }
    Rectangle{
        id: mask
        anchors.fill: parent
        color: "black"
        opacity: drawer.position*0.54
        Material.theme: app.lightTheme ? Material.Light : Material.Dark
    }

    //Menu drawer component
    Drawer {
        id: drawer
        width: Math.min(parent.width, parent.height, 600*app.scaleFactor) * 0.80
        height: parent.height
        Material.elevation: 16
        Material.background: app.appDialogColor

        edge: Qt.LeftEdge
        dragMargin: 0
        contentItem: SideMenuPanel{
            currentIndex: menuCurrentIndex
            menuModel: drawerModel
            onMenuSelected: {
                drawer.close();
                //after selecting a menu item, the page is switched depending on the option selected
                switch(action){
                case "page1":
                    loader.sourceComponent = page1ViewPage;                   
                    break;
                case "page2":
                    loader.sourceComponent = page2ViewPage;
                    break;
                case "page3":
                    loader.sourceComponent = page3ViewPage;
                    break;
                case "page4":
                    loader.sourceComponent = page4ViewPage;
                    break;
                case "page5":
                    loader.sourceComponent = page5ViewPage;
                    break;
                case "page6":
                    loader.sourceComponent = page6ViewPage;
                    break;
                case "page7":
                    loader.sourceComponent = page7ViewPage;
                    break;
                case "about":
                    loader.sourceComponent = aboutViewPage;
                    break;
                default:
                    break;
                }
            }
        }

    }

    //List model containing all the items for the drawer
    //Each element has two icons (one when selected and one when not selected)
    ListModel{
        id: drawerModel
        ListElement {action:"page1"; type: "delegate"; name: qsTr("Explore Car Parking"); iconSource: "./images/m1.png";iconSource2: "./images/m12.png"}
        ListElement {action:"page2"; type: "delegate"; name: qsTr("Find Closest Parking Lot"); iconSource: "./images/m8.png";iconSource2: "./images/m82.png"}
        ListElement {action:"page3"; type: "delegate"; name: qsTr("Snow Restricted Parking"); iconSource: "./images/m2.png";iconSource2: "./images/m22.png"}
        ListElement {action:"page4"; type: "delegate"; name: qsTr("Carpool & Electric Parking"); iconSource: "./images/m3.png";iconSource2: "./images/m32.png"}
        ListElement {action:"page5"; type: "delegate"; name: qsTr("Explore Bicycle Parking"); iconSource: "./images/m4.png";iconSource2: "./images/m42.png"}
        ListElement {action:"page6"; type: "delegate"; name: qsTr("Explore Parking Tickets"); iconSource: "./images/m5.png";iconSource2: "./images/m52.png"}
        ListElement {action:"page7"; type: "delegate"; name: qsTr("Park My Vehicle"); iconSource: "./images/m6.png";iconSource2: "./images/m62.png"}
        ListElement {action:""; type: "divider"; name: ""; iconSource: ""}
        ListElement {action:"about"; type: "delegate"; name: qsTr("About"); iconSource: "./images/m7.png";iconSource2: "./images/m72.png"}

    }

    //First menu item
    Component{
        id: page1ViewPage
        WebMapPage{
            titleText: qsTr("Explore Car Parking")
            descText: qsTr("This is page 1")
            mapid:"740c3dc7fd7e443684b7cb30ab148f5d"
            legend:true
            layers:true
            legendScale:300
            layerScale:170
            onOpenMenu: {
                drawer.open();
            }
        }
    }

    //Second menu item
    Component{
        id: page2ViewPage
        ClosestFacility{
            titleText: qsTr("Find Closest Parking Lot")
            onOpenMenu: {
                drawer.open();
            }
        }
    }

    //Third menu item
    Component{
        id: page3ViewPage
        WebMapPage{
            titleText:qsTr("Snow Restricted Parking")
            descText: qsTr("This is page 2")
            mapid:"e23272f01e36477f85b5fe554e4fc439"
            layers:false
            legend:true
            legendScale:150
            onOpenMenu: {
                drawer.open();
            }
        }
    }

    //Fourth menu item
    Component{
        id: page4ViewPage
        WebMapPage{
            titleText:qsTr("Car Pooling & Electric Cars Parking")
            descText: qsTr("This is page 2")
            mapid:"f1f5c5a502c844609be591ae719d5fbc"
            legend:true
            layers:true
            legendScale:150
            layerScale:150
            onOpenMenu: {
                drawer.open();
            }
        }
    }

    //Fifth menu item
    Component{
        id: page5ViewPage
        WebMapPage{
            titleText:qsTr("Explore Bicycle Parking")
            descText: qsTr("This is page 2")
            mapid:"77b09c507c7a47159df4622387eef2e3"
            legend:true
            layers:false
            legendScale:180
            onOpenMenu: {
                drawer.open();
            }
        }
    }

    //Sixth menu item
    Component{
        id: page6ViewPage
        WebMapPage{
            titleText:qsTr("Explore Parking Tickets")
            descText: qsTr("This is page 2")
            legend:false
            layers:false
            mapid:"629b22cb7cd54e0db5135f082559b91c"
            onOpenMenu: {
                drawer.open();
            }
        }
    }

    //Seventh menu item
    Component{
        id: page7ViewPage
        MyCarPage{
            titleText:qsTr("Park My Vehicle")
            descText: qsTr("This is page 2")
            onOpenMenu: {
                drawer.open();
            }
        }
    }

    //Eight menu item
    Component{
        id: aboutViewPage
        AboutPage{
            titleText: qsTr("About")
            descText: qsTr("This is an about page")
            onOpenMenu: {
                drawer.open();
            }
        }
    }

    //Position source to obtain the location in all the pages
    PositionSource {
        id: positionSource
        active: true
        property bool isInitial: true
        onPositionChanged: {
            //*if(map.loadStatus === Enums.LoadStatusLoaded && isInitial) {
                isInitial = false;
                //zoomToCurrentLocation();
            }

    }

}







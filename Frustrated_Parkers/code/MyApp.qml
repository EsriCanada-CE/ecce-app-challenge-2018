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

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

/*
  Main App file which initialize the app components


  */

App {
    id: app
    width: 400
    height: 680

    // App color properties
    readonly property color primaryColor:"white"
    readonly property color secondaryColor: "#08452F"
    readonly property color accentColor: "#08452F"
    readonly property color appDialogColor: "white"
    readonly property color appPrimaryTextColor: lightTheme? "#000000":"#FFFFFF"
    readonly property color appSecondaryTextColor: Qt.darker(appPrimaryTextColor)
    readonly property color headerTextColor:"#FFFFFF"
    readonly property color listViewDividerColor:"#19000000"

    readonly property real scaleFactor: AppFramework.displayScaleFactor

    property real baseFontSize: app.width < 450*app.scaleFactor? 21 * scaleFactor:23 * scaleFactor
    property real titleFontSize: baseFontSize
    property real subtitleFontSize: 0.8 * app.baseFontSize

    property alias stackView: stackView

    readonly property alias fontFamily: fontFamily
    readonly property alias fontBoldFamily: fontBoldFamily

    FontLoader {
        id: fontFamily
        source: app.folder.fileUrl("./fonts/Roboto-Regular.ttf")
    }

    FontLoader {
        id: fontBoldFamily
        source: app.folder.fileUrl("./fonts/Roboto-Bold.ttf")
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: startPage
    }

    Component {
        id: startPage
        MainPage{
            onNext: {
                stackView.push(page1);
            }
        }
    }

    Component {
        id: page1
        MenuPage{
        }
    }


}


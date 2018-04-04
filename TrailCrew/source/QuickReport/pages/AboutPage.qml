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
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0

import "../controls/"

Rectangle {
    id:_root
    width: parent.width
    height: parent.height
    color: app.pageBackgroundColor

    signal next(string message)
    signal previous(string message)

    property int hitFeatureId
    property variant attrValue
    visible: false

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        Rectangle {
            id: mapPage_headerBar
            Layout.alignment: Qt.AlignTop
            color: app.headerBackgroundColor
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: 50 * app.scaleFactor

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mouse.accepted = false
                }
            }

            Text {
                id: mapPage_titleText
                text: qsTr("About")
                textFormat: Text.StyledText
                anchors.centerIn: parent
                font.pixelSize: app.titleFontSize
                font.family: app.customTitleFont.name
                color: app.headerTextColor
                maximumLineCount: 1
                elide: Text.ElideRight
            }

            Icon {
                imageSource: "../images/ic_clear_white_48dp.png"
                anchors.left: parent.left
                anchors.verticalCenter: parent.verticalCenter
                onIconClicked: {
                    hide()
                }
            }
        }

        Rectangle {
            Layout.alignment: Qt.AlignTop
            Layout.fillHeight: true
            color: app.pageBackgroundColor
            Layout.preferredWidth: parent.width
            Layout.preferredHeight: parent.height - mapPage_headerBar.height
            Layout.topMargin: app.units(16)

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mouse.accepted = false
                }
            }

            Flickable {
                anchors.fill: parent
                contentHeight: columnContainer.height
                clip: true

                ColumnLayout {
                    id: columnContainer
                    width: Math.min(parent.width, 600*app.scaleFactor)
                    anchors.horizontalCenter: parent.horizontalCenter
                    spacing: app.units(16)

                    Image {
                        Layout.preferredHeight: 50 * AppFramework.displayScaleFactor
                        Layout.preferredWidth: 50 * AppFramework.displayScaleFactor
                        anchors.horizontalCenter: parent.horizontalCenter
                        fillMode: Image.PreserveAspectFit
                        source: getAppIcon()
                        visible: source > ""
                    }                    

                    Text {
                        text: app.info.title
                        color: app.textColor
                        font.pixelSize: app.titleFontSize
                        font.family: app.customTitleFont.name
                        font.bold: true
                        font.weight: Font.Bold
                        anchors.horizontalCenter: parent.horizontalCenter
                    }                    

                    Text {
                        text: app.info.description
                        visible: app.info.description > ""
                        textFormat: Text.StyledText
                        color: app.textColor
                        wrapMode: Text.Wrap
                        linkColor: app.headerBackgroundColor
                        Layout.preferredWidth: parent.width - 20 * AppFramework.displayScaleFactor
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: app.textFontSize
                        font.family: app.customTextFont.name
                        onLinkActivated: {
                            var component = webPageComponent;
                            var webPage = component.createObject(_root);
                            webPage.openWebURL(link, "")
                        }
                    }

                    Text{
                        text: qsTr("Access and Use Constraints") + ":"
                        visible: app.info.licenseInfo > ""
                        color: app.textColor
                        wrapMode: Text.Wrap
                        linkColor: app.headerBackgroundColor
                        Layout.preferredWidth: parent.width - 20 * AppFramework.displayScaleFactor
                        anchors.horizontalCenter: parent.horizontalCenter
                        font {
                            bold: true
                            pixelSize: app.titleFontSize
                            weight: Font.Bold
                            family: app.customTitleFont.name
                        }
                    }

                    Text {
                        text: app.info.licenseInfo
                        visible: app.info.licenseInfo > ""
                        textFormat: Text.StyledText
                        color: app.textColor
                        wrapMode: Text.Wrap
                        linkColor: app.headerBackgroundColor
                        Layout.preferredWidth: parent.width - 20 * AppFramework.displayScaleFactor
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: app.textFontSize
                        font.family: app.customTextFont.name
                        onLinkActivated: {
                            var component = webPageComponent;
                            var webPage = component.createObject(_root);
                            webPage.openWebURL(link, "")
                        }
                    }

                    Text {
                        text: qsTr("Credits") + ":"
                        visible: app.info.accessInformation > ""
                        textFormat: Text.RichText
                        color: app.textColor
                        wrapMode: Text.Wrap
                        linkColor: app.headerBackgroundColor
                        Layout.preferredWidth: parent.width - 20 * AppFramework.displayScaleFactor
                        anchors.horizontalCenter: parent.horizontalCenter
                        font {
                            bold: true
                            weight: Font.Bold
                            pixelSize: app.titleFontSize
                            family: app.customTitleFont.name
                        }
                    }

                    Text {
                        text: app.info.accessInformation
                        visible: app.info.accessInformation > ""
                        textFormat: Text.StyledText
                        color: app.textColor
                        wrapMode: Text.Wrap
                        linkColor: app.headerBackgroundColor
                        Layout.preferredWidth: parent.width - 20 * AppFramework.displayScaleFactor
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: app.textFontSize
                        font.family: app.customTextFont.name
                        onLinkActivated: {
                            var component = webPageComponent;
                            var webPage = component.createObject(_root);
                            webPage.openWebURL(link, "")
                        }
                    }

                    Text {
                        text: qsTr("About the App") + ":"
                        textFormat: Text.RichText
                        color: app.textColor
                        wrapMode: Text.Wrap
                        linkColor: app.headerBackgroundColor
                        Layout.preferredWidth: parent.width - 20 * AppFramework.displayScaleFactor
                        anchors.horizontalCenter: parent.horizontalCenter
                        font {
                            bold: true
                            weight: Font.Bold
                            pixelSize: app.titleFontSize
                            family: app.customTitleFont.name
                        }
                    }

                    Text {
                        text: qsTr("This app was built using the new AppStudio for ArcGIS. Mapping API provided by Esri.");
                        textFormat: Text.StyledText
                        color: app.textColor
                        wrapMode: Text.Wrap
                        linkColor: app.headerBackgroundColor
                        Layout.preferredWidth: parent.width - 20 * AppFramework.displayScaleFactor
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: app.textFontSize
                        font.family: app.customTextFont.name
                        onLinkActivated: {
                            var component = webPageComponent;
                            var webPage = component.createObject(_root);
                            webPage.openWebURL(link, "")
                        }
                    }

                    Text {
                        text: qsTr("Version") + ":"
                        visible: app.info.version > ""
                        textFormat: Text.RichText
                        color: app.textColor
                        wrapMode: Text.Wrap
                        linkColor: app.headerBackgroundColor
                        Layout.preferredWidth: parent.width - 20 * AppFramework.displayScaleFactor
                        anchors.horizontalCenter: parent.horizontalCenter
                        font {
                            bold: true
                            weight: Font.Bold
                            pixelSize: app.titleFontSize
                            family: app.customTitleFont.name
                        }
                    }

                    Text {
                        text: app.info.version
                        visible: app.info.version > ""
                        textFormat: Text.StyledText
                        color: app.textColor
                        wrapMode: Text.Wrap
                        linkColor: app.headerBackgroundColor
                        Layout.preferredWidth: parent.width - 20 * AppFramework.displayScaleFactor
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: app.textFontSize
                        font.family: app.customTextFont.name
                        onLinkActivated: {
                            var component = webPageComponent;
                            var webPage = component.createObject(_root);
                            webPage.openWebURL(link, "")
                        }
                    }                    
                }
            }
        }
    }

    DropShadow {
        source: mapPage_headerBar
        //anchors.fill: source
        width: source.width
        height: source.height
        cached: false
        radius: 5.0
        samples: 16
        color: "#80000000"
        smooth: true
        visible: source.visible
    }

    function getAppIcon() {
        var resources = app.info.value("resources", {});
        var appIconPath = "", appIconFilePath = "";

        if (!resources) {
            resources = {};
        }

        if (resources.appIcon) {
            appIconPath = resources.appIcon;
        }

        //console.log("appIcon absolute path ", appIconPath, app.folder.filePath(appIconPath));

        var f = AppFramework.fileInfo(appIconPath)
        console.log(f.filePath, f.url, f.exists)

        if(f.exists) {
            appIconFilePath = "file:///" +app.folder.filePath(appIconPath);
        }

        return appIconFilePath;
    }

    function open(){
        _root.visible = true
        bottomUp.start();
    }

    function hide(){
        topDown.start();
    }

    NumberAnimation {
        id: bottomUp
        target: _root
        property: "y"
        duration: 200
        from:_root.height
        to:0
        easing.type: Easing.InOutQuad
    }

    NumberAnimation {
        id: topDown
        target: _root
        property: "y"
        duration: 200
        from:0
        to:_root.height
        easing.type: Easing.InOutQuad
        onStopped: {
            _root.visible = false
        }
    }
}
